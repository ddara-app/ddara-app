import 'package:ddara/core/exception/profile_exception.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/core/router/app_router.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/profile/provider/notifier_provider.dart';
import 'package:ddara/feature/profile/util/profile_state.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileNotifier extends AutoDisposeNotifier<ProfileState> {
  /// autoDispose 폐기 후 in-flight 응답이 state 를 만지지 않도록 하는 가드.
  /// (응답 전에 화면을 떠나면 dispose 된 Notifier 대입으로 StateError)
  bool _disposed = false;

  @override
  ProfileState build() {
    _disposed = false; // invalidate 재빌드(같은 인스턴스) 대비 리셋.
    ref.onDispose(() => _disposed = true);
    // 진입 시 프로필 정보를 자동 조회. (build 는 동기라 fire-and-forget)
    _load();

    return const ProfileState();
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(ProfileState Function(ProfileState state) updater) {
    if (_disposed) return;
    state = updater(state);
  }

  /// 서버에서 사용자 프로필·앱 버전·연동 계정 정보를 가져와 상태에 저장한다.
  Future<void> _load() async {
    // 앱 버전은 서버 응답과 무관하므로 프로필 조회와 함께 미리 읽어둔다.
    final appVersion = await _getAppVersion();

    try {
      final profile = await ref.read(getProfileUseCaseProvider)();

      _update(
        (s) => s.copyWith(
          appVersion: appVersion,
          load: ProfileLoaded(
            name: profile.name,
            profileImageUrl: profile.profileImageUrl,
            joinedAt: profile.createdAt,
            // 서버 provider 코드('KAKAO')를 한글 표시명('카카오')으로 변환한다.
            linkedAccount:
                SocialLoginType.fromValue(profile.provider)?.label ??
                profile.provider,
          ),
        ),
      );
    } on UserNotFoundException {
      _update(
        (s) => s.copyWith(
          appVersion: appVersion,
          load: const ProfileLoadFailed(ProfileLoadError.userNotFound),
        ),
      );
    } catch (e) {
      // NetworkException 및 기타 예기치 못한 오류.
      debugPrint('[Profile] 조회 실패: $e');
      _update(
        (s) => s.copyWith(
          appVersion: appVersion,
          load: const ProfileLoadFailed(ProfileLoadError.loadFailed),
        ),
      );
    }
  }

  /// 앱 버전 문자열. 조회가 `_load` 의 try 밖에서 실행되므로, 여기서 실패를
  /// 삼키지 않으면 상태가 isLoading 인 채 고정된다 — 실패 시 빈 값으로 대체.
  Future<String> _getAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return 'v${info.version}';
    } catch (e) {
      debugPrint('[Profile] 앱 버전 조회 실패: $e');
      return '';
    }
  }

  /// 프로필 이미지를 업로드하고, 성공 시 새 이미지 URL로 상태를 갱신한다.
  ///
  /// 실패(형식 오류·사용자 없음·네트워크 등)는 호출한 화면에서 안내하도록
  /// 예외를 그대로 전파한다. 업로드 중 중복 호출은 무시한다.
  Future<void> updateProfileImage(String imagePath) async {
    if (state.isImageUploading) return;

    _update((s) => s.copyWith(isImageUploading: true));
    try {
      final url = await ref.read(uploadProfileImageUseCaseProvider)(imagePath);
      // 새 이미지 바이트는 업로드 단계(Repository)에서 캐시로 심어지므로
      // (같은 URL 덮어쓰기 대비 메모리 캐시 비움 포함) 바로 상태만 갱신한다.
      _update(
        (s) => s.copyWith(
          isImageUploading: false,
          load: switch (s.load) {
            final ProfileLoaded loaded => loaded.copyWith(profileImageUrl: url),
            final other => other,
          },
        ),
      );
      // 공유 프로필(홈 AppBar 아바타 등)도 새 이미지로 갱신되도록 재조회를 유도한다.
      ref.invalidate(currentProfileProvider);
    } catch (_) {
      _update((s) => s.copyWith(isImageUploading: false));
      rethrow;
    }
  }

  /// 프로필 이미지를 기본 이미지로 되돌리고, 성공 시 상태에서 URL 을 비운다.
  ///
  /// 실패(사용자 없음·네트워크 등)는 호출한 화면에서 안내하도록 예외를 그대로
  /// 전파한다. 업로드/초기화 중 중복 호출은 무시한다.
  Future<void> resetProfileImage() async {
    if (state.isImageUploading) return;

    _update((s) => s.copyWith(isImageUploading: true));
    try {
      await ref.read(resetProfileImageUseCaseProvider)();
      _update(
        (s) => s.copyWith(
          isImageUploading: false,
          load: switch (s.load) {
            final ProfileLoaded loaded => loaded.copyWith(
              clearProfileImageUrl: true,
            ),
            final other => other,
          },
        ),
      );
      // 공유 프로필(홈 AppBar 아바타 등)도 기본 이미지로 갱신되도록 재조회를 유도한다.
      ref.invalidate(currentProfileProvider);
    } catch (_) {
      _update((s) => s.copyWith(isImageUploading: false));
      rethrow;
    }
  }

  /// 로그아웃. 토큰·소셜 정보를 비우고(UseCase) 인증 상태를 무효화한다.
  Future<void> logout() async {
    if (state.logoutStatus == LogoutStatus.loading) return;

    _update((s) => s.copyWith(logoutStatus: LogoutStatus.loading));

    // 토큰·소셜타입 정리와 로그아웃 API 호출은 UseCase가 담당한다.
    final success = await ref.read(logoutUseCaseProvider)();

    // 로컬 인증 정보는 이미 비워졌으므로, 인증 상태를 비로그인으로 즉시 확정한다.
    // (재계산을 기다리는 사이 redirect 가 stale 값을 읽어 홈으로 바운스되는 것을 막는다)
    ref.read(authStateProvider.notifier).markLoggedOut();

    _update(
      (s) => s.copyWith(
        logoutStatus: success ? LogoutStatus.success : LogoutStatus.fail,
      ),
    );
  }

  /// 회원 탈퇴. 서버 탈퇴 성공 시 로컬 인증 정보가 정리되고(UseCase),
  /// 인증 상태를 무효화해 로그인 화면으로 보낸다.
  /// 실패 시 상태를 fail 로 두면 화면에서 토스트로 안내한다.
  Future<void> withdraw() async {
    if (state.withdrawStatus == WithdrawStatus.loading) return;

    _update((s) => s.copyWith(withdrawStatus: WithdrawStatus.loading));

    try {
      // 서버 회원 탈퇴 + 소셜·로컬 인증 정보 정리는 UseCase가 담당한다.
      // (애플 계정은 연동 해제용 재인증을 먼저 거치며, 취소하면 false)
      final done = await ref.read(deleteAccountUseCaseProvider)();
      if (!done) {
        // 재인증 취소 — 아무 변경도 없으므로 실패 안내 없이 원상태로 복귀.
        _update((s) => s.copyWith(withdrawStatus: WithdrawStatus.idle));
        return;
      }

      // 로컬 인증 정보가 비워졌으므로, 인증 상태를 비로그인으로 즉시 확정한다.
      // (재계산을 기다리는 사이 redirect 가 stale 값을 읽어 홈으로 바운스되는 것을 막는다)
      ref.read(authStateProvider.notifier).markLoggedOut();

      _update((s) => s.copyWith(withdrawStatus: WithdrawStatus.success));
    } catch (_) {
      // 서버 탈퇴 실패 등. (로컬 인증 정보는 그대로 유지된다)
      _update((s) => s.copyWith(withdrawStatus: WithdrawStatus.fail));
    }
  }
}
