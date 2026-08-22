import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 단계 숫자를 담는 원의 지름.
const double _circleSize = 24;

/// 원과 원을 잇는 세로 선의 너비.
const double _connectorWidth = 2;

/// 따라찍기 진행 방식을 1·2·3 단계로 보여주는 스테퍼.
///
/// 각 단계는 '숫자 원 + 설명' 한 줄이고, 원끼리는 세로 선으로 이어진다.
/// 선이 끊기지 않도록 단계 사이 여백(s5)을 설명 아래쪽 패딩으로 주고, 선이
/// 그 구간까지 내려오게 한다. (Column 의 spacing 을 쓰면 그 틈에서 선이 끊긴다)
class GuideFlowSteps extends StatelessWidget {
  const GuideFlowSteps({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = [
      l10n.guideFlowStep1,
      l10n.guideFlowStep2,
      l10n.guideFlowStep3,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < steps.length; index++)
          _Step(
            number: index + 1,
            text: steps[index],
            isLast: index == steps.length - 1,
          ),
      ],
    );
  }
}

/// 단계 한 줄. 왼쪽에 숫자 원(+ 다음 단계로 잇는 선), 오른쪽에 설명.
class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text, required this.isLast});

  final int number;
  final String text;

  /// 마지막 단계. 아래로 이을 곳이 없어 선과 간격을 두지 않는다.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        // 왼쪽 열이 설명 높이만큼 늘어나야 선이 다음 원까지 닿는다.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              _StepCircle(number: number),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: _connectorWidth,
                    color: AppColors.borderStrong,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.s4),
          Expanded(
            child: Padding(
              // 다음 단계와의 간격. 세로 선이 이 구간까지 이어진다.
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.s5),
              // body 기본색은 textSecondary 라 단계 설명용으로 올려 잡는다.
              child: AppText.body(text, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

/// 단계 숫자를 뚫어 낸 파란 원.
///
/// 숫자를 색으로 칠하지 않고 원에서 도려내, 그 자리로 뒤 배경이 그대로 비친다.
/// [BlendMode.srcOut] 은 '자식이 그려지지 않은 곳에만 색을 칠하는' 합성이라,
/// 자식(숫자)은 색이 아니라 마스크로만 쓰인다. 그래서 숫자의 글자색은 결과에
/// 영향을 주지 않는다. 마지막으로 [ClipOval] 이 칠해진 사각형을 원으로 자른다.
class _StepCircle extends StatelessWidget {
  const _StepCircle({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(
          AppColors.accentDefault,
          BlendMode.srcOut,
        ),
        child: SizedBox(
          width: _circleSize,
          height: _circleSize,
          child: Center(child: AppText.label('$number')),
        ),
      ),
    );
  }
}
