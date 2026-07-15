import 'package:flutter/cupertino.dart';

import '../../../core/designsystem/component/surface/app_surface.dart';
import '../../../core/designsystem/component/text/app_text.dart';
import '../../../core/designsystem/theme/app_colors.dart';

/// 개별 권한 항목 카드. (아이콘 · 제목 · 설명)
class PermissionItem extends StatelessWidget {
  const PermissionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
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
            child: Icon(icon, size: 24, color: AppColors.textPrimary),
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
