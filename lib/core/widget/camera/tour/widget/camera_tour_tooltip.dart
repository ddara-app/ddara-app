import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_step.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_text.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 본문 오른쪽에 기본 여백(s4) 외에 더 두는 공간.
///
/// 본문이 왼쪽 정렬이라 오른쪽 끝은 줄마다 고르지 않다. 그쪽에만 여유를
/// 두어 글자가 상자에 붙어 보이지 않게 한다. 말풍선 폭은 본문 길이가
/// 정하므로, 이 값만큼 상자가 더 넓어진다.
///
/// 하단 버튼 줄에는 붙이지 않는다. 버튼은 오른쪽 끝에 맞춰 붙어야 해서
/// 기본 여백(s4)만 둔다.
const double _extraRightSpace = AppSpacing.s6;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        // 상자 여백은 s4 로 둘러놓고, 본문 오른쪽 여유는 본문에만 따로
        // 붙인다. 그래야 버튼 줄이 오른쪽 끝에 그대로 붙는다.
        // 하단은 0 — 버튼이 세로 44dp 터치 영역을 잡고 있어 글자 아래로
        // 이미 빈 공간이 생긴다.
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s4,
          AppSpacing.s4,
          AppSpacing.s4,
          AppSpacing.s0,
        ),
        decoration: BoxDecoration(
          color: AppColors.bgSurfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.borderDefault),
        ),
        // 하단 줄(Row)은 그대로 두면 주어진 폭을 다 채워 버린다. 문구 길이가
        // 폭을 정하도록, 자식들의 고유 폭 중 가장 넓은 값을 폭으로 삼는다.
        child: IntrinsicWidth(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.s3,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: _extraRightSpace),
                  child: AppText.body(
                    cameraTourBody(l10n, step.id),
                    color: AppColors.textPrimary,
                  ),
                ),
                _actions(l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 하단 줄. 왼쪽 진행 표시 · 오른쪽 이전/다음(마지막이면 시작하기).
  ///
  /// 문구가 길어지거나 시스템 글자가 커져도 말풍선 안쪽 폭을 넘지 않도록
  /// 양쪽을 [Flexible] 로 감싸고, 버튼이 둘까지 들어가는 오른쪽에 남는 폭을
  /// 더 준다. (반씩 나누면 '이전'이 눌리지 않을 만큼 좁아진다)
  Widget _actions(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: AppSpacing.s2,
      children: [
        Flexible(
          child: AppText.caption(
            l10n.cameraTourProgress(stepNumber, stepCount),
            color: AppColors.textSecondary,
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
                    onPressed: onPrevious,
                    child: AppText.body(
                      l10n.cameraTourPrevious,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              Flexible(
                child: _TooltipAction(
                  onPressed: onNext,
                  child: AppText.label(
                    isLastStep ? l10n.cameraTourDone : l10n.cameraTourNext,
                    color: AppColors.textAccent,
                  ),
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
/// 글자만 있는 버튼이지만 딤 위에서 한 번에 눌려야 하므로 **세로 44dp** 를
/// 터치 대상으로 확보한다. (`AppTextButton` 은 글자 영역만 눌리도록 만들어져
/// 있어 '이전' 같은 두 글자 라벨이 너무 작다)
///
/// 가로는 늘리지 않는다. 최소 너비를 주면 짧은 라벨 옆에 죽은 공간이 생겨,
/// 맨 오른쪽 글자가 말풍선 안쪽 끝에서 그만큼 떨어져 보인다. (왼쪽 진행 표시와
/// 어긋나 균형이 깨진다) 대신 좌우 여백을 조금 둬 터치 폭을 벌린다.
class _TooltipAction extends StatelessWidget {
  const _TooltipAction({required this.onPressed, required this.child});

  final VoidCallback onPressed;

  /// 버튼에 들어갈 글자. 버튼마다 스타일·색이 달라 위젯으로 받는다.
  final Widget child;

  /// 최소 터치 영역 세로 길이. (접근성 권장치)
  static const double _minTapHeight = 44;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
      minimumSize: const Size(0, _minTapHeight),
      alignment: Alignment.centerRight,
      onPressed: onPressed,
      child: child,
    );
  }
}
