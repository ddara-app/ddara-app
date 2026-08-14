class StorageKey {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';

  /// 마지막으로 로그인한 소셜 종류(`GOOGLE`/`KAKAO`). 토큰 만료 시 무중단
  /// 재인증에서 어느 소셜로 재로그인할지 분기하는 데 사용한다.
  static const socialLoginType = 'social_login_type';

  /// 온보딩(앱 설명) 화면을 한 번이라도 본 적 있는지 여부.
  static const onboardingSeen = 'onboarding_seen';

  /// 따라찍기 촬영 화면 진입 시 뜨는 코너 미니뷰 가이드 투어를 끝까지 보거나
  /// 건너뛴 적이 있는지 여부. 투어를 개편하면 버전(v1)을 올려 다시 노출한다.
  static const cameraCornerTourDone = 'tour_camera_corner_v1_done';

  /// 고스트 확대로 처음 전환했을 때 뜨는 가이드 투어를 본 적이 있는지 여부.
  static const cameraGhostTourDone = 'tour_camera_ghost_v1_done';

  /// 이번 설치에서 앱을 실행한 적이 있는지 여부.
  ///
  /// SharedPreferences 는 앱 삭제 시 함께 지워지므로, 이 플래그가 없으면
  /// 신규(재)설치의 첫 실행으로 판단한다. (iOS Keychain 잔존 토큰 정리에 사용)
  static const firstRunDone = 'first_run_done';
}
