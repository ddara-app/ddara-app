import 'dart:async' show unawaited;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/feed/feed.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:ddara/core/widget/image/photo_viewer.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group/gallery/widget/comment_report_sheet.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:ddara/feature/home/util/feed_state.dart';
import 'package:ddara/feature/home/util/photo_comment_mapper.dart';
import 'package:ddara/feature/home/util/refresh_with_min_duration.dart';
import 'package:ddara/feature/home/widget/card_grid_view.dart';
import 'package:ddara/feature/home/widget/feed_card.dart';
import 'package:ddara/feature/home/widget/home_dashboard.dart';
import 'package:ddara/feature/home/widget/home_tab_header.dart';
import 'package:ddara/feature/home/widget/photo_card_shell.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 최근 업데이트 탭: 따라찍기 모임 탭과 같은 그리드 구조를 공유한다.
///
/// 모임 카드 자리에 피드 카드(회차 주제 · 업로더 닉네임)를 채우고,
/// 잠긴 사진은 블러 + 자물쇠로 가린다.
class RecentUpdatesView extends ConsumerWidget {
  const RecentUpdatesView({super.key, required this.blockedUserIds});

  /// 내가 차단한 사용자 userId 집합.
  /// (차단한 멤버가 올린 사진은 차단 자리표시로 가린다)
  final Set<int> blockedUserIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedNotifierProvider);

    // 댓글 등 액션 실패를 토스트로 안내한다.
    // (초기 조회 실패는 본문에 표시되므로 피드가 로드된 뒤의 에러만 다룬다)
    ref.listen(feedNotifierProvider, (prev, next) {
      if (next.feed != null && next.errorMessage.isNotEmpty) {
        Toast.showToast(context, next.errorMessage, type: ToastType.error);
        ref.read(feedNotifierProvider.notifier).clearError();
      }
    });

    // 당겨서 새로고침 → 피드 재조회.
    Future<void> onRefresh() => refreshWithMinDuration(
      () => ref.read(feedNotifierProvider.notifier).refresh(),
    );

    final feed = state.feed;
    // 조회 완료 전: 로딩 인디케이터 또는 에러 메시지. (홈 본문과 같은 분기)
    if (feed == null) {
      if (state.errorMessage.isEmpty) {
        return const Center(child: CupertinoActivityIndicator());
      }
      // 최초 조회 실패 화면에서도 당겨서 재시도할 수 있게 한다.
      return CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: AppText.body(state.errorMessage)),
          ),
        ],
      );
    }

    // 차단한 멤버가 올린 사진은 목록에서 아예 뺀다. (자리표시로도 남기지 않는다)
    final items = feed.items
        .where((item) => !blockedUserIds.contains(item.userId))
        .toList();

    return CardGridView(
      items: items,
      dashboard: HomeDashboard.updateCount(
        count: feed.updateCount,
        pageIndex: 1,
        pageCount: homeTabCount,
      ),
      cardBuilder: (context, item) => FeedCard(
        item: item,
        // 차단한 멤버의 댓글은 미리보기에서 뺀다.
        blockedUserIds: blockedUserIds,
        onCommentTap: () => _openPhotoViewer(context, ref, item, state),
        // 카드를 누르면 그 사진이 속한 회차의 갤러리로 들어간다.
        onTap: () => context.push(RoutePath.follower, extra: item.cycleId),
      ),
      onRefresh: onRefresh,
    );
  }

  /// 피드 사진을 크게 띄우고, 댓글 시트가 열린 상태로 시작한다.
  ///
  /// 카드에서 보이던 프레임(186:245) 그대로 잘라 보여주고, 잠긴 사진은 뷰어에서도
  /// 블러 + 자물쇠를 유지한다. (서버가 잠긴 사진의 댓글 작성을 막으므로 뷰어가
  /// 입력창을 비활성화한다)
  void _openPhotoViewer(
    BuildContext context,
    WidgetRef ref,
    FeedItem item,
    FeedState state,
  ) {
    final imageUrl = item.imageUrl;
    if (imageUrl == null) return;

    final notifier = ref.read(feedNotifierProvider.notifier);
    showPhotoViewer(
      context,
      image: CachedNetworkImageProvider(imageUrl),
      aspectRatio: photoCardAspectRatio,
      // 댓글 시트 헤더: 업로더 닉네임 + 따라찍기 주제.
      title: item.nickname,
      body: item.topic,
      // 전송 중 댓글을 서버 응답 전에 보여주기 위한 내 작성자 정보.
      myNickname: state.myNickname,
      myProfileImageUrl: state.myProfileImageUrl,
      locked: item.locked,
      // 댓글을 눌러 들어왔으므로 시트를 연 채로 시작한다.
      openCommentSheet: true,
      onLoadComments: () async {
        final comments = await notifier.loadComments(
          shotId: item.shotId,
          // 뷰어가 열린 동안 차단이 늘 수 있어(댓글 작성자 차단), 위젯에
          // 캡처된 집합 대신 조회 시점의 최신 차단 목록을 읽는다.
          blockedUserIds: ref.read(homeNotifierProvider).blockedUserIds,
        );
        if (comments == null || !context.mounted) return null;
        final l10n = AppLocalizations.of(context);
        return comments
            .map((comment) => toPhotoComment(comment, l10n, state.myUserId))
            .toList();
      },
      onSubmitComment: (content) async {
        final created = await notifier.submitComment(
          shotId: item.shotId,
          content: content,
        );
        if (created == null || !context.mounted) return null;
        return toPhotoComment(
          created,
          AppLocalizations.of(context),
          state.myUserId,
        );
      },
      // 삭제·수정은 댓글 id 로 처리한다. (대상 사진 shotId 와 무관)
      onDeleteComment: (comment) async {
        final id = comment.commentId;
        if (id == null) return false;
        return notifier.deleteComment(commentId: id);
      },
      onEditComment: (comment, newContent) async {
        final id = comment.commentId;
        if (id == null) return null;
        final content = await notifier.editComment(
          commentId: id,
          content: newContent,
        );
        if (content == null) return null;
        // 수정에 성공했으므로 '수정됨' 표시를 켠다.
        return comment.copyWith(content: content, isEdited: true);
      },
      onReportComment: (comment) => _reportComment(context, ref, comment),
      onBlockComment: (comment) => _blockCommentAuthor(context, ref, comment),
    );
  }

  /// 댓글 작성자를 차단한다. 먼저 확인 다이얼로그를 띄우고, 확인 시에만
  /// 진행한다. 성공하면 차단이 카드·댓글 필터에 반영되도록 홈을 다시 조회하고
  /// 완료 토스트를 띄운 뒤 true 를 반환한다. (true 면 댓글 시트가 목록을
  /// 재조회해 차단한 유저의 댓글을 걷어낸다)
  Future<bool> _blockCommentAuthor(
    BuildContext context,
    WidgetRef ref,
    PhotoComment comment,
  ) async {
    final userId = comment.userId;
    if (userId == null) return false;

    final l10n = AppLocalizations.of(context);
    final confirmed = await AppDialog.show(
      context,
      title: l10n.memberBlockConfirmTitle(comment.nickname),
      message: l10n.memberBlockConfirmMessage,
      confirmLabel: l10n.memberBlockConfirmAction,
      confirmColor: AppColors.statusDanger,
      confirmLabelColor: AppColors.textPrimary,
    );
    if (!confirmed || !context.mounted) return false;

    final success = await ref
        .read(homeNotifierProvider.notifier)
        .blockUser(userId);
    if (!context.mounted) return success;

    if (success) {
      Toast.showToast(context, l10n.memberBlockedToast(comment.nickname));
    } else {
      Toast.showToast(
        context,
        l10n.memberBlockFailedToast,
        type: ToastType.error,
      );
    }
    return success;
  }

  /// 댓글 신고 사유 시트를 띄우고, 확정하면 즉시 true 를 반환해 시트가
  /// 댓글을 바로 지우게 한다. (낙관적 — 접수는 백그라운드로 진행)
  /// 접수 성공 시 완료 토스트를, 실패 시 notifier 가 errorMessage → 토스트로
  /// 안내한다. (실패하면 서버에 신고가 남지 않았으므로 다음 목록 조회 때
  /// 댓글이 되살아난다)
  Future<bool> _reportComment(
    BuildContext context,
    WidgetRef ref,
    PhotoComment comment,
  ) async {
    final commentId = comment.commentId;
    if (commentId == null) return false;

    final result = await CommentReportSheet.show(context);
    if (result == null || !context.mounted) return false;

    // 접수 결과를 기다리지 않는다. (확정 즉시 댓글을 지우는 낙관적 처리)
    unawaited(
      ref
          .read(feedNotifierProvider.notifier)
          .reportComment(
            commentId: commentId,
            reason: result.reason,
            reasonText: result.detail.isEmpty ? null : result.detail,
          )
          .then((success) {
            if (!success || !context.mounted) return;
            Toast.showToast(
              context,
              AppLocalizations.of(context).reportSubmitted,
            );
          }),
    );
    return true;
  }
}
