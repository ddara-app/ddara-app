import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/router/gallery_navigation.dart';
import 'package:ddara/core/util/refresh_with_min_duration.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/home/provider/viewmodel_provider.dart';
import 'package:ddara/feature/home/util/feed_state.dart';
import 'package:ddara/feature/home/widget/card_grid_view.dart';
import 'package:ddara/feature/home/widget/feed_card.dart';
import 'package:ddara/feature/home/widget/home_dashboard.dart';
import 'package:ddara/feature/home/widget/home_refresh_control.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 최근 업데이트 탭: 따라찍기 모임 탭과 같은 그리드 구조를 공유한다.
///
/// 모임 카드 자리에 피드 카드(회차 주제 · 업로더 닉네임)를 채우고,
/// 잠긴 사진은 블러 + 자물쇠로 가린다.
class RecentUpdatesView extends ConsumerWidget {
  const RecentUpdatesView({
    super.key,
    required this.blockedUserIds,
    this.controller,
  });

  /// 내가 차단한 사용자 userId 집합.
  /// (차단한 멤버가 올린 사진은 목록에서 제외한다)
  final Set<int> blockedUserIds;

  /// 스크롤 컨트롤러. 탭 재선택으로 목록을 맨 위로 되돌릴 때 쓴다.
  final ScrollController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedViewModelProvider);

    // 액션 실패를 토스트로 안내한다.
    // (초기 조회 실패는 FeedLoadError 본문이 표시하므로 여기선 제외된다)
    ref.listen(feedViewModelProvider, (prev, next) {
      final actionError = next is FeedLoaded ? next.actionError : null;
      if (actionError != null) {
        Toast.showToast(
          context,
          _actionErrorMessage(AppLocalizations.of(context), actionError),
          type: ToastType.error,
        );
        ref.read(feedViewModelProvider.notifier).clearActionError();
      }
    });

    // 당겨서 새로고침 → 피드 재조회.
    Future<void> onRefresh() => refreshWithMinDuration(
      () => ref.read(feedViewModelProvider.notifier).refresh(),
    );

    return switch (state) {
      FeedLoading() => const Center(child: CupertinoActivityIndicator()),
      // 최초 조회 실패 화면에서도 당겨서 재시도할 수 있게 한다.
      FeedLoadError() => CustomScrollView(
        controller: controller,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          HomeRefreshControl(onRefresh: onRefresh),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: AppText.body(AppLocalizations.of(context).feedLoadFailed),
            ),
          ),
        ],
      ),
      FeedLoaded() => _grid(context, state, onRefresh),
    };
  }

  /// 액션 실패 종류를 사용자 노출 문구로 매핑한다.
  String _actionErrorMessage(AppLocalizations l10n, FeedActionError error) {
    return switch (error) {
      FeedRefreshFailed() => l10n.feedLoadFailed,
    };
  }

  /// 로드 완료 상태의 카드 그리드.
  Widget _grid(
    BuildContext context,
    FeedLoaded state,
    Future<void> Function() onRefresh,
  ) {
    // 차단한 멤버가 올린 사진은 목록에서 아예 뺀다. (자리표시로도 남기지 않는다)
    final items = state.feed.items
        .where((item) => !blockedUserIds.contains(item.userId))
        .toList();

    return CardGridView(
      controller: controller,
      items: items,
      dashboard: HomeDashboard.updateCount(count: state.feed.updateCount),
      cardBuilder: (context, item) => FeedCard(
        item: item,
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
}
