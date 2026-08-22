import 'dart:async';

import 'package:ddara/core/widget/camera/mode/camera_mode_toggle.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_step.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_steps.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_target.dart';
import 'package:flutter/widgets.dart';

/// 투어가 화면(카메라) 상태를 읽고 바꾸기 위한 창구.
///
/// 카메라 화면의 표시 상태는 `Camera` 위젯의 State 가 들고 있으므로, 투어는
/// 그 State 를 직접 참조하지 않고 이 인터페이스로만 접근한다.
abstract interface class CameraTourHost {
  /// 현재 프리뷰 보조 모드.
  GuideViewMode get guideMode;

  /// 프리뷰 보조 모드를 바꾼다.
  void setGuideMode(GuideViewMode mode);

  /// 왼쪽으로 밀어 치워 둔 코너 미니뷰를 다시 꺼낸다.
  /// (치워진 상태면 미니뷰 타겟이 화면에 없다)
  void revealMiniView();

  /// 코너 미니뷰를 왼쪽으로 접는다. (접기 시연용)
  void foldMiniView();

  /// 기기 설정에서 애니메이션을 끈 상태인지.
  /// true 면 움직임으로 설명하는 시연을 건너뛴다.
  bool get animationsDisabled;

  /// 가이드 이미지 디코딩이 끝날 때까지 기다린다. 실패해도 예외를 던지지 않는다.
  Future<void> ensureGuideImageLoaded();

  /// 투어 오버레이가 깔리는 영역의 RenderObject.
  /// 타겟 좌표를 이 기준으로 환산해야 구멍 위치가 맞는다.
  RenderObject? get tourOrigin;
}

/// 타겟 좌표를 찾지 못했을 때 그 스텝을 포기하기까지의 시간.
const Duration _measureTimeout = Duration(seconds: 3);

/// 좌표 재조회 간격.
const Duration _measureInterval = Duration(milliseconds: 32);

/// 모드 전환 애니메이션이 끝나기를 기다리는 시간.
/// (모드 토글 250ms · 코너 미니뷰 전환 200ms 보다 길게 잡는다)
const Duration _modeSettleDelay = Duration(milliseconds: 300);

/// 접기 시연을 시작하기 전 두는 시간.
///
/// 너무 늦으면 시연을 보기 전에 '다음'을 눌러 버린다. 말풍선이
/// 떠서 자리를 잡을 만큼만 기다리고 바로 움직인다.
const Duration _foldDemoDelay = Duration(milliseconds: 500);

/// 접힌 모습을 보여 주는 시간.
const Duration _foldDemoHold = Duration(milliseconds: 900);

/// 접기/펴기 전환(`AnimatedSwitcher` 200ms)이 끝나기를 기다리는 시간.
const Duration _foldSettleDelay = Duration(milliseconds: 220);

/// 따라찍기 가이드 투어의 진행 상태와 로직.
///
/// 스텝을 순서대로 밟으며 하이라이트할 구멍([hole])을 계산해 알린다.
/// 어떤 투어를 돌릴지는 [start] 에서 정하므로 컨트롤러 하나로 종류를 오간다.
/// 화면 상태 접근은 [CameraTourHost] 로만 하고, 위젯 트리는 알지 못한다.
class CameraTourController extends ChangeNotifier {
  CameraTourController({required this.host});

  final CameraTourHost host;

  List<CameraTourStep> _steps = const [];
  CameraTourKind? _kind;
  VoidCallback? _onFinished;

  int _index = -1;
  Rect? _hole;
  bool _disposed = false;

  /// 지금 구멍이 가리키는 타겟. 보통은 현재 스텝의 것이지만, 접기 시연 중에는
  /// 손잡이로 바뀐다. (재측정도 이 값을 따라간다)
  String? _activeTargetId;

  /// 지금 구멍에 적용할 모서리 반경. 가리키는 대상이 바뀌면 함께 바뀐다.
  double _activeRadius = CameraTourStep.defaultRadius;

  /// 접기 시연으로 미니뷰를 접어 둔 상태.
  /// 스텝을 벗어날 때 반드시 펴 줘야 한다.
  bool _foldedByDemo = false;

  bool get isActive => _index >= 0 && _index < _steps.length;

  /// 진행 중인 투어 종류. 멈춰 있으면 null.
  CameraTourKind? get kind => _kind;

  /// 지금 하이라이트하고 있는 타겟 id. 없으면 null.
  ///
  /// 타겟 위젯이 안내받는 동안 모양을 달리 하려고 할 때 쓴다.
  /// (구멍을 칠해 가리는 대신 위젯 자신이 바뀐다)
  String? get activeTargetId => _activeTargetId;

  /// 현재 스텝. [isActive] 가 true 일 때만 호출한다.
  CameraTourStep get current => _steps[_index];

  /// 진행 표시용. (1부터)
  int get stepNumber => _index + 1;
  int get stepCount => _steps.length;
  bool get isLastStep => _index == _steps.length - 1;

  /// 되돌아갈 스텝이 남아 있는지. (첫 스텝에서는 false)
  bool get canGoBack => isActive && _index > 0;

  /// 하이라이트할 화면 좌표계 사각형. null 이면 전체 딤.
  Rect? get hole => _hole;

  /// 구멍에 적용할 모서리 반경.
  /// 스텝의 값이 기본이지만 접기 시연 중에는 손잡이에 맞춘 값으로 바뀐다.
  double get holeRadius => _activeRadius;

  /// [kind] 투어를 처음부터 연다. 이미 진행 중이면 무시한다.
  ///
  /// [onFinished] 는 완주·건너뛰기 공통으로 한 번 호출된다.
  /// (완료 플래그 저장에 쓴다)
  Future<void> start(
    CameraTourKind kind, {
    required VoidCallback onFinished,
  }) async {
    if (isActive) return;
    _kind = kind;
    _steps = kind.steps;
    _onFinished = onFinished;
    _index = 0;
    await _enterStep();
  }

  Future<void> next() async {
    if (!isActive) return;
    // 마지막 스텝에서는 인덱스를 올리지 않고 끝낸다. 먼저 올려 버리면 그 순간
    // [isActive] 가 false 가 되어 [finish] 가 제 일을 못 하고 빠져나간다.
    if (isLastStep) {
      finish();
      return;
    }
    _leaveStep();
    _index++;
    await _enterStep();
  }

  /// 한 스텝 되돌린다. 첫 스텝에서는 아무 일도 하지 않는다.
  ///
  /// 되돌아간 스텝의 [CameraTourStep.requiresMode] 로 화면 모드도 함께 복원되므로,
  /// 앞으로 갈 때와 같은 상태에서 안내를 다시 읽게 된다.
  Future<void> previous() async {
    if (!canGoBack) return;
    _leaveStep();
    _index--;
    await _enterStep();
  }

  void skip() => finish();

  void finish() {
    if (!isActive) return;
    _leaveStep();
    _index = -1;
    _hole = null;
    _steps = const [];
    _kind = null;
    _activeTargetId = null;

    // 모드는 되돌리지 않는다. 투어가 모드를 강제로 바꾸는 흐름이 없고
    // (각 투어는 이미 그 모드일 때만 뜬다), 사용자가 마지막으로 고른 모드가
    // 그대로 남는 편이 자연스럽다.
    final onFinished = _onFinished;
    _onFinished = null;
    onFinished?.call();

    _notify();
  }

  /// 화면 상태가 바뀌었을 때 호출한다. (모드 전환 등)
  /// 진행 중인 스텝의 구멍을 다시 잰다. 모드 전환은 애니메이션이 있어 잠시 기다린다.
  Future<void> onHostChanged() => remeasure(delay: _modeSettleDelay);

  /// 지금 가리키는 대상의 구멍을 다시 잰다. (회전 · 리사이즈 · 백그라운드 복귀)
  Future<void> remeasure({Duration? delay}) async {
    if (!isActive) return;
    if (delay != null) await Future<void>.delayed(delay);
    final targetId = _activeTargetId;
    if (!isActive || targetId == null) return;

    final rect = await _measure(targetId);
    if (!isActive) return;
    // 못 찾았으면 직전 구멍을 그대로 둔다. 진행 중인 스텝을 화면 밖 변화로
    // 건너뛰면 사용자가 안내를 놓친다. (스텝 진입 실패와는 구분한다)
    if (rect == null) return;

    _hole = rect.inflate(current.padding);
    _notify();
  }

  /// 스텝을 벗어나기 직전 정리. 시연으로 바꿔 놓은 화면 상태를 되돌린다.
  void _leaveStep() {
    if (!_foldedByDemo) return;
    _foldedByDemo = false;
    host.revealMiniView();
  }

  Future<void> _enterStep() async {
    final step = current;

    // 1) 이 스텝이 요구하는 모드로 맞춘다.
    final requiredMode = step.requiresMode;
    if (requiredMode != null && host.guideMode != requiredMode) {
      host.setGuideMode(requiredMode);
      await Future<void>.delayed(_modeSettleDelay);
      if (!isActive) return;
    }

    // 코너 미니뷰를 치워 뒀다면 타겟이 화면에 없으므로 다시 꺼낸다.
    if (step.targetId == CameraTourTargets.miniGuide) {
      host.revealMiniView();
    }

    // 2) 가이드 이미지 로딩 대기. (실패해도 그대로 진행)
    if (step.waitForGuideImage) {
      await host.ensureGuideImageLoaded();
      if (!isActive) return;
    }

    // 3) 레이아웃이 끝난 뒤 좌표를 잰다. 못 찾으면 이 스텝은 건너뛴다.
    _activeTargetId = step.targetId;
    _activeRadius = step.radius;
    final rect = await _measure(step.targetId);
    if (!isActive) return;
    if (rect == null) {
      debugPrint('[CameraTour] target not found: ${step.targetId}');
      await next();
      return;
    }

    _hole = rect.inflate(step.padding);
    _notify();

    // 4) 말로만 설명하기 어려운 동작은 한 번 시연한다.
    if (step.foldDemoTargetId != null) unawaited(_playFoldDemo(step));
  }

  /// 코너 미니뷰를 한 번 접었다 편다.
  ///
  /// 접으면 미니뷰가 사라지므로 구멍은 그 자리에 남는 손잡이로 옮겨 간다.
  /// 도중에 사용자가 스텝을 넘기면 [_leaveStep] 이 펴 주므로, 여기서는 매 단계
  /// 같은 스텝에 머물러 있는지만 확인한다.
  Future<void> _playFoldDemo(CameraTourStep step) async {
    final foldedTargetId = step.foldDemoTargetId;
    if (foldedTargetId == null) return;
    // 움직임을 줄여 달라는 설정이면 시연하지 않는다.
    if (host.animationsDisabled) return;

    await Future<void>.delayed(_foldDemoDelay);
    if (!_isStillOn(step)) return;

    // 접기 전에 가리킬 대상을 먼저 바꿔 둔다. 화면 쪽에서 오는 재측정이
    // 옛 타겟(사라진 미니뷰)을 찾아 헤매지 않게 한다.
    _activeTargetId = foldedTargetId;
    _activeRadius = step.foldDemoRadius;
    _foldedByDemo = true;
    host.foldMiniView();
    await _followTransition(step);

    await Future<void>.delayed(_foldDemoHold);
    if (!_isStillOn(step)) return;

    _activeTargetId = step.targetId;
    _activeRadius = step.radius;
    _foldedByDemo = false;
    host.revealMiniView();
    await _followTransition(step);
  }

  /// 접기/펴기 전환을 구멍이 함께 따라가게 한다.
  ///
  /// 전환이 끝나기를 기다렸다 재면 구멍만 뒤늦게 움직인다. 그래서 **바로 한 번**
  /// 재서 같이 출발시키고(이때 값은 전환이 막 시작한 위치라 조금 어긋난다),
  /// 전환이 끝난 뒤 한 번 더 재서 최종 위치로 맞춘다.
  Future<void> _followTransition(CameraTourStep step) async {
    await remeasure();
    await Future<void>.delayed(_foldSettleDelay);
    if (!_isStillOn(step)) return;
    await remeasure();
  }

  /// 시연을 시작한 스텝에 아직 머물러 있는지.
  bool _isStillOn(CameraTourStep step) =>
      !_disposed && isActive && identical(current, step);

  /// 타겟이 레이아웃될 때까지 프레임을 넘겨 가며 좌표를 조회한다.
  /// 제한 시간 안에 못 찾으면 null. (무한 대기 금지)
  Future<Rect?> _measure(String targetId) async {
    var waited = Duration.zero;
    while (waited < _measureTimeout) {
      await WidgetsBinding.instance.endOfFrame;
      if (_disposed) return null;

      final rect = CameraTourRegistry.rectOf(
        targetId,
        ancestor: host.tourOrigin,
      );
      if (rect != null && !rect.isEmpty) return rect;

      await Future<void>.delayed(_measureInterval);
      if (_disposed) return null;
      waited += _measureInterval;
    }
    return null;
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
