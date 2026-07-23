import 'package:ddara/core/design_system/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';

import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/foundation/app_icons.dart';
import 'package:ddara/core/design_system/foundation/app_radius.dart';

/// 원형 체크박스. 탭하면 [onChanged] 로 토글된 값을 전달한다.
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 20,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: value ? AppColors.accentDefault : null,
          shape: RoundedRectangleBorder(
            side: value
                ? BorderSide.none
                : const BorderSide(width: 1.5, color: AppColors.borderStrong),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
        child: value
            ? AppIcon(
                AppIcons.checkmark,
                size: size * 0.62,
                color: AppColors.textOnAccent,
              )
            : null,
      ),
    );
  }
}
