import 'dart:ui' show lerpDouble;

import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/group_list.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/home/widget/fab_speed_dial.dart';
import 'package:ddara/feature/home/widget/home_dashboard.dart';
import 'package:ddara/feature/home/widget/meeting_card.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 우측 하단 FAB 의 지름.
const double _fabSize = 56;

/// 탭 터치 시 페이지 이동 애니메이션 시간.
const Duration _tabSwitchDuration = Duration(milliseconds: 300);

/// 탭 인디케이터 두께.
const double _indicatorHeight = 3;

/// 홈 탭(페이지) 개수.
const int _tabCount = 2;

/// 참여한 모임이 하나 이상일 때 보여주는 홈 본문.
///
/// 상단에 좌측 정렬 탭 2개(따라찍기 모임 / 최근 업데이트)를 두고,
/// 아래 [PageView] 를 좌우 스와이프해 두 화면을 오간다.
/// FAB 는 탭과 무관하게 항상 우하단에 떠 있다.
class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key, required this.groups});

  /// 표시할 모임 목록. (상위 HomePage 에서 조회 결과를 주입)
  final List<Group> groups;

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
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

  void _onTabTap(int index) {
    if (index == _tabIndex) return;
    _pageController.animateToPage(
      index,
      duration: _tabSwitchDuration,
      // 빠르게 출발해 부드럽게 감속 착지.
      curve: Curves.easeOutCubic,
    );
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
                AppSpacing.s4,
                AppSpacing.s4,
                AppSpacing.s4,
                AppSpacing.s3,
              ),
              child: _buildTabHeader(l10n),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                // 스와이프로 넘겨도 탭 라벨 강조가 따라오도록 인덱스를 동기화.
                onPageChanged: (index) => setState(() => _tabIndex = index),
                children: [
                  _GroupListView(groups: widget.groups),
                  const _RecentUpdatesView(),
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

  /// 좌측 정렬 탭 헤더 (라벨 2개 + 밑줄 인디케이터).
  ///
  /// 고정 프레임 애니메이션 대신 [PageView] 의 스크롤 진행도(0.0~1.0)를 매 프레임
  /// 읽어 라벨 색과 인디케이터 위치·폭을 보간한다. 그래서 손가락 드래그를
  /// 그대로 따라오고, 탭 터치 시에도 페이지 이동과 완전히 동기화된다.
  Widget _buildTabHeader(AppLocalizations l10n) {
    final labels = [l10n.homeTabGroups, l10n.homeTabRecentUpdates];
    return AnimatedBuilder(
      // PageController 가 스크롤마다 notify 하므로 진행도를 프레임 단위로 반영.
      animation: _pageController,
      builder: (context, _) {
        final page = _currentPage;
        final t = page.clamp(0.0, 1.0);

        // 라벨별 실제 렌더링 폭. (인디케이터 위치·폭 보간의 기준)
        final textScaler = MediaQuery.textScalerOf(context);
        final widths = [
          for (final label in labels) _labelWidth(label, textScaler),
        ];
        // 각 라벨의 시작 x 좌표. (Row 간격 s4 반영)
        final lefts = [0.0, widths[0] + AppSpacing.s4];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: AppSpacing.s4,
              children: [
                for (var i = 0; i < labels.length; i++)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onTabTap(i),
                    child: Text(
                      labels[i],
                      style: AppTypography.label.copyWith(
                        // 진행도에 비례해 회색↔흰색을 섞어 드래그를 따라온다.
                        color: Color.lerp(
                          AppColors.textTertiary,
                          AppColors.textPrimary,
                          (1 - (page - i).abs()).clamp(0.0, 1.0),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s3),
            // 선택 라벨 아래로 미끄러지는 인디케이터. 위치·폭을 진행도로 보간한다.
            SizedBox(
              height: _indicatorHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    left: lerpDouble(lefts[0], lefts[1], t)!,
                    width: lerpDouble(widths[0], widths[1], t)!,
                    top: 0,
                    bottom: 0,
                    child: const ColoredBox(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// [AppTypography.label] 스타일 기준 라벨의 렌더링 폭.
  double _labelWidth(String label, TextScaler textScaler) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: AppTypography.label),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }
}

/// 따라찍기 모임 탭: 진행 중인 모임 카드 목록.
class _GroupListView extends StatelessWidget {
  const _GroupListView({required this.groups});

  final List<Group> groups;

  @override
  Widget build(BuildContext context) {
    return _CardGridView(
      groups: groups,
      dashboard: HomeDashboard.groupCount(
        count: groups.length,
        pageIndex: 0,
        pageCount: _tabCount,
      ),
      cardBuilder: (context, group) => MeetingCard(
        group: group,
        onTap: () => _openGroup(context, group.groupId),
      ),
    );
  }
}

/// 최근 업데이트 탭: 따라찍기 모임 탭과 같은 그리드 구조를 공유한다.
///
/// 업데이트 데이터가 아직 없어 지금은 대시보드만 있는 빈 그리드를 보여준다.
class _RecentUpdatesView extends StatelessWidget {
  const _RecentUpdatesView();

  @override
  Widget build(BuildContext context) {
    return _CardGridView(
      // TODO: 최근 업데이트 데이터가 정해지면 개수·카드 목록을 채운다.
      groups: const [],
      dashboard: const HomeDashboard.updateCount(
        count: 0,
        pageIndex: 1,
        pageCount: _tabCount,
      ),
      cardBuilder: (context, group) => MeetingCard(
        group: group,
        onTap: () => _openGroup(context, group.groupId),
      ),
    );
  }
}

void _openGroup(BuildContext context, int groupId) {
  context.push(RoutePath.group, extra: groupId);
}

/// 두 탭이 공유하는 카드 그리드 본문.
///
/// 화면을 세로로 반 나눠 좌/우 두 열에 카드를 번갈아(지그재그) 배치한다.
/// 우측 열 맨 위에는 카드보다 작은 고정 위젯([HomeDashboard])이 들어가, 그 높이
/// 차이만큼 우측 카드들이 위로 덜 내려오면서 자연스러운 지그재그가 만들어진다.
///
/// 카드 높이가 균일하므로 Masonry 패키지 없이 `Row` + `Column` 2개로 충분하다.
class _CardGridView extends StatelessWidget {
  const _CardGridView({
    required this.groups,
    required this.dashboard,
    required this.cardBuilder,
  });

  final List<Group> groups;

  /// 우측 열 맨 위에 고정되는 요약 위젯. (탭마다 담는 내용이 다르다)
  final Widget dashboard;

  /// 카드 생성자. (탭마다 카드에 담는 내용이 달라 주입받는다)
  final Widget Function(BuildContext context, Group group) cardBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // 콘텐츠가 화면에 들어가면 스크롤 없음, 카드가 많아지면 스크롤로
      // 전환되도록 뷰포트 높이를 최소 높이로 강제한다. (프로필과 동일 패턴)
      builder: (context, constraints) => SingleChildScrollView(
        // 카드가 적어 화면에 다 들어가도 당김(바운스)이 되도록 항상
        // 스크롤 가능하게 둔다.
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            // 패딩이 스크롤 범위에 더해져 항상 스크롤되지 않도록
            // (minHeight 초과) ConstrainedBox 안쪽에 둔다.
            // 위는 탭 헤더가 있어 s4, 좌우 s4. (하단은 FAB 에 가리지 않도록
            // 버튼 높이 + Safe Area 인셋만큼 더 여유)
            padding: EdgeInsets.fromLTRB(
              AppSpacing.s4,
              AppSpacing.s4,
              AppSpacing.s4,
              AppSpacing.s6 +
                  _fabSize +
                  AppSpacing.s4 +
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Row(
              // 핵심: 두 열을 위 기준으로 정렬해야 고정 위젯이 만든 오프셋이 유지된다.
              crossAxisAlignment: CrossAxisAlignment.start,
              // 두 열 사이 간격.
              spacing: AppSpacing.s3,
              children: [
                // 좌측 열: 짝수 인덱스 카드 (0, 2, 4 …)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.s3,
                    children: [
                      for (var i = 0; i < groups.length; i += 2)
                        cardBuilder(context, groups[i]),
                    ],
                  ),
                ),
                // 우측 열: 맨 위 고정 위젯 + 홀수 인덱스 카드 (1, 3, 5 …)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.s3,
                    children: [
                      // 지그재그 오프셋용 고정 위젯. (내용은 탭별로 주입)
                      dashboard,
                      for (var i = 1; i < groups.length; i += 2)
                        cardBuilder(context, groups[i]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
