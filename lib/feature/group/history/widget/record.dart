import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 모임 기록 요약 카드. (나의 따라찍기 · 모임 따라찍기)
class Record extends StatelessWidget {
  const Record({super.key, required this.myCount, required this.totalCount});

  /// 내가 참여한 따라찍기 수.
  final int myCount;

  /// 모임의 전체 따라찍기 수.
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: AppSpacing.s3,
        left: AppSpacing.s5,
        right: AppSpacing.s5,
        bottom: AppSpacing.s5,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSpacing.s3,
        children: [
          Expanded(
            child: _StatItem(
              value: '$myCount',
              label: l10n.recordMyCycleLabel,
            ),
          ),
          Expanded(
            child: _StatItem(
              value: '$totalCount',
              label: l10n.recordGroupCycleLabel,
            ),
          ),
        ],
      ),
    );
  }
}

/// 숫자 + 라벨로 구성된 단일 통계 항목. (가운데 정렬)
class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: AppSpacing.s1,
      children: [
        AppText.display(value),
        AppText.caption(label, color: AppColors.textTertiary),
      ],
    );
  }
}
