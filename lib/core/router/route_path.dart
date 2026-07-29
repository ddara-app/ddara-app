class RoutePath {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const home = '/home';
  static const signup = '/signup';
  static const permission = '/permission';
  static const requiredPermission = '/required-permission';
  static const groupCreate = '/group/create';
  static const inviteCodeInput = '/group/join/code';
  static const inviteLanding = '/group/join/landing';
  static const joinGroup = '/group/join/confirm';
  static const historyList = '/group/history';
  static const starter = '/group/starter';
  static const randomStarter = '/group/random-starter';
  static const followerCamera = '/group/camera';
  static const profile = '/profile';
  static const accountManage = '/profile/account';
  static const blockedUsers = '/profile/blocked-users';
  static const notificationSettings = '/profile/notification-settings';
  static const termsPolicy = '/profile/terms-policy';
  static const policyViewer = '/profile/terms-policy/viewer';
  static const notification = '/notification';

  // 모임 상세와 회차 갤러리는 홈 > 모임 > 갤러리로 중첩돼 있다.
  // 덕분에 딥링크로 갤러리에 바로 들어가도(go) 중간 화면이 스쳐 보이지 않으면서
  // 백스택은 홈 > 모임 > 갤러리로 구성되고, 뒤로가기가 순서대로 이어진다.
  // (라우트 정의는 app_router 의 home 하위 routes 참고)

  /// 모임 상세 경로. (홈 하위 — 뒤로가면 홈)
  static String group(int groupId) => '$home/group/$groupId';

  /// 회차 사진 갤러리 경로. (모임 하위 — 뒤로가면 그 모임)
  static String cycleGallery({required int groupId, required int cycleId}) =>
      '${group(groupId)}/cycle/$cycleId';
}
