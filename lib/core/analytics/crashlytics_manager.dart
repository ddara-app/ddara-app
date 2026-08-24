import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Crashlytics 어댑터.
///
/// 크래시 리포트에 **사용자와 그가 지나온 흐름**을 붙인다. 분석 이벤트를 그대로
/// 로그로 남겨두면, 크래시가 났을 때 리포트에 그 직전까지의 이벤트가 시간순으로
/// 따라붙어 재현 경로를 좁힐 수 있다.
///
/// 에러 보고 자체(FlutterError.onError 등)는 앱 시작 시 `app_bootstrap` 이
/// 연결한다. 여기는 그 리포트에 얹을 맥락만 담당한다.
class CrashlyticsManager {
  CrashlyticsManager._();

  static final CrashlyticsManager instance = CrashlyticsManager._();

  /// 로그 한 줄의 최대 길이. (Crashlytics 제한 1KB)
  ///
  /// 세션 전체로는 64KB 까지 쌓이고 넘으면 오래된 것부터 버려진다.
  static const _maxLogLength = 1024;

  /// 이벤트를 크래시 리포트의 흐름(breadcrumb)으로 남긴다.
  ///
  /// 실패해도 앱 흐름을 막지 않는다. (분석 데이터의 문제일 뿐)
  Future<void> log(String name, Map<String, dynamic>? properties) async {
    try {
      await FirebaseCrashlytics.instance.log(_message(name, properties));
    } catch (error) {
      debugPrint('[Analytics] Crashlytics 로그 실패($name): $error');
    }
  }

  /// 앱을 죽이지 않은 에러를 non-fatal 이슈로 남긴다.
  ///
  /// 크래시 목록과 섞이지 않고 따로 쌓이며, [log] 로 남긴 흐름과 사용자
  /// 식별자가 그대로 따라붙는다. [reason] 은 리포트에 함께 보일 한 줄 설명이다.
  ///
  /// 무엇을 남길지는 부르는 쪽이 고른다. 사용자 입력 실수까지 남기면 정상
  /// 동작이 이슈로 쌓여 우선순위 판단을 방해한다.
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
  }) async {
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: reason,
        fatal: false,
      );
    } catch (error) {
      debugPrint('[Analytics] Crashlytics 에러 기록 실패: $error');
    }
  }

  /// 크래시 리포트에 붙일 사용자 식별자를 설정한다.
  ///
  /// 로그아웃 시엔 null 을 넘긴다. (Crashlytics 는 빈 문자열로 식별을 지운다)
  /// 닉네임 같은 개인정보는 넘기지 않는다 — 리포트에 그대로 남기 때문이다.
  Future<void> setUserId(String? userId) async {
    try {
      await FirebaseCrashlytics.instance.setUserIdentifier(userId ?? '');
    } catch (error) {
      debugPrint('[Analytics] Crashlytics 사용자 id 설정 실패: $error');
    }
  }

  /// 이벤트 이름과 속성을 한 줄로 합친다. (`name(key=value, ...)`)
  static String _message(String name, Map<String, dynamic>? properties) {
    if (properties == null || properties.isEmpty) return name;

    final pairs = properties.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join(', ');
    final message = '$name($pairs)';

    return message.length <= _maxLogLength
        ? message
        : message.substring(0, _maxLogLength);
  }
}
