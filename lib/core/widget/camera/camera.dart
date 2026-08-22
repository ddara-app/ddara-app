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
import 'package:ddara/core/widget/camera/session/camera_session_controller.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_host_mixin.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_target.dart';
import 'package:ddara/core/widget/camera/tour/widget/camera_tour_overlay.dart';
import 'package:ddara/core/widget/camera/preview/preview.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 카메라 화면 본문. 상단(헤더) · 프리뷰 · 하단(컨트롤)으로 구성한다.
/// 카메라 컨트롤러는 여기서 보유하고 하위 위젯에 전달한다.
/// 헤더의 투명도/플래시 처리는 외부 콜백으로 위임한다.
class Camera extends StatefulWidget {
  const Camera({
    super.key,
    required this.onRequestCameraPermission,
    required this.onOpenSettings,
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
    this.tourSeen,
    this.onTourFinished,
  });

  /// 카메라 권한을 확인하고, 없으면 요청까지 한 뒤 최종 허용 여부를 돌려준다.
  /// 권한을 어디서 어떻게 다루는지는 화면(feature)의 몫이라 함수로 받는다.
  final Future<bool> Function() onRequestCameraPermission;

  /// 권한이 거부된 안내 화면에서 '설정으로 이동'을 눌렀을 때.
  final VoidCallback onOpenSettings;

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

  /// 투어를 이미 본 적이 있는지. 완료 여부의 보관은 화면(feature)의 몫이라
  /// 여기서는 결과만 넘겨받는다.
  ///
  /// null 은 '아직 확인 중'이라는 뜻이라 그동안은 투어를 열지 않는다. 값이
  /// 정해지면 그때 연다. ([forceTour] 로 들어온 경우는 확인 없이 바로 연다)
  final bool? tourSeen;

  /// 투어를 끝까지 봤을 때. 완료 저장은 호출부가 맡는다. (선택)
  final VoidCallback? onTourFinished;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera>
    with WidgetsBindingObserver, CameraTourHostMixin {
  /// 기기 카메라 세션. 촬영 · 플래시 · 전환 · 줌은 전부 여기로 위임한다.
  late final CameraSessionController _session = CameraSessionController(
    ensureCameraPermission: widget.onRequestCameraPermission,
  );

  late GuideViewMode _guideMode = widget.initialViewMode;

  /// 코너 미니뷰를 왼쪽으로 밀어 치워 둔 상태. 손잡이만 남는다.
  bool _miniViewHidden = false;

  // 현재 선택된 투명도 라벨. (탭 · 프리뷰 스와이프가 함께 쓰는 상태)
  String _opacityLabel = cameraDefaultOpacityLabel;

  double get _guideOpacity => (int.tryParse(_opacityLabel) ?? 0) / 100;

  // 이번 제스처에서 동시에 닿았던 최대 손가락 수. 끝난 뒤 핀치(줌)였는지
  // 한 손가락 스와이프(투명도)였는지 가르는 데 쓴다.
  int _maxPointers = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _session.addListener(_onSessionChanged);
    _session.initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    // 설정에서 권한을 켜고 돌아온 경우, 거부 상태였다면 다시 시도한다.
    _session.resume();
    // 복귀 후에는 레이아웃이 달라졌을 수 있어 하이라이트를 다시 잰다.
    tour.remeasure();
  }

  @override
  void didUpdateWidget(Camera oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 바깥에서 도움말을 눌러 투어를 다시 열도록 요청했다.
    if (widget.tourRestartToken != oldWidget.tourRestartToken) restartTour();
    // 시청 여부 확인이 늦게 끝났다면, 그 결과로 진입 투어를 다시 판단한다.
    // (프리뷰가 준비된 뒤라야 타겟 좌표를 잴 수 있다)
    if (widget.tourSeen != oldWidget.tourSeen && _session.isReady) {
      startInitialTourIfNeeded();
    }
  }

  @override
  void didChangeMetrics() {
    // 회전·리사이즈로 타겟이 움직이면 구멍도 따라가야 한다.
    tour.remeasure();
  }

  /// 카메라 세션(프리뷰 · 플래시 · 촬영 상태)이 바뀌면 화면을 다시 그린다.
  void _onSessionChanged() {
    if (!mounted) return;
    setState(() {});
    // 프리뷰가 준비된 뒤라야 투어 타겟 좌표를 잴 수 있다.
    if (_session.isReady) startInitialTourIfNeeded();
  }

  /// 촬영을 요청하고, 저장된 파일 경로를 호출부에 전달한다.
  Future<void> _capture() async {
    final path = await _session.capture();
    if (path == null || !mounted) return;
    widget.onCapture?.call(path);
  }

  Future<void> _toggleFlash() async {
    final wasOn = _session.flashOn;
    final isOn = await _session.toggleFlash();
    // 조작할 수 없는 상태였다면 값이 그대로 돌아오므로 알리지 않는다.
    if (!mounted || isOn == wasOn) return;
    widget.onFlashPressed?.call(isOn);
  }

  /// 핀치 시작: 현재 줌 배율을 기준값으로 잡는다.
  void _onScaleStart(ScaleStartDetails details) {
    _session.beginZoom();
    _maxPointers = details.pointerCount;
  }

  /// 핀치 진행: 두 손가락일 때만 배율을 줌에 넘긴다.
  Future<void> _onScaleUpdate(ScaleUpdateDetails details) async {
    // 손가락이 하나 늦게 내려오는 경우가 흔해, 제스처 내내 최대값을 기억한다.
    // (끝난 뒤 줌이었는지 스와이프였는지 가르는 기준)
    if (details.pointerCount > _maxPointers) {
      _maxPointers = details.pointerCount;
    }

    // 두 손가락 핀치가 아니면(단일 터치 이동 등) 무시한다.
    if (details.pointerCount < 2) return;
    await _session.zoomBy(details.scale);
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
    onGuideModeSettled(mode);
  }

  @override
  void setMiniViewHidden(bool hidden) {
    if (_miniViewHidden == hidden) return;
    setState(() => _miniViewHidden = hidden);
    // 미니뷰를 치우면 타겟이 사라지므로 구멍을 다시 잰다.
    tour.onHostChanged();
  }

  @override
  GuideViewMode get guideMode => _guideMode;

  @override
  void setGuideMode(GuideViewMode mode) => _onViewModeChanged(mode);

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
    _session.removeListener(_onSessionChanged);
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 권한이 거부된 경우: 카메라 대신 안내 + 설정 이동 버튼을 보여준다.
    if (_session.permissionDenied) {
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
              onPressed: widget.onOpenSettings,
            ),
          ],
        ),
      );
    }

    // 촬영 후처리 동안 화면 전체를 덮어 입력을 막는다. (전면 반전 등)
    return Stack(
      key: tourOriginKey,
      children: [
        _cameraBody(),
        // 딤과 구멍 좌표가 본문과 같은 상자를 쓰도록 영역 전체를 채운다.
        if (tour.isActive)
          Positioned.fill(child: CameraTourOverlay(controller: tour)),
        if (_session.isCapturing) const AppLoadingOverlay(),
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
                  onShow: () => setMiniViewHidden(false),
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
                  onHide: () => setMiniViewHidden(true),
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
                    child: Preview(controller: _session.controller),
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
                          icon: _session.flashOn
                              ? AppIcons.flashOn
                              : AppIcons.flashOff,
                          onPressed: _toggleFlash,
                        ),
                        _PreviewControlButton(
                          icon: AppIcons.reverse,
                          onPressed: _session.switchCamera,
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
          onCapture: tapGuard(_session.isCapturing || tour.isActive, _capture),
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
