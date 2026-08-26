import 'dart:async';

import 'package:ddara/core/analytics/crashlytics_manager.dart';
import 'package:dio/dio.dart';

/// 예상치 못한 API 실패만 Crashlytics 에 non-fatal 로 기록하는 인터셉터.
///
/// 실패를 전부 남기면 정상 동작이 이슈로 쌓여 쓸모가 없어진다. 그래서 **고쳐야
/// 할 문제**만 고른다 — 서버 오류(5xx)·연결 실패·타임아웃처럼 사용자가 어떻게
/// 해볼 수 없는 것들이다.
///
/// 4xx 는 거른다. 잘못된 초대코드·정원 초과·닉네임 중복 같은 비즈니스 오류라
/// 화면이 안내 문구로 처리하는 정상 흐름이고, 얼마나 자주 일어나는지는 이미
/// Mixpanel 이벤트로 본다.
///
/// [AuthInterceptor] 보다 **뒤에** 등록해야 한다. 401 을 세션 복구로 되살린
/// 경우는 여기까지 오지 않아야 하기 때문이다.
class ErrorReportingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_shouldReport(err)) {
      unawaited(
        CrashlyticsManager.instance.recordError(
          err,
          err.stackTrace,
          reason: _reason(err),
        ),
      );
    }

    handler.next(err);
  }

  /// 기록할 실패인지. (판단 기준은 클래스 주석 참고)
  static bool _shouldReport(DioException err) {
    final statusCode = err.response?.statusCode;
    // 서버가 응답을 준 경우 — 5xx 만 남긴다.
    if (statusCode != null) return statusCode >= 500;

    // 응답이 없는 경우 — 연결·타임아웃·파싱 실패 등.
    // 취소는 화면 이탈 등으로 우리가 끊은 것이라 문제가 아니다.
    return err.type != DioExceptionType.cancel;
  }

  /// 리포트에 함께 남길 한 줄 설명. (`POST /api/groups -> 500`)
  ///
  /// 쿼리 문자열은 뗀다 — 초대 코드 같은 값이 리포트에 남지 않도록.
  static String _reason(DioException err) {
    final options = err.requestOptions;
    final path = Uri.parse(options.path).path;
    final result = err.response?.statusCode?.toString() ?? err.type.name;

    return '${options.method} $path -> $result';
  }
}
