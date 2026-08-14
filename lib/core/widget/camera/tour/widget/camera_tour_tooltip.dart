import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_step.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_text.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 투어 스텝 안내 말풍선.
///
/// 문구는 스텝 [CameraTourStepId] 로 l10n 에서 조회한다. 세로 길이를 고정하지
/// 않고, 주어진 높이를 넘치면 안에서 스크롤한다. (긴 문구·큰 시스템 글자 대비)
class CameraTourTooltip extends StatelessWidget {
  const CameraTourTooltip({
    super.key,
    required this.step,
    required this.stepNumber,
    required this.stepCount,
    required this.isLastStep,
    required this.canGoBack,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
  });

  final CameraTourStep step;

  /// 진행 표시용 현재 순번. (1부터)
  final int stepNumber;
  final int stepCount;
  final bool isLastStep;

  /// 되돌아갈 스텝이 있는지. false 면 '이전'을 감춘다.
  final bool canGoBack;

  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s5),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s3,
            children: [
              AppText.caption(
                l10n.cameraTourProgress(stepNumber, stepCount),
                color: AppColors.textTertiary,
              ),
              AppText.title(cameraTourTitle(l10n, step.id)),
              AppText.body(
                cameraTourBody(l10n, step.id),
                color: AppColors.textSecondary,
              ),
              _actions(l10n),
            ],
          ),
        ),
      ),
    );
  }

  /// 하단 액션 줄. 왼쪽 건너뛰기 · 오른쪽 이전/다음(또는 안내).
  /// 문구가 길어져도 넘치지 않도록 각 항목을 [Flexible] 로 감싼다.
  Widget _actions(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: AppSpacing.s2,
      children: [
        // 오른쪽에는 버튼이 둘까지 들어가므로 남는 폭을 1:2 로 나눈다.
        // (반씩 나누면 '이전'이 눌리지 않을 만큼 좁아진다)
        Flexible(
          child: _TooltipAction(
            label: l10n.cameraTourSkip,
            color: AppColors.textTertiary,
            alignment: Alignment.centerLeft,
            onPressed: onSkip,
          ),
        ),
        Flexible(
          flex: 2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: AppSpacing.s2,
            children: [
              if (canGoBack)
                Flexible(
                  child: _TooltipAction(
                    label: l10n.cameraTourPrevious,
                    color: AppColors.textSecondary,
                    onPressed: onPrevious,
                  ),
                ),
              Flexible(
                child: _TooltipAction(
                  label: isLastStep ? l10n.cameraTourDone : l10n.cameraTourNext,
                  color: AppColors.accentDefault,
                  onPressed: onNext,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 툴팁 하단 액션 버튼.
///
/// 글자만 있는 버튼이지만 딤 위에서 한 번에 눌려야 하므로, 글자 영역이 아니라
/// **최소 44dp 정사각**을 터치 대상으로 잡는다. (`AppTextButton` 은 여백 없이
/// 글자 영역만 눌리도록 만들어져 있어 '이전' 같은 두 글자 라벨이 너무 작다)
class _TooltipAction extends StatelessWidget {
  const _TooltipAction({
    required this.label,
    required this.color,
    required this.onPressed,
    this.alignment = Alignment.centerRight,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  /// 확보한 터치 영역 안에서 글자가 붙을 자리.
  final Alignment alignment;

  /// 최소 터치 영역 한 변. (접근성 권장치)
  static const double _minTapSize = 44;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
      minimumSize: const Size(_minTapSize, _minTapSize),
      alignment: alignment,
      onPressed: onPressed,
      child: AppText.body(label, color: color),
    );
  }
}
