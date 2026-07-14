import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/history_cycles.dart';
import 'package:ddara/feature/group/history/widget/history_list_item.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 년·월 단위 섹션. ('2026년 6월' 제목 + 해당 월의 아이템 목록)
class HistoryMonthSection extends StatelessWidget {
  const HistoryMonthSection({
    super.key,
    required this.year,
    required this.month,
    required this.cycles,
    this.showTitle = true,
    this.showYear = true,
  });

  /// 섹션의 년·월.
  final int year;
  final int month;

  /// 이 년·월에 포함된 사이클들.
  final List<HistoryCycle> cycles;

  /// 제목 표시 여부. (년·월 필터가 걸린 경우 제목 없이 목록만 표시)
  final bool showTitle;

  /// 제목에 연도 표시 여부. (전체보기에서 올해 섹션은 월만 표시)
  final bool showYear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s4,
      children: [
        if (showTitle)
          AppText.headlineLarge(
            showYear
                ? l10n.groupHistoryFilterYearMonth(year, month)
                : l10n.historyMonthLabel(month),
          ),
        // 아이템 간 간격은 s6. (제목과 목록 사이는 s4 유지)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s6,
          children: [
            for (final cycle in cycles) HistoryListItem(cycle: cycle),
          ],
        ),
      ],
    );
  }
}
