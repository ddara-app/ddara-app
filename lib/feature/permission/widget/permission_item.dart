import 'package:flutter/cupertino.dart';

import '../../../core/design_system/component/surface/app_surface.dart';
import '../../../core/design_system/component/text/app_text.dart';
import '../../../core/design_system/theme/app_colors.dart';

/// 개별 권한 항목 카드. (아이콘 · 제목 · 설명)
class PermissionItem extends StatelessWidget {
  const PermissionItem({
    super.key,
    this.icon,
    this.leading,
    required this.title,
    required this.description,
    required this.onTap,
  }) : assert(icon != null || leading != null, 'icon 또는 leading 중 하나는 필요');

  /// 좌측 아이콘. [leading] 이 없을 때 [Icon] 으로 그린다.
  final IconData? icon;

  /// 좌측 아이콘을 직접 지정할 때. (예: SVG) 있으면 [icon] 대신 이걸 그린다.
  final Widget? leading;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      // 누르는 동안 살짝 밝게.
      pressedColor: AppColors.bgSurfaceAlt,
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12,
        children: [
          // 좌측 아이콘 (임시 — 추후 권한별 아이콘으로 교체)
          Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child:
                leading ?? Icon(icon, size: 24, color: AppColors.textPrimary),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                AppText.label(title, color: AppColors.textPrimary),
                AppText.caption(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
