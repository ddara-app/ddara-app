import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 모임 기록 요약 카드. (따라찍기 수 · 함께한 사진 수)
class Record extends StatelessWidget {
  const Record({super.key, required this.ddaraCount, required this.photoCount});

  /// 따라찍기 수.
  final int ddaraCount;

  /// 함께한 사진 수.
  final int photoCount;

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
            child: _StatItem(value: '$ddaraCount', label: l10n.recordCycleLabel),
          ),
          Expanded(
            child: _StatItem(value: '$photoCount', label: l10n.recordPhotoLabel),
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
