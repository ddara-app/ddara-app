import 'dart:async';

import 'package:ddara/core/analytics/crashlytics_manager.dart';
import 'package:ddara/core/analytics/firebase_analytics_manager.dart';
import 'package:ddara/core/analytics/mixpanel_manager.dart';
import 'package:flutter/foundation.dart';

/// 분석 이벤트 전송 창구.
///
/// 화면 코드가 Mixpanel·Firebase Analytics·Crashlytics 를 각각 부르지 않도록
/// 한 곳에서 함께 보낸다. 도구를 늘리거나 빼는 변경이 이 파일 안에서 끝난다.
///
/// Crashlytics 로는 이벤트를 흐름(breadcrumb)으로 남긴다. 분석용이 아니라,
/// 크래시 리포트에 그 직전 경로를 붙여 재현을 돕기 위한 것이다.
///
/// 전송은 기다리지 않는다(fire-and-forget) — 분석은 화면 동작을 지연시킬
/// 이유가 없고, 실패해도 각 어댑터가 자체적으로 삼킨다.
class AppAnalytics {
  const AppAnalytics._();

  /// [name] 이벤트를 분석 도구들에 함께 보내고, 크래시 리포트에도 남긴다.
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
    unawaited(CrashlyticsManager.instance.log(name, properties));
  }

  /// 로그인 사용자를 분석 도구에 식별시킨다.
  ///
  /// Mixpanel 은 이 시점부터 이벤트를 [userId] 에 묶는다. 그래서 한 사람이 어떤
  /// 순서로 화면을 오갔는지 하나의 흐름으로 볼 수 있다. (식별 전 이벤트는 기기별
  /// 익명 id 로 쌓이고, 식별하면 그 익명 id 가 이 사용자에 병합된다)
  ///
  /// [properties] 는 Mixpanel User Profile 로 올라가 세그먼트·필터에 쓰인다.
  /// `r'$name'` 처럼 `$` 로 시작하는 키는 Mixpanel 예약 속성이다.
  static void identifyUser(String userId, {Map<String, dynamic>? properties}) {
    try {
      final mixpanel = MixpanelManager.instance;
      unawaited(mixpanel.identify(userId));
      if (properties != null) {
        // People 은 속성을 하나씩 받는다. (Map 을 통째로 넣는 API 가 없다)
        properties.forEach(mixpanel.getPeople().set);
      }
    } catch (error) {
      // 초기화 실패(StateError) 등으로 Mixpanel 이 없어도 Firebase 는 잇는다.
      debugPrint('[Analytics] Mixpanel 사용자 식별 실패($userId): $error');
    }

    unawaited(FirebaseAnalyticsManager.instance.setUserId(userId));
    // Crashlytics 에는 식별자만 넘긴다. [properties] 에는 닉네임 같은 개인정보가
    // 섞여 있고, 크래시 리포트에 그대로 남기 때문이다.
    unawaited(CrashlyticsManager.instance.setUserId(userId));
  }

  /// 사용자 식별을 지운다. (로그아웃·탈퇴)
  ///
  /// Mixpanel 은 새 익명 id 를 발급해, 같은 기기를 쓰는 다음 사용자의 이벤트가
  /// 이전 사용자에 섞이지 않게 한다. 슈퍼 프로퍼티도 함께 지워진다.
  /// 남길 이벤트가 있으면 이 호출보다 **먼저** 보내야 한다.
  static void resetUser() {
    try {
      unawaited(MixpanelManager.instance.reset());
    } catch (error) {
      debugPrint('[Analytics] Mixpanel 사용자 초기화 실패: $error');
    }

    unawaited(FirebaseAnalyticsManager.instance.setUserId(null));
    unawaited(CrashlyticsManager.instance.setUserId(null));
  }
}
