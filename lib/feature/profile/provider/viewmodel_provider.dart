import 'package:ddara/core/analytics/app_analytics.dart';
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
///
/// 분석 도구의 사용자 식별도 여기서 맞춘다. 방금 로그인했든 앱을 다시 열어
/// 자동 로그인됐든 프로필은 반드시 이 provider 를 거치므로, 화면마다 식별을
/// 챙길 필요가 없다. (재조회로 다시 불려도 같은 값을 덮어쓸 뿐이라 무해하다)
final currentProfileProvider = FutureProvider<Profile>((ref) async {
  final profile = await ref.read(getProfileUseCaseProvider)();

  AppAnalytics.identifyUser(
    '${profile.id}',
    properties: {
      // r'$...' 는 Mixpanel 예약 속성. (사람 이름·가입 시각 칸에 들어간다)
      r'$name': profile.name,
      r'$created': profile.createdAt.toIso8601String(),
      'provider': profile.provider,
    },
  );

  return profile;
});

// autoDispose: 화면을 벗어나면 폐기되어 재진입 시 서버 설정을 다시 조회한다.
final notificationSettingsViewModelProvider =
    NotifierProvider.autoDispose<
      NotificationSettingsViewModel,
      NotificationSettingsState
    >(NotificationSettingsViewModel.new);
