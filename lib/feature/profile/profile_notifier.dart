import 'package:ddara/core/exception/profile_exception.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/core/router/app_router.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/profile/util/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileNotifier extends AutoDisposeNotifier<ProfileState> {
  @override
  ProfileState build() {
    // 진입 시 프로필 정보를 자동 조회. (build 는 동기라 fire-and-forget)
    _load();

    return const ProfileState(isLoading: true);
  }

  /// 서버에서 사용자 프로필·앱 버전·연동 계정 정보를 가져와 상태에 저장한다.
  Future<void> _load() async {
    // 앱 버전은 서버 응답과 무관하므로 프로필 조회와 함께 미리 읽어둔다.
    final appVersion = await _getAppVersion();

    try {
      final profile = await ref.read(getProfileUseCaseProvider)();

      state = state.copyWith(
        isLoading: false,
        name: profile.name,
        profileImageUrl: profile.profileImageUrl,
        joinedAt: profile.createdAt,
        appVersion: appVersion,
        // 서버 provider 코드('KAKAO')를 한글 표시명('카카오')으로 변환한다.
        linkedAccount:
            SocialLoginType.fromValue(profile.provider)?.label ??
            profile.provider,
      );
    } on UserNotFoundException {
      state = state.copyWith(
        isLoading: false,
        appVersion: appVersion,
        errorMessage: '사용자를 찾을 수 없어요.',
      );
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(
        isLoading: false,
        appVersion: appVersion,
        errorMessage: '프로필 정보를 불러오지 못했어요.',
      );
    }
  }

  Future<String> _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return 'v${info.version}';
  }

  /// 로그아웃. 토큰·소셜 정보를 비우고(UseCase) 인증 상태를 무효화한다.
  Future<void> logout() async {
    if (state.logoutStatus == LogoutStatus.loading) return;

    state = state.copyWith(logoutStatus: LogoutStatus.loading);

    // 토큰·소셜타입 정리와 로그아웃 API 호출은 UseCase가 담당한다.
    final success = await ref.read(logoutUseCaseProvider)();

    // 로컬 인증 정보는 이미 비워졌으므로, 인증 상태를 비로그인으로 즉시 확정한다.
    // (재계산을 기다리는 사이 redirect 가 stale 값을 읽어 홈으로 바운스되는 것을 막는다)
    ref.read(authStateProvider.notifier).markLoggedOut();

    state = state.copyWith(
      logoutStatus: success ? LogoutStatus.success : LogoutStatus.fail,
    );
  }

  /// 회원 탈퇴. 서버 탈퇴 성공 시 로컬 인증 정보가 정리되고(UseCase),
  /// 인증 상태를 무효화해 로그인 화면으로 보낸다.
  /// 실패 시 상태를 fail 로 두면 화면에서 토스트로 안내한다.
  Future<void> withdraw() async {
    if (state.withdrawStatus == WithdrawStatus.loading) return;

    state = state.copyWith(withdrawStatus: WithdrawStatus.loading);

    try {
      // 서버 회원 탈퇴 + 소셜·로컬 인증 정보 정리는 UseCase가 담당한다.
      await ref.read(deleteAccountUseCaseProvider)();

      // 로컬 인증 정보가 비워졌으므로, 인증 상태를 비로그인으로 즉시 확정한다.
      // (재계산을 기다리는 사이 redirect 가 stale 값을 읽어 홈으로 바운스되는 것을 막는다)
      ref.read(authStateProvider.notifier).markLoggedOut();

      state = state.copyWith(withdrawStatus: WithdrawStatus.success);
    } catch (_) {
      // 서버 탈퇴 실패 등. (로컬 인증 정보는 그대로 유지된다)
      state = state.copyWith(withdrawStatus: WithdrawStatus.fail);
    }
  }
}
