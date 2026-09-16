import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/core/permission/provider/permission_provider.dart';
import 'package:ddara/core/router/app_router.dart';
import 'package:ddara/core/router/pending_invite.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/data/provider/repository_provider.dart';
import 'package:ddara/domain/model/group/group_list.dart';
import 'package:ddara/domain/model/profile/notification_settings.dart';
import 'package:ddara/domain/model/profile/profile.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/repository/auth_repository.dart';
import 'package:ddara/domain/usecase/block/get_blocked_user_ids_use_case.dart';
import 'package:ddara/domain/usecase/group/get_group_list_use_case.dart';
import 'package:ddara/domain/usecase/profile/get_notification_settings_use_case.dart';
import 'package:ddara/domain/usecase/profile/get_profile_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockPermissionService extends Mock implements PermissionService {}

class MockGetGroupListUseCase extends Mock implements GetGroupListUseCase {}

class MockGetBlockedUserIdsUseCase extends Mock implements GetBlockedUserIdsUseCase {}

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class MockGetNotificationSettingsUseCase extends Mock
    implements GetNotificationSettingsUseCase {}

/// [routeAfterAuth] 를 호출할 [WidgetRef] 를 얻기 위한 자리표시 화면.
/// 실제 화면은 BuildContext 없이도 쓸 수 있게 router 를 직접 받지만, ref 는
/// Provider 트리에 묶여 있어 위젯을 통해서만 얻을 수 있다.
class _StartScreen extends ConsumerWidget {
  const _StartScreen({required this.onRef});

  final void Function(WidgetRef ref) onRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    onRef(ref);
    return const SizedBox.shrink();
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(label);
}

GoRouter _buildRouter(void Function(WidgetRef ref) onRef) {
  return GoRouter(
    initialLocation: '/start',
    routes: [
      GoRoute(
        path: '/start',
        builder: (_, _) => _StartScreen(onRef: onRef),
      ),
      GoRoute(
        path: RoutePath.permission,
        builder: (_, _) => const _Placeholder('permission'),
      ),
      GoRoute(
        path: RoutePath.home,
        builder: (_, _) => const _Placeholder('home'),
      ),
      GoRoute(
        path: RoutePath.inviteLanding,
        builder: (_, state) => _Placeholder('landing:${state.uri.queryParameters['code']}'),
      ),
    ],
  );
}

void main() {
  late MockAuthRepository authRepository;
  late MockPermissionService permission;
  late MockGetGroupListUseCase getGroupList;
  late MockGetBlockedUserIdsUseCase getBlockedUserIds;
  late MockGetProfileUseCase getProfile;
  late MockGetNotificationSettingsUseCase getNotificationSettings;
  late ProviderContainer container;
  late WidgetRef ref;
  late GoRouter router;

  setUpAll(() {
    PackageInfo.setMockInitialValues(
      appName: 'ddara',
      packageName: 'com.ddara.team3',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  setUp(() async {
    authRepository = MockAuthRepository();
    permission = MockPermissionService();
    getGroupList = MockGetGroupListUseCase();
    getBlockedUserIds = MockGetBlockedUserIdsUseCase();
    getProfile = MockGetProfileUseCase();
    getNotificationSettings = MockGetNotificationSettingsUseCase();

    when(() => authRepository.getAccessToken()).thenAnswer((_) async => 'access');
    when(() => getGroupList()).thenAnswer((_) async => const GroupList(groups: []));
    when(() => getBlockedUserIds()).thenAnswer((_) async => <int>{});
    when(() => getProfile()).thenAnswer(
      (_) async => Profile(
        id: 1,
        name: 'kim',
        profileImageUrl: null,
        provider: 'KAKAO',
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    when(() => getNotificationSettings()).thenAnswer(
      (_) async => const NotificationSettings(
        allowAll: true,
        followShot: true,
        friendShot: true,
        starterAssigned: true,
        comment: true,
        memberJoin: true,
      ),
    );

    router = _buildRouter((r) => ref = r);
  });

  /// [permissionGranted] · [pendingInvite] · [noticeAcknowledged] 로 시작 상태를
  /// 맞춘 컨테이너를 만들고, authStateProvider 의 최초 build() 가 끝날 때까지
  /// 기다린다. (build 도중 markLoggedIn 을 부르면 대입이 씹힐 수 있다)
  Future<void> pumpWithOverrides(
    WidgetTester tester, {
    required bool permissionGranted,
    String? pendingInvite,
    bool noticeAcknowledged = false,
  }) async {
    when(() => permission.isCameraGranted()).thenAnswer((_) async => permissionGranted);
    when(() => permission.isNotificationGranted()).thenAnswer((_) async => true);

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        permissionServiceProvider.overrideWithValue(permission),
        getGroupListUseCaseProvider.overrideWithValue(getGroupList),
        getBlockedUserIdsUseCaseProvider.overrideWithValue(getBlockedUserIds),
        getProfileUseCaseProvider.overrideWithValue(getProfile),
        getNotificationSettingsUseCaseProvider.overrideWithValue(getNotificationSettings),
        cameraNoticeAcknowledgedProvider.overrideWith((ref) => noticeAcknowledged),
        pendingInviteCodeProvider.overrideWith((ref) => pendingInvite),
      ],
    );
    addTearDown(container.dispose);
    // authStateProvider 의 초기 build() 를 먼저 끝내둔다. (실제 앱도 라우터
    // 진입 전 이미 한 번 조회돼 있다 — build 도중 markLoggedIn 을 부르는 건
    // 이 함수가 테스트하려는 대상이 아니다)
    await container.read(authStateProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
  }

  testWidgets('카메라 권한이 없으면 권한 화면으로 보내고, 보관된 초대코드는 그대로 둔다', (
    tester,
  ) async {
    await pumpWithOverrides(
      tester,
      permissionGranted: false,
      pendingInvite: 'ABC123',
    );

    await routeAfterAuth(ref, router);
    await tester.pumpAndSettle();

    expect(find.text('permission'), findsOneWidget);
    expect(container.read(pendingInviteCodeProvider), 'ABC123');
    expect(container.read(authStateProvider).value, true);
  });

  testWidgets('권한 안내를 이미 봤고 보관된 초대코드가 있으면 랜딩으로 보내고 코드를 소비한다', (
    tester,
  ) async {
    await pumpWithOverrides(
      tester,
      permissionGranted: true,
      pendingInvite: 'XYZ789',
      noticeAcknowledged: true,
    );

    await routeAfterAuth(ref, router);
    await tester.pumpAndSettle();

    expect(find.text('landing:XYZ789'), findsOneWidget);
    expect(container.read(pendingInviteCodeProvider), isNull);
  });

  testWidgets('권한 안내를 이미 봤고 보관된 초대코드가 없으면 기본 홈으로 보낸다', (tester) async {
    await pumpWithOverrides(
      tester,
      permissionGranted: true,
      pendingInvite: null,
      noticeAcknowledged: true,
    );

    await routeAfterAuth(ref, router);
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('권한 안내 전이지만 이미 허용돼 있으면 안내를 본 것으로 확정하고 통과시킨다', (
    tester,
  ) async {
    await pumpWithOverrides(
      tester,
      permissionGranted: true,
      pendingInvite: null,
      noticeAcknowledged: false,
    );

    await routeAfterAuth(ref, router);
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    expect(container.read(cameraNoticeAcknowledgedProvider), true);
  });
}
