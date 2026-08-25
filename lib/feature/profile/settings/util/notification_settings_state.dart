/// 알림 설정 화면 상태.
///
/// 서버에 저장되는 알림 선호값과 OS 알림 권한 허용 여부([permissionGranted])를
/// 함께 보관한다.
class NotificationSettingsState {
  /// '알림 허용' 서버 저장값. 권한이 없으면 false 로 낮춰 저장한다.
  /// (서버가 이 값으로 FCM 전송 여부를 판단한다)
  final bool allowAll;

  /// '따라찍기 알림'. (새 따라찍기가 열리거나 마감될 때)
  final bool followShot;

  /// '다른 친구의 따라찍기 알림'.
  final bool friendShot;

  /// '랜덤 스타터 알림'.
  final bool starterAssigned;

  /// '친구 참여 알림'.
  final bool memberJoin;

  /// OS 알림 권한 허용 여부.
  final bool permissionGranted;

  /// 설정 로딩 여부.
  final bool isLoading;

  /// '알림 허용' 토글의 실제 표시값. 권한과 사용자 선호가 모두 켜져야 on.
  /// (권한을 허용하지 않았으면 사용자 선호와 무관하게 false)
  bool get notificationEnabled => permissionGranted && allowAll;

  // 최초 기본값은 모두 true. (권한 미허용 시 notificationEnabled 가 false 로 계산됨)
  const NotificationSettingsState({
    this.allowAll = true,
    this.followShot = true,
    this.friendShot = true,
    this.starterAssigned = true,
    this.memberJoin = true,
    this.permissionGranted = false,
    this.isLoading = false,
  });

  NotificationSettingsState copyWith({
    bool? allowAll,
    bool? followShot,
    bool? friendShot,
    bool? starterAssigned,
    bool? memberJoin,
    bool? permissionGranted,
    bool? isLoading,
  }) {
    return NotificationSettingsState(
      allowAll: allowAll ?? this.allowAll,
      followShot: followShot ?? this.followShot,
      friendShot: friendShot ?? this.friendShot,
      starterAssigned: starterAssigned ?? this.starterAssigned,
      memberJoin: memberJoin ?? this.memberJoin,
      permissionGranted: permissionGranted ?? this.permissionGranted,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
