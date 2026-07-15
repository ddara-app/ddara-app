import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

/// 카메라 프리뷰 영역.
/// 컨트롤러가 아직 준비되지 않았으면 로딩 인디케이터를 보여준다.
class Preview extends StatelessWidget {
  const Preview({
    super.key,
    required this.controller,
    required this.initFuture,
  });

  /// 상위에서 관리하는 카메라 컨트롤러. 초기화 전이면 null.
  final CameraController? controller;

  /// 카메라 초기화 Future. 완료 여부에 따라 프리뷰/로딩을 전환한다.
  final Future<void>? initFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initFuture,
      builder: (context, snapshot) {
        final c = controller;
        // key 가 바뀌면 AnimatedSwitcher 가 페이드로 전환한다.
        // (로딩 ↔ 프리뷰, 카메라 전환 시 카메라별 key 로 구분)
        final Widget child = (c == null || !c.value.isInitialized)
            ? const Center(
                key: ValueKey('camera-loading'),
                child: CupertinoActivityIndicator(),
              )
            : _FittedCameraPreview(
                controller: c,
                key: ValueKey(c.description.name),
              );

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: _flipTransition,
          child: child,
        );
      },
    );
  }

  /// Y축 3D 회전(flip) + 페이드 전환.
  /// 들어오는 child 는 90°→0°, 나가는 child 는 0°→90° 로 회전한다.
  static Widget _flipTransition(Widget child, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final value = animation.value;
        final angle = (1 - value) * (math.pi / 2);
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001) // 원근감(perspective)
          ..rotateY(angle);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: Opacity(opacity: value, child: child),
        );
      },
    );
  }
}

/// 비율을 유지한 채 영역을 가득 채우는(cover) 카메라 프리뷰.
/// 좌우 여백 없이 채우되, 늘리지 않고 넘치는 부분만 잘라낸다.
class _FittedCameraPreview extends StatelessWidget {
  const _FittedCameraPreview({super.key, required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final size = controller.value.previewSize;
    if (size == null) return CameraPreview(controller);

    return ClipRect(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            // 세로 모드 기준으로 프리뷰의 가로/세로를 뒤집어 매핑한다.
            width: size.height,
            height: size.width,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }
}
