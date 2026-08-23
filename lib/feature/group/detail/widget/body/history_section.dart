import 'package:ddara/core/analytics/app_analytics.dart';
import 'package:ddara/core/design_system/component/button/app_text_button.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/domain/model/group/history_cycles.dart';
import 'package:ddara/feature/group/detail/group_page_actions.dart';
import 'package:ddara/feature/group/detail/widget/body/history_photos.dart';
import 'package:ddara/feature/group/detail/widget/group_section.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// '지난 따라찍기' 섹션. 사진 카드 목록과 전체 보기 버튼을 보여준다.
class HistorySection extends StatelessWidget {
  const HistorySection({
    super.key,
    required this.cycles,
    required this.blockedUserIds,
    required this.groupId,
    required this.actions,
  });

  final List<HistoryCycle> cycles;

  /// 내가 차단한 유저 id 집합. (차단한 스타터의 썸네일은 자리표시로 가린다)
  final Set<int> blockedUserIds;

  /// 분석 이벤트에 남길 모임 식별자.
  final int groupId;

  final GroupPageActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GroupSection(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText.headlineLarge(l10n.groupHistoryTitle),
          AppTextButton(
            label: l10n.groupHistoryMore,
            // 지난 따라찍기 전체 목록으로 이동. (복귀 시 상세 갱신)
            onPressed: actions.pushHistoryList,
          ),
        ],
      ),
      // 히스토리가 있으면 사진 카드들을, 없으면 같은 높이의 빈 상태 안내를 보여준다.
      // (카드 높이 + HistoryPhotos 의 상하 s5 패딩)
      body: cycles.isEmpty
          ? SizedBox(
              height: HistoryPhotos.cardHeight + AppSpacing.s5 * 2,
              child: Center(child: AppText.body(l10n.groupHistoryEmpty)),
            )
          : HistoryPhotos(
              cycles: cycles,
              // 차단한 스타터의 썸네일은 차단 자리표시로 가린다.
              blockedUserIds: blockedUserIds,
              // 카드 탭 → 해당 사이클의 사진 갤러리로 이동. (복귀 시 상세 갱신)
              onCycleTap: (cycleId) {
                AppAnalytics.track(
                  'group_history_cycle_clicked',
                  properties: {'group_id': groupId, 'cycle_id': cycleId},
                );
                actions.pushGallery(cycleId);
              },
            ),
    );
  }
}
