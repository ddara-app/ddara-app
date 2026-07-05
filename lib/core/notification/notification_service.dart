import 'dart:convert';
import 'dart:io';

import 'package:ddara/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

/// 백그라운드/종료 상태에서 도착한 메시지를 처리하는 top-level 핸들러.
///
/// 반드시 top-level 함수 + `@pragma('vm:entry-point')` 여야 별도 백그라운드
/// 아이솔레이트에서 진입점으로 실행된다. (인스턴스 메서드/클로저 불가)
///
/// 백엔드는 notification + data 를 함께 보내므로 백그라운드/종료 상태에서는
/// OS 가 notification 블록을 자동 표시한다. 따라서 여기서는 중복 표시를 막기 위해
/// notification 이 있으면 아무것도 하지 않고, data-only 인 경우에만 직접 표시한다.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (message.notification != null) return; // OS 가 표시 → 중복 방지
  await NotificationService.showDataNotification(message);
}

/// FCM 수신 + 로컬 알림 표시 + 탭 라우팅 플러밍을 담당하는 싱글턴.
///
/// 백엔드는 `notification`(title/body) + `data`(type·id·imageUrl) 를 함께 보낸다.
/// - 백그라운드/종료: OS 가 notification 을 자동 표시. (앱 코드는 관여 안 함)
/// - 포그라운드: OS 가 자동 표시하지 않으므로 여기서 로컬 알림을 직접 띄운다.
///   (data.imageUrl 을 받아 알림에 이미지로 함께 표시)
///
/// 알림 탭은 포그라운드 로컬 알림/백그라운드/종료 세 경로 모두 [_onTap] 으로
/// 통합해 `data` 를 넘긴다. 서버 토큰 등록/권한 요청은 이 서비스가 다루지 않는다.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  /// 포그라운드/백그라운드 로컬 알림 표시에 함께 쓰는 Android 채널.
  /// (AndroidManifest 의 default_notification_channel_id 와 ID 를 맞춘다)
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    '중요 알림',
    description: '중요한 알림을 표시합니다.',
    importance: Importance.high,
  );

  bool _initialized = false;

  /// 알림 탭 시 payload(data) 로 라우팅을 위임할 콜백. (init 에서 주입)
  void Function(Map<String, dynamic> data)? _onTap;

  /// 현재 FCM 토큰. iOS 는 APNs 토큰이 먼저 준비돼야 값이 나온다.
  Future<String?> getToken() async {
    if (Platform.isIOS) {
      // APNs 토큰이 아직이면 null. 이후 onTokenRefresh 로 보정된다.
      await _fcm.getAPNSToken();
    }
    return _fcm.getToken();
  }

  /// FCM 이 토큰을 새로 발급할 때마다 새 토큰을 흘려보내는 스트림.
  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;

  /// 로컬 알림 초기화 + 포그라운드/탭 핸들러 등록. 앱 첫 프레임 이후 1회 호출.
  ///
  /// [onTap] 은 알림 탭 시 `data` 로 화면 라우팅을 처리하는 콜백.
  Future<void> init({
    void Function(Map<String, dynamic> data)? onTap,
  }) async {
    if (_initialized) return;
    _initialized = true;
    _onTap = onTap;

    await _initLocalNotifications();
    _setupHandlers();
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // 권한은 기존 권한 게이트가 요청하므로 여기서는 프롬프트를 띄우지 않는다.
    const DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _local.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      // 포그라운드에서 띄운 로컬 알림을 탭했을 때. (payload = data JSON)
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleLocalTap(response.payload);
      },
    );

    // Android 알림 채널 생성. (없으면 로컬 알림이 표시되지 않음)
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  void _setupHandlers() {
    // 포그라운드: OS 가 자동 표시하지 않으므로 data 로 로컬 알림을 직접 띄운다.
    FirebaseMessaging.onMessage.listen(_showForeground);

    // 백그라운드에서 OS 알림 탭 → 앱이 열릴 때.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _onTap?.call(message.data);
    });
  }

  /// 종료 상태에서 알림 탭으로 앱이 시작된 경우의 최초 메시지를 처리한다.
  Future<void> checkInitialMessage() async {
    final RemoteMessage? message = await _fcm.getInitialMessage();
    if (message != null) {
      _onTap?.call(message.data);
    }
  }

  /// 포그라운드 수신 메시지를 이미지와 함께 로컬 알림으로 표시한다.
  Future<void> _showForeground(RemoteMessage message) async {
    final _NotificationContent? content = _contentOf(message);
    if (content == null) return;

    // data.imageUrl 을 받아 알림에 이미지로 표시한다. (실패하면 이미지 없이 표시)
    final Uint8List? image = await _downloadImage(
      message.data['imageUrl'] as String?,
    );
    final String? iosPath = image == null
        ? null
        : await _writeTempImage(content.id, image);

    await _local.show(
      id: content.id,
      title: content.title,
      body: content.body,
      notificationDetails: _details(
        largeIcon: image,
        iosAttachmentPath: iosPath,
      ),
      payload: content.payload,
    );
  }

  /// 백그라운드 아이솔레이트에서 data-only 메시지로 로컬 알림을 표시한다.
  /// (현재 백엔드는 notification 을 함께 보내 OS 가 표시하므로 거의 쓰이지 않는다)
  static Future<void> showDataNotification(RemoteMessage message) async {
    final _NotificationContent? content = _contentOf(message);
    if (content == null) return;

    final FlutterLocalNotificationsPlugin plugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await plugin.initialize(
      settings: const InitializationSettings(android: android),
    );
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    await plugin.show(
      id: content.id,
      title: content.title,
      body: content.body,
      notificationDetails: _details(),
      payload: content.payload,
    );
  }

  /// 로컬 알림 탭(payload=data JSON) 을 라우팅 콜백으로 넘긴다.
  void _handleLocalTap(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) _onTap?.call(decoded);
    } catch (_) {
      // payload 형식 오류는 무시한다.
    }
  }

  /// 표시에 쓸 알림 상세. [largeIcon]/[iosAttachmentPath] 가 있으면 이미지도 표시.
  static NotificationDetails _details({
    Uint8List? largeIcon,
    String? iosAttachmentPath,
  }) => NotificationDetails(
    android: AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      largeIcon: largeIcon == null ? null : ByteArrayAndroidBitmap(largeIcon),
    ),
    iOS: DarwinNotificationDetails(
      attachments: iosAttachmentPath == null
          ? null
          : [DarwinNotificationAttachment(iosAttachmentPath)],
    ),
  );

  /// [url] 이미지를 내려받아 바이트로 반환한다. (없거나 실패하면 null)
  static Future<Uint8List?> _downloadImage(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return response.bodyBytes;
    } catch (_) {
      // 네트워크 오류 등은 무시하고 이미지 없이 표시한다.
    }
    return null;
  }

  /// iOS 첨부용으로 이미지 바이트를 임시 파일에 쓰고 경로를 반환한다.
  static Future<String?> _writeTempImage(int id, Uint8List bytes) async {
    try {
      final file = File('${Directory.systemTemp.path}/fcm_notif_$id.png');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (_) {
      return null;
    }
  }

  /// 메시지에서 표시할 제목/본문/페이로드를 뽑는다.
  ///
  /// 백엔드가 `notification`(title/body) 을 보내므로 이를 우선 쓰고, 없으면
  /// `data['title']`/`data['body']` 로 보정한다. 둘 다 없으면 표시하지 않는다.
  static _NotificationContent? _contentOf(RemoteMessage message) {
    final String? title =
        message.notification?.title ?? message.data['title'] as String?;
    final String? body =
        message.notification?.body ?? message.data['body'] as String?;
    if (title == null && body == null) return null;

    // data 전체를 payload 로 실어 탭 시 라우팅에 쓴다.
    final String payload = jsonEncode(message.data);
    // 같은 메시지 재수신 시 알림 중복 누적을 줄이도록 messageId 기준 id 부여.
    final int id = (message.messageId ?? payload).hashCode;
    return _NotificationContent(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }
}

/// 로컬 알림 표시에 필요한 최소 내용. ([NotificationService] 내부용)
class _NotificationContent {
  const _NotificationContent({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String payload;
}
