import 'package:ddara/core/design_system/foundation/app_color_primitives.dart';
import 'package:ddara/core/design_system/theme/app_colors.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_step.dart';
import 'package:flutter/widgets.dart';

/// 구멍 테두리 두께.
const double _borderWidth = 2;

/// 화면 전체를 덮는 딤에 타겟 모양의 구멍을 뚫어 그린다.
///
/// 구멍이 없으면([hole] 이 null) 전체를 딤으로 덮는다.
class SpotlightPainter extends CustomPainter {
  const SpotlightPainter({
    required this.hole,
    required this.radius,
    required this.dim,
    required this.shape,
  });

  /// 하이라이트할 영역. null 이면 전체 딤.
  final Rect? hole;

  /// [CameraTourShape.rrect] 구멍의 모서리 반경.
  final double radius;

  /// 딤 농도. 0.0(투명) ~ 1.0(불투명).
  final double dim;

  final CameraTourShape shape;

  @override
  void paint(Canvas canvas, Size size) {
    final dimPaint = Paint()
      ..color = AppColorPrimitives.black.withValues(alpha: dim);
    final full = Path()..addRect(Offset.zero & size);

    final hole = this.hole;
    if (hole == null) {
      canvas.drawPath(full, dimPaint);
      return;
    }

    final holePath = switch (shape) {
      CameraTourShape.circle =>
        Path()..addOval(
          Rect.fromCircle(center: hole.center, radius: hole.longestSide / 2),
        ),
      CameraTourShape.rrect =>
        Path()
          ..addRRect(RRect.fromRectAndRadius(hole, Radius.circular(radius))),
    };

    canvas.drawPath(
      Path.combine(PathOperation.difference, full, holePath),
      dimPaint,
    );

    // 딤이 옅은 스텝에서도 구멍 경계가 읽히도록 테두리를 얹는다.
    canvas.drawPath(
      holePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _borderWidth
        ..color = AppColors.accentDefault,
    );
  }

  @override
  bool shouldRepaint(SpotlightPainter oldDelegate) =>
      oldDelegate.hole != hole ||
      oldDelegate.dim != dim ||
      oldDelegate.radius != radius ||
      oldDelegate.shape != shape;
}
