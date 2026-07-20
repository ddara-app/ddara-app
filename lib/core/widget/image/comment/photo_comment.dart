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

  PhotoComment copyWith({String? content, bool? isEdited}) {
    return PhotoComment(
      commentId: commentId,
      nickname: nickname,
      content: content ?? this.content,
      timeLabel: timeLabel,
      profileImageUrl: profileImageUrl,
      isUnderReview: isUnderReview,
      isMine: isMine,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
