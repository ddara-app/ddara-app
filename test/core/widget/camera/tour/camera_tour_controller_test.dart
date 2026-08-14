import 'dart:async';

import 'package:ddara/core/widget/camera/mode/camera_mode_toggle.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_controller.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_step.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_steps.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_target.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// 실제 투어의 첫 스텝 두 개가 쓰는 타겟. ([CameraTourKind.corner])
const _firstTarget = CameraTourTargets.miniGuide;
const _lastTarget = CameraTourTargets.ghostZoomMode;

/// 화면 상태 대신 값만 들고 있는 호스트.
class _FakeHost implements CameraTourHost {
  _FakeHost(this._originKey);

  final GlobalKey _originKey;

  GuideViewMode _mode = GuideViewMode.cornerMini;
  int revealMiniViewCount = 0;
  int foldMiniViewCount = 0;

  @override
  GuideViewMode get guideMode => _mode;

  @override
  void setGuideMode(GuideViewMode mode) => _mode = mode;

  @override
  void revealMiniView() => revealMiniViewCount++;

  @override
  void foldMiniView() => foldMiniViewCount++;

  // 시연은 실제 화면에서만 의미가 있으므로 테스트에서는 끈다.
  @override
  bool get animationsDisabled => true;

  @override
  Future<void> ensureGuideImageLoaded() async {}

  @override
  RenderObject? get tourOrigin => _originKey.currentContext?.findRenderObject();
}

/// 스텝 전환에 걸린 대기(모드 전환 300ms · 좌표 재조회 32ms)를 모두 흘려보낸다.
/// `pumpAndSettle` 만으로는 프레임을 만들지 않는 [Future.delayed] 가 남는다.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
}

void main() {
  late GlobalKey originKey;
  late _FakeHost host;
  late int finishedCount;
  late CameraTourController controller;

  setUp(() {
    originKey = GlobalKey();
    host = _FakeHost(originKey);
    finishedCount = 0;
    controller = CameraTourController(host: host);
  });

  tearDown(() => controller.dispose());

  /// 코너 미니뷰 투어를 시작한다. (완료 횟수는 [finishedCount] 로 센다)
  Future<void> startCornerTour() => controller.start(
    CameraTourKind.corner,
    onFinished: () => finishedCount++,
  );

  /// 두 타겟이 항상 존재하는 화면. (모드와 무관하게 측정에 성공한다)
  Future<void> pumpTargets(WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          key: originKey,
          children: const [
            CameraTourTarget(
              id: _firstTarget,
              child: SizedBox(width: 100, height: 100),
            ),
            CameraTourTarget(
              id: _lastTarget,
              child: SizedBox(width: 80, height: 80),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('start 하면 첫 스텝이 활성화되고 구멍이 잡힌다', (tester) async {
    await pumpTargets(tester);

    unawaited(startCornerTour());
    await settle(tester);

    expect(controller.isActive, isTrue);
    expect(controller.kind, CameraTourKind.corner);
    expect(controller.current.id, CameraTourStepId.miniGuide);
    expect(controller.stepNumber, 1);
    expect(controller.canGoBack, isFalse);
    expect(controller.hole, isNotNull);
  });

  testWidgets('마지막 스텝에서 next 하면 투어가 끝난다', (tester) async {
    await pumpTargets(tester);

    unawaited(startCornerTour());
    await settle(tester);

    // 스텝 수가 바뀌어도 깨지지 않도록 마지막까지 밀어 넣는다.
    while (!controller.isLastStep) {
      unawaited(controller.next());
      await settle(tester);
    }
    expect(controller.current.id, CameraTourStepId.modeToggle);

    unawaited(controller.next());
    await settle(tester);

    expect(controller.isActive, isFalse);
    expect(controller.kind, isNull);
    expect(controller.hole, isNull);
    expect(finishedCount, 1);
    // 모드는 되돌리지 않는다. (사용자가 마지막으로 고른 상태가 남는다)
    expect(host.guideMode, GuideViewMode.cornerMini);
  });

  testWidgets('previous 는 이전 스텝으로 돌아간다', (tester) async {
    await pumpTargets(tester);

    unawaited(startCornerTour());
    await settle(tester);
    unawaited(controller.next());
    await settle(tester);
    expect(controller.canGoBack, isTrue);

    unawaited(controller.previous());
    await settle(tester);

    expect(controller.current.id, CameraTourStepId.miniGuide);
    expect(controller.stepNumber, 1);
    expect(controller.isActive, isTrue);
  });

  testWidgets('끝난 뒤 다시 start 하면 처음부터 진행된다', (tester) async {
    await pumpTargets(tester);

    unawaited(startCornerTour());
    await settle(tester);
    controller.skip();
    await settle(tester);
    expect(controller.isActive, isFalse);
    expect(finishedCount, 1);

    unawaited(startCornerTour());
    await settle(tester);

    expect(controller.isActive, isTrue);
    expect(controller.stepNumber, 1);
  });

  testWidgets('진행 중에 다른 종류를 start 해도 무시된다', (tester) async {
    await pumpTargets(tester);

    unawaited(startCornerTour());
    await settle(tester);

    unawaited(controller.start(CameraTourKind.ghost, onFinished: () {}));
    await settle(tester);

    expect(controller.kind, CameraTourKind.corner);
    expect(controller.stepNumber, 1);
  });
}
