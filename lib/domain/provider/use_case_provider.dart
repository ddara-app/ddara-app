import 'package:ddara/core/auth/provider/auth_provider.dart';
import 'package:ddara/domain/usecase/auth/login_use_case.dart';
import 'package:ddara/domain/usecase/auth/logout_use_case.dart';
import 'package:ddara/domain/usecase/auth/signup_use_case.dart';
import 'package:ddara/domain/usecase/cycle/follower_upload_use_case.dart';
import 'package:ddara/domain/usecase/cycle/get_cycle_gallery_use_case.dart';
import 'package:ddara/domain/usecase/cycle/starter_upload_use_case.dart';
import 'package:ddara/domain/usecase/group/create_group_use_case.dart';
import 'package:ddara/domain/usecase/group/get_group_list_use_case.dart';
import 'package:ddara/domain/usecase/notification/get_notifications_use_case.dart';
import 'package:ddara/domain/usecase/notification/mark_notification_as_read_use_case.dart';
import 'package:ddara/domain/usecase/profile/change_notification_settings_use_case.dart';
import 'package:ddara/domain/usecase/profile/delete_account_use_case.dart';
import 'package:ddara/domain/usecase/profile/get_notification_settings_use_case.dart';
import 'package:ddara/domain/usecase/profile/get_profile_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/provider/repository_provider.dart';
import '../usecase/group/change_nickname_use_case.dart';
import '../usecase/group/exit_group_use_case.dart';
import '../usecase/group/get_group_detail_use_case.dart';
import '../usecase/group/get_history_cycles_use_case.dart';
import '../usecase/group/get_invite_group_use_case.dart';
import '../usecase/group/join_group_use_case.dart';

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(
    ref.read(authRepositoryProvider),
    ref.read(kakaoAuthProvider),
    ref.read(googleAuthProvider),
  );
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(
    ref.read(authRepositoryProvider),
    ref.read(kakaoAuthProvider),
    ref.read(googleAuthProvider),
  );
});

final createGroupUseCaseProvider = Provider<CreateGroupUseCase>((ref) {
  return CreateGroupUseCase(ref.read(groupRepositoryProvider));
});

final getGroupListUseCaseProvider = Provider<GetGroupListUseCase>((ref) {
  return GetGroupListUseCase(ref.read(groupRepositoryProvider));
});

final getGroupDetailUseCaseProvider = Provider<GetGroupDetailUseCase>((ref) {
  return GetGroupDetailUseCase(ref.read(groupRepositoryProvider));
});

final getInviteGroupUseCaseProvider = Provider<GetInviteGroupUseCase>((ref) {
  return GetInviteGroupUseCase(ref.read(groupRepositoryProvider));
});

final joinGroupUseCaseProvider = Provider<JoinGroupUseCase>((ref) {
  return JoinGroupUseCase(ref.read(groupRepositoryProvider));
});

final exitGroupUseCaseProvider = Provider<ExitGroupUseCase>((ref) {
  return ExitGroupUseCase(ref.read(groupRepositoryProvider));
});

final getHistoryCyclesUseCaseProvider = Provider<GetHistoryCyclesUseCase>((
  ref,
) {
  return GetHistoryCyclesUseCase(ref.read(groupRepositoryProvider));
});

final changeNicknameUseCaseProvider = Provider<ChangeNicknameUseCase>((ref) {
  return ChangeNicknameUseCase(ref.read(groupRepositoryProvider));
});

final starterUploadUseCase = Provider<StarterUploadUseCase>((ref) {
  return StarterUploadUseCase(ref.read(cycleRepositoryProvider));
});

final getCycleGalleryUseCaseProvider = Provider<GetCycleGalleryUseCase>((ref) {
  return GetCycleGalleryUseCase(ref.read(cycleRepositoryProvider));
});

final followerUploadUseCase = Provider<FollowerUploadUseCase>((ref) {
  return FollowerUploadUseCase(ref.read(cycleRepositoryProvider));
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(ref.read(profileRepositoryProvider));
});

final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>((ref) {
  return DeleteAccountUseCase(
    ref.read(profileRepositoryProvider),
    ref.read(authRepositoryProvider),
    ref.read(kakaoAuthProvider),
    ref.read(googleAuthProvider),
  );
});

final getNotificationSettingsUseCaseProvider =
    Provider<GetNotificationSettingsUseCase>((ref) {
      return GetNotificationSettingsUseCase(
        ref.read(profileRepositoryProvider),
      );
    });

final changeNotificationSettingsUseCaseProvider =
    Provider<ChangeNotificationSettingsUseCase>((ref) {
      return ChangeNotificationSettingsUseCase(
        ref.read(profileRepositoryProvider),
      );
    });

final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((
  ref,
) {
  return GetNotificationsUseCase(ref.read(notificationRepositoryProvider));
});

final markNotificationAsReadUseCaseProvider =
    Provider<MarkNotificationAsReadUseCase>((ref) {
      return MarkNotificationAsReadUseCase(
        ref.read(notificationRepositoryProvider),
      );
    });
