import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:ddara/core/widget/image/comment/photo_comment_item.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 댓글 수정 모드에서 입력창 위에 뜨는 배너.
/// 헤더('댓글 수정 중' + 닫기) 아래에 수정 대상 댓글 아이템을 그대로 보여준다.
class CommentEditingBanner extends StatelessWidget {
  const CommentEditingBanner({
    super.key,
    required this.comment,
    required this.onCancel,
  });

  /// 수정 대상 댓글.
  final PhotoComment comment;

  /// 닫기(수정 취소) 콜백.
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더: '댓글 수정 중' 라벨 + 닫기(취소).
          Row(
            children: [
              Expanded(
                child: AppText.caption(
                  l10n.commentEditingLabel,
                  color: AppColors.textAccent,
                ),
              ),
              GestureDetector(
                onTap: onCancel,
                behavior: HitTestBehavior.opaque,
                child: const AppIcon(
                  AppIcons.close,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          // 수정 대상 댓글 아이템. (목록과 동일한 형태, 내용은 최대 2줄)
          CommentContent(comment: comment, contentMaxLines: 2),
        ],
      ),
    );
  }
}
