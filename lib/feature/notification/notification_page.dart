import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/model/notification/notification_item.dart';
import 'package:ddara/core/router/route_path.dart';
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

  Widget _body(BuildContext context, NotificationState state) {
    // 첫 조회 중: 로딩 인디케이터.
    if (state.isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    // 조회 실패: 에러 메시지.
    if (state.errorMessage.isNotEmpty) {
      return Center(child: AppText.body(state.errorMessage));
    }

    // 알림이 없으면 빈 상태 화면을 중앙에 보여준다.
    if (state.isEmpty) {
      return const Center(child: NotificationEmpty());
    }

    return SingleChildScrollView(
      // 끝에서 더 당겨지는 바운스(overscroll)를 막고 가장자리에서 멈춘다.
      physics: const ClampingScrollPhysics(),
      // 상단 s3, 좌우 s5, 하단 s6 + Safe Area 인셋 여백. (마지막 알림이
      // 홈 인디케이터와 겹치지 않도록)
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s5,
        AppSpacing.s3,
        AppSpacing.s5,
        AppSpacing.s6 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s3,
        children: [
          for (final notification in state.items)
            NotificationTile(
              item: notification,
              blockedUserIds: state.blockedUserIds,
              onTap: _onTap(context, notification),
            ),
        ],
      ),
    );
  }

  /// 알림 탭 시 이동할 화면.
  ///
  /// cycleId 가 있으면(NEW_CYCLE·CYCLE_COMPLETED·DEADLINE) 해당 사이클 갤러리로,
  /// 없고 groupId 만 있으면(MEMBER_JOIN) 해당 모임 화면으로 이동한다.
  VoidCallback? _onTap(BuildContext context, NotificationItem item) {
    final cycleId = item.payload.cycleId;
    if (cycleId != null) {
      return () => context.push(RoutePath.follower, extra: cycleId);
    }

    final groupId = item.payload.groupId;
    if (groupId != null) {
      return () => context.push(RoutePath.group, extra: groupId);
    }

    return null;
  }
}
