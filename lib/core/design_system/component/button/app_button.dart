import 'package:ddara/core/design_system/theme/app_colors.dart';
import 'package:ddara/core/design_system/theme/app_typography.dart';
import 'package:flutter/cupertino.dart';

import '../../foundation/app_radius.dart';

/// [AppButton] 시각 변형.
enum AppButtonVariant {
  /// 강조색으로 채워진 기본 버튼.
  primary,

  /// 배경은 투명하고 테두리·글자색만 강조색인 보조 버튼.
  outline,
}

/// 풀폭 기본 버튼.
///
/// 기본 생성자는 강조색으로 채워진 [AppButtonVariant.primary],
/// [AppButton.outline] 은 테두리만 강조한 보조 버튼이다. 두 변형은 동일 치수다.
/// [onPressed] 가 null 이면 비활성 상태로 표시된다.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.foregroundColor,
  }) : variant = AppButtonVariant.primary,
       backgroundColor = null;

  const AppButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
  }) : variant = AppButtonVariant.outline,
       color = null,
       foregroundColor = null;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  /// primary 변형의 채움색 override. null 이면 기본 강조색(accentDefault).
  final Color? color;

  /// primary 변형의 글자색 override. null 이면 기본값(textOnAccent).
  final Color? foregroundColor;

  /// outline 변형의 배경색. null 이면 투명.
  ///
  /// 백드롭 위에 띄우는 경우처럼 뒤 콘텐츠가 비치면 안 될 때
  /// 앱 배경색([AppColors.bgBase])을 지정한다.
  final Color? backgroundColor;

  /// 두 변형 공통 상하 여백. (primary 는 CupertinoButton 기본값과 같다)
  static const double _verticalPadding = 16;

  /// outline 테두리 두께.
  static const double _borderWidth = 1;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return SizedBox(
      width: double.infinity,
      child: switch (variant) {
        AppButtonVariant.primary => CupertinoButton(
          color: color ?? AppColors.accentDefault,
          // 비활성 시 배경색.
          disabledColor: AppColors.bgSurfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.md),
          onPressed: onPressed,
          child: Text(
            label,
            style: AppTypography.title.copyWith(
              color: isEnabled
                  ? (foregroundColor ?? AppColors.textOnAccent)
                  : AppColors.textDisabled,
            ),
          ),
        ),
        // 테두리는 DecoratedBox 로 그린다. Container(alignment) 를 쓰면
        // 느슨한 제약에서 최대 크기까지 늘어나 primary 와 높이가 달라진다.
        AppButtonVariant.outline => DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              width: _borderWidth,
              color: isEnabled
                  ? AppColors.accentDefault
                  : AppColors.textDisabled,
            ),
          ),
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
            onPressed: onPressed,
            child: Text(
              label,
              style: AppTypography.title.copyWith(
                color: isEnabled
                    ? AppColors.accentDefault
                    : AppColors.textDisabled,
              ),
            ),
          ),
        ),
      },
    );
  }
}
