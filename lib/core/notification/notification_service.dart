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
/// notification 페이로드가 있는 메시지는 OS 가 기본 채널로 자동 표시하므로
/// 여기서는 백그라운드 아이솔레이트의 Firebase 초기화만 보장한다.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[FCM] 백그라운드 메시지 수신: ${message.messageId}');
}

/// FCM 수신 + 로컬 알림 표시 등 순수 플러밍을 담당하는 싱글턴.
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

  /// 포그라운드 알림 표시 및 백그라운드 자동 표시에 함께 쓰는 Android 채널.
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
        // TODO(fcm): payload 로 화면 라우팅 처리. (로컬 알림 탭)
        debugPrint('[FCM] 로컬 알림 탭 payload: ${response.payload}');
      },
    );

    // Android 알림 채널 생성. (없으면 포그라운드 로컬 알림이 표시되지 않음)
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  void _setupHandlers() {
    // 포그라운드: 시스템이 자동 표시하지 않으므로 로컬 알림으로 직접 띄운다.
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

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

  void _showLocalNotification(RemoteMessage message) {
    final RemoteNotification? notification = message.notification;
    if (notification == null) return;

    _local.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }
}
