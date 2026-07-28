import 'package:ddara/l10n/app_localizations.dart';

/// 모임 관련 화면(상세·갤러리·히스토리·스타터·따라찍기)의 액션 실패 종류.
///
/// notifier 는 종류만 상태에 담고, 사용자 노출 문구는 화면에서
/// [GroupActionErrorMessage.message] 로 l10n 매핑한다. 같은 예외가 화면마다
/// 다른 문구로 갈라지지 않도록 매핑을 한곳에 모은다.
/// (댓글 쪽 `CommentActionError` 와 같은 구조)
enum GroupActionError {
  // 공통
  /// 해당 모임의 멤버가 아님.
  notGroupMember,

  /// 모임 없음.
  groupNotFound,

  /// 회차(사이클) 없음.
  cycleNotFound,

  /// 인증 만료. (인터셉터 복구도 실패)
  unauthorized,

  /// 네트워크 오류.
  network,

  // 조회
  /// 모임 상세 조회 실패.
  groupLoadFailed,

  /// 사이클 갤러리 조회 실패.
  galleryLoadFailed,

  /// 지난 따라찍기 조회 실패.
  historyLoadFailed,

  // 모임 나가기
  /// 모임 나가기 실패.
  exitFailed,

  // 신고
  /// 신고 내용이 유효하지 않음.
  reportInvalidInput,

  /// 신고 대상 사진이 이미 삭제됨.
  reportShotNotFound,

  /// 신고 대상 유저가 모임에 없음.
  reportUserNotFound,

  /// 신고 접수 실패.
  reportFailed,

  // 차단
  /// 자기 자신을 차단하려 함.
  blockSelf,

  /// 차단 대상이 존재하지 않음.
  blockTargetNotFound,

  /// 차단 실패.
  blockFailed,

  // 모임 닉네임
  /// 닉네임 길이 규칙 위반.
  nicknameInvalid,

  /// 모임 안에서 이미 쓰이는 닉네임.
  nicknameDuplicate,

  /// 닉네임 변경 실패.
  nicknameChangeFailed,

  // 사진 업로드
  /// 스타터 컨셉·이미지가 유효하지 않음.
  starterInvalidInput,

  /// S3 업로드 실패.
  imageUploadFailed,

  /// 시작에 필요한 활동 멤버 수 미달.
  notEnoughMembers,

  /// 이미 진행 중인 회차가 있음.
  cycleAlreadyInProgress,

  /// 따라찍기 시작 실패.
  starterUploadFailed,

  /// 따라찍기 사진 등록 실패.
  followerUploadFailed,
}

extension GroupActionErrorMessage on GroupActionError {
  /// 실패 종류를 사용자 노출 문구로 매핑한다.
  String message(AppLocalizations l10n) {
    return switch (this) {
      GroupActionError.notGroupMember => l10n.groupErrorNotGroupMember,
      GroupActionError.groupNotFound => l10n.groupErrorGroupNotFound,
      GroupActionError.cycleNotFound => l10n.groupErrorCycleNotFound,
      GroupActionError.unauthorized => l10n.groupErrorUnauthorized,
      GroupActionError.network => l10n.groupErrorNetwork,
      GroupActionError.groupLoadFailed => l10n.groupErrorGroupLoadFailed,
      GroupActionError.galleryLoadFailed => l10n.groupErrorGalleryLoadFailed,
      GroupActionError.historyLoadFailed => l10n.groupErrorHistoryLoadFailed,
      GroupActionError.exitFailed => l10n.groupErrorExitFailed,
      GroupActionError.reportInvalidInput => l10n.groupErrorReportInvalidInput,
      GroupActionError.reportShotNotFound => l10n.groupErrorReportShotNotFound,
      GroupActionError.reportUserNotFound => l10n.groupErrorReportUserNotFound,
      GroupActionError.reportFailed => l10n.groupErrorReportFailed,
      GroupActionError.blockSelf => l10n.groupErrorBlockSelf,
      GroupActionError.blockTargetNotFound =>
        l10n.groupErrorBlockTargetNotFound,
      GroupActionError.blockFailed => l10n.groupErrorBlockFailed,
      GroupActionError.nicknameInvalid => l10n.groupErrorNicknameInvalid,
      GroupActionError.nicknameDuplicate => l10n.groupErrorNicknameDuplicate,
      GroupActionError.nicknameChangeFailed =>
        l10n.groupErrorNicknameChangeFailed,
      GroupActionError.starterInvalidInput =>
        l10n.groupErrorStarterInvalidInput,
      GroupActionError.imageUploadFailed => l10n.groupErrorImageUploadFailed,
      GroupActionError.notEnoughMembers => l10n.groupErrorNotEnoughMembers,
      GroupActionError.cycleAlreadyInProgress =>
        l10n.groupErrorCycleAlreadyInProgress,
      GroupActionError.starterUploadFailed =>
        l10n.groupErrorStarterUploadFailed,
      GroupActionError.followerUploadFailed =>
        l10n.groupErrorFollowerUploadFailed,
    };
  }
}
