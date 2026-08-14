import 'package:ddara/domain/model/profile/profile.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile_viewmodel.dart';
import '../settings/notification_settings_viewmodel.dart';
import '../settings/util/notification_settings_state.dart';
import '../util/profile_state.dart';

// autoDispose: 로그아웃 시 폐기되어 다음 로그인 때 새 사용자 프로필을 다시 조회한다.
final profileViewModelProvider =
    NotifierProvider.autoDispose<ProfileViewModel, ProfileState>(
      ProfileViewModel.new,
    );

/// 현재 로그인 사용자의 프로필. (홈 AppBar 아바타 등 여러 화면에서 공유)
///
/// 한 번 조회하면 캐시되어 공유되며, 프로필 이미지 변경 후 최신화가 필요하면
/// `ref.invalidate(currentProfileProvider)` 로 재조회한다.
final currentProfileProvider = FutureProvider<Profile>((ref) {
  return ref.read(getProfileUseCaseProvider)();
});

// autoDispose: 화면을 벗어나면 폐기되어 재진입 시 서버 설정을 다시 조회한다.
final notificationSettingsViewModelProvider =
    NotifierProvider.autoDispose<
      NotificationSettingsViewModel,
      NotificationSettingsState
    >(NotificationSettingsViewModel.new);
