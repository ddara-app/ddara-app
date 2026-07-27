import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase Analytics 전송 어댑터.
///
/// Firebase 는 이벤트 이름·파라미터에 제약이 있어([_sanitizeName]·[_sanitizeParams])
/// Mixpanel 과 같은 호출을 그대로 넘길 수 없다. 그 차이를 여기서 흡수해,
/// 호출부([AppAnalytics])는 두 도구의 규칙을 몰라도 되게 한다.
class FirebaseAnalyticsManager {
  FirebaseAnalyticsManager._();

  static final FirebaseAnalyticsManager instance = FirebaseAnalyticsManager._();

  /// 화면 전환 자동 기록용 옵저버. (GoRouter 의 observers 에 등록)
  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  /// 이벤트 이름 최대 길이. (Firebase 제한)
  static const _maxNameLength = 40;

  /// 파라미터 문자열 값의 최대 길이. (Firebase 제한)
  static const _maxParamValueLength = 100;

  /// 이벤트를 전송한다. 실패해도 앱 흐름을 막지 않는다.
  ///
  /// Firebase 미초기화·네트워크 오류 등은 분석 데이터의 문제일 뿐이므로
  /// 삼키고 로그만 남긴다. (Mixpanel 전송까지 함께 끊기지 않도록)
  Future<void> logEvent(String name, Map<String, dynamic>? properties) async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: _sanitizeName(name),
        parameters: _sanitizeParams(properties),
      );
    } catch (error) {
      debugPrint('[Analytics] Firebase 이벤트 전송 실패($name): $error');
    }
  }

  /// 로그인 사용자 식별자를 설정한다. 로그아웃 시엔 null 을 넘긴다.
  Future<void> setUserId(String? userId) async {
    try {
      await FirebaseAnalytics.instance.setUserId(id: userId);
    } catch (error) {
      debugPrint('[Analytics] Firebase 사용자 id 설정 실패: $error');
    }
  }

  /// 이벤트 이름을 Firebase 규칙에 맞게 보정한다.
  ///
  /// 영숫자·언더스코어만 허용하고 문자로 시작해야 하며 40자를 넘을 수 없다.
  /// (Mixpanel 은 제약이 없어 `onboarding_step_viewed(1)` 같은 이름이 들어온다)
  static String _sanitizeName(String name) {
    final replaced = name.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
    // 문자로 시작하지 않으면(숫자·언더스코어) 접두사를 붙여 규칙을 맞춘다.
    final prefixed = RegExp(r'^[A-Za-z]').hasMatch(replaced)
        ? replaced
        : 'e_$replaced';

    return prefixed.length <= _maxNameLength
        ? prefixed
        : prefixed.substring(0, _maxNameLength);
  }

  /// 파라미터를 Firebase 가 받는 형태(String·num)로 변환한다.
  ///
  /// null 값은 제외하고, 그 외 타입은 문자열로 바꾼다. 값이 없으면 null 을
  /// 돌려 파라미터 없는 이벤트로 보낸다. (빈 Map 은 허용되지 않는다)
  static Map<String, Object>? _sanitizeParams(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return null;

    final result = <String, Object>{};
    params.forEach((key, value) {
      if (value == null) return;
      final name = _sanitizeName(key);
      result[name] = value is num ? value : _clampValue('$value');
    });

    return result.isEmpty ? null : result;
  }

  /// 문자열 파라미터 값을 최대 길이로 자른다.
  static String _clampValue(String value) =>
      value.length <= _maxParamValueLength
      ? value
      : value.substring(0, _maxParamValueLength);
}
