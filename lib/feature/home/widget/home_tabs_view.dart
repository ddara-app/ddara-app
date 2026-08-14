import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/domain/model/group/group_list.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/home/widget/fab_speed_dial.dart';
import 'package:ddara/feature/home/widget/group_list_view.dart';
import 'package:ddara/feature/home/widget/home_tab_header.dart';
import 'package:ddara/feature/home/widget/recent_updates_view.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 참여한 모임이 하나 이상일 때 보여주는 홈 본문.
///
/// 상단에 좌측 정렬 탭 2개(따라찍기 모임 / 최근 업데이트)를 두고,
/// 아래 [PageView] 를 좌우 스와이프해 두 화면을 오간다.
/// FAB 는 탭과 무관하게 항상 우하단에 떠 있다.
class HomeTabsView extends StatefulWidget {
  const HomeTabsView({
    super.key,
    required this.groups,
    this.blockedUserIds = const {},
  });

  /// 표시할 모임 목록. (상위 HomePage 에서 조회 결과를 주입)
  final List<Group> groups;

  /// 내가 차단한 사용자 userId 집합.
  /// (차단한 멤버가 올린 썸네일은 차단 자리표시로 가린다)
  final Set<int> blockedUserIds;

  @override
  State<HomeTabsView> createState() => _HomeTabsViewState();
}

class _HomeTabsViewState extends State<HomeTabsView> {
  final PageController _pageController = PageController();

  /// 현재 선택된 탭 인덱스. (0 = 따라찍기 모임, 1 = 최근 업데이트)
  int _tabIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// PageView 의 현재 페이지 값(스와이프 진행도 포함).
  /// 첫 레이아웃 전(치수 미확정)에는 선택 인덱스로 대체한다.
  double get _currentPage {
    final hasPage =
        _pageController.hasClients && _pageController.position.haveDimensions;
    return hasPage ? _pageController.page! : _tabIndex.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Stack(
      // 콘텐츠가 짧아도(빈 목록 등) 화면 전체 높이를 채워 FAB 가 항상 바닥에 붙도록.
      fit: StackFit.expand,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s5,
                AppSpacing.s5,
                AppSpacing.s5,
                AppSpacing.s7,
              ),
              child: HomeTabHeader(
                controller: _pageController,
                labels: [l10n.homeTabGroups, l10n.homeTabRecentUpdates],
                currentIndex: _tabIndex,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                // 스와이프로 넘겨도 탭 라벨 강조가 따라오도록 인덱스를 동기화.
                onPageChanged: (index) => setState(() => _tabIndex = index),
                children: [
                  GroupListView(
                    groups: widget.groups,
                    blockedUserIds: widget.blockedUserIds,
                  ),
                  RecentUpdatesView(blockedUserIds: widget.blockedUserIds),
                ],
              ),
            ),
          ],
        ),
        // 백드롭 + FAB + 펼침 모션을 모두 내장한 완결형 위젯.
        // Stack 의 맨 위(마지막 자식)에 얹어 콘텐츠 위를 덮도록 한다.
        // FAB 는 따라찍기 모임 탭 전용이라, 최근 업데이트 탭으로 갈수록
        // 스와이프 진행도에 맞춰 페이드 아웃되고 완전히 넘어가면 사라진다.
        AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            final visibility = (1 - _currentPage).clamp(0.0, 1.0);
            // 완전히 사라졌으면 터치 영역까지 제거한다.
            if (visibility == 0) return const SizedBox.shrink();
            return IgnorePointer(
              // 반쯤 사라진 상태에서 잘못 눌리지 않도록 일찍 막는다.
              ignoring: visibility < 0.5,
              child: Opacity(opacity: visibility, child: child),
            );
          },
          child: SpeedDialFab(
            actions: [
              SpeedDialAction(
                label: l10n.groupCreate,
                filled: true,
                onTap: () => context.push(RoutePath.groupCreate),
              ),
              SpeedDialAction(
                label: l10n.groupJoin,
                onTap: () => context.push(RoutePath.inviteCodeInput),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
