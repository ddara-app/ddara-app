import 'package:ddara/l10n/app_localizations.dart';

/// 댓글 액션 실패 종류. (CommentActions mixin 이 발행)
///
/// notifier 는 종류만 상태에 담고, 사용자 노출 문구는 화면에서
/// [CommentActionErrorMessage.message] 로 l10n 매핑한다.
enum CommentActionError {
  /// 대상 사진이 이미 삭제됨.
  photoDeleted,

  /// 해당 모임의 멤버가 아님.
  notGroupMember,

  /// 댓글 목록 조회 실패. (네트워크 등)
  loadFailed,

  /// 댓글 내용이 유효하지 않음.
  invalidInput,

  /// 내 인증샷 미업로드(잠금) 상태라 작성 불가.
  photoLocked,

  /// 검토 중인 사진이라 작성 불가.
  photoUnderReview,

  /// 댓글 등록 실패. (네트워크 등)
  submitFailed,

  /// 내 댓글이 아니라 삭제 불가.
  deleteForbidden,

  /// 대상 댓글이 이미 삭제됨.
  commentAlreadyDeleted,

  /// 댓글 삭제 실패. (네트워크 등)
  deleteFailed,

  /// 내 댓글이 아니라 수정 불가.
  editForbidden,

  /// 댓글 수정 실패. (네트워크 등)
  editFailed,

  /// 신고 내용이 유효하지 않음.
  invalidReport,

  /// 신고 접수 실패. (네트워크 등)
  reportFailed,
}

extension CommentActionErrorMessage on CommentActionError {
  /// 실패 종류를 사용자 노출 문구로 매핑한다. (홈 피드·갤러리 공용)
  String message(AppLocalizations l10n) {
    return switch (this) {
      CommentActionError.photoDeleted => l10n.commentErrorPhotoDeleted,
      CommentActionError.notGroupMember => l10n.commentErrorNotGroupMember,
      CommentActionError.loadFailed => l10n.commentErrorLoadFailed,
      CommentActionError.invalidInput => l10n.commentErrorInvalidInput,
      CommentActionError.photoLocked => l10n.commentErrorPhotoLocked,
      CommentActionError.photoUnderReview => l10n.commentErrorPhotoUnderReview,
      CommentActionError.submitFailed => l10n.commentErrorSubmitFailed,
      CommentActionError.deleteForbidden => l10n.commentErrorDeleteForbidden,
      CommentActionError.commentAlreadyDeleted =>
        l10n.commentErrorAlreadyDeleted,
      CommentActionError.deleteFailed => l10n.commentErrorDeleteFailed,
      CommentActionError.editForbidden => l10n.commentErrorEditForbidden,
      CommentActionError.editFailed => l10n.commentErrorEditFailed,
      CommentActionError.invalidReport => l10n.commentErrorInvalidReport,
      CommentActionError.reportFailed => l10n.commentErrorReportFailed,
    };
  }
}
