import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/avatar/profile_avatar.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 댓글 시트의 댓글 한 줄. (좌: 프로필 아바타 · 우: 닉네임/시간 + 내용)
///
/// 더보기(⋮) 버튼을 누르면 버튼 옆에 컨텍스트 메뉴가 뜬다. 배경은 어둡게
/// 하지 않고(투명 배리어), 바깥을 탭하면 닫힌다. 내 댓글이면 수정·삭제,
/// 상대 댓글이면 신고 항목을 보여준다.
///
/// 삭제는 확인 다이얼로그까지 이 위젯이 처리하고, 사용자가 확인한 경우에만
/// [onDelete] 를 부른다.
class CommentItem extends StatefulWidget {
  const CommentItem({
    super.key,
    required this.comment,
    this.onEdit,
    this.onDelete,
    this.onReport,
    this.onRetry,
    this.onDiscard,
  });

  /// 표시할 댓글.
  final PhotoComment comment;

  /// 내 댓글 '수정하기' 콜백.
  final void Function(PhotoComment comment)? onEdit;

  /// 내 댓글 '삭제하기' 콜백. (확인 다이얼로그에서 확인한 경우에만 호출)
  final void Function(PhotoComment comment)? onDelete;

  /// 상대 댓글 '신고하기' 콜백.
  final void Function(PhotoComment comment)? onReport;

  /// 전송 실패 댓글 '재전송' 콜백.
  final void Function(PhotoComment comment)? onRetry;

  /// 전송 실패 댓글 '삭제' 콜백. (확인 다이얼로그에서 확인한 경우에만 호출)
  /// 서버에 없는 댓글이므로 목록에서 치우기만 한다.
  final void Function(PhotoComment comment)? onDiscard;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  /// 버튼 위치에 메뉴를 잇는 링크.
  final LayerLink _link = LayerLink();

  /// 열려 있는 메뉴 라우트. 닫혀 있으면 null.
  Route<void>? _menuRoute;

  void _open() {
    if (_menuRoute != null) return;
    // 메뉴를 라우트로 띄워 뒤로가기(Android)가 화면 pop 대신 메뉴 닫기가
    // 되도록 한다. 배리어는 투명이라 배경을 어둡게 하지 않고, 바깥 탭으로 닫힌다.
    final route = RawDialogRoute<void>(
      barrierColor: const Color(0x00000000),
      barrierLabel: AppLocalizations.of(context).commonCancel,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, _, _) => _buildOverlay(dialogContext),
    );
    _menuRoute = route;
    Navigator.of(context).push(route).then((_) => _menuRoute = null);
  }

  /// 메뉴를 닫은 뒤 선택한 동작을 실행한다.
  void _select(
    BuildContext dialogContext,
    void Function(PhotoComment comment)? action,
  ) {
    Navigator.of(dialogContext).pop();
    action?.call(widget.comment);
  }

  /// 재전송 확인 다이얼로그를 띄우고, 확인하면 재전송 콜백을 부른다.
  /// (실수로 눌러 다시 보내는 일을 막는다)
  Future<void> _confirmRetry() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await AppDialog.show(
      context,
      title: l10n.commentRetryTitle,
      confirmLabel: l10n.commentRetry,
    );
    if (!confirmed || !mounted) return;
    widget.onRetry?.call(widget.comment);
  }

  /// 전송 실패 댓글 삭제 확인 다이얼로그를 띄우고, 확인하면 삭제 콜백을 부른다.
  /// 서버에 없는 댓글이라 목록에서 치우기만 하지만, 쓴 내용이 그대로 사라지므로
  /// 확인을 받는다.
  Future<void> _confirmDiscard() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await AppDialog.show(
      context,
      title: l10n.commentDiscardTitle,
      message: l10n.commentDiscardMessage,
      // 서버 댓글 삭제와 마찬가지로 빨간색은 쓰지 않는다. (기본 강조색)
      confirmLabel: l10n.commentMenuDelete,
    );
    if (!confirmed || !mounted) return;
    widget.onDiscard?.call(widget.comment);
  }

  /// 메뉴를 닫고 삭제 확인 다이얼로그를 띄운다. 확인하면 삭제 콜백을 부른다.
  Future<void> _confirmDelete(BuildContext dialogContext) async {
    Navigator.of(dialogContext).pop();
    final l10n = AppLocalizations.of(context);
    final confirmed = await AppDialog.show(
      context,
      title: l10n.commentDeleteTitle,
      message: l10n.commentDeleteMessage,
      // 삭제 버튼은 파괴적이지만 빨간색은 쓰지 않는다. (기본 강조색)
      confirmLabel: l10n.commentMenuDelete,
    );
    if (!confirmed || !mounted) return;
    widget.onDelete?.call(widget.comment);
  }

  @override
  void dispose() {
    // 항목이 사라지면(목록 갱신 등) 열려 있던 메뉴 라우트도 함께 닫는다.
    final route = _menuRoute;
    if (route != null && route.isActive) {
      route.navigator?.removeRoute(route);
    }
    super.dispose();
  }

  Widget _buildOverlay(BuildContext dialogContext) {
    // 버튼 왼쪽에 앵커해 버튼 옆(좌측)으로 펼친다. (메뉴 오른쪽 끝을 버튼
    // 왼쪽에 붙이고 s2 만큼 띄운다)
    return Stack(
      children: [
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.centerLeft,
          followerAnchor: Alignment.centerRight,
          offset: const Offset(-AppSpacing.s2, 0),
          child: _menu(dialogContext),
        ),
      ],
    );
  }

  Widget _menu(BuildContext dialogContext) {
    final l10n = AppLocalizations.of(context);
    final List<Widget> items = widget.comment.isMine
        ? [
            _menuItem(
              l10n.commentMenuDelete,
              color: AppColors.textPrimary,
              onPressed: () => _confirmDelete(dialogContext),
            ),
            Container(height: 1, color: AppColors.borderDefault),
            _menuItem(
              l10n.commentMenuEdit,
              color: AppColors.textPrimary,
              onPressed: () => _select(dialogContext, widget.onEdit),
            ),
          ]
        : [
            _menuItem(
              l10n.commentMenuReport,
              color: AppColors.statusDanger,
              onPressed: () => _select(dialogContext, widget.onReport),
            ),
          ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: const [
          BoxShadow(
            color: AppColorPrimitives.black40,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items,
        ),
      ),
    );
  }

  Widget _menuItem(
    String label, {
    required Color color,
    required VoidCallback onPressed,
  }) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppText.body(label, color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
      child: CommentContent(comment: widget.comment, trailing: _trailing()),
    );
  }

  /// 댓글 우측에 붙일 위젯.
  ///
  /// 아직 서버에 없는 댓글(전송 중·실패)은 더보기 메뉴 대신 전송 상태를
  /// 보여준다. 수정·삭제·신고 대상이 될 수 없기 때문이다.
  /// 검토 중인 댓글은 아무것도 두지 않는다.
  Widget? _trailing() {
    final comment = widget.comment;
    final l10n = AppLocalizations.of(context);
    // 더보기 버튼은 내부 여백 12 를 갖지만 텍스트에는 없어, 같은 자리에 놓이도록
    // 우측 여백을 직접 준다. ('전송중'·'재전송' 은 서로 교체되므로 함께 맞춘다)
    const textPadding = EdgeInsets.only(right: AppSpacing.s4);
    switch (comment.sendStatus) {
      case CommentSendStatus.sending:
        return Padding(
          padding: textPadding,
          child: AppText.caption(
            l10n.commentSending,
            color: AppColors.textDisabled,
          ),
        );
      case CommentSendStatus.failed:
        // 재전송 · 삭제. 닉네임 행과 같은 가운뎃점으로 구분한다.
        return Padding(
          padding: textPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _confirmRetry,
                child: AppText.caption(
                  l10n.commentRetry,
                  color: AppColors.textAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
                child: AppText.caption('·', color: AppColors.textDisabled),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _confirmDiscard,
                child: AppText.caption(
                  l10n.commentDiscard,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      case CommentSendStatus.sent:
        if (comment.isUnderReview) return null;
        // 버튼을 앵커로 삼아 탭하면 컨텍스트 메뉴를 띄운다.
        return CompositedTransformTarget(
          link: _link,
          child: AppBarIconButton(
            size: 20,
            onPressed: _open,
            child: const Icon(
              CupertinoIcons.ellipsis_vertical,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
        );
    }
  }
}

/// 댓글 한 줄의 본문 레이아웃. (아바타 + 닉네임·시간 + 내용, 우측 선택 [trailing])
/// 목록 항목([CommentItem])과 수정 배너에서 공통으로 쓴다.
class CommentContent extends StatelessWidget {
  const CommentContent({
    super.key,
    required this.comment,
    this.trailing,
    this.contentMaxLines,
  });

  final PhotoComment comment;

  /// 우측에 붙일 위젯. (목록: 더보기 버튼 / 배너: 없음)
  final Widget? trailing;

  /// 내용 최대 줄 수. null 이면 제한 없음. (배너에서는 짧게 자른다)
  final int? contentMaxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: AppSpacing.s4,
      children: [
        ProfileAvatar(size: 32, imageUrl: comment.profileImageUrl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: AppText.caption(
                      comment.nickname,
                      color: AppColors.textAccent,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s1,
                    ),
                    child: AppText.caption('·', color: AppColors.textDisabled),
                  ),
                  // 전송에 실패한 댓글은 작성 시각 자리에 '실패' 를 띄운다.
                  // (아직 서버에 없어 시각이 의미가 없다)
                  if (comment.sendStatus == CommentSendStatus.failed)
                    AppText.caption(
                      AppLocalizations.of(context).commentSendFailed,
                      color: AppColors.statusDanger,
                    )
                  else
                    AppText.caption(
                      comment.timeLabel,
                      color: AppColors.textDisabled,
                    ),
                  // 수정된 댓글은 시간 옆에 '· 수정됨' 을 덧붙인다.
                  if (comment.isEdited) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s1),
                      child: AppText.caption('·', color: AppColors.textDisabled),
                    ),
                    AppText.caption(
                      AppLocalizations.of(context).commentEdited,
                      color: AppColors.textDisabled,
                    ),
                  ],
                ],
              ),
              // 검토 중인 댓글(자리표시 문구)과 아직 서버에 없는 댓글
              // (전송 중·실패)은 흐린 색으로 보여준다.
              AppText.body(
                comment.content,
                color: comment.isUnderReview || comment.isPending
                    ? AppColors.textDisabled
                    : AppColors.textPrimary,
                maxLines: contentMaxLines,
                overflow: contentMaxLines != null
                    ? TextOverflow.ellipsis
                    : null,
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
