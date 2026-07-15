import 'package:ddara/core/local/storage_key.dart';
import 'package:ddara/core/network/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class MockDio extends Mock implements Dio {}

class MockRequestHandler extends Mock implements RequestInterceptorHandler {}

class MockErrorHandler extends Mock implements ErrorInterceptorHandler {}

DioException _error(String path, int status) {
  final req = RequestOptions(path: path);
  return DioException(
    requestOptions: req,
    response: Response(requestOptions: req, statusCode: status),
  );
}

void main() {
  late MockSecureStorage storage;
  late MockDio retryDio;

  // 콜백은 단순 카운터/스텁으로 동작을 관찰한다.
  late int recoverCalls;
  late String? recoverResult;
  late int expiredCalls;

  AuthInterceptor build() => AuthInterceptor(
    storage: storage,
    retryDio: retryDio,
    recoverSession: () async {
      recoverCalls++;
      return recoverResult;
    },
    onSessionExpired: () async {
      expiredCalls++;
    },
  );

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
    registerFallbackValue(
      Response(requestOptions: RequestOptions(path: '/')),
    );
    registerFallbackValue(_error('/', 401));
  });

  setUp(() {
    storage = MockSecureStorage();
    retryDio = MockDio();
    recoverCalls = 0;
    recoverResult = null;
    expiredCalls = 0;
  });

  group('onRequest', () {
    test('저장된 AccessToken 을 Authorization 헤더에 붙인다', () async {
      when(
        () => storage.read(key: StorageKey.accessToken),
      ).thenAnswer((_) async => 'abc');
      final handler = MockRequestHandler();
      final options = RequestOptions(path: '/api/groups');

      build().onRequest(options, handler);
      await pumpEventQueue();

      expect(options.headers['Authorization'], 'Bearer abc');
      verify(() => handler.next(options)).called(1);
    });

    test('토큰이 없으면 헤더를 붙이지 않는다', () async {
      when(
        () => storage.read(key: StorageKey.accessToken),
      ).thenAnswer((_) async => null);
      final handler = MockRequestHandler();
      final options = RequestOptions(path: '/api/groups');

      build().onRequest(options, handler);
      await pumpEventQueue();

      expect(options.headers.containsKey('Authorization'), isFalse);
      verify(() => handler.next(options)).called(1);
    });

    test('인증 API(/api/auth/*) 에는 토큰을 붙이지 않는다', () async {
      when(
        () => storage.read(key: StorageKey.accessToken),
      ).thenAnswer((_) async => 'abc');
      final handler = MockRequestHandler();
      final options = RequestOptions(path: '/api/auth/login');

      build().onRequest(options, handler);
      await pumpEventQueue();

      expect(options.headers.containsKey('Authorization'), isFalse);
      // 토큰을 읽지도 않는다.
      verifyNever(() => storage.read(key: StorageKey.accessToken));
      verify(() => handler.next(options)).called(1);
    });
  });

  group('onError', () {
    test('401 이 아니면 그대로 전파하고 복구하지 않는다', () async {
      final handler = MockErrorHandler();
      final err = _error('/api/groups', 500);

      build().onError(err, handler);
      await pumpEventQueue();

      expect(recoverCalls, 0);
      verify(() => handler.next(err)).called(1);
    });

    test('인증 API(/api/auth/*) 401 은 복구하지 않고 전파한다(재귀 차단)', () async {
      final handler = MockErrorHandler();
      final err = _error('/api/auth/refresh', 401);

      build().onError(err, handler);
      await pumpEventQueue();

      expect(recoverCalls, 0);
      verify(() => handler.next(err)).called(1);
    });

    test('이미 재시도한 요청은 다시 복구하지 않는다', () async {
      final handler = MockErrorHandler();
      final req = RequestOptions(path: '/api/groups', extra: {'retried': true});
      final err = DioException(
        requestOptions: req,
        response: Response(requestOptions: req, statusCode: 401),
      );

      build().onError(err, handler);
      await pumpEventQueue();

      expect(recoverCalls, 0);
      verify(() => handler.next(err)).called(1);
    });

    test('복구 성공 시 새 토큰으로 재시도하고 응답을 resolve 한다', () async {
      recoverResult = 'fresh';
      final retried = Response(
        requestOptions: RequestOptions(path: '/api/groups'),
        statusCode: 200,
      );
      when(() => retryDio.fetch<dynamic>(any())).thenAnswer((_) async => retried);

      final handler = MockErrorHandler();
      final err = _error('/api/groups', 401);

      build().onError(err, handler);
      await pumpEventQueue();

      expect(recoverCalls, 1);
      expect(err.requestOptions.headers['Authorization'], 'Bearer fresh');
      expect(err.requestOptions.extra['retried'], true);
      verify(() => handler.resolve(retried)).called(1);
      expect(expiredCalls, 0);
    });

    test('복구가 null 이면 강제 로그아웃을 호출하고 에러를 전파한다', () async {
      recoverResult = null;
      final handler = MockErrorHandler();
      final err = _error('/api/groups', 401);

      build().onError(err, handler);
      await pumpEventQueue();

      expect(recoverCalls, 1);
      expect(expiredCalls, 1);
      verify(() => handler.next(err)).called(1);
      verifyNever(() => retryDio.fetch<dynamic>(any()));
    });
  });
}
