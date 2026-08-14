import 'dart:async';

import 'package:camera/camera.dart';
import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/loading/app_loading_overlay.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/util/tap_guard.dart';
import 'package:ddara/core/widget/camera/bottom/camera_bottom.dart';
import 'package:ddara/core/widget/camera/header/camera_header.dart';
import 'package:ddara/core/widget/camera/mode/camera_mode_toggle.dart';
import 'package:ddara/core/widget/camera/preview/corner_mini_handle.dart';
import 'package:ddara/core/widget/camera/preview/corner_mini_view.dart';
import 'package:ddara/core/widget/camera/preview/ghost_guide_view.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_controller.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_steps.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_target.dart';
import 'package:ddara/core/widget/camera/tour/provider/camera_tour_provider.dart';
import 'package:ddara/core/widget/camera/tour/widget/camera_tour_overlay.dart';
import 'package:ddara/core/widget/camera/util/image_mirror.dart';
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
    this.initialViewMode = GuideViewMode.cornerMini,
    this.showTour = false,
    this.forceTour = false,
    this.tourRestartToken = 0,
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

  /// 화면을 열었을 때 선택돼 있을 프리뷰 보조 모드.
  final GuideViewMode initialViewMode;

  /// 가이드 투어(코치마크) 사용 여부.
  ///
  /// true 면 첫 진입에 투어가 자동으로 시작되고, 프리뷰 우측 하단에 다시 보기
  /// 버튼이 생긴다. 가이드 사진이 없는 화면(스타터 촬영)은 안내할 것이 없어
  /// 기본값 false 다.
  final bool showTour;

  /// 투어를 이미 본 적이 있어도 처음부터 다시 띄운다. ([showTour] 가 true 일 때만)
  /// 완료 플래그를 건드리지 않으므로 다른 진입 경로에는 영향이 없다.
  final bool forceTour;

  /// 값이 바뀌면 투어를 처음부터 다시 연다.
  ///
  /// 투어 상태는 이 위젯이 들고 있어서 바깥(AppBar 의 도움말 버튼 등)에서 직접
  /// 열 수 없다. 호출부가 이 값을 올리는 것으로 요청을 전달한다.
  final int tourRestartToken;

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

class _CameraState extends ConsumerState<Camera>
    with WidgetsBindingObserver
    implements CameraTourHost {
  CameraController? _controller;
  Future<void>? _initFuture;
  bool _flashOn = false;

  /// 카메라 권한이 거부된 상태. true 면 안내 화면을 보여준다.
  bool _permissionDenied = false;

  /// 촬영 후처리(전면 반전 등)가 진행 중인 상태.
  /// 짧지만 즉시 끝나지는 않아, 그동안 촬영 버튼을 막고 로딩을 덮는다.
  bool _processing = false;

  List<CameraDescription> _cameras = const [];
  int _cameraIndex = 0;
  late GuideViewMode _guideMode = widget.initialViewMode;

  /// 코너 미니뷰를 왼쪽으로 밀어 치워 둔 상태. 손잡이만 남는다.
  bool _miniViewHidden = false;

  // 현재 선택된 투명도 라벨. (탭 · 프리뷰 스와이프가 함께 쓰는 상태)
  String _opacityLabel = cameraDefaultOpacityLabel;

  double get _guideOpacity => (int.tryParse(_opacityLabel) ?? 0) / 100;

  // 핀치 줌 상태. min/max 는 카메라를 열 때 조회한다. (미지원 시 1.0 → 줌 없음)
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _currentZoom = 1.0;

  // 핀치 시작 시점의 줌 배율. (제스처 도중 기준값)
  double _baseZoom = 1.0;

  // 이번 제스처에서 동시에 닿았던 최대 손가락 수. 끝난 뒤 핀치(줌)였는지
  // 한 손가락 스와이프(투명도)였는지 가르는 데 쓴다.
  int _maxPointers = 0;

  /// 투어 오버레이가 깔리는 Stack. 타겟 좌표를 이 기준으로 환산한다.
  final GlobalKey _tourOriginKey = GlobalKey();

  late final CameraTourController _tour = CameraTourController(host: this);

  /// 이 화면에서 진입 투어를 자동 시작한 적이 있는지.
  /// (카메라 전환 등으로 재초기화될 때 다시 뜨지 않게 한다)
  bool _tourAutoStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tour.addListener(_onTourChanged);
    _initFuture = _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 설정에서 권한을 켜고 돌아온 경우, 거부 상태였다면 다시 시도한다.
    if (state == AppLifecycleState.resumed && _permissionDenied) {
      _initFuture = _initCamera();
    }
    // 복귀 후에는 레이아웃이 달라졌을 수 있어 하이라이트를 다시 잰다.
    if (state == AppLifecycleState.resumed) _tour.remeasure();
  }

  @override
  void didUpdateWidget(Camera oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 바깥에서 도움말을 눌러 투어를 다시 열도록 요청했다.
    // 지금 보고 있는 모드의 안내를 연다.
    if (widget.tourRestartToken != oldWidget.tourRestartToken) {
      _startTour(CameraTourKind.of(_guideMode), force: true);
    }
  }

  @override
  void didChangeMetrics() {
    // 회전·리사이즈로 타겟이 움직이면 구멍도 따라가야 한다.
    _tour.remeasure();
  }

  /// 투어 상태가 바뀌면 오버레이 표시와 촬영 차단 여부가 함께 달라진다.
  void _onTourChanged() {
    if (mounted) setState(() {});
  }

  /// 화면에 처음 들어왔을 때의 안내(코너 미니뷰)를 한 번 띄운다.
  /// (프리뷰가 준비된 뒤 호출해야 타겟 좌표를 잴 수 있다)
  void _startInitialTourIfNeeded() {
    if (_tourAutoStarted) return;
    _tourAutoStarted = true;
    _startTour(CameraTourKind.corner, force: widget.forceTour);
  }

  /// [kind] 안내를 연다. 이미 본 적이 있으면 열지 않는다.
  /// ([force] 는 도움말 버튼·테스트 진입처럼 다시 보겠다고 요청한 경우)
  void _startTour(CameraTourKind kind, {bool force = false}) {
    if (!widget.showTour || !mounted) return;
    if (!force && ref.read(cameraTourSeenProvider(kind))) return;

    _tour.start(
      kind,
      onFinished: () =>
          ref.read(cameraTourSeenProvider(kind).notifier).complete(),
    );
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
    _startInitialTourIfNeeded();
  }

  /// 현재 프리뷰를 촬영해 앱 임시 디렉토리에 저장하고, 그 경로를 전달한다.
  /// (OS 갤러리에는 저장하지 않는다.)
  ///
  /// 전면 카메라는 프리뷰가 거울상으로 보이므로, 저장본도 같은 좌우로 뒤집어
  /// 방금 본 화면과 확인 화면·업로드본이 어긋나지 않게 한다.
  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    // 이미 촬영 중이면 중복 호출을 막는다.
    if (controller.value.isTakingPicture) return;

    setState(() => _processing = true);
    try {
      final file = await controller.takePicture();
      // 촬영 후 화면이 넘어가도 토치가 켜진 채 남지 않도록 끈다.
      // (뒤로가기는 dispose 에서 처리되지만, 촬영 후 전환은 dispose 가 호출되지 않는다.)
      if (_flashOn) {
        await controller.setFlashMode(FlashMode.off);
        if (mounted) setState(() => _flashOn = false);
      }

      final isFront =
          controller.description.lensDirection == CameraLensDirection.front;
      final path = isFront ? await mirrorImageFile(file.path) : file.path;

      if (!mounted) return;
      widget.onCapture?.call(path);
    } catch (_) {
      // 촬영 실패는 무시한다. (필요 시 사용자 안내 추가)
    } finally {
      // 촬영이 성공하면 보통 화면이 넘어가지만, 같은 화면에 머무는 호출부도
      // 있으므로(가이드 재촬영 등) 처리 상태는 항상 되돌린다.
      if (mounted) setState(() => _processing = false);
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
    _maxPointers = details.pointerCount;
  }

  /// 핀치 진행: 배율(scale)을 기준값에 곱해 줌 범위 안으로 적용한다.
  Future<void> _onScaleUpdate(ScaleUpdateDetails details) async {
    // 손가락이 하나 늦게 내려오는 경우가 흔해, 제스처 내내 최대값을 기억한다.
    // (끝난 뒤 줌이었는지 스와이프였는지 가르는 기준)
    if (details.pointerCount > _maxPointers) {
      _maxPointers = details.pointerCount;
    }

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
    if (_guideMode == mode) return;
    setState(() {
      _guideMode = mode;
      // 코너 미니뷰를 다시 고른 것은 가이드를 보겠다는 뜻이므로, 숨겨 뒀더라도
      // 꺼내 둔다. (토글로 골랐는데 손잡이만 남아 있으면 고장처럼 보인다)
      _miniViewHidden = false;
    });
    widget.onViewModeChanged?.call(mode);
    _onGuideModeSettled(mode);
  }

  /// 모드가 바뀐 뒤 투어를 정리한다.
  ///
  /// 모드마다 안내가 따로 있으므로, 사용자가 다른 모드로 옮겨 가면 지금 보던
  /// 안내는 거기서 끝내고 그쪽 안내로 넘긴다. 같은 모드 안에서의 변화라면
  /// 하이라이트 위치만 다시 잰다.
  void _onGuideModeSettled(GuideViewMode mode) {
    final kind = CameraTourKind.of(mode);
    if (_tour.isActive && _tour.kind != kind) _tour.finish();

    if (_tour.isActive) {
      _tour.onHostChanged();
    } else {
      _startTour(kind);
    }
  }

  void _setMiniViewHidden(bool hidden) {
    if (_miniViewHidden == hidden) return;
    setState(() => _miniViewHidden = hidden);
    // 미니뷰를 치우면 타겟이 사라지므로 구멍을 다시 잰다.
    _tour.onHostChanged();
  }

  // ── CameraTourHost ────────────────────────────────────────────────

  @override
  GuideViewMode get guideMode => _guideMode;

  @override
  void setGuideMode(GuideViewMode mode) => _onViewModeChanged(mode);

  @override
  void revealMiniView() => _setMiniViewHidden(false);

  @override
  void foldMiniView() => _setMiniViewHidden(true);

  @override
  bool get animationsDisabled =>
      mounted && MediaQuery.disableAnimationsOf(context);

  @override
  RenderObject? get tourOrigin =>
      _tourOriginKey.currentContext?.findRenderObject();

  /// 가이드 사진은 네트워크 이미지라 첫 표시에 지연이 있을 수 있다.
  /// 디코딩이 끝날 때까지 기다리되, 실패·지연으로 투어가 멈추지는 않게 한다.
  @override
  Future<void> ensureGuideImageLoaded() async {
    final image = widget.guideImage;
    if (image == null || !mounted) return;
    try {
      await precacheImage(image, context).timeout(const Duration(seconds: 3));
    } catch (_) {
      // 로딩에 실패해도 투어는 계속 진행한다.
    }
  }

  /// 제스처 종료: 한 손가락 가로 스와이프였다면 원본사진 투명도를 바꾼다.
  /// 방향·감도는 투명도 탭과 같은 규칙([opacityLabelForSwipe])을 쓴다.
  ///
  /// 가로 드래그를 별도 인식기로 두면 핀치와 같은 아레나에서 경쟁해, 두 번째
  /// 손가락이 닿기 전에 드래그가 이겨 버리면 줌이 통째로 먹히지 않는다.
  /// 그래서 인식기를 scale 하나로 합치고, 핀치였는지는 [_maxPointers] 로 가른다.
  /// (투명도를 조절할 수 없는 상태 — 고스트 확대 모드가 아닐 때는 무시)
  void _onScaleEnd(ScaleEndDetails details) {
    if (_maxPointers > 1) return;
    if (!widget.showOpacity || _guideMode != GuideViewMode.ghostZoom) return;

    final next = opacityLabelForSwipe(
      _opacityLabel,
      details.velocity.pixelsPerSecond.dx,
    );
    if (next != null) _onOpacityChanged(next);
  }

  void _onOpacityChanged(String label) {
    if (_opacityLabel == label) return;
    setState(() => _opacityLabel = label);
    widget.onOpacityChanged?.call(label);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tour.removeListener(_onTourChanged);
    _tour.dispose();
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

    // 촬영 후처리 동안 화면 전체를 덮어 입력을 막는다. (전면 반전 등)
    return Stack(
      key: _tourOriginKey,
      children: [
        _cameraBody(),
        // 딤과 구멍 좌표가 본문과 같은 상자를 쓰도록 영역 전체를 채운다.
        if (_tour.isActive)
          Positioned.fill(child: CameraTourOverlay(controller: _tour)),
        if (_processing) const AppLoadingOverlay(),
      ],
    );
  }

  /// 코너 미니뷰 자리. 숨긴 상태면 손잡이만, 아니면 가이드 미니뷰를 그린다.
  ///
  /// 둘은 크기도 여백도 달라 자리를 [Align] 으로 잡고, 교체는 왼쪽으로
  /// 미끄러지는 전환으로 이어 붙인다. (미는 방향과 화면이 어긋나지 않게)
  Widget _cornerMini() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      // 기본 layoutBuilder 는 가운데 정렬이라, 크기가 다른 둘이 교체될 때
      // 자리가 흔들린다. 좌상단에 고정한다.
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.topLeft,
        children: [...previousChildren, ?currentChild],
      ),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.25, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: _miniViewHidden
          // 손잡이는 화면 왼쪽 끝에 붙고, 위로만 프리뷰에서 띄운다.
          ? Padding(
              key: const ValueKey('corner-mini-handle'),
              padding: const EdgeInsets.only(top: AppSpacing.s5),
              child: CameraTourTarget(
                id: CameraTourTargets.miniGuideHandle,
                child: CornerMiniHandle(
                  onShow: () => _setMiniViewHidden(false),
                ),
              ),
            )
          : Padding(
              key: const ValueKey('corner-mini-view'),
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: CameraTourTarget(
                id: CameraTourTargets.miniGuide,
                child: CornerMiniView(
                  image: widget.guideImage!,
                  onHide: () => _setMiniViewHidden(true),
                ),
              ),
            ),
    );
  }

  /// 헤더 · 프리뷰 · 모드 토글 · 촬영 버튼으로 이어지는 본문.
  Widget _cameraBody() {
    return Column(
      children: [
        CameraHeader(
          // 코너 미니뷰 모드에서는 투명도 조절이 의미 없어 숨긴다.
          showOpacity:
              widget.showOpacity && _guideMode != GuideViewMode.cornerMini,
          opacityLabel: _opacityLabel,
          onOpacityChanged: _onOpacityChanged,
        ),
        // 헤더 아래로 프리뷰 · 모드 토글 · 촬영 버튼을 차례로 붙이고,
        // 남는 세로 공간은 맨 아래에 둔다. 프리뷰는 촬영 결과와 같은 사진
        // 프레임(3:4)으로 잘라, 보이는 그대로 저장되게 맞춘다.
        // (세로 공간이 모자란 기기에서는 폭을 줄여 프레임을 유지한다)
        Flexible(
          child: AspectRatio(
            aspectRatio: AppRatio.photo,
            // 프리뷰 영역 어디서든 핀치로 줌인/아웃, 가로 스와이프로 원본사진
            // 투명도 조절. (버튼 탭은 제스처 아레나에서 탭이 우선되어 그대로 동작한다)
            child: GestureDetector(
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              onScaleEnd: _onScaleEnd,
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
                      // 코너 미니뷰: 좌상단에 작게. 왼쪽으로 밀어 치우면
                      // 같은 자리에 다시 꺼낼 손잡이만 남는다.
                      GuideViewMode.cornerMini => Positioned.fill(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: _cornerMini(),
                        ),
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
          mode: _guideMode,
          onChanged: _onViewModeChanged,
        ),
        // 투어 중에는 촬영 버튼이 딤에 덮이지만, 구멍이 뚫린 스텝을 대비해
        // 촬영 로직 자체도 막는다.
        CameraBottom(
          onCapture: tapGuard(_processing || _tour.isActive, _capture),
        ),
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
