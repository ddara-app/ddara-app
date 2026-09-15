import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/core/permission/provider/permission_provider.dart';
import 'package:ddara/domain/model/profile/notification_settings.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/profile/change_notification_settings_use_case.dart';
import 'package:ddara/domain/usecase/profile/get_notification_settings_use_case.dart';
import 'package:ddara/feature/profile/provider/viewmodel_provider.dart';
import 'package:ddara/feature/profile/settings/notification_settings_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNotificationSettingsUseCase extends Mock
    implements GetNotificationSettingsUseCase {}

class MockChangeNotificationSettingsUseCase extends Mock
    implements ChangeNotificationSettingsUseCase {}

class MockPermissionService extends Mock implements PermissionService {}

const _allTrue = NotificationSettings(
  allowAll: true,
  followShot: true,
  friendShot: true,
  starterAssigned: true,
  comment: true,
  memberJoin: true,
);

NotificationSettingsViewModel notifierAlive(ProviderContainer container) {
  container.listen(notificationSettingsViewModelProvider, (_, _) {});
  return container.read(notificationSettingsViewModelProvider.notifier);
}

void main() {
  late MockGetNotificationSettingsUseCase getSettings;
  late MockChangeNotificationSettingsUseCase changeSettings;
  late MockPermissionService permission;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_allTrue);
  });

  setUp(() {
    getSettings = MockGetNotificationSettingsUseCase();
    changeSettings = MockChangeNotificationSettingsUseCase();
    permission = MockPermissionService();
    container = ProviderContainer(
      overrides: [
        getNotificationSettingsUseCaseProvider.overrideWithValue(getSettings),
        changeNotificationSettingsUseCaseProvider.overrideWithValue(changeSettings),
        permissionServiceProvider.overrideWithValue(permission),
      ],
    );
    addTearDown(container.dispose);
    // 실제 서버처럼 저장 요청받은 값을 그대로 돌려준다. (항상 true 를
    // 돌려주면 _persist() 이후 상태가 요청과 무관하게 true 로 덮인다)
    when(() => changeSettings(any())).thenAnswer(
      (invocation) async => invocation.positionalArguments.first as NotificationSettings,
    );
  });

  test('권한이 있고 서버 allowAll 이 true 면 그대로 반영한다', () async {
    when(() => permission.isNotificationGranted()).thenAnswer((_) async => true);
    when(() => getSettings()).thenAnswer((_) async => _allTrue);

    notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(notificationSettingsViewModelProvider);
    expect(state.isLoading, false);
    expect(state.allowAll, true);
    expect(state.permissionGranted, true);
  });

  test('권한이 없으면 서버 allowAll 이 true 여도 false 로 낮추고 서버에도 저장한다', () async {
    when(() => permission.isNotificationGranted()).thenAnswer((_) async => false);
    when(() => getSettings()).thenAnswer((_) async => _allTrue);

    notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(notificationSettingsViewModelProvider);
    expect(state.allowAll, false);
    expect(state.permissionGranted, false);
    verify(() => changeSettings(any())).called(1);
  });

  test('조회 실패해도 권한 상태는 반영한다', () async {
    when(() => permission.isNotificationGranted()).thenAnswer((_) async => true);
    when(() => getSettings()).thenAnswer((_) async => throw Exception('fail'));

    notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(notificationSettingsViewModelProvider);
    expect(state.isLoading, false);
    expect(state.permissionGranted, true);
  });

  group('changeAllow', () {
    test('권한이 이미 있으면 요청 없이 켠다', () async {
      when(() => permission.isNotificationGranted()).thenAnswer((_) async => true);
      when(() => getSettings()).thenAnswer((_) async => _allTrue);
      final notifier = notifierAlive(container);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final result = await notifier.changeAllow(true);

      expect(result, isNull);
      expect(container.read(notificationSettingsViewModelProvider).allowAll, true);
      verifyNever(() => permission.requestNotification());
    });

    test('권한이 없는데 켜면 권한을 요청하고, 거부되면 allowAll 은 false 로 저장한다', () async {
      when(() => permission.isNotificationGranted()).thenAnswer((_) async => false);
      when(() => getSettings()).thenAnswer((_) async => _allTrue);
      when(() => permission.requestNotification()).thenAnswer(
        (_) async => PermissionResult.denied,
      );
      final notifier = notifierAlive(container);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final result = await notifier.changeAllow(true);

      expect(result, PermissionResult.denied);
      expect(container.read(notificationSettingsViewModelProvider).allowAll, false);
    });
  });

  test('changeFollowShot 은 값을 갱신하고 서버에 저장한다', () async {
    when(() => permission.isNotificationGranted()).thenAnswer((_) async => true);
    when(() => getSettings()).thenAnswer((_) async => _allTrue);
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.changeFollowShot(false);

    expect(container.read(notificationSettingsViewModelProvider).followShot, false);
    verify(() => changeSettings(any())).called(1);
  });
}
