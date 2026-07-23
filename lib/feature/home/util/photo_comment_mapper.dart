import 'package:ddara/core/model/comment/comment.dart';
import 'package:ddara/core/util/time_ago.dart';
import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:ddara/l10n/app_localizations.dart';

/// 도메인 [Comment] 를 뷰어 표시용 [PhotoComment] 로 변환한다.
/// 작성자가 [myUserId] 와 같으면 내 댓글로 표시한다. (더보기 메뉴 구성이
/// 달라진다)
PhotoComment toPhotoComment(
  Comment comment,
  AppLocalizations l10n,
  int? myUserId,
) {
  return PhotoComment(
    commentId: comment.commentId,
    userId: comment.userId,
    nickname: comment.nickname,
    content: comment.content ?? '',
    timeLabel: timeAgoLabel(comment.createdAt, l10n),
    profileImageUrl: comment.profileImageUrl,
    isMine: myUserId != null && comment.userId == myUserId,
    // 수정 시각이 있으면 수정된 댓글로 본다.
    isEdited: comment.updatedAt != null,
  );
}
