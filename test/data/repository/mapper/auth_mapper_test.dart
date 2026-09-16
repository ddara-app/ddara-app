import 'package:ddara/core/network/dto/auth/login_response.dart';
import 'package:ddara/data/repository/mapper/auth_mapper.dart';
import 'package:ddara/domain/model/sign_up_command.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginMapper', () {
    test('DTO 필드를 그대로 도메인 모델로 옮긴다', () {
      const response = LoginResponse(
        isNewUser: false,
        accessToken: 'access',
        refreshToken: 'refresh',
        user: null,
      );

      final login = response.toDomain();

      expect(login.isNewUser, false);
      expect(login.accessToken, 'access');
      expect(login.refreshToken, 'refresh');
    });

    test('토큰이 null 이어도 그대로 전달한다 (신규 유저 약관 동의 전 상태)', () {
      const response = LoginResponse(
        isNewUser: true,
        accessToken: null,
        refreshToken: null,
        user: null,
      );

      final login = response.toDomain();

      expect(login.isNewUser, true);
      expect(login.accessToken, isNull);
      expect(login.refreshToken, isNull);
    });
  });

  group('SignUpMapper', () {
    test('SignUpCommand 를 SignUpRequest 로 변환한다', () {
      const command = SignUpCommand(
        provider: 'KAKAO',
        accessToken: 'kakaoToken',
        termsAgreed: true,
      );

      final request = command.toDto();

      expect(request.provider, 'KAKAO');
      expect(request.accessToken, 'kakaoToken');
      expect(request.termsAgreed, true);
    });
  });
}
