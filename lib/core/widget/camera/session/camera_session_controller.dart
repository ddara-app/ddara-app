import 'dart:async';

import 'package:camera/camera.dart';
import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/core/widget/camera/util/image_mirror.dart';
import 'package:flutter/foundation.dart';

/// 기기 카메라 세션. 권한 · 컨트롤러 수명 · 촬영 · 플래시 · 전/후면 전환 · 줌만 맡는다.
///
/// 가이드 미니뷰 · 원본사진 투명도 · 투어 같은 화면 기능은 알지 못한다.
/// 화면은 이 컨트롤러를 구독해 상태를 그리고, 조작은 메서드로만 요청한다.
class CameraSessionController extends ChangeNotifier {
  CameraSessionController({required this.permission});

  /// 카메라 권한 확인·요청 창구.
  final PermissionService permission;

  CameraController? _controller;

  /// 카메라 권한이 거부된 상태. true 면 화면이 안내를 보여준다.
  bool _permissionDenied = false;

  /// 촬영 후처리(전면 반전 등)가 진행 중인 상태.
  /// 짧지만 즉시 끝나지는 않아, 그동안 촬영 버튼을 막고 로딩을 덮는다.
  bool _capturing = false;

  bool _flashOn = false;

  List<CameraDescription> _cameras = const [];
  int _cameraIndex = 0;

  // 핀치 줌 상태. min/max 는 카메라를 열 때 조회한다. (미지원 시 1.0 → 줌 없음)
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _currentZoom = 1.0;

  // 핀치 시작 시점의 줌 배율. (제스처 도중 기준값)
  double _baseZoom = 1.0;

  bool _disposed = false;

  /// 프리뷰에 넘길 카메라 컨트롤러. 준비 전이거나 전환 중이면 null.
  CameraController? get controller => _controller;

  /// 프리뷰를 그릴 수 있는 상태인지.
  bool get isReady => _controller?.value.isInitialized ?? false;

  bool get permissionDenied => _permissionDenied;

  bool get isCapturing => _capturing;

  bool get flashOn => _flashOn;

  /// 권한을 확인하고 카메라를 연다.
  ///
  /// 권한이 없으면 이 시점에 '카메라' 권한만 요청한다. (미결정 상태면 OS
  /// 프롬프트가 뜨고, 이미 영구 거부면 프롬프트 없이 거부로 돌아와
  /// [permissionDenied] 로 처리된다)
  Future<void> initialize() async {
    var granted = await permission.isCameraGranted();
    if (!granted) {
      final result = await permission.requestCamera();
      granted = result == PermissionResult.granted;
    }
    if (_disposed) return;

    if (!granted) {
      _setPermissionDenied(true);
      return;
    }
    _setPermissionDenied(false);

    _cameras = await availableCameras();
    if (_disposed || _cameras.isEmpty) return;

    // 후면 카메라를 우선 선택한다.
    final backIndex = _cameras.indexWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
    );
    _cameraIndex = backIndex >= 0 ? backIndex : 0;
    await _openCamera(_cameras[_cameraIndex]);
  }

  /// 앱이 다시 앞으로 나왔을 때 호출한다.
  /// 권한이 거부된 상태였다면(설정에서 켜고 돌아온 경우) 다시 시도한다.
  Future<void> resume() async {
    if (!_permissionDenied) return;
    await initialize();
  }

  /// 주어진 카메라로 컨트롤러를 새로 만들어 초기화한다.
  Future<void> _openCamera(CameraDescription description) async {
    final controller = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await controller.initialize();
    if (_disposed) {
      await controller.dispose();
      return;
    }

    // 기본 플래시 모드가 auto 라서 어두운 환경에서 촬영 시 자동 발광한다.
    // 토치는 사용자가 직접 토글하므로, 열 때 명시적으로 꺼 자동 발광을 막는다.
    try {
      await controller.setFlashMode(FlashMode.off);
    } catch (_) {
      // 일부 기기에서 미지원일 수 있으나, 무시해도 프리뷰에는 영향이 없다.
    }
    _flashOn = false;

    // 핀치 줌 범위 조회. (미지원/실패 시 1.0 고정 → 줌 동작 없음)
    try {
      _minZoom = await controller.getMinZoomLevel();
      _maxZoom = await controller.getMaxZoomLevel();
    } catch (_) {
      _minZoom = 1.0;
      _maxZoom = 1.0;
    }
    _currentZoom = _minZoom;

    if (_disposed) {
      await controller.dispose();
      return;
    }
    _controller = controller;
    _notify();
  }

  /// 현재 프리뷰를 촬영해 앱 임시 디렉토리에 저장하고, 그 경로를 돌려준다.
  /// (OS 갤러리에는 저장하지 않는다.) 촬영할 수 없거나 실패하면 null.
  ///
  /// 전면 카메라는 프리뷰가 거울상으로 보이므로, 저장본도 같은 좌우로 뒤집어
  /// 방금 본 화면과 확인 화면·업로드본이 어긋나지 않게 한다.
  Future<String?> capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return null;
    // 이미 촬영 중이면 중복 호출을 막는다.
    if (controller.value.isTakingPicture) return null;

    _capturing = true;
    _notify();
    try {
      final file = await controller.takePicture();
      // 촬영 후 화면이 넘어가도 토치가 켜진 채 남지 않도록 끈다.
      // (뒤로가기는 dispose 에서 처리되지만, 촬영 후 전환은 dispose 가 호출되지 않는다.)
      await _turnOffFlash(controller);

      final isFront =
          controller.description.lensDirection == CameraLensDirection.front;
      return isFront ? await mirrorImageFile(file.path) : file.path;
    } catch (_) {
      // 촬영 실패는 무시한다. (필요 시 사용자 안내 추가)
      return null;
    } finally {
      // 촬영이 성공하면 보통 화면이 넘어가지만, 같은 화면에 머무는 호출부도
      // 있으므로(가이드 재촬영 등) 처리 상태는 항상 되돌린다.
      _capturing = false;
      _notify();
    }
  }

  /// 토치를 켜고 끈다. 바뀐 뒤의 켜짐 여부를 돌려준다.
  /// (조작할 수 없는 상태면 현재 값을 그대로 돌려준다)
  Future<bool> toggleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return _flashOn;

    final next = !_flashOn;
    await controller.setFlashMode(next ? FlashMode.torch : FlashMode.off);
    if (_disposed) return _flashOn;

    _flashOn = next;
    _notify();
    return next;
  }

  /// 전/후면 카메라를 전환한다.
  ///
  /// 목록 순환이 아니라 렌즈 방향(전/후) 기준으로 반대편을 찾는다.
  /// iPhone 은 후면 렌즈가 여러 개(광각·초광각·망원)라 순환 방식으로는
  /// 후면 렌즈끼리만 바뀌고 전면이 바로 나오지 않는다.
  Future<void> switchCamera() async {
    // 카메라를 아직 못 열었거나 한 대뿐이면 전환할 곳이 없다.
    if (_cameras.length < 2) return;

    final targetDirection =
        _cameras[_cameraIndex].lensDirection == CameraLensDirection.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;
    final next = _cameras.indexWhere((c) => c.lensDirection == targetDirection);
    // 반대편 카메라가 없는 기기(전면 없음 등)면 전환하지 않는다.
    if (next < 0 || next == _cameraIndex) return;

    final previous = _controller;

    // 전환 중에는 프리뷰를 로딩 상태로 두고, 플래시는 초기화한다.
    _controller = null;
    _flashOn = false;
    _notify();
    await previous?.dispose();
    if (_disposed) return;

    _cameraIndex = next;
    await _openCamera(_cameras[next]);
  }

  /// 핀치 시작: 현재 줌 배율을 기준값으로 잡는다.
  void beginZoom() => _baseZoom = _currentZoom;

  /// 핀치 진행: 배율([scale])을 기준값에 곱해 줌 범위 안으로 적용한다.
  Future<void> zoomBy(double scale) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    final zoom = (_baseZoom * scale).clamp(_minZoom, _maxZoom).toDouble();
    if (zoom == _currentZoom) return;

    _currentZoom = zoom;
    await controller.setZoomLevel(zoom);
  }

  void _setPermissionDenied(bool denied) {
    if (_permissionDenied == denied) return;
    _permissionDenied = denied;
    _notify();
  }

  /// 켜져 있던 토치를 끈다. 미지원·해제 직전이라 실패해도 무시한다.
  Future<void> _turnOffFlash(CameraController controller) async {
    if (!_flashOn) return;
    try {
      if (controller.value.isInitialized) {
        await controller.setFlashMode(FlashMode.off);
      }
    } catch (_) {
      // 끄지 못해도 촬영·해제 흐름을 막지 않는다.
    }
    _flashOn = false;
    _notify();
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    final controller = _controller;
    _controller = null;
    if (controller != null) {
      // 화면을 떠날 때 켜져 있던 플래시(토치)를 끄고 컨트롤러를 해제한다.
      unawaited(_turnOffFlashAndDispose(controller));
    }
    super.dispose();
  }

  Future<void> _turnOffFlashAndDispose(CameraController controller) async {
    try {
      if (_flashOn && controller.value.isInitialized) {
        await controller.setFlashMode(FlashMode.off);
      }
    } catch (_) {
      // 해제 직전이라 실패해도 dispose 로 정리되므로 무시한다.
    } finally {
      await controller.dispose();
    }
  }
}
