import 'package:ddara/core/design_system/component/button/app_text_button.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 년·월 선택 카드.
///
/// 헤더(‹ 연도 ›)로 연도를 이동하고, 아래 4×3 그리드에서 월을 선택한다.
/// 선택 상태는 호출부가 관리한다.
class YearMonthPicker extends StatelessWidget {
  const YearMonthPicker({
    super.key,
    required this.year,
    required this.selectedMonth,
    required this.onPrevYear,
    required this.onNextYear,
    required this.onMonthSelected,
    required this.onReset,
  });

  /// 표시 중인 연도.
  final int year;

  /// 표시 중인 연도에서 선택된 월(1~12). 없으면 null.
  final int? selectedMonth;

  /// 이전/다음 연도 이동 콜백.
  final VoidCallback onPrevYear;
  final VoidCallback onNextYear;

  /// 월 셀 탭 콜백. (1~12)
  final ValueChanged<int> onMonthSelected;

  /// 초기화(전체보기로 되돌리기) 콜백.
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s4),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.borderDefault),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.s3,
        children: [
          _header(l10n),
          // 헤더와 월 그리드 사이 구분선.
          Container(height: 1, color: AppColors.borderDefault),
          _monthGrid(l10n),
          // 우측 하단: 선택을 전체보기로 되돌리는 초기화 버튼.
          Align(
            alignment: Alignment.centerRight,
            child: AppTextButton(
              label: l10n.historyFilterReset,
              onPressed: onReset,
            ),
          ),
        ],
      ),
    );
  }

  /// 헤더. (‹ 2026년 ›)
  Widget _header(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _arrowButton(AppIcons.chevronLeft, onPrevYear),
          AppText.headlineMedium(l10n.historyYearLabel(year)),
          _arrowButton(AppIcons.chevronRight, onNextYear),
        ],
      ),
    );
  }

  /// 연도 이동 화살표 버튼. (아이콘 24)
  Widget _arrowButton(AppIconData icon, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AppIcon(icon, size: 24, color: AppColors.textPrimary),
    );
  }

  /// 4열 × 3행 월 그리드.
  Widget _monthGrid(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s2,
      children: [
        for (var row = 0; row < 3; row++)
          Row(
            spacing: AppSpacing.s2,
            children: [
              for (var month = row * 4 + 1; month <= row * 4 + 4; month++)
                Expanded(child: _monthCell(l10n, month)),
            ],
          ),
      ],
    );
  }

  /// 단일 월 셀. 선택된 월은 accent 배경으로 강조한다.
  Widget _monthCell(AppLocalizations l10n, int month) {
    final selected = month == selectedMonth;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onMonthSelected(month),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: selected ? AppColors.accentDefault : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
        child: AppText.label(
          l10n.historyMonthLabel(month),
          color: selected ? AppColors.textOnAccent : AppColors.textSecondary,
        ),
      ),
    );
  }
}
