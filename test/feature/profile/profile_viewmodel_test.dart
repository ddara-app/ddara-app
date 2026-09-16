import 'package:ddara/core/exception/profile_exception.dart';
import 'package:ddara/core/router/app_router.dart';
import 'package:ddara/data/provider/repository_provider.dart';
import 'package:ddara/domain/model/auth/social_login_type.dart';
import 'package:ddara/domain/model/profile/profile.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/repository/auth_repository.dart';
import 'package:ddara/domain/usecase/auth/logout_use_case.dart';
import 'package:ddara/domain/usecase/profile/delete_account_use_case.dart';
import 'package:ddara/domain/usecase/profile/get_profile_use_case.dart';
import 'package:ddara/domain/usecase/profile/reset_profile_image_use_case.dart';
import 'package:ddara/domain/usecase/profile/upload_profile_image_use_case.dart';
import 'package:ddara/feature/profile/profile_viewmodel.dart';
import 'package:ddara/feature/profile/provider/viewmodel_provider.dart';
import 'package:ddara/feature/profile/util/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class MockUploadProfileImageUseCase extends Mock implements UploadProfileImageUseCase {}

class MockResetProfileImageUseCase extends Mock implements ResetProfileImageUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockDeleteAccountUseCase extends Mock implements DeleteAccountUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

Profile _profile() {
  return Profile(
    id: 1,
    name: 'kim',
    profileImageUrl: 'https://img',
    provider: 'KAKAO',
    createdAt: DateTime(2026, 1, 1),
  );
}

ProfileViewModel notifierAlive(ProviderContainer container) {
  container.listen(profileViewModelProvider, (_, _) {});
  return container.read(profileViewModelProvider.notifier);
}

void main() {
  late MockGetProfileUseCase getProfile;
  late MockUploadProfileImageUseCase uploadProfileImage;
  late MockResetProfileImageUseCase resetProfileImage;
  late MockLogoutUseCase logout;
  late MockDeleteAccountUseCase deleteAccount;
  late MockAuthRepository authRepository;
  late ProviderContainer container;

  setUpAll(() {
    PackageInfo.setMockInitialValues(
      appName: 'ddara',
      packageName: 'com.ddara.team3',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  setUp(() {
    getProfile = MockGetProfileUseCase();
    uploadProfileImage = MockUploadProfileImageUseCase();
    resetProfileImage = MockResetProfileImageUseCase();
    logout = MockLogoutUseCase();
    deleteAccount = MockDeleteAccountUseCase();
    authRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        getProfileUseCaseProvider.overrideWithValue(getProfile),
        uploadProfileImageUseCaseProvider.overrideWithValue(uploadProfileImage),
        resetProfileImageUseCaseProvider.overrideWithValue(resetProfileImage),
        logoutUseCaseProvider.overrideWithValue(logout),
        deleteAccountUseCaseProvider.overrideWithValue(deleteAccount),
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    addTearDown(container.dispose);
    when(() => authRepository.getAccessToken()).thenAnswer((_) async => 'access');
  });

  test('조회 성공하면 ProfileLoaded 로 전환하고 앱 버전을 담는다', () async {
    when(() => getProfile()).thenAnswer((_) async => _profile());

    notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profileViewModelProvider);
    expect(state.load, isA<ProfileLoaded>());
    expect((state.load as ProfileLoaded).name, 'kim');
    expect((state.load as ProfileLoaded).provider, SocialLoginType.kakao);
    expect(state.appVersion, 'v1.0.0');
  });

  test('UserNotFoundException 이면 userNotFound 로 전환한다', () async {
    when(() => getProfile()).thenAnswer((_) async => throw UserNotFoundException());

    notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profileViewModelProvider);
    expect(state.load, isA<ProfileLoadFailed>());
    expect((state.load as ProfileLoadFailed).error, ProfileLoadError.userNotFound);
  });

  test('updateProfileImage 성공하면 profileImageUrl 을 갱신한다', () async {
    when(() => getProfile()).thenAnswer((_) async => _profile());
    when(() => uploadProfileImage('/path.jpg')).thenAnswer((_) async => 'https://new');
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.updateProfileImage('/path.jpg');

    final state = container.read(profileViewModelProvider);
    expect(state.isImageUploading, false);
    expect((state.load as ProfileLoaded).profileImageUrl, 'https://new');
  });

  test('updateProfileImage 실패하면 예외를 전파하고 isImageUploading 을 내린다', () async {
    when(() => getProfile()).thenAnswer((_) async => _profile());
    when(() => uploadProfileImage(any())).thenThrow(Exception('fail'));
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await expectLater(
      () => notifier.updateProfileImage('/path.jpg'),
      throwsA(isA<Exception>()),
    );

    expect(container.read(profileViewModelProvider).isImageUploading, false);
  });

  test('logout 성공하면 success 상태가 되고 인증 상태를 로그아웃으로 확정한다', () async {
    when(() => getProfile()).thenAnswer((_) async => _profile());
    when(() => logout()).thenAnswer((_) async => true);
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.logout();

    expect(container.read(profileViewModelProvider).logoutStatus, LogoutStatus.success);
    expect(container.read(authStateProvider).value, false);
  });

  test('logout 이 서버에서 실패해도 fail 상태로 남는다', () async {
    when(() => getProfile()).thenAnswer((_) async => _profile());
    when(() => logout()).thenAnswer((_) async => false);
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.logout();

    expect(container.read(profileViewModelProvider).logoutStatus, LogoutStatus.fail);
  });

  test('withdraw 성공하면 success 상태가 된다', () async {
    when(() => getProfile()).thenAnswer((_) async => _profile());
    when(() => deleteAccount()).thenAnswer((_) async => true);
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.withdraw();

    expect(container.read(profileViewModelProvider).withdrawStatus, WithdrawStatus.success);
  });

  test('withdraw 가 재인증 취소(false)면 idle 로 되돌아간다(실패 안내 없음)', () async {
    when(() => getProfile()).thenAnswer((_) async => _profile());
    when(() => deleteAccount()).thenAnswer((_) async => false);
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.withdraw();

    expect(container.read(profileViewModelProvider).withdrawStatus, WithdrawStatus.idle);
  });

  test('withdraw 가 예외를 던지면 fail 상태가 된다', () async {
    when(() => getProfile()).thenAnswer((_) async => _profile());
    when(() => deleteAccount()).thenAnswer((_) async => throw Exception('fail'));
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.withdraw();

    expect(container.read(profileViewModelProvider).withdrawStatus, WithdrawStatus.fail);
  });
}
