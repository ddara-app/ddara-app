/// 로그아웃 진행 상태.
enum LogoutStatus {
  /// 대기(미진행).
  idle,

  /// 로그아웃 진행 중.
  loading,

  /// 로그아웃 완료. (로컬 인증 정보를 비웠으므로 로그인 화면으로 이동한다)
  success,

  /// 서버 로그아웃 실패. (로컬 인증 정보는 이미 비워진 상태)
  fail,
}

/// 회원 탈퇴 진행 상태.
enum WithdrawStatus {
  /// 대기(미진행).
  idle,

  /// 회원 탈퇴 진행 중.
  loading,

  /// 회원 탈퇴 완료. (로컬 인증 정보를 비웠으므로 로그인 화면으로 이동한다)
  success,

  /// 회원 탈퇴 실패. (계정·로컬 인증 정보는 그대로 유지된다)
  fail,
}

/// 프로필 조회 실패 종류. (사용자 노출 문구는 화면에서 l10n 으로 매핑한다)
enum ProfileLoadError {
  /// 사용자를 찾을 수 없음. (탈퇴 등)
  userNotFound,

  /// 네트워크 등 그 외 조회 실패.
  loadFailed,
}

/// 프로필 화면 상태.
///
/// 사용자 이름·가입일·앱 버전·연동 계정 등 서버에서 내려받는 정보와
/// 로그아웃 진행 상태를 함께 보관한다.
class ProfileState {
  /// 사용자 이름(닉네임).
  final String name;

  /// 프로필 이미지 URL. 미등록 시 null.
  final String? profileImageUrl;

  /// 가입일.
  final DateTime? joinedAt;

  /// 앱 버전. (예: 'v1.0.0')
  final String appVersion;

  /// 연동된 소셜 계정 이름. (예: '카카오')
  final String linkedAccount;

  /// 프로필 정보 로딩 여부.
  final bool isLoading;

  /// 프로필 이미지 업로드 진행 여부. (중복 탭 방지 + 진행 표시)
  final bool isImageUploading;

  /// 프로필 정보 로딩 실패 종류. (없으면 null — 문구 매핑은 화면 담당)
  final ProfileLoadError? loadError;

  /// 로그아웃 진행 상태.
  final LogoutStatus logoutStatus;

  /// 회원 탈퇴 진행 상태.
  final WithdrawStatus withdrawStatus;

  const ProfileState({
    this.name = '',
    this.profileImageUrl,
    this.joinedAt,
    this.appVersion = '',
    this.linkedAccount = '',
    this.isLoading = false,
    this.isImageUploading = false,
    this.loadError,
    this.logoutStatus = LogoutStatus.idle,
    this.withdrawStatus = WithdrawStatus.idle,
  });

  ProfileState copyWith({
    String? name,
    String? profileImageUrl,
    // 기본 이미지로 되돌릴 때 사용. (copyWith 의 null 은 '유지'라 별도 플래그)
    bool clearProfileImageUrl = false,
    DateTime? joinedAt,
    String? appVersion,
    String? linkedAccount,
    bool? isLoading,
    bool? isImageUploading,
    ProfileLoadError? loadError,
    LogoutStatus? logoutStatus,
    WithdrawStatus? withdrawStatus,
  }) {
    return ProfileState(
      name: name ?? this.name,
      profileImageUrl: clearProfileImageUrl
          ? null
          : (profileImageUrl ?? this.profileImageUrl),
      joinedAt: joinedAt ?? this.joinedAt,
      appVersion: appVersion ?? this.appVersion,
      linkedAccount: linkedAccount ?? this.linkedAccount,
      isLoading: isLoading ?? this.isLoading,
      isImageUploading: isImageUploading ?? this.isImageUploading,
      loadError: loadError ?? this.loadError,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      withdrawStatus: withdrawStatus ?? this.withdrawStatus,
    );
  }
}
