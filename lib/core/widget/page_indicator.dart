import 'package:flutter/widgets.dart';

import '../designsystem/foundation/app_spacing.dart';
import '../designsystem/theme/app_colors.dart';

/// 페이지 인디케이터. [count] 개의 점을 한 줄로 그리고 [currentIndex] 위치의
/// 점을 강조한다.
///
/// 모든 점은 같은 크기이며, 현재 점은 [AppColors.accentDefault], 나머지는
/// [AppColors.textTertiary] 다. [currentIndex] 가 바뀌면 색이 부드럽게 전환된다.
///
/// (온보딩·홈 등 여러 화면에서 공유한다. 단일 상태 점인 알림의 읽지 않음 표시
/// 등은 의미가 달라 별도로 둔다.)
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.currentIndex,
    this.count = 3,
    this.size = 8,
    this.spacing = AppSpacing.s2,
  });

  /// 현재 활성화된 페이지 인덱스 (0부터 시작).
  final int currentIndex;

  /// 전체 페이지 수.
  final int count;

  /// 점 하나의 지름. (예: 온보딩 8, 홈 6)
  final double size;

  /// 점 사이의 간격. (예: 온보딩 [AppSpacing.s2], 홈 [AppSpacing.s1])
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: spacing,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: size,
          height: size,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: isActive ? AppColors.accentDefault : AppColors.textTertiary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}
