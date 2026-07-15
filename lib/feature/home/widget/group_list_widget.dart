import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 홈 화면 우측 상단에 고정되는 요약 위젯.
///
/// 모임 리스트의 지그재그 오프셋을 위해 모임 카드보다 낮은 높이를 갖는다.
/// 현재 참여 중인 모임 개수([count]/[maxCount])를 보여주고, 하단 점은
/// 페이지 인디케이터 자리다.
class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key, required this.count, this.maxCount = 20});

  /// 현재 참여 중인 모임 개수. (외부 주입)
  final int count;

  /// 참여 가능한 최대 모임 개수.
  final int maxCount;

  // 하단 페이지 인디케이터 점 개수. (TODO: 기능 추가 시 아래 Row 와 함께 주석 해제)
  // static const int _dotCount = 4;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      // 높이는 카드보다 낮게 고정해 지그재그 오프셋을 만든다. (폭은 열에 맞춰 stretch)
      height: 142,
      padding: const EdgeInsets.all(AppSpacing.s4),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.50, 0),
          end: Alignment(0.50, 1.00),
          colors: [AppColors.bgSurface, AppColorPrimitives.sky900],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title(
                  l10n.groupCountLabel,
                  color: AppColors.textAccent,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s1,
                  children: [
                    AppText.display(l10n.groupCountValue(count, maxCount)),
                    AppText.caption(l10n.groupCountCaption),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s1),
          // 하단 페이지 인디케이터. (첫 점 활성)
          // todo 기능 추가되면 주석 해제
          // PageIndicator(currentIndex: 0, count: _dotCount, size: 6, spacing: AppSpacing.s1),
        ],
      ),
    );
  }
}
