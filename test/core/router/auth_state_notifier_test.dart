import 'package:ddara/core/router/app_router.dart';
import 'package:ddara/data/provider/repository_provider.dart';
import 'package:ddara/domain/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;

  /// authRepository 만 스텁으로 갈아끼운 컨테이너.
  /// (build 는 로컬 액세스 토큰 존재 여부로 낙관적 로그인 상태를 확정한다)
  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    repo = MockAuthRepository();
  });

  group('build (로컬 토큰으로 낙관적 로그인 확정)', () {
    test('로컬 액세스 토큰이 있으면 로그인(true)', () async {
      when(() => repo.getAccessToken()).thenAnswer((_) async => 'local-token');
      final container = makeContainer();

      final isLoggedIn = await container.read(authStateProvider.future);

      expect(isLoggedIn, isTrue);
    });

    test('로컬 액세스 토큰이 없으면(null) 비로그인(false)', () async {
      when(() => repo.getAccessToken()).thenAnswer((_) async => null);
      final container = makeContainer();

      final isLoggedIn = await container.read(authStateProvider.future);

      expect(isLoggedIn, isFalse);
    });

    test('로컬 액세스 토큰이 빈 문자열이면 비로그인(false)', () async {
      when(() => repo.getAccessToken()).thenAnswer((_) async => '');
      final container = makeContainer();

      final isLoggedIn = await container.read(authStateProvider.future);

      expect(isLoggedIn, isFalse);
    });

    test('build 는 네트워크 세션 복구(recoverSession)를 호출하지 않는다', () async {
      // 스플래시를 붙잡지 않도록 build 는 로컬 확인만 한다.
      // 실제 복구는 진입 후 백그라운드(MyApp._recoverSession)에서 수행한다.
      when(() => repo.getAccessToken()).thenAnswer((_) async => 'local-token');
      final container = makeContainer();

      await container.read(authStateProvider.future);

      verifyNever(() => repo.recoverSession());
    });
  });

  group('markLoggedOut (세션 만료·로그아웃 시 동기 확정)', () {
    test('로그인 상태에서 호출하면 인증 상태가 즉시 false 가 된다', () async {
      when(() => repo.getAccessToken()).thenAnswer((_) async => 'local-token');
      final container = makeContainer();

      // 로그인 상태로 확정.
      expect(await container.read(authStateProvider.future), isTrue);

      container.read(authStateProvider.notifier).markLoggedOut();

      // 핵심: await 없이 곧바로 false 여야 한다.
      // (라우터 redirect 가 이 값을 동기로 읽어 login→home 바운스를 막는다.
      //  예전 invalidate 방식은 재계산 중 이전 값 true 를 유지해 바운스가 났다)
      final state = container.read(authStateProvider);
      expect(state, const AsyncData<bool>(false));
      expect(state.valueOrNull, isFalse);
    });

    test('markLoggedOut 은 build 를 다시 실행하지 않는다(재계산 없음)', () async {
      when(() => repo.getAccessToken()).thenAnswer((_) async => 'local-token');
      final container = makeContainer();

      await container.read(authStateProvider.future); // 최초 1회 build.
      container.read(authStateProvider.notifier).markLoggedOut();
      // 상태 변화가 재빌드를 유발하지 않는지 이벤트 큐를 비운 뒤 확인.
      await pumpEventQueue();

      verify(() => repo.getAccessToken()).called(1);
      expect(container.read(authStateProvider).valueOrNull, isFalse);
    });
  });

  group('markLoggedIn (재로그인 시 로그인 상태 복귀)', () {
    test('로그아웃(false) 후 markLoggedIn 하면 다시 true 로 돌아온다', () async {
      when(() => repo.getAccessToken()).thenAnswer((_) async => 'local-token');
      final container = makeContainer();
      final notifier = container.read(authStateProvider.notifier);

      // 로그인 → 로그아웃 → 같은 세션에서 재로그인 라운드트립.
      expect(await container.read(authStateProvider.future), isTrue);

      notifier.markLoggedOut();
      expect(container.read(authStateProvider).valueOrNull, isFalse);

      // routeAfterAuth 가 부르는 markLoggedIn 에 해당.
      notifier.markLoggedIn();

      // 핵심: 재로그인 후 isLoggedIn 이 즉시 true 로 복귀해야 redirect
      // (로그인 화면 재진입 → 홈) 가드가 정상 동작한다.
      final state = container.read(authStateProvider);
      expect(state, const AsyncData<bool>(true));
      expect(state.valueOrNull, isTrue);
    });

    test('markLoggedIn 은 build 재실행 없이 동기로 확정한다', () async {
      when(() => repo.getAccessToken()).thenAnswer((_) async => null);
      final container = makeContainer();

      // 미로그인(로컬 토큰 없음)으로 시작.
      expect(await container.read(authStateProvider.future), isFalse);

      container.read(authStateProvider.notifier).markLoggedIn();
      await pumpEventQueue();

      // 최초 build 1회 외에 추가 실행이 없어야 한다.
      verify(() => repo.getAccessToken()).called(1);
      expect(container.read(authStateProvider).valueOrNull, isTrue);
    });
  });
}