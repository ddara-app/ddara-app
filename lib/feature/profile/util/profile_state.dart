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

/// 프로필 조회 결과. 로딩·실패·완료가 상호배타인 sealed 설계라
/// "로딩 중인데 에러", "데이터 있는데 에러" 같은 조합이 타입상 불가능하다.
sealed class ProfileLoadState {
  const ProfileLoadState();
}

final class ProfileLoading extends ProfileLoadState {
  const ProfileLoading();
}

/// 조회 실패. (문구 매핑은 화면 담당)
final class ProfileLoadFailed extends ProfileLoadState {
  const ProfileLoadFailed(this.error);

  final ProfileLoadError error;
}

final class ProfileLoaded extends ProfileLoadState {
  const ProfileLoaded({
    required this.name,
    this.profileImageUrl,
    this.joinedAt,
    this.linkedAccount = '',
  });

  /// 사용자 이름(닉네임).
  final String name;

  /// 프로필 이미지 URL. 미등록 시 null.
  final String? profileImageUrl;

  /// 가입일.
  final DateTime? joinedAt;

  /// 연동된 소셜 계정 이름. (예: '카카오')
  final String linkedAccount;

  ProfileLoaded copyWith({
    String? profileImageUrl,
    // 기본 이미지로 되돌릴 때 사용. (copyWith 의 null 은 '유지'라 별도 플래그)
    bool clearProfileImageUrl = false,
  }) {
    return ProfileLoaded(
      name: name,
      profileImageUrl: clearProfileImageUrl
          ? null
          : (profileImageUrl ?? this.profileImageUrl),
      joinedAt: joinedAt,
      linkedAccount: linkedAccount,
    );
  }
}

/// 프로필 화면 상태.
///
/// 서로 독립인 채널을 분리해 보관한다 — 조회 결과([load])와 이미지 업로드·
/// 로그아웃·탈퇴 진행 상태는 서로 조합이 자유롭다.
class ProfileState {
  /// 프로필 조회 결과. (로딩/실패/완료)
  final ProfileLoadState load;

  /// 앱 버전. (예: 'v1.0.0') 서버 조회와 무관하게 채워진다.
  final String appVersion;

  /// 프로필 이미지 업로드 진행 여부. (중복 탭 방지 + 진행 표시)
  final bool isImageUploading;

  /// 로그아웃 진행 상태.
  final LogoutStatus logoutStatus;

  /// 회원 탈퇴 진행 상태.
  final WithdrawStatus withdrawStatus;

  const ProfileState({
    this.load = const ProfileLoading(),
    this.appVersion = '',
    this.isImageUploading = false,
    this.logoutStatus = LogoutStatus.idle,
    this.withdrawStatus = WithdrawStatus.idle,
  });

  ProfileState copyWith({
    ProfileLoadState? load,
    String? appVersion,
    bool? isImageUploading,
    LogoutStatus? logoutStatus,
    WithdrawStatus? withdrawStatus,
  }) {
    return ProfileState(
      load: load ?? this.load,
      appVersion: appVersion ?? this.appVersion,
      isImageUploading: isImageUploading ?? this.isImageUploading,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      withdrawStatus: withdrawStatus ?? this.withdrawStatus,
    );
  }
}
