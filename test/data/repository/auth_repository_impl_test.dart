import 'package:ddara/core/auth/apple/apple_auth_service.dart';
import 'package:ddara/core/auth/google/google_auth_service.dart';
import 'package:ddara/core/auth/kakao/kakao_auth_service.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/domain/model/auth/social_login_type.dart';
import 'package:ddara/core/network/dto/auth/login_response.dart';
import 'package:ddara/core/network/dto/auth/refresh_access_token_response.dart';
import 'package:ddara/data/datasource/auth/auth_datasource.dart';
import 'package:ddara/data/repository/auth_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockKakaoAuthService extends Mock implements KakaoAuthService {}

class MockGoogleAuthService extends Mock implements GoogleAuthService {}

class MockAppleAuthService extends Mock implements AppleAuthService {}

DioException _dioError(int status) {
  final req = RequestOptions(path: '/api/auth/refresh');
  return DioException(
    requestOptions: req,
    response: Response(requestOptions: req, statusCode: status),
  );
}

LoginResponse _loginResponse({
  bool isNewUser = false,
  String? accessToken = 'newAccess',
  String? refreshToken = 'newRefresh',
}) {
  return LoginResponse(
    isNewUser: isNewUser,
    accessToken: accessToken,
    refreshToken: refreshToken,
    user: null,
  );
}

void main() {
  late MockAuthRemoteDataSource ds;
  late MockKakaoAuthService kakao;
  late MockGoogleAuthService google;
  late MockAppleAuthService apple;
  late AuthRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(SocialLoginType.google);
  });

  setUp(() {
    ds = MockAuthRemoteDataSource();
    kakao = MockKakaoAuthService();
    google = MockGoogleAuthService();
    apple = MockAppleAuthService();
    repo = AuthRepositoryImpl(ds, kakao, google, apple);

    // 저장 계열은 기본적으로 통과시킨다.
    when(() => ds.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => ds.saveRefreshToken(any())).thenAnswer((_) async {});
    when(() => ds.saveSocialLoginType(any())).thenAnswer((_) async {});
  });

  group('recoverSession - 재발급', () {
    test('RefreshToken 정상이면 재발급 토큰을 저장하고 반환한다', () async {
      when(() => ds.getRefreshToken()).thenAnswer((_) async => 'refresh');
      when(() => ds.refreshAccessToken('refresh')).thenAnswer(
        (_) async => const RefreshAccessTokenResponse(accessToken: 'reissued'),
      );

      final result = await repo.recoverSession();

      expect(result, 'reissued');
      verify(() => ds.saveAccessToken('reissued')).called(1);
      // 재발급 성공 시 소셜 경로는 타지 않는다.
      verifyNever(() => ds.getSocialLoginType());
    });

    test('재발급이 401 이 아닌 오류면 그대로 전파한다(강제 로그아웃 안 함)', () async {
      when(() => ds.getRefreshToken()).thenAnswer((_) async => 'refresh');
      when(
        () => ds.refreshAccessToken('refresh'),
      ).thenThrow(_dioError(500));

      expect(repo.recoverSession(), throwsA(isA<DioException>()));
    });
  });

  group('recoverSession - 소셜 무중단 재인증', () {
    test('RefreshToken 없고 소셜 정보도 없으면 null', () async {
      when(() => ds.getRefreshToken()).thenAnswer((_) async => null);
      when(() => ds.getSocialLoginType()).thenAnswer((_) async => null);

      expect(await repo.recoverSession(), isNull);
    });

    test('재발급 401 → 구글 무중단 재인증 성공 시 새 토큰 반환·저장', () async {
      when(() => ds.getRefreshToken()).thenAnswer((_) async => 'refresh');
      when(() => ds.refreshAccessToken('refresh')).thenThrow(_dioError(401));
      when(
        () => ds.getSocialLoginType(),
      ).thenAnswer((_) async => SocialLoginType.google);
      when(() => google.signInSilently()).thenAnswer((_) async => 'gToken');
      when(
        () => ds.login('gToken', SocialLoginType.google),
      ).thenAnswer((_) async => _loginResponse(accessToken: 'social-access'));

      final result = await repo.recoverSession();

      expect(result, 'social-access');
      verify(() => ds.saveAccessToken('social-access')).called(1);
      verify(() => ds.saveRefreshToken('newRefresh')).called(1);
      verify(() => ds.saveSocialLoginType(SocialLoginType.google)).called(1);
    });

    test('구글 signInSilently 가 null 이면 복구 실패(null)', () async {
      when(() => ds.getRefreshToken()).thenAnswer((_) async => null);
      when(
        () => ds.getSocialLoginType(),
      ).thenAnswer((_) async => SocialLoginType.google);
      when(() => google.signInSilently()).thenAnswer((_) async => null);

      expect(await repo.recoverSession(), isNull);
    });

    test('카카오 토큰 유효하면 재로그인 성공', () async {
      when(() => ds.getRefreshToken()).thenAnswer((_) async => null);
      when(
        () => ds.getSocialLoginType(),
      ).thenAnswer((_) async => SocialLoginType.kakao);
      when(() => kakao.availabilityToken()).thenAnswer((_) async => true);
      when(() => kakao.getKakaoAccessToken()).thenAnswer((_) async => 'kToken');
      when(
        () => ds.login('kToken', SocialLoginType.kakao),
      ).thenAnswer((_) async => _loginResponse(accessToken: 'kakao-access'));

      expect(await repo.recoverSession(), 'kakao-access');
    });

    test('카카오 토큰 무효하면 복구 실패(null)', () async {
      when(() => ds.getRefreshToken()).thenAnswer((_) async => null);
      when(
        () => ds.getSocialLoginType(),
      ).thenAnswer((_) async => SocialLoginType.kakao);
      when(() => kakao.availabilityToken()).thenAnswer((_) async => false);

      expect(await repo.recoverSession(), isNull);
      verifyNever(() => kakao.getKakaoAccessToken());
    });

    test('소셜 재로그인 응답이 isNewUser=true 면 복구 실패(null)', () async {
      when(() => ds.getRefreshToken()).thenAnswer((_) async => null);
      when(
        () => ds.getSocialLoginType(),
      ).thenAnswer((_) async => SocialLoginType.google);
      when(() => google.signInSilently()).thenAnswer((_) async => 'gToken');
      when(() => ds.login('gToken', SocialLoginType.google)).thenAnswer(
        (_) async => _loginResponse(
          isNewUser: true,
          accessToken: null,
          refreshToken: null,
        ),
      );

      expect(await repo.recoverSession(), isNull);
      verifyNever(() => ds.saveAccessToken(any()));
    });

    test('소셜 토큰이 서버에서 거부(401)되면 복구 실패(null)', () async {
      when(() => ds.getRefreshToken()).thenAnswer((_) async => null);
      when(
        () => ds.getSocialLoginType(),
      ).thenAnswer((_) async => SocialLoginType.google);
      when(() => google.signInSilently()).thenAnswer((_) async => 'gToken');
      when(
        () => ds.login('gToken', SocialLoginType.google),
      ).thenThrow(_dioError(401));

      expect(await repo.recoverSession(), isNull);
    });

    test('소셜 재로그인 중 네트워크 오류는 전파한다(강제 로그아웃 안 함)', () async {
      when(() => ds.getRefreshToken()).thenAnswer((_) async => null);
      when(
        () => ds.getSocialLoginType(),
      ).thenAnswer((_) async => SocialLoginType.google);
      when(() => google.signInSilently()).thenAnswer((_) async => 'gToken');
      when(
        () => ds.login('gToken', SocialLoginType.google),
      ).thenThrow(_dioError(500));

      expect(repo.recoverSession(), throwsA(isA<NetworkException>()));
    });
  });

  group('recoverSession - 단일 비행', () {
    test('동시 호출 시 복구는 한 번만 수행하고 결과를 공유한다', () async {
      when(() => ds.getRefreshToken()).thenAnswer((_) async => 'refresh');
      when(() => ds.refreshAccessToken('refresh')).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return const RefreshAccessTokenResponse(accessToken: 'once');
      });

      final results = await Future.wait([
        repo.recoverSession(),
        repo.recoverSession(),
        repo.recoverSession(),
      ]);

      expect(results, ['once', 'once', 'once']);
      verify(() => ds.refreshAccessToken('refresh')).called(1);
    });

    test('복구 완료 후 다시 호출하면 새로 수행한다', () async {
      when(() => ds.getRefreshToken()).thenAnswer((_) async => 'refresh');
      when(() => ds.refreshAccessToken('refresh')).thenAnswer(
        (_) async => const RefreshAccessTokenResponse(accessToken: 'a'),
      );

      await repo.recoverSession();
      await repo.recoverSession();

      verify(() => ds.refreshAccessToken('refresh')).called(2);
    });
  });
}
