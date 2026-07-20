/// 댓글의 서버 전송 상태. (낙관적 업데이트 — 전송 전에 목록에 먼저 보여준다)
enum CommentSendStatus {
  /// 서버에 반영된 정상 댓글. 서버에서 받아 온 댓글은 모두 이 상태다.
  sent,

  /// 전송 중. 목록에는 보이지만 아직 서버 응답 전이다.
  sending,

  /// 전송 실패. 재전송할 수 있다.
  failed,
}

/// 사진 뷰어 댓글 시트에 표시할 댓글 하나.
class PhotoComment {
  const PhotoComment({
    required this.nickname,
    required this.content,
    required this.timeLabel,
    this.commentId,
    this.profileImageUrl,
    this.isUnderReview = false,
    this.isMine = false,
    this.isEdited = false,
    this.sendStatus = CommentSendStatus.sent,
  });

  /// 서버 댓글 id. 삭제·수정 대상 식별에 쓴다. (API 연동 전 임시 댓글은 null)
  final int? commentId;

  /// 작성자 닉네임.
  final String nickname;

  /// 댓글 내용. (검토 중인 댓글이면 호출 측에서 자리표시 문구를 넣어 전달)
  final String content;

  /// 작성 시각 라벨. (예: '3분 전' — 호출 측에서 포맷해 전달)
  final String timeLabel;

  /// 작성자 프로필 이미지 URL. null·빈 값이면 기본 아이콘.
  final String? profileImageUrl;

  /// 신고 접수로 검토 중인 댓글인지 여부.
  /// (내용을 흐린 색으로 보여주고 더보기 메뉴를 숨긴다)
  final bool isUnderReview;

  /// 내가 작성한 댓글인지 여부.
  /// (더보기 메뉴 구성이 달라진다 — 내 댓글: 수정·삭제, 상대: 신고)
  final bool isMine;

  /// 수정된 댓글인지 여부. (시간 옆에 '수정됨' 표시)
  final bool isEdited;

  /// 서버 전송 상태. [CommentSendStatus.sent] 가 아니면 아직 서버에 없는
  /// 댓글이라, 본문을 흐리게 보여주고 더보기 메뉴 대신 전송 상태를 표시한다.
  final CommentSendStatus sendStatus;

  /// 아직 서버에 반영되지 않은 댓글인지 여부. (전송 중이거나 실패)
  bool get isPending => sendStatus != CommentSendStatus.sent;

  PhotoComment copyWith({
    String? content,
    bool? isEdited,
    CommentSendStatus? sendStatus,
  }) {
    return PhotoComment(
      commentId: commentId,
      nickname: nickname,
      content: content ?? this.content,
      timeLabel: timeLabel,
      profileImageUrl: profileImageUrl,
      isUnderReview: isUnderReview,
      isMine: isMine,
      isEdited: isEdited ?? this.isEdited,
      sendStatus: sendStatus ?? this.sendStatus,
    );
  }
}
