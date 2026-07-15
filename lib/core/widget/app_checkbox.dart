import 'package:ddara/core/designsystem/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';

import '../designsystem/foundation/app_radius.dart';

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
            ? Icon(
                CupertinoIcons.checkmark,
                size: size * 0.62,
                color: AppColors.textOnAccent,
              )
            : null,
      ),
    );
  }
}
