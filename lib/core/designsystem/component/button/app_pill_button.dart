import 'package:ddara/core/designsystem/theme/app_colors.dart';
import 'package:ddara/core/designsystem/theme/app_typography.dart';
import 'package:flutter/cupertino.dart';

import '../../foundation/app_spacing.dart';

/// [AppPillButton] 시각 변형.
enum AppPillButtonVariant {
  /// 강조색으로 채워진 기본 버튼.
  primary,

  /// 배경은 투명하고 테두리·글자색만 강조색인 보조 버튼.
  outline,
}

/// Pill(완전 둥근) 형태 버튼.
///
/// 높이 56 고정, 내용에 맞춰 가로폭이 정해지며 최소 너비는 120 이다.
/// 기본 생성자는 강조색으로 채워진 [AppPillButtonVariant.primary],
/// [AppPillButton.outline] 은 테두리만 강조한 보조 버튼이다. 두 변형은 동일 치수다.
/// [onPressed] 가 null 이면 비활성 상태로 표시된다.
class AppPillButton extends StatelessWidget {
  const AppPillButton({
    super.key,
    required this.label,
    required this.onPressed,
  }) : variant = AppPillButtonVariant.primary;

  const AppPillButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
  }) : variant = AppPillButtonVariant.outline;

  final String label;
  final VoidCallback? onPressed;
  final AppPillButtonVariant variant;

  static const double _height = 56;
  static const double _minWidth = 120;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final isPrimary = variant == AppPillButtonVariant.primary;

    // 활성/비활성에 따른 강조색. (테두리·outline 글자에 사용)
    final accent = isEnabled ? AppColors.accentDefault : AppColors.textDisabled;

    // primary: 채운 배경 + 대비 글자, outline: 투명 배경 + 테두리/글자 강조색.
    final Color? background = isPrimary
        ? (isEnabled ? AppColors.accentDefault : AppColors.bgSurfaceAlt)
        : null;
    final Color contentColor = isPrimary
        ? (isEnabled ? AppColors.textOnAccent : AppColors.textDisabled)
        : accent;
    final BorderSide side = isPrimary
        ? BorderSide.none
        : BorderSide(color: accent);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: _minWidth,
        minHeight: _height,
        maxHeight: _height,
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s5),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: background,
            shape: StadiumBorder(side: side),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.title.copyWith(color: contentColor),
          ),
        ),
      ),
    );
  }
}
