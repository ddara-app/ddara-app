import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/notification/notification_item.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/list/lazy_reveal_list.dart';
import 'package:ddara/feature/group/detail/group_page.dart';
import 'package:ddara/feature/notification/provider/notifier_provider.dart';
import 'package:ddara/feature/notification/util/notification_state.dart';
import 'package:ddara/feature/notification/widget/notification_empty.dart';
import 'package:ddara/feature/notification/widget/notification_tile.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 알림 목록 화면.
///
/// 상단 바(뒤로가기 + 가운데 '알림') 아래로 알림 항목([NotificationTile])을 쌓는다.
class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  /// 한 번에 화면에 드러내는 알림 개수. (클라이언트 사이드 페이징 단위)
  static const _pageSize = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationNotifierProvider);

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: AppLocalizations.of(context).notificationTitle,
        onBack: () => context.pop(),
      ),
      child: SafeArea(bottom: false, child: _body(context, state)),
    );
  }

  /// 조회 결과에 따라 화면을 분기한다.
  /// 로딩 → 인디케이터 / 에러 → 안내 / 알림 없음 → 빈 상태 / 있으면 목록.
  Widget _body(BuildContext context, NotificationState state) {
    final l10n = AppLocalizations.of(context);
    return switch (state) {
      NotificationLoading() => const Center(
        child: CupertinoActivityIndicator(),
      ),
      NotificationLoadError() => Center(
        child: AppText.body(l10n.notificationLoadFailed),
      ),
      NotificationLoaded(:final items, :final blockedUserIds) =>
        items.isEmpty
            ? const Center(child: NotificationEmpty())
            : _list(context, items, blockedUserIds),
    };
  }

  /// 전량 받아둔 목록을 청크 단위로만 그린다. (docs/client_side_paging.md)
  Widget _list(
    BuildContext context,
    List<NotificationItem> items,
    Set<int> blockedUserIds,
  ) {
    return LazyRevealList(
      items: items,
      pageSize: _pageSize,
      builder: (context, visibleItems) => SingleChildScrollView(
        // 끝에서 더 당겨지는 바운스(overscroll)를 막고 가장자리에서 멈춘다.
        physics: const ClampingScrollPhysics(),
        // 상단 s3, 좌우 s4, 하단 s6 + Safe Area 인셋 여백. (마지막 알림이
        // 홈 인디케이터와 겹치지 않도록)
        padding: EdgeInsets.fromLTRB(
          AppSpacing.s4,
          AppSpacing.s3,
          AppSpacing.s4,
          AppSpacing.s6 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s3,
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

  /// 알림 탭 시 이동할 화면.
  ///
  /// cycleId 가 있으면(NEW_CYCLE·CYCLE_COMPLETED·DEADLINE·FRIEND_SHOT·COMMENT)
  /// 해당 사이클 갤러리로, 없고 groupId 만 있으면(MEMBER_JOIN·STARTER_ASSIGNED)
  /// 해당 모임 화면으로 이동한다.
  /// (COMMENT 의 shotId 로 사진 뷰어까지 바로 여는 건 갤러리 라우트가 사이클
  ///  단위라 지원하지 않는다 — 갤러리에서 사진을 골라 들어간다)
  VoidCallback? _onTap(BuildContext context, NotificationItem item) {
    final cycleId = item.payload.cycleId;
    if (cycleId != null) {
      return () => context.push(RoutePath.follower, extra: cycleId);
    }

    final groupId = item.payload.groupId;
    if (groupId != null) {
      // payload 의 모임 이름을 함께 넘겨 조회 전에도 AppBar 를 채운다.
      return () => context.push(
        RoutePath.group,
        extra: GroupPageArgs(
          groupId: groupId,
          groupName: item.payload.groupName,
        ),
      );
    }

    return null;
  }
}
