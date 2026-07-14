import 'package:flutter/widgets.dart';

import '../../theme/app_colors.dart';

/// 1px 두께의 가로 구분선.
///
/// 색은 디자인 시스템의 [AppColors.borderDefault]. 부모가 가로 폭을 정해 주는
/// 곳(예: [Column] 안)에 두면 그 폭을 꽉 채운다.
class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.borderDefault);
  }
}
