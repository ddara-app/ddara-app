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

/// 참여한 모임이 하나 이상일 때 보여주는 모임 목록 화면.
///
/// 화면을 세로로 반 나눠 좌/우 두 열에 카드를 번갈아(지그재그) 배치한다.
/// 우측 열 맨 위에는 카드보다 작은 고정 위젯([HomeDashboard])이 들어가, 그 높이
/// 차이만큼 우측 카드들이 위로 덜 내려오면서 자연스러운 지그재그가 만들어진다.
///
/// 카드 높이가 균일하므로 Masonry 패키지 없이 `Row` + `Column` 2개로 충분하다.
class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key, required this.groups});

  /// 표시할 모임 목록. (상위 HomePage 에서 조회 결과를 주입)
  final List<Group> groups;

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final groups = widget.groups;
    return Stack(
      // 콘텐츠가 짧아도(빈 목록 등) 화면 전체 높이를 채워 FAB 가 항상 바닥에 붙도록.
      fit: StackFit.expand,
      children: [
        LayoutBuilder(
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
                // 위아래 s6, 좌우 s4. (하단은 FAB 에 가리지 않도록 버튼 높이 +
                // Safe Area 인셋만큼 더 여유)
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.s4,
                  AppSpacing.s6,
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
                            MeetingCard(
                              group: groups[i],
                              onTap: () =>
                                  _openGroup(context, groups[i].groupId),
                            ),
                        ],
                      ),
                    ),
                    // 우측 열: 맨 위 고정 위젯 + 홀수 인덱스 카드 (1, 3, 5 …)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: AppSpacing.s3,
                        children: [
                          // 참여 중인 모임 개수를 주입. (지그재그 오프셋용 고정 위젯)
                          HomeDashboard(count: groups.length),
                          for (var i = 1; i < groups.length; i += 2)
                            MeetingCard(
                              group: groups[i],
                              onTap: () =>
                                  _openGroup(context, groups[i].groupId),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // 백드롭 + FAB + 펼침 모션을 모두 내장한 완결형 위젯.
        // Stack 의 맨 위(마지막 자식)에 얹어 콘텐츠 위를 덮도록 한다.
        SpeedDialFab(
          actions: [
            SpeedDialAction(
              label: l10n.groupCreate,
              filled: true,
              onTap: () => context.push(RoutePath.groupCreate),
            ),
            SpeedDialAction(
              label: l10n.groupEnter,
              onTap: () => context.push(RoutePath.inviteCodeInput),
            ),
          ],
        ),
      ],
    );
  }

  void _openGroup(BuildContext context, int groupId) {
    context.push(RoutePath.group, extra: groupId);
  }
}
