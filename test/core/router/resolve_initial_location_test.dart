import 'package:ddara/core/router/app_router.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveInitialLocation (콜드 스타트 초기 분기)', () {
    test('온보딩을 본 적 없으면 로그인·초대 여부와 무관하게 온보딩', () {
      final location = resolveInitialLocation(
        hasSeenOnboarding: false,
        isLoggedIn: true,
        pendingInvite: 'ABC123',
      );

      expect(location, RoutePath.onboarding);
    });

    test('온보딩은 봤지만 미로그인이면 로그인', () {
      final location = resolveInitialLocation(
        hasSeenOnboarding: true,
        isLoggedIn: false,
        pendingInvite: null,
      );

      expect(location, RoutePath.login);
    });

    test('미로그인이면 보관된 초대코드가 있어도 로그인 (로그인 후 소비)', () {
      final location = resolveInitialLocation(
        hasSeenOnboarding: true,
        isLoggedIn: false,
        pendingInvite: 'ABC123',
      );

      expect(location, RoutePath.login);
    });

    test('로그인 상태 + 초대코드 없으면 홈', () {
      final location = resolveInitialLocation(
        hasSeenOnboarding: true,
        isLoggedIn: true,
        pendingInvite: null,
      );

      expect(location, RoutePath.home);
    });

    test('로그인 상태 + 빈 초대코드는 없는 것으로 취급해 홈', () {
      final location = resolveInitialLocation(
        hasSeenOnboarding: true,
        isLoggedIn: true,
        pendingInvite: '',
      );

      expect(location, RoutePath.home);
    });

    test('로그인 상태 + 초대코드 있으면 홈을 거치지 않고 landing 으로 코드 전달', () {
      final location = resolveInitialLocation(
        hasSeenOnboarding: true,
        isLoggedIn: true,
        pendingInvite: 'ABC123',
      );

      expect(location, '${RoutePath.inviteLanding}?code=ABC123');
    });

    test('loginRoute 를 재정의하면 미로그인 분기에 반영된다', () {
      final location = resolveInitialLocation(
        hasSeenOnboarding: true,
        isLoggedIn: false,
        pendingInvite: null,
        loginRoute: '/custom-login',
      );

      expect(location, '/custom-login');
    });
  });
}
