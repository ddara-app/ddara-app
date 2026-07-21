import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';

/// 모든 API 요청의 소요 시간·응답 코드·페이로드 크기를 Firebase Performance
/// `HttpMetric` 으로 기록한다.
///
/// Dio 는 Dart 소켓으로 직접 통신하므로 Firebase 의 네이티브 자동 네트워크
/// 계측(OkHttp·URLSession)에 잡히지 않는다. 이 인터셉터가 그 공백을 메운다.
///
/// 계측 실패가 실제 요청을 막지 않도록 모든 단계는 조용히 실패한다.
/// (수집이 꺼진 디버그 빌드에서는 start/stop 이 no-op)
class PerformanceInterceptor extends Interceptor {
  static const _metricKey = 'perf_http_metric';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final metric = FirebasePerformance.instance.newHttpMetric(
        _metricUrl(options.uri),
        _method(options.method),
      );
      await metric.start();
      options.extra[_metricKey] = metric;
    } catch (_) {
      // 계측 시작 실패는 무시하고 요청을 계속한다.
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _stopMetric(response.requestOptions, response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 네트워크 단절 등 응답 자체가 없으면 응답 코드 없이 시간만 기록된다.
    _stopMetric(err.requestOptions, err.response);
    handler.next(err);
  }

  /// 요청에 붙여둔 metric 을 응답 정보와 함께 종료한다. (재진입 방지로 제거 후 종료)
  void _stopMetric(RequestOptions options, Response<dynamic>? response) async {
    final metric = options.extra.remove(_metricKey);
    if (metric is! HttpMetric) return;

    try {
      if (response != null) {
        metric.httpResponseCode = response.statusCode;
        metric.responseContentType = response.headers.value(
          Headers.contentTypeHeader,
        );
        final length = int.tryParse(
          response.headers.value(Headers.contentLengthHeader) ?? '',
        );
        if (length != null) metric.responsePayloadSize = length;
      }
      await metric.stop();
    } catch (_) {
      // 계측 종료 실패는 무시한다.
    }
  }

  /// 콘솔의 URL 패턴이 요청마다 흩어지지 않도록 쿼리스트링은 제외하고 기록한다.
  String _metricUrl(Uri uri) => uri.toString().split('?').first;

  HttpMethod _method(String method) => switch (method.toUpperCase()) {
    'GET' => HttpMethod.Get,
    'POST' => HttpMethod.Post,
    'PUT' => HttpMethod.Put,
    'DELETE' => HttpMethod.Delete,
    'PATCH' => HttpMethod.Patch,
    'HEAD' => HttpMethod.Head,
    'OPTIONS' => HttpMethod.Options,
    'TRACE' => HttpMethod.Trace,
    'CONNECT' => HttpMethod.Connect,
    _ => HttpMethod.Get,
  };
}