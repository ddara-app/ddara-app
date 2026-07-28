import 'dart:async';

import 'package:ddara/core/analytics/firebase_analytics_manager.dart';
import 'package:ddara/core/analytics/mixpanel_manager.dart';
import 'package:flutter/foundation.dart';

/// 분석 이벤트 전송 창구.
///
/// 화면 코드가 Mixpanel·Firebase Analytics 를 각각 부르지 않도록 한 곳에서
/// 함께 보낸다. 도구를 늘리거나 빼는 변경이 이 파일 안에서 끝난다.
///
/// 전송은 기다리지 않는다(fire-and-forget) — 분석은 화면 동작을 지연시킬
/// 이유가 없고, 실패해도 각 어댑터가 자체적으로 삼킨다.
class AppAnalytics {
  const AppAnalytics._();

  /// [name] 이벤트를 두 분석 도구에 함께 보낸다.
  ///
  /// 이벤트 이름은 Mixpanel 기준(자유 문자열)으로 넘기면 되고, Firebase 규칙에
  /// 맞춘 보정은 [FirebaseAnalyticsManager] 가 처리한다.
  static void track(String name, {Map<String, dynamic>? properties}) {
    try {
      MixpanelManager.instance.track(name, properties: properties);
    } catch (error) {
      // 초기화 실패(StateError) 등으로 Mixpanel 이 없어도 Firebase 전송은 잇는다.
      debugPrint('[Analytics] Mixpanel 이벤트 전송 실패($name): $error');
    }

    unawaited(FirebaseAnalyticsManager.instance.logEvent(name, properties));
  }

  /// 로그인 사용자 식별자를 설정한다. 로그아웃 시엔 null 을 넘긴다.
  static void setUserId(String? userId) {
    unawaited(FirebaseAnalyticsManager.instance.setUserId(userId));
  }
}
