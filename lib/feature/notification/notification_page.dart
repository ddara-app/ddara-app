import 'package:ddara/core/analytics/analytics_events.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/domain/model/notification/notification_item.dart';
import 'package:ddara/core/router/gallery_navigation.dart';
import 'package:ddara/core/widget/list/lazy_reveal_list.dart';
import 'package:ddara/core/widget/scrollable_page_body.dart';
import 'package:ddara/core/widget/tab/page_tab_header.dart';
import 'package:ddara/feature/notification/provider/viewmodel_provider.dart';
import 'package:ddara/feature/notification/util/notification_filter.dart';
import 'package:ddara/feature/notification/util/notification_state.dart';
import 'package:ddara/feature/notification/widget/notification_empty.dart';
import 'package:ddara/feature/notification/widget/notification_filter_chips.dart';
import 'package:ddara/feature/notification/widget/notification_retry_button.dart';
import 'package:ddara/feature/notification/widget/notification_tile.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 알림 목록 화면.
///
/// 상단 바(뒤로가기 + 가운데 '알림') 아래로 탭 두 개('전체' / '안 읽음')를 두고,
/// [PageView] 를 좌우로 스와이프해 오간다. (홈 화면과 같은 구성)
class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  /// 한 번에 화면에 드러내는 알림 개수. (클라이언트 사이드 페이징 단위)
  static const _pageSize = 20;

  final PageController _pageController = PageController();

  /// 현재 선택된 탭 인덱스. (0 = 전체, 1 = 안 읽음)
  int _tabIndex = 0;

  /// 현재 선택된 필터 칩.
  ///
  /// 탭과 따로 놀고, 탭을 오가도 그대로 유지된다.
  NotificationFilter _filter = NotificationFilter.all;

  @override
  void initState() {
    super.initState();
    AnalyticsEvents.notificationPageViewed();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(notificationViewModelProvider);

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.notificationTitle,
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  // 하단 여백은 두지 않는다. 인디케이터와 칩 사이 간격은
                  // 스크롤되는 본문(_scrollBody) 상단이 갖고 있어, 스크롤하면
                  // 여백째 올라가 목록이 탭 바로 아래까지 붙는다. (홈과 같은 방식)
                  padding: pageTabHeaderPadding.copyWith(bottom: AppSpacing.s0),
                  child: PageTabHeader(
                    controller: _pageController,
                    labels: [
                      l10n.notificationTabAll,
                      l10n.notificationTabUnread,
                    ],
                    currentIndex: _tabIndex,
                    // 라벨이 짧아 그대로 두면 밑줄이 밀착해 보인다. 홈과 같은 폭으로 맞춘다.
                    tabWidth: pageTabWidth,
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    // 스와이프로 넘겨도 탭 라벨 강조가 따라오도록 인덱스를 동기화.
                    onPageChanged: (index) => setState(() => _tabIndex = index),
                    children: [
                      _page(state, unreadOnly: false),
                      _page(state, unreadOnly: true),
                    ],
                  ),
                ),
              ],
            ),
            // 목록 대신 보여줄 화면은 헤더·칩 위에 올려 **화면 가운데**에 둔다.
            // 본문 안에 두면 헤더·칩이 차지한 높이만큼 아래로 치우쳐 보인다.
            //
            // 탭·칩은 그대로 누를 수 있어야 하는데, [Center] 는 자식 크기만큼만
            // 터치를 받아 바깥 빈 자리는 알아서 통과된다. IgnorePointer 로 막으면
            // 안내 안의 '다시 시도' 버튼까지 막힌다.
            if (_placeholder(context, state) case final placeholder?)
              Positioned.fill(child: Center(child: placeholder)),
          ],
        ),
      ),
    );
  }

  /// 목록 대신 보여줄 화면. 보여줄 목록이 있으면 null.
  ///
  /// 로딩 → 인디케이터 / 에러 → 안내 / 걸러낸 결과 없음 → 빈 화면.
  /// 스와이프 중에도 한 장만 띄워야 해서 현재 탭([_tabIndex]) 기준으로 고른다.
  Widget? _placeholder(BuildContext context, NotificationState state) {
    final l10n = AppLocalizations.of(context);
    return switch (state) {
      NotificationLoading() => const CupertinoActivityIndicator(),
      NotificationLoadError() => NotificationEmpty(
        title: l10n.notificationLoadFailedTitle,
        description: l10n.notificationLoadFailedDescription,
        action: NotificationRetryButton(
          onPressed: () =>
              ref.read(notificationViewModelProvider.notifier).retry(),
        ),
      ),
      NotificationLoaded(:final items) =>
        _visibleItems(items, unreadOnly: _tabIndex == 1).isEmpty
            ? _empty(context, unreadOnly: _tabIndex == 1)
            : null,
    };
  }

  /// 탭([unreadOnly])과 칩([_filter])을 모두 걸러낸 목록.
  ///
  /// 조회는 한 번만 하고 추리기만 하므로 탭·칩을 오갈 때 다시 부르지 않는다.
  List<NotificationItem> _visibleItems(
    List<NotificationItem> items, {
    required bool unreadOnly,
  }) {
    return items
        .where((item) => !unreadOnly || !item.isRead)
        .where(_filter.matches)
        .toList();
  }

  /// 한 탭의 본문. 필터 칩 줄과 목록이 한 몸으로 스크롤된다.
  ///
  /// 칩을 스크롤 밖에 두면 목록만 올라가고 칩은 남지만, 여기선 함께 올라간다.
  /// 다시 보려면 목록을 최상단까지 되돌려야 한다.
  ///
  /// 탭마다 한 벌씩 그려도 선택 상태([_filter])는 화면이 들고 있어 두 탭이
  /// 같은 값을 본다.
  ///
  /// 보여줄 목록이 없으면(로딩·에러·걸러낸 결과 없음) 칩 줄만 남긴다.
  /// (그때 보여줄 화면은 [_placeholder] 가 위에 올린다)
  Widget _page(NotificationState state, {required bool unreadOnly}) {
    if (state is! NotificationLoaded) {
      return _scrollBody(const SizedBox.shrink());
    }

    final items = _visibleItems(state.items, unreadOnly: unreadOnly);
    if (items.isEmpty) return _scrollBody(const SizedBox.shrink());

    return _listView(items, state.blockedUserIds);
  }

  /// 걸러낸 결과가 없을 때 보여줄 화면. 탭·칩 조합마다 문구가 다르다.
  ///
  /// - 안 읽음 탭: 남은 것이 없다는 뜻
  /// - 댓글 칩: 아직 댓글이 없다는 뜻
  /// - 그 외: 받은 알림 자체가 없는 상태
  Widget _empty(BuildContext context, {required bool unreadOnly}) {
    final l10n = AppLocalizations.of(context);
    if (unreadOnly) {
      return NotificationEmpty(
        title: l10n.notificationUnreadEmptyTitle,
        description: l10n.notificationUnreadEmptyDescription,
      );
    }
    if (_filter == NotificationFilter.comment) {
      return NotificationEmpty(
        title: l10n.notificationCommentEmptyTitle,
        description: l10n.notificationCommentEmptyDescription,
      );
    }
    return NotificationEmpty(
      title: l10n.notificationEmptyTitle,
      description: l10n.notificationEmptyDescription,
    );
  }

  /// 전량 받아둔 목록을 청크 단위로만 그린다. (docs/client_side_paging.md)
  Widget _listView(List<NotificationItem> items, Set<int> blockedUserIds) {
    return LazyRevealList(
      items: items,
      pageSize: _pageSize,
      // 칩을 바꾸면 목록이 통째로 갈리므로 노출 개수를 첫 페이지로 되돌린다.
      resetKey: _filter,
      builder: (context, visibleItems) => _scrollBody(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s4,
          children: [
            for (final notification in visibleItems)
              NotificationTile(
                item: notification,
                blockedUserIds: blockedUserIds,
                onTap: _onTap(context, notification),
              ),
          ],
        ),
      ),
    );
  }

  /// 필터 칩 줄과 [list] 를 한 몸으로 스크롤시키는 본문.
  ///
  /// 스크롤 정책은 공용 [ScrollablePageBody] 를 따르고 여백만 손본다.
  /// 상단 여백을 탭 헤더가 아니라 스크롤되는 이쪽이 갖고 있어, 스크롤하면
  /// 칩과 여백이 함께 올라간다. 다시 보려면 최상단까지 되돌려야 한다.
  Widget _scrollBody(Widget list) {
    return ScrollablePageBody(
      padding: const EdgeInsets.only(
        top: AppSpacing.s4,
        left: AppSpacing.s5,
        right: AppSpacing.s5,
        bottom: AppSpacing.s7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            // 칩과 첫 알림 사이 간격.
            padding: const EdgeInsets.only(bottom: AppSpacing.s4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: NotificationFilterChips(
                selected: _filter,
                onChanged: (filter) => setState(() => _filter = filter),
              ),
            ),
          ),
          list,
        ],
      ),
    );
  }

  /// 알림 탭 시 이동할 화면.
  ///
  /// cycleId 가 있으면(NEW_CYCLE·CYCLE_COMPLETED·DEADLINE·FRIEND_SHOT·COMMENT)
  /// 해당 사이클 갤러리로, 없고 groupId 만 있으면(MEMBER_JOIN·STARTER_ASSIGNED)
  /// 해당 모임 화면으로 이동한다.
  /// (COMMENT 의 shotId 로 사진 뷰어까지 바로 여는 건 갤러리 라우트가 사이클
  ///  단위라 지원하지 않는다 — 갤러리에서 사진을 골라 들어간다)
  VoidCallback? _onTap(BuildContext context, NotificationItem item) {
    final payload = item.payload;
    // 모임을 모르면 어느 화면으로도 갈 수 없다. (알림 종류를 불문하고 함께 온다)
    final groupId = payload.groupId;
    if (groupId == null) return null;

    /// 이동 직전에 읽음으로 표시한다.
    void markRead() =>
        ref.read(notificationViewModelProvider.notifier).markAsRead(item.id);

    // 이동은 모두 홈 기준으로 스택을 다시 세운다 — 갤러리에서 뒤로 나오면
    // 알림 목록이 아니라 그 모임으로, 모임에서 한 번 더 나오면 홈이다.
    // (모임 이름을 함께 넘겨 조회 전에도 AppBar 를 채운다)
    final cycleId = payload.cycleId;
    if (cycleId != null) {
      return () {
        markRead();
        goCycleGallery(
          GoRouter.of(context),
          groupId: groupId,
          cycleId: cycleId,
          groupName: payload.groupName,
        );
      };
    }

    return () {
      markRead();
      goGroup(
        GoRouter.of(context),
        groupId: groupId,
        groupName: payload.groupName,
      );
    };
  }
}
