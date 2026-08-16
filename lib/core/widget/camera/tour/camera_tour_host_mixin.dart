import 'package:ddara/core/widget/camera/camera.dart';
import 'package:ddara/core/widget/camera/mode/camera_mode_toggle.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_controller.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_steps.dart';
import 'package:ddara/core/widget/camera/tour/provider/camera_tour_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 카메라 화면에 따라찍기 가이드 투어(코치마크)를 붙이는 mixin.
///
/// 투어 컨트롤러의 수명 · 시작 조건 · [CameraTourHost] 계약을 맡는다.
/// 프리뷰 보조 모드와 코너 미니뷰는 화면이 들고 있는 표시 상태라, 여기서는
/// [guideMode] · [setGuideMode] · [setMiniViewHidden] 으로만 오간다.
mixin CameraTourHostMixin on ConsumerState<Camera> implements CameraTourHost {
  /// 투어 오버레이가 깔리는 Stack. 타겟 좌표를 이 기준으로 환산한다.
  final GlobalKey tourOriginKey = GlobalKey();

  late final CameraTourController tour = CameraTourController(host: this);

  /// 이 화면에서 진입 투어를 자동 시작한 적이 있는지.
  /// (카메라 전환 등으로 재초기화될 때 다시 뜨지 않게 한다)
  bool _tourAutoStarted = false;

  /// 코너 미니뷰를 접거나 편다. 표시 상태는 화면이 들고 있으므로 위임한다.
  void setMiniViewHidden(bool hidden);

  @override
  void initState() {
    super.initState();
    tour.addListener(_onTourChanged);
  }

  @override
  void dispose() {
    tour.removeListener(_onTourChanged);
    tour.dispose();
    super.dispose();
  }

  /// 투어 상태가 바뀌면 오버레이 표시와 촬영 차단 여부가 함께 달라진다.
  void _onTourChanged() {
    if (mounted) setState(() {});
  }

  /// 화면에 처음 들어왔을 때의 안내(코너 미니뷰)를 한 번 띄운다.
  /// (프리뷰가 준비된 뒤 호출해야 타겟 좌표를 잴 수 있다)
  void startInitialTourIfNeeded() {
    if (_tourAutoStarted) return;
    _tourAutoStarted = true;
    startTour(CameraTourKind.corner, force: widget.forceTour);
  }

  /// 지금 보고 있는 모드의 안내를 처음부터 다시 연다.
  /// (바깥에서 도움말을 눌러 요청한 경우)
  void restartTour() => startTour(CameraTourKind.of(guideMode), force: true);

  /// [kind] 안내를 연다. 이미 본 적이 있으면 열지 않는다.
  /// ([force] 는 도움말 버튼·테스트 진입처럼 다시 보겠다고 요청한 경우)
  void startTour(CameraTourKind kind, {bool force = false}) {
    if (!widget.showTour || !mounted) return;
    if (!force && ref.read(cameraTourSeenProvider(kind))) return;

    tour.start(
      kind,
      onFinished: () =>
          ref.read(cameraTourSeenProvider(kind).notifier).complete(),
    );
  }

  /// 모드가 바뀐 뒤 투어를 정리한다.
  ///
  /// 모드마다 안내가 따로 있으므로, 사용자가 다른 모드로 옮겨 가면 지금 보던
  /// 안내는 거기서 끝내고 그쪽 안내로 넘긴다. 같은 모드 안에서의 변화라면
  /// 하이라이트 위치만 다시 잰다.
  void onGuideModeSettled(GuideViewMode mode) {
    final kind = CameraTourKind.of(mode);
    if (tour.isActive && tour.kind != kind) tour.finish();

    if (tour.isActive) {
      tour.onHostChanged();
    } else {
      startTour(kind);
    }
  }

  // ── CameraTourHost ────────────────────────────────────────────────

  @override
  void revealMiniView() => setMiniViewHidden(false);

  @override
  void foldMiniView() => setMiniViewHidden(true);

  @override
  bool get animationsDisabled =>
      mounted && MediaQuery.disableAnimationsOf(context);

  @override
  RenderObject? get tourOrigin =>
      tourOriginKey.currentContext?.findRenderObject();

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
}
