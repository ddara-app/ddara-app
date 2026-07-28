import 'package:camera/camera.dart';
import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/camera/bottom/camera_bottom.dart';
import 'package:ddara/core/widget/camera/header/camera_header.dart';
import 'package:ddara/core/widget/camera/mode/camera_mode_toggle.dart';
import 'package:ddara/core/widget/camera/preview/corner_mini_view.dart';
import 'package:ddara/core/widget/camera/preview/ghost_guide_view.dart';
import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/core/permission/provider/permission_provider.dart';
import 'package:ddara/core/widget/camera/preview/preview.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 카메라 화면 본문. 상단(헤더) · 프리뷰 · 하단(컨트롤)으로 구성한다.
/// 카메라 컨트롤러는 여기서 보유하고 하위 위젯에 전달한다.
/// 헤더의 투명도/플래시 처리는 외부 콜백으로 위임한다.
class Camera extends ConsumerStatefulWidget {
  const Camera({
    super.key,
    this.showOpacity = false,
    this.showViewMode = false,
    this.guideImage,
    this.onOpacityChanged,
    this.onViewModeChanged,
    this.onFlashPressed,
    this.onCapture,
  });

  /// '원본사진 투명도' 영역 표시 여부.
  final bool showOpacity;

  /// 모드 토글('코너 미니뷰'/'고스트 확대') 영역 표시 여부.
  final bool showViewMode;

  /// 따라찍기 가이드(친구가 미리 찍은) 사진. null 이면 미니뷰를 표시하지 않는다.
  final ImageProvider? guideImage;

  /// 모드가 바뀌었을 때 선택된 모드를 전달한다. (선택)
  final ValueChanged<GuideViewMode>? onViewModeChanged;

  /// 투명도 탭이 바뀌었을 때. 선택된 라벨('0'/'20'/'40')을 전달한다. (선택)
  final ValueChanged<String>? onOpacityChanged;

  /// 플래시 토글 후 호출되는 알림 콜백. 현재 켜짐 여부를 전달한다. (선택)
  final ValueChanged<bool>? onFlashPressed;

  /// 촬영이 끝났을 때, 저장된 이미지 파일 경로를 전달한다. (선택)
  final ValueChanged<String>? onCapture;

  @override
  ConsumerState<Camera> createState() => _CameraState();
}

class _CameraState extends ConsumerState<Camera> with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initFuture;
  bool _flashOn = false;

  /// 카메라 권한이 거부된 상태. true 면 안내 화면을 보여준다.
  bool _permissionDenied = false;

  List<CameraDescription> _cameras = const [];
  int _cameraIndex = 0;
  GuideViewMode _guideMode = GuideViewMode.cornerMini;

  // 투명도 탭 기본 선택('40')과 맞춘다.
  double _guideOpacity = 0.4;

  // 핀치 줌 상태. min/max 는 카메라를 열 때 조회한다. (미지원 시 1.0 → 줌 없음)
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _currentZoom = 1.0;

  // 핀치 시작 시점의 줌 배율. (제스처 도중 기준값)
  double _baseZoom = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initFuture = _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 설정에서 권한을 켜고 돌아온 경우, 거부 상태였다면 다시 시도한다.
    if (state == AppLifecycleState.resumed && _permissionDenied) {
      _initFuture = _initCamera();
    }
  }

  Future<void> _initCamera() async {
    final permission = ref.read(permissionServiceProvider);

    // 권한을 확인하고, 없으면 이 시점에 '카메라' 권한만 요청한다.
    // (미결정 상태면 OS 프롬프트가 뜨고, 이미 영구 거부면 프롬프트 없이 거부로
    //  돌아와 아래 안내 화면으로 처리한다)
    var granted = await permission.isCameraGranted();
    if (!granted) {
      final result = await permission.requestCamera();
      granted = result == PermissionResult.granted;
    }
    if (!granted) {
      if (mounted) setState(() => _permissionDenied = true);
      return;
    }
    if (_permissionDenied && mounted) {
      setState(() => _permissionDenied = false);
    }

    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;

    // 후면 카메라를 우선 선택한다.
    final backIndex = _cameras.indexWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
    );
    _cameraIndex = backIndex >= 0 ? backIndex : 0;
    await _openCamera(_cameras[_cameraIndex]);
  }

  /// 주어진 카메라로 컨트롤러를 새로 만들어 초기화한다.
  Future<void> _openCamera(CameraDescription description) async {
    final controller = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await controller.initialize();
    if (!mounted) {
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

    // 핀치 줌 범위 조회. (미지원/실패 시 1.0 고정 → 줌 동작 없음)
    try {
      _minZoom = await controller.getMinZoomLevel();
      _maxZoom = await controller.getMaxZoomLevel();
    } catch (_) {
      _minZoom = 1.0;
      _maxZoom = 1.0;
    }
    _currentZoom = _minZoom;

    setState(() => _controller = controller);
  }

  /// 현재 프리뷰를 촬영해 앱 임시 디렉토리에 저장하고, 그 경로를 전달한다.
  /// (OS 갤러리에는 저장하지 않는다.)
  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    // 이미 촬영 중이면 중복 호출을 막는다.
    if (controller.value.isTakingPicture) return;

    try {
      final file = await controller.takePicture();
      // 촬영 후 화면이 넘어가도 토치가 켜진 채 남지 않도록 끈다.
      // (뒤로가기는 dispose 에서 처리되지만, 촬영 후 전환은 dispose 가 호출되지 않는다.)
      if (_flashOn) {
        await controller.setFlashMode(FlashMode.off);
        if (mounted) setState(() => _flashOn = false);
      }
      if (!mounted) return;
      widget.onCapture?.call(file.path);
    } catch (_) {
      // 촬영 실패는 무시한다. (필요 시 사용자 안내 추가)
    }
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    final next = !_flashOn;
    await controller.setFlashMode(next ? FlashMode.torch : FlashMode.off);
    if (!mounted) return;
    setState(() => _flashOn = next);
    widget.onFlashPressed?.call(next);
  }

  /// 전/후면 카메라를 전환한다.
  ///
  /// 목록 순환이 아니라 렌즈 방향(전/후) 기준으로 반대편을 찾는다.
  /// iPhone 은 후면 렌즈가 여러 개(광각·초광각·망원)라 순환 방식으로는
  /// 후면 렌즈끼리만 바뀌고 전면이 바로 나오지 않는다.
  Future<void> _switchCamera() async {
    final targetDirection =
        _cameras[_cameraIndex].lensDirection == CameraLensDirection.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;
    final next = _cameras.indexWhere((c) => c.lensDirection == targetDirection);
    // 반대편 카메라가 없는 기기(전면 없음 등)면 전환하지 않는다.
    if (next < 0 || next == _cameraIndex) return;

    final previous = _controller;

    // 전환 중에는 프리뷰를 로딩 상태로 두고, 플래시는 초기화한다.
    setState(() {
      _controller = null;
      _flashOn = false;
    });
    await previous?.dispose();

    _cameraIndex = next;
    await _openCamera(_cameras[next]);
  }

  /// 핀치 시작: 현재 줌 배율을 기준값으로 잡는다.
  void _onScaleStart(ScaleStartDetails details) {
    _baseZoom = _currentZoom;
  }

  /// 핀치 진행: 배율(scale)을 기준값에 곱해 줌 범위 안으로 적용한다.
  Future<void> _onScaleUpdate(ScaleUpdateDetails details) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    // 두 손가락 핀치가 아니면(단일 터치 이동 등) 무시한다.
    if (details.pointerCount < 2) return;

    final zoom = (_baseZoom * details.scale)
        .clamp(_minZoom, _maxZoom)
        .toDouble();
    if (zoom == _currentZoom) return;

    _currentZoom = zoom;
    await controller.setZoomLevel(zoom);
  }

  void _onViewModeChanged(GuideViewMode mode) {
    setState(() => _guideMode = mode);
    widget.onViewModeChanged?.call(mode);
  }

  void _onOpacityChanged(String label) {
    final percent = int.tryParse(label) ?? 0;
    setState(() => _guideOpacity = percent / 100);
    widget.onOpacityChanged?.call(label);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final controller = _controller;
    _controller = null;
    if (controller != null) {
      // 화면을 떠날 때 켜져 있던 플래시(토치)를 끄고 컨트롤러를 해제한다.
      _turnOffFlashAndDispose(controller);
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

  @override
  Widget build(BuildContext context) {
    // 권한이 거부된 경우: 카메라 대신 안내 + 설정 이동 버튼을 보여준다.
    if (_permissionDenied) {
      final l10n = AppLocalizations.of(context);
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.s6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppIcon(
              AppIcons.camera,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.s5),
            AppText.headlineMedium(
              l10n.cameraPermissionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s3),
            AppText.body(
              l10n.cameraPermissionDescription,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s6),
            AppButton(
              label: l10n.permissionGoToSettings,
              onPressed: () =>
                  ref.read(permissionServiceProvider).openSettings(),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        CameraHeader(
          // 코너 미니뷰 모드에서는 투명도 조절이 의미 없어 숨긴다.
          showOpacity:
              widget.showOpacity && _guideMode != GuideViewMode.cornerMini,
          onOpacityChanged: _onOpacityChanged,
        ),
        // 헤더 아래로 프리뷰 · 모드 토글 · 촬영 버튼을 차례로 붙이고,
        // 남는 세로 공간은 맨 아래에 둔다. 프리뷰는 촬영 결과와 같은 사진
        // 프레임(3:4)으로 잘라, 보이는 그대로 저장되게 맞춘다.
        // (세로 공간이 모자란 기기에서는 폭을 줄여 프레임을 유지한다)
        Flexible(
          child: AspectRatio(
            aspectRatio: AppRatio.photo,
            // 프리뷰 영역 어디서든 핀치로 줌인/아웃. (버튼 탭은 제스처
            // 아레나에서 탭이 우선되어 그대로 동작한다)
            child: GestureDetector(
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Preview(
                      controller: _controller,
                      initFuture: _initFuture,
                    ),
                  ),
                  if (widget.showViewMode && widget.guideImage != null)
                    switch (_guideMode) {
                      // 코너 미니뷰: 좌상단에 작게.
                      GuideViewMode.cornerMini => Positioned(
                        left: AppSpacing.s4,
                        top: AppSpacing.s4,
                        child: CornerMiniView(image: widget.guideImage!),
                      ),
                      // 고스트 확대: 가운데 90% 창으로 프리뷰 크기 그대로 보여준다.
                      // (창 밖 가장자리는 잘림 — 창·이미지 배치는 GhostGuideView 가 처리)
                      GuideViewMode.ghostZoom => Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.s4),
                          child: GhostGuideView(
                            image: widget.guideImage!,
                            opacity: _guideOpacity,
                            // 원본 전체가 아니라 모임 상세 헤더에서 보이던 프레임만
                            // 가이드로 쓴다. (사진 프레임 비율 공용)
                            frameAspectRatio: AppRatio.photo,
                          ),
                        ),
                      ),
                    },
                  // 프리뷰 우측 하단: 플래시 · 카메라 전환 (배경 없이 흰색 아이콘).
                  Positioned(
                    right: AppSpacing.s5,
                    bottom: AppSpacing.s5,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.s3,
                      children: [
                        _PreviewControlButton(
                          icon: _flashOn ? AppIcons.flashOn : AppIcons.flashOff,
                          onPressed: _toggleFlash,
                        ),
                        _PreviewControlButton(
                          icon: AppIcons.reverse,
                          onPressed: _switchCamera,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // 프리뷰 바로 아래에 붙는 모드 토글.
        const SizedBox(height: AppSpacing.s5),
        CameraModeToggle(
          visible: widget.showViewMode,
          onChanged: _onViewModeChanged,
        ),
        CameraBottom(onCapture: _capture),
      ],
    );
  }
}

/// 프리뷰 위에 얹는 컨트롤 버튼. (배경 없이 흰색 아이콘만)
class _PreviewControlButton extends StatelessWidget {
  const _PreviewControlButton({required this.icon, required this.onPressed});

  /// 아이콘.
  final AppIconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(AppSpacing.s3),
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: AppIcon(icon, size: 24, color: AppColors.textPrimary),
    );
  }
}
