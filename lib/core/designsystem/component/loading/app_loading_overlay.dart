import 'package:ddara/core/designsystem/foundation/app_radius.dart';
import 'package:ddara/core/designsystem/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';

/// 처리 중 화면 전체를 덮는 로딩 오버레이.
///
/// 반투명 스크림([AppColors.overlayScrim])으로 하위 입력을 차단하고
/// 중앙에 [CupertinoActivityIndicator]를 표시한다.
/// `Stack` 안에서 `if (isLoading) const AppLoadingOverlay()` 형태로 사용한다.
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: ColoredBox(
        color: AppColors.overlayScrim,
        child: Center(
          child: CupertinoActivityIndicator(radius: AppRadius.md),
        ),
      ),
    );
  }
}
