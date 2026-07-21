import 'package:flutter/widgets.dart';

import '../../theme/app_colors.dart';

/// 1px 두께의 가로 구분선.
///
/// 부모가 가로 폭을 정해 주는 곳(예: [Column] 안)에 두면 그 폭을 꽉 채운다.
class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.color = AppColors.borderDefault});

  /// 선 색. 기본은 [AppColors.borderDefault] 이고, 더 약한 경계가 필요하면
  /// [AppColors.borderSubtle] 을 넘긴다.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: color);
  }
}
