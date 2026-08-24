import 'package:ddara/core/analytics/app_analytics.dart';

/// 화면이 부르는 분석 이벤트 목록.
///
/// 이벤트 이름 문자열과 속성 키를 여기서만 정한다. 화면 코드는 메서드만 부르므로
/// 오타로 이름이 갈라지지 않고, 이름·속성을 바꿀 때 이 파일만 고치면 된다.
/// 어떤 이벤트를 보내고 있는지도 이 파일 하나로 훑을 수 있다.
///
/// 전송 자체는 [AppAnalytics] 가 맡는다. (Mixpanel + Firebase 동시 전송)
/// 파라미터는 primitive 로만 받는다 — core 가 feature 의 타입(enum 등)에
/// 기대지 않도록. 호출부에서 `type.name` 처럼 풀어서 넘긴다.
abstract final class AnalyticsEvents {
  const AnalyticsEvents._();

  // ── 온보딩 ──────────────────────────────────────────────────────

  /// 온보딩 스텝 노출. [step] 은 1부터.
  ///
  /// ⚠ 이름에 스텝 번호가 박혀 있어 Mixpanel 에서 이벤트가 스텝 수만큼
  /// 갈라진다. 같은 값이 `step` 속성에도 들어가므로 중복이다. 대시보드를
  /// 새로 짤 수 있을 때 이름을 `onboarding_step_viewed` 로 합치는 것이 좋다.
  static void onboardingStepViewed(int step) => AppAnalytics.track(
    'onboarding_step_viewed($step)',
    properties: {'step': step},
  );

  /// 온보딩을 끝내고 시작하기를 눌렀다.
  static void onboardingCompleted() =>
      AppAnalytics.track('onboarding_completed');

  // ── 로그인 · 가입 ───────────────────────────────────────────────

  static void loginPageViewed() => AppAnalytics.track('login_page_viewed');

  /// 소셜 로그인 버튼을 눌렀다. ([provider] = SocialLoginType.name)
  static void loginAttempted(String provider) =>
      AppAnalytics.track('login_attempted', properties: {'provider': provider});

  static void loginSucceeded(String provider) =>
      AppAnalytics.track('login_succeeded', properties: {'provider': provider});

  /// 로그인은 됐지만 가입 정보가 없어 가입 화면으로 보냈다.
  static void loginSignupRequired(String provider) => AppAnalytics.track(
    'login_signup_required',
    properties: {'provider': provider},
  );

  /// [reason] 은 서버 디버그 메시지, 없으면 LoginErrorType.name.
  static void loginFailed({
    required String provider,
    required String reason,
  }) => AppAnalytics.track(
    'login_failed',
    properties: {'provider': provider, 'reason': reason},
  );

  static void signupPageViewed(String provider) => AppAnalytics.track(
    'signup_page_viewed',
    properties: {'provider': provider},
  );

  /// 필수 약관에 모두 동의했다. (가입 화면 진입 → 가입 완료 사이의 단계)
  static void signupTermsAgreed() =>
      AppAnalytics.track('signup_terms_agreed');

  static void signupSucceeded(String provider) => AppAnalytics.track(
    'signup_succeeded',
    properties: {'provider': provider},
  );

  // ── 홈 ──────────────────────────────────────────────────────────

  /// 홈 화면이 확정됐다. (로딩·에러가 끝난 시점에 한 번)
  static void homeViewed({required bool isEmpty, required int groupCount}) =>
      AppAnalytics.track(
        'home_viewed',
        properties: {
          'state': isEmpty ? 'empty' : 'list',
          'group_count': groupCount,
        },
      );

  // ── 모임 만들기 · 참여 ──────────────────────────────────────────

  static void groupCreatePageViewed() =>
      AppAnalytics.track('group_create_page_viewed');

  static void groupCreateSucceeded(int groupId) => AppAnalytics.track(
    'group_create_succeeded',
    properties: {'group_id': groupId},
  );

  /// 초대 링크로 들어와 랜딩(초대장 애니메이션)이 떴다. 참여 퍼널의 입구다.
  static void inviteLandingViewed() =>
      AppAnalytics.track('invite_landing_viewed');

  /// 초대코드 입력 화면 노출.
  /// [prefilled] 는 딥링크로 받은 코드가 미리 채워졌는지. (false = 직접 입력)
  static void inviteCodeInputViewed({required bool prefilled}) =>
      AppAnalytics.track(
        'invite_code_input_viewed',
        properties: {'prefilled': prefilled},
      );

  /// 초대 확인 화면 노출. [joinable] 은 지금 참여할 수 있는 상태인지.
  static void groupJoinPageViewed({required bool joinable}) =>
      AppAnalytics.track(
        'group_join_page_viewed',
        properties: {'joinable': joinable},
      );

  static void groupJoinSucceeded(int groupId) => AppAnalytics.track(
    'group_join_succeeded',
    properties: {'group_id': groupId},
  );

  // ── 모임 상세 ───────────────────────────────────────────────────

  static void groupPageViewed(int groupId) =>
      AppAnalytics.track('group_page_viewed', properties: {'group_id': groupId});

  /// 지난 기록 '더보기'를 눌렀다.
  static void groupHistoryMoreClicked(int groupId) => AppAnalytics.track(
    'group_history_more_clicked',
    properties: {'group_id': groupId},
  );

  /// 지난 기록에서 사이클 하나를 눌러 갤러리로 들어갔다.
  static void groupHistoryCycleClicked({
    required int groupId,
    required int cycleId,
  }) => AppAnalytics.track(
    'group_history_cycle_clicked',
    properties: {'group_id': groupId, 'cycle_id': cycleId},
  );

  /// 지난 기록 목록 화면 노출. ('더보기' 로 들어온 뒤 단계)
  static void historyListViewed(int groupId) => AppAnalytics.track(
    'history_list_viewed',
    properties: {'group_id': groupId},
  );

  static void groupNicknameChanged(int groupId) => AppAnalytics.track(
    'group_nickname_changed',
    properties: {'group_id': groupId},
  );

  static void groupExitSucceeded(int groupId) => AppAnalytics.track(
    'group_exit_succeeded',
    properties: {'group_id': groupId},
  );

  // ── 스타터 · 팔로워 · 갤러리 ────────────────────────────────────

  static void starterPageViewed(int groupId) => AppAnalytics.track(
    'starter_page_viewed',
    properties: {'group_id': groupId},
  );

  /// 스타터가 첫 사진을 올려 사이클이 시작됐다.
  static void starterPhotoPosted({
    required int groupId,
    required int cycleId,
  }) => AppAnalytics.track(
    'starter_photo_posted',
    properties: {'group_id': groupId, 'cycle_id': cycleId},
  );

  /// 다음 스타터 추첨 화면 노출.
  static void randomStarterPageViewed(int groupId) => AppAnalytics.track(
    'random_starter_page_viewed',
    properties: {'group_id': groupId},
  );

  static void followerPageViewed(int cycleId) => AppAnalytics.track(
    'follower_page_viewed',
    properties: {'cycle_id': cycleId},
  );

  static void followerPhotoPosted(int cycleId) => AppAnalytics.track(
    'follower_photo_posted',
    properties: {'cycle_id': cycleId},
  );

  static void galleryPageViewed(int cycleId) => AppAnalytics.track(
    'gallery_page_viewed',
    properties: {'cycle_id': cycleId},
  );

  // ── 알림 ────────────────────────────────────────────────────────

  static void notificationPageViewed() =>
      AppAnalytics.track('notification_page_viewed');

  static void notificationSettingsPageViewed() =>
      AppAnalytics.track('notification_settings_page_viewed');

  // ── 가이드 ──────────────────────────────────────────────────────

  static void guidePageViewed() => AppAnalytics.track('guide_page_viewed');

  /// 가이드 투어 진입. [mode] = GuideViewMode.name (코너 미니뷰 / 고스트 확대)
  static void guideTourViewed(String mode) =>
      AppAnalytics.track('guide_tour_viewed', properties: {'mode': mode});

  // ── 초대 공유 ───────────────────────────────────────────────────

  static void inviteKakaoShareClicked() =>
      AppAnalytics.track('invite_kakao_share_clicked');

  static void inviteCodeCopyClicked() =>
      AppAnalytics.track('invite_code_copy_clicked');

  // ── 프로필 · 계정 ───────────────────────────────────────────────

  static void profilePageViewed() =>
      AppAnalytics.track('profile_page_viewed');

  static void profileImageEditClicked() =>
      AppAnalytics.track('profile_image_edit_clicked');

  static void blockedUsersPageViewed() =>
      AppAnalytics.track('blocked_users_page_viewed');

  static void termsPolicyPageViewed() =>
      AppAnalytics.track('terms_policy_page_viewed');

  /// 정책 문서 열람.
  ///
  /// [assetPath] 에서 파일명만 뽑아 문서를 구분한다. 화면 제목은 l10n 이라
  /// 언어별로 달라져 분석 값으로 쓸 수 없다.
  static void policyViewerViewed(String assetPath) => AppAnalytics.track(
    'policy_viewer_viewed',
    properties: {'document': assetPath.split('/').last.split('.').first},
  );

  /// 계정 관리 화면 노출. (로그아웃·탈퇴 직전 단계)
  static void accountManagePageViewed() =>
      AppAnalytics.track('account_manage_page_viewed');

  /// 로그아웃 완료. 이벤트를 남긴 **뒤** 사용자 식별을 지운다.
  /// (순서가 바뀌면 이 이벤트가 익명 사용자에 붙는다)
  static void logoutSucceeded() {
    AppAnalytics.track('logout_succeeded');
    AppAnalytics.resetUser();
  }

  /// 회원 탈퇴 완료. [logoutSucceeded] 와 같은 이유로 순서를 지킨다.
  static void accountWithdrawSucceeded() {
    AppAnalytics.track('account_withdraw_succeeded');
    AppAnalytics.resetUser();
  }

  // ── 권한 ────────────────────────────────────────────────────────

  /// 권한 안내 화면 노출. (요청 결과는 [permissionResult])
  static void permissionPageViewed() =>
      AppAnalytics.track('permission_page_viewed');

  /// 카메라 권한이 없어 필수 권한 안내로 넘어왔다.
  static void requiredPermissionPageViewed() =>
      AppAnalytics.track('required_permission_page_viewed');

  /// 권한 요청 결과.
  /// [permission] = camera·notification·photos, [result] = PermissionResult.name.
  static void permissionResult({
    required String permission,
    required String result,
  }) => AppAnalytics.track(
    'permission_result',
    properties: {'permission': permission, 'result': result},
  );
}
