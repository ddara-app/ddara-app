import 'package:ddara/core/analytics/app_analytics.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/logo/logo.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/foundation/app_icons.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/design_system/component/avatar/profile_avatar.dart';
import 'package:ddara/feature/home/widget/empty_group_view.dart';
import 'package:ddara/feature/home/widget/home_tabs_view.dart';
import 'package:ddara/feature/home/provider/viewmodel_provider.dart';
import 'package:ddara/feature/home/util/home_state.dart';
import 'package:ddara/feature/notification/provider/unread_notification_provider.dart';
import 'package:ddara/feature/profile/provider/viewmodel_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  /// 홈 콘텐츠(빈 상태·목록)가 처음 확정됐을 때 조회 이벤트를 한 번만 보낸다.
  bool _viewTracked = false;

  /// 로딩·에러가 끝나 화면이 확정되면 빈 상태/목록을 구분해 조회 이벤트를 전송한다.
  void _trackHomeViewed(HomeState state) {
    if (_viewTracked) return;
    // 아직 어떤 화면인지 확정되지 않았으므로 보류.
    if (state is! HomeLoaded) return;
    _viewTracked = true;
    AppAnalytics.track(
      'home_viewed',
      properties: {
        'state': state.groups.isEmpty ? 'empty' : 'list',
        'group_count': state.groups.length,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(homeViewModelProvider);
    // 조회 이벤트는 상태 변화 콜백에서 전송한다. (build 는 순수하게 유지)
    ref.listen(homeViewModelProvider, (_, next) => _trackHomeViewed(next));
    // 서버 프로필의 이미지 URL. (조회 전·미등록이면 null → 기본 아바타)
    // 이미지 URL 만 select 해 닉네임 등 다른 프로필 변경에는 rebuild 하지 않는다.
    final profileImageUrl = ref.watch(
      currentProfileProvider.select((v) => v.valueOrNull?.profileImageUrl),
    );
    // 안 읽은 알림 여부. (조회 전·실패면 false → 기본 종)
    final hasUnread = ref.watch(
      hasUnreadNotificationProvider.select((v) => v.valueOrNull ?? false),
    );

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        // 좌측 로고를 직접 배치하므로 뒤로가기 버튼 비활성화.
        showBackButton: false,
        leading: const Align(alignment: Alignment.centerLeft, child: Logo()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBarIconButton(
              onPressed: _openNotification,
              child: AppIcon(
                hasUnread ? AppIcons.bellUnread : AppIcons.bell,
                size: 24,
              ),
            ),
            AppBarIconButton(
              size: 32,
              // 아바타 자체가 시각적 버튼이라 내부 여백 없이 콘텐츠에 딱 맞춘다.
              hugContent: true,
              child: ProfileAvatar(size: 32, imageUrl: profileImageUrl),
              onPressed: () => context.push(RoutePath.profile),
            ),
          ],
        ),
      ),
      child: SafeArea(bottom: false, child: _body(state, l10n)),
    );
  }

  /// 알림 목록으로 이동하고, 돌아오면 안 읽음 여부를 다시 조회한다.
  ///
  /// 홈은 그대로 떠 있어 알아서 갱신되지 않는다. 목록에서 알림을 탭해
  /// 다른 화면으로 넘어가는 경우는 ViewModel 이 읽음 처리 뒤 따로 갱신한다.
  Future<void> _openNotification() async {
    await context.push(RoutePath.notification);
    if (!mounted) return;
    ref.invalidate(hasUnreadNotificationProvider);
  }

  /// 조회 결과에 따라 화면을 분기한다.
  /// 로딩 → 인디케이터 / 에러 → 안내 / 모임 없음 → 빈 상태 / 있으면 목록.
  Widget _body(HomeState state, AppLocalizations l10n) {
    return switch (state) {
      HomeLoading() => const Center(child: CupertinoActivityIndicator()),
      HomeLoadError() => Center(child: AppText.body(l10n.homeLoadFailed)),
      HomeLoaded(:final groups, :final blockedUserIds) => groups.isNotEmpty
          ? HomeTabsView(groups: groups, blockedUserIds: blockedUserIds)
          : const EmptyGroupView(),
    };
  }
}
