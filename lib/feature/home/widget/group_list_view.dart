import 'package:ddara/core/model/group/group_list.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:ddara/feature/home/util/refresh_with_min_duration.dart';
import 'package:ddara/feature/home/widget/card_grid_view.dart';
import 'package:ddara/feature/home/widget/home_dashboard.dart';
import 'package:ddara/feature/home/widget/home_tab_header.dart';
import 'package:ddara/feature/home/widget/meeting_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 따라찍기 모임 탭: 진행 중인 모임 카드 목록.
class GroupListView extends ConsumerWidget {
  const GroupListView({
    super.key,
    required this.groups,
    required this.blockedUserIds,
  });

  final List<Group> groups;

  /// 내가 차단한 사용자 userId 집합.
  /// (차단한 멤버가 올린 썸네일은 차단 자리표시로 가린다)
  final Set<int> blockedUserIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardGridView(
      items: groups,
      dashboard: HomeDashboard.groupCount(
        count: groups.length,
        pageIndex: 0,
        pageCount: homeTabCount,
      ),
      cardBuilder: (context, group) => MeetingCard(
        group: group,
        // 차단한 멤버가 올린 썸네일은 차단 자리표시로 가린다.
        thumbnailBlocked: blockedUserIds.contains(group.thumbnailUserId),
        onTap: () => context.push(RoutePath.group, extra: group.groupId),
      ),
      // 당겨서 새로고침 → 모임 목록·차단 목록 재조회.
      onRefresh: () => refreshWithMinDuration(
        () => ref.read(homeNotifierProvider.notifier).refresh(),
      ),
    );
  }
}
