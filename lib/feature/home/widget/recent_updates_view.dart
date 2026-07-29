import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/comment/comment_action_error.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/feed/feed.dart';
import 'package:ddara/core/router/gallery_navigation.dart';
import 'package:ddara/core/util/refresh_with_min_duration.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/image/comment/comment_sheet_handlers.dart';
import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:ddara/core/widget/image/photo_viewer.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:ddara/feature/home/util/feed_state.dart';
import 'package:ddara/feature/home/util/home_state.dart';
import 'package:ddara/feature/home/widget/card_grid_view.dart';
import 'package:ddara/feature/home/widget/feed_card.dart';
import 'package:ddara/feature/home/widget/home_dashboard.dart';
import 'package:ddara/feature/home/widget/photo_card_shell.dart';
import 'package:ddara/feature/profile/provider/notifier_provider.dart';
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
    // (초기 조회 실패는 FeedLoadError 본문이 표시하므로 여기선 제외된다)
    ref.listen(feedNotifierProvider, (prev, next) {
      final actionError = next is FeedLoaded ? next.actionError : null;
      if (actionError != null) {
        Toast.showToast(
          context,
          _actionErrorMessage(AppLocalizations.of(context), actionError),
          type: ToastType.error,
        );
        ref.read(feedNotifierProvider.notifier).clearActionError();
      }
    });

    // 당겨서 새로고침 → 피드 재조회.
    Future<void> onRefresh() => refreshWithMinDuration(
      () => ref.read(feedNotifierProvider.notifier).refresh(),
    );

    return switch (state) {
      FeedLoading() => const Center(child: CupertinoActivityIndicator()),
      // 최초 조회 실패 화면에서도 당겨서 재시도할 수 있게 한다.
      FeedLoadError() => CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: AppText.body(AppLocalizations.of(context).feedLoadFailed),
            ),
          ),
        ],
      ),
      FeedLoaded() => _grid(context, ref, state, onRefresh),
    };
  }

  /// 액션 실패 종류를 사용자 노출 문구로 매핑한다.
  String _actionErrorMessage(AppLocalizations l10n, FeedActionError error) {
    return switch (error) {
      FeedRefreshFailed() => l10n.feedLoadFailed,
      FeedCommentError(:final error) => error.message(l10n),
    };
  }

  /// 로드 완료 상태의 카드 그리드.
  Widget _grid(
    BuildContext context,
    WidgetRef ref,
    FeedLoaded state,
    Future<void> Function() onRefresh,
  ) {
    // 차단한 멤버가 올린 사진은 목록에서 아예 뺀다. (자리표시로도 남기지 않는다)
    final items = state.feed.items
        .where((item) => !blockedUserIds.contains(item.userId))
        .toList();

    return CardGridView(
      items: items,
      dashboard: HomeDashboard.updateCount(count: state.feed.updateCount),
      cardBuilder: (context, item) => FeedCard(
        item: item,
        // 차단한 멤버의 댓글은 미리보기에서 뺀다.
        blockedUserIds: blockedUserIds,
        onCommentTap: () => _openPhotoViewer(context, ref, item),
        // 카드를 누르면 그 사진이 속한 회차의 갤러리로 들어간다.
        // (뒤로 나오면 홈이 아니라 사진이 속한 모임으로 이어진다)
        onTap: () => goCycleGallery(
          GoRouter.of(context),
          groupId: item.groupId,
          cycleId: item.cycleId,
          groupName: item.groupName,
        ),
      ),
      onRefresh: onRefresh,
    );
  }

  /// 피드 사진을 크게 띄우고, 댓글 시트가 열린 상태로 시작한다.
  ///
  /// 카드에서 보이던 프레임(186:245) 그대로 잘라 보여주고, 잠긴 사진은 뷰어에서도
  /// 블러 + 자물쇠를 유지한다. (서버가 잠긴 사진의 댓글 작성을 막으므로 뷰어가
  /// 입력창을 비활성화한다)
  void _openPhotoViewer(BuildContext context, WidgetRef ref, FeedItem item) {
    final imageUrl = item.imageUrl;
    if (imageUrl == null) return;

    // 내 프로필(공유 캐시 currentProfileProvider). 아직 조회 전이면 null —
    // 내 댓글 구분·작성자 표기가 빠질 뿐 뷰어 동작에는 지장 없다.
    final profile = ref.read(currentProfileProvider).valueOrNull;
    final handlers = CommentSheetHandlers(
      context: context,
      notifier: ref.read(feedNotifierProvider.notifier),
      shotId: item.shotId,
      myUserId: () => profile?.id,
      // 뷰어가 열린 동안 차단이 늘 수 있어(댓글 작성자 차단), 위젯에
      // 캡처된 집합 대신 조회 시점의 최신 차단 목록을 읽는다.
      blockedUserIds: () {
        final homeState = ref.read(homeNotifierProvider);
        return homeState is HomeLoaded
            ? homeState.blockedUserIds
            : blockedUserIds;
      },
      // 차단 API 가 모임 맥락을 요구하므로 사진이 속한 모임 id 를 함께 넘긴다.
      onBlockComment: (comment) =>
          _blockCommentAuthor(context, ref, comment, groupId: item.groupId),
    );

    showPhotoViewer(
      context,
      image: CachedNetworkImageProvider(imageUrl),
      aspectRatio: photoCardAspectRatio,
      // 댓글 시트 헤더: 업로더 닉네임 + 따라찍기 주제.
      title: item.nickname,
      body: item.topic,
      // 전송 중 댓글을 서버 응답 전에 보여주기 위한 내 작성자 정보.
      myNickname: profile?.name ?? '',
      myProfileImageUrl: profile?.profileImageUrl,
      locked: item.locked,
      // 댓글을 눌러 들어왔으므로 시트를 연 채로 시작한다.
      openCommentSheet: true,
      onLoadComments: handlers.onLoadComments,
      onSubmitComment: handlers.onSubmitComment,
      onDeleteComment: handlers.onDeleteComment,
      onEditComment: handlers.onEditComment,
      onReportComment: handlers.onReportComment,
      onBlockComment: handlers.onBlockComment,
    );
  }

  /// 댓글 작성자를 차단한다. 먼저 확인 다이얼로그를 띄우고, 확인 시에만
  /// 진행한다. 성공하면 차단이 카드·댓글 필터에 반영되도록 홈을 다시 조회하고
  /// 완료 토스트를 띄운 뒤 true 를 반환한다. (true 면 댓글 시트가 목록을
  /// 재조회해 차단한 유저의 댓글을 걷어낸다)
  Future<bool> _blockCommentAuthor(
    BuildContext context,
    WidgetRef ref,
    PhotoComment comment, {
    required int groupId,
  }) async {
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
        .blockUser(userId, groupId: groupId);
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
}
