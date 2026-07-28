import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 카메라 하단 컨트롤 영역. 촬영 버튼을 둔다.
/// (모드 토글은 프리뷰 바로 아래에 붙으므로 [CameraModeToggle] 로 분리했다)
class CameraBottom extends StatelessWidget {
  const CameraBottom({super.key, this.onCapture});

  /// 촬영 버튼을 눌렀을 때. null 이면 아무 동작도 하지 않는다.
  final VoidCallback? onCapture;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.s5,
        right: AppSpacing.s5,
        // 모드 토글과 촬영 버튼 사이 간격.
        top: AppSpacing.s4,
        bottom: AppSpacing.s8,
      ),
      // 간격이 자리마다 달라 Column spacing 대신 각자 여백을 준다.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_CaptureButton(onPressed: onCapture ?? () {})],
          ),
          const SizedBox(height: AppSpacing.s4),
        ],
      ),
    );
  }
}

/// iOS 카메라 스타일 촬영 버튼. 흰색 링 안에 채워진 흰 원.
class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.onPressed});

  final VoidCallback onPressed;

  static const double _size = 72;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Container(
        width: _size,
        height: _size,
        padding: const EdgeInsets.all(AppSpacing.s1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.textPrimary, width: 4),
        ),
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
