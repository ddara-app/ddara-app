import 'dart:convert';
import 'dart:io' show Platform;

import 'package:ddara/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 백그라운드/종료 상태에서 도착한 메시지를 처리하는 top-level 핸들러.
///
/// 반드시 top-level 함수 + `@pragma('vm:entry-point')` 여야 별도 백그라운드
/// 아이솔레이트에서 진입점으로 실행된다. (인스턴스 메서드/클로저 불가)
///
/// 백엔드는 data 페이로드로 알림 내용을 보내고 클라이언트가 알림을 만든다.
/// - Android: data-only 이므로 여기서 로컬 알림을 직접 띄운다.
/// - iOS: notification 페이로드가 함께 오면 OS 가 이미 표시하므로, 중복 표시를
///   막기 위해 [message]에 notification 이 있으면 아무것도 하지 않는다.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (message.notification != null) return; // OS 가 표시 → 중복 방지
  await NotificationService.showDataNotification(message);
}

/// FCM 수신 + 로컬 알림 표시 등 순수 플러밍을 담당하는 싱글턴.
///
/// 백엔드는 `data` 페이로드(`title`/`body` + 라우팅용 키)를 보내고, 클라이언트가
/// 그 값으로 로컬 알림을 만들어 표시한다. iOS 는 백그라운드/종료 상태 표시 보장을
/// 위해 notification 페이로드도 함께 받는다(하이브리드).
///
/// 서버로의 토큰 등록/동기화는 인증 상태를 알아야 하므로 여기서 하지 않고,
/// Riverpod 코디네이터(fcm_token_sync)가 [getToken]/[onTokenRefresh] 를 사용해
/// 처리한다. 권한 요청도 기존 권한 게이트(PermissionPage)가 담당하므로
/// 이 서비스는 권한 프롬프트를 띄우지 않는다.
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

  /// 알림 탭으로 앱을 열었을 때 라우팅을 위임할 콜백. (init 에서 주입)
  void Function(RemoteMessage message)? _onMessageOpened;

  /// 현재 FCM 토큰. iOS 는 APNs 토큰이 먼저 준비돼야 값이 나온다.
  Future<String?> getToken() async {
    if (Platform.isIOS) {
      // APNs 토큰이 아직이면 null. 이후 onTokenRefresh 로 보정된다.
      await _fcm.getAPNSToken();
    }
    return _fcm.getToken();
  }

  /// FCM 이 토큰을 새로 발급할 때마다 새 토큰을 흘려보내는 스트림.
  /// (앱 실행 중 재발급/기기 복원/데이터 삭제 등)
  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;

  /// 로컬 알림 초기화 + 포그라운드/탭 핸들러 등록. 앱 첫 프레임 이후 1회 호출.
  Future<void> init({
    void Function(RemoteMessage message)? onMessageOpened,
  }) async {
    if (_initialized) return;
    _initialized = true;
    _onMessageOpened = onMessageOpened;

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
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // TODO(fcm): payload(data JSON) 로 화면 라우팅 처리. (로컬 알림 탭)
        debugPrint('[FCM] 로컬 알림 탭 payload: ${response.payload}');
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final NotificationContent? content = _contentOf(message);
      if (content == null) return;
      _local.show(
        id: content.id,
        title: content.title,
        body: content.body,
        notificationDetails: _details(),
        payload: content.payload,
      );
    });

    // 백그라운드에서 알림 탭 → 앱이 열릴 때.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _onMessageOpened?.call(message);
    });
  }

  /// 종료 상태에서 알림 탭으로 앱이 시작된 경우의 최초 메시지를 처리한다.
  Future<void> checkInitialMessage() async {
    final RemoteMessage? message = await _fcm.getInitialMessage();
    if (message != null) {
      _onMessageOpened?.call(message);
    }
  }

  /// 백그라운드 아이솔레이트에서 data 메시지로 로컬 알림을 표시한다.
  ///
  /// 별도 아이솔레이트라 인스턴스 플러그인을 쓸 수 없어 새 플러그인을 만들어
  /// 초기화한다. (Android data-only 경로에서만 호출된다)
  static Future<void> showDataNotification(RemoteMessage message) async {
    final NotificationContent? content = _contentOf(message);
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

  /// 표시에 쓸 알림 상세. (포그라운드/백그라운드 공통)
  static NotificationDetails _details() => NotificationDetails(
    android: AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    ),
    iOS: const DarwinNotificationDetails(),
  );

  /// 메시지에서 표시할 제목/본문/페이로드를 뽑는다.
  ///
  /// 백엔드 규약에 따라 `data['title']`/`data['body']` 를 우선 쓰고, 값이 없으면
  /// notification 페이로드(iOS 하이브리드)로 보정한다. 둘 다 없으면 표시하지 않는다.
  static NotificationContent? _contentOf(RemoteMessage message) {
    final String? title =
        (message.data['title'] as String?) ?? message.notification?.title;
    final String? body =
        (message.data['body'] as String?) ?? message.notification?.body;
    if (title == null && body == null) return null;

    // data 전체를 payload 로 실어 탭 시 라우팅에 쓴다.
    final String payload = jsonEncode(message.data);
    // 같은 메시지 재수신 시 알림 중복 누적을 줄이도록 messageId 기준 id 부여.
    final int id = (message.messageId ?? payload).hashCode;
    return NotificationContent(id: id, title: title, body: body, payload: payload);
  }
}

/// 로컬 알림 표시에 필요한 최소 내용. ([NotificationService] 내부용)
class NotificationContent {
  const NotificationContent({
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
