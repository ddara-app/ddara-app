import 'package:ddara/core/design_system/component/avatar/profile_avatar.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/feed/feed.dart';
import 'package:ddara/feature/home/widget/photo_card_shell.dart';
import 'package:flutter/cupertino.dart';

/// 최근 업데이트 카드. (모임 카드와 같은 껍데기에 회차 주제·업로더 닉네임을 얹는다)
///
/// 잠긴 사진([FeedItem.locked])은 블러 처리되고 가운데에 자물쇠가 표시된다.
/// 카드 상단에는 댓글 상태를 얹는다 — 보여줄 댓글이 있으면 가장 최신 댓글
/// 하나의 미리보기를, 없으면 첫 댓글을 유도하는 댓글 버튼을 보여준다.
class FeedCard extends StatelessWidget {
  const FeedCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onCommentTap,
    this.blockedUserIds = const {},
  });

  final FeedItem item;
  final VoidCallback onTap;

  /// 상단 댓글 버튼·미리보기 탭 콜백. null 이면 상단에 아무것도 띄우지 않는다.
  final VoidCallback? onCommentTap;

  /// 내가 차단한 사용자 userId 집합. (그 멤버의 댓글을 미리보기에서 뺀다)
  ///
  /// 차단한 멤버가 올린 사진은 목록 단계에서 이미 제외되므로, 카드에서는
  /// 사진을 가릴 일이 없고 댓글만 걸러낸다.
  final Set<int> blockedUserIds;

  @override
  Widget build(BuildContext context) {
    return PhotoCardShell(
      imageUrl: item.imageUrl,
      title: item.topic,
      subtitle: item.nickname,
      underReview: item.imageUnderReview,
      locked: item.locked,
      topAction: _topAction(),
      onTap: onTap,
    );
  }

  /// 카드 상단에 얹을 위젯. (댓글 미리보기 / 댓글 버튼 / 없음)
  Widget? _topAction() {
    final onCommentTap = this.onCommentTap;
    if (onCommentTap == null) return null;

    // 사진 대신 검토 자리표시가 깔린 카드는 열어 볼 사진이 없으므로 비워 둔다.
    final hasPhoto = !item.imageUnderReview && item.imageUrl != null;
    if (!hasPhoto) return null;

    // 차단한 유저의 댓글, 검토 중(underReview)이거나 내가 신고한
    // (reportedByMe) 댓글은 건너뛰고 가장 최신 댓글 하나만 보여준다.
    // (걸러진 댓글이 최신이면 그다음 댓글이 올라온다)
    final latestComment = item.latestComments
        .where(
          (comment) =>
              !blockedUserIds.contains(comment.userId) &&
              !comment.underReview &&
              !comment.reportedByMe,
        )
        .firstOrNull;

    // 보여줄 댓글이 없으면(댓글이 아직 없거나, 전부 걸러졌으면)
    // 첫 댓글을 유도하는 버튼을 대신 띄운다.
    if (latestComment == null) {
      return Align(
        alignment: Alignment.centerRight,
        child: _CommentButton(onTap: onCommentTap),
      );
    }

    return _CommentPreview(comment: latestComment, onTap: onCommentTap);
  }
}

/// 카드 상단의 최신 댓글 미리보기. (가장 최신 댓글 하나를 알약으로)
class _CommentPreview extends StatelessWidget {
  const _CommentPreview({required this.comment, required this.onTap});

  final FeedComment comment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // 자리(topAction)가 카드 폭을 꽉 채우므로, 알약이 내용만큼만
    // 커지도록 좌측으로 정렬해 둔다.
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: _CommentPill(
          profileImageUrl: comment.profileImageUrl,
          content: comment.content ?? '',
        ),
      ),
    );
  }
}

/// 댓글 한 줄을 담는 알약. (좌: 작성자 아바타 · 우: 내용 한 줄)
class _CommentPill extends StatelessWidget {
  const _CommentPill({required this.content, this.profileImageUrl});

  final String content;

  /// 작성자 프로필 이미지 URL. null·빈 값이면 기본 아바타.
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 좌측은 아바타가 원형이라 여백을 적게(s1), 우측은 글자라 s2 로 맞춘다.
      padding: const EdgeInsets.only(
        left: AppSpacing.s1,
        right: AppSpacing.s2,
        top: AppSpacing.s1,
        bottom: AppSpacing.s1,
      ),
      decoration: ShapeDecoration(
        color: AppColors.overlayScrim,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      child: Row(
        // 내용이 짧으면 알약도 짧게, 길면 카드 폭까지만 늘어난다.
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.s2,
        children: [
          ProfileAvatar(size: 24, imageUrl: profileImageUrl),
          Flexible(
            child: AppText.caption(
              content,
              // caption 기본색은 textSecondary 라, 사진 위 가독성을 위해
              // 흰색(textPrimary)으로 올린다.
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// 카드 우상단의 원형 댓글 버튼.
/// (사진 뷰어 우하단 버튼과 같은 형태를 카드 크기에 맞춰 줄인 것)
class _CommentButton extends StatelessWidget {
  const _CommentButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // 아이콘 16 + 패딩 s2(8)×2 = 지름 32 원.
        padding: const EdgeInsets.all(AppSpacing.s2),
        decoration: const BoxDecoration(
          color: AppColors.overlayScrim,
          shape: BoxShape.circle,
        ),
        child: const AppIcon(AppIcons.comment, size: 16),
      ),
    );
  }
}
