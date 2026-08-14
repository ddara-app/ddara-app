import 'package:ddara/core/design_system/foundation/app_radius.dart';
import 'package:ddara/core/design_system/foundation/app_spacing.dart';
import 'package:ddara/core/widget/camera/mode/camera_mode_toggle.dart';

/// 툴팁을 구멍의 위/아래 어디에 붙일지.
enum CameraTourPlacement { top, bottom }

/// 구멍 모양.
enum CameraTourShape { rrect, circle }

/// 스텝 식별자.
///
/// 문구는 스텝 모델이 아니라 이 id 로 l10n 에서 조회한다. 그래야 스텝을 const
/// 로 둘 수 있고, 로케일이 바뀌어도 리빌드만으로 문구가 갱신된다.
/// exhaustive switch 를 쓰므로 스텝을 추가하고 문구를 빠뜨리면 컴파일 에러다.
enum CameraTourStepId {
  miniGuide,
  miniGuideFold,
  modeToggle,
  ghostGuide,
  opacity,
}

/// 투어 한 스텝의 구조. (문구는 담지 않는다 — [CameraTourStepId] 참고)
class CameraTourStep {
  const CameraTourStep({
    required this.id,
    required this.targetId,
    required this.placement,
    this.shape = CameraTourShape.rrect,
    this.dim = defaultDim,
    this.padding = AppSpacing.s0,
    this.radius = defaultRadius,
    this.requiresMode,
    this.allowTouch = false,
    this.waitForGuideImage = false,
    this.foldDemoTargetId,
    this.foldDemoRadius = AppRadius.xs,
  });

  /// 기본 딤 농도. 구멍이 화면 대부분을 덮는 스텝은 이보다 낮춘다.
  static const double defaultDim = 0.72;

  /// 기본 구멍 반경. (가이드 사진의 테두리 반경과 같다)
  static const double defaultRadius = AppRadius.sm;

  final CameraTourStepId id;

  /// 하이라이트할 위젯의 [CameraTourTargets] 상수.
  final String targetId;

  final CameraTourPlacement placement;
  final CameraTourShape shape;

  /// 딤 농도. 0.0(투명) ~ 1.0(불투명).
  final double dim;

  /// 타겟 둘레에 더할 구멍 여백.
  /// 기본값 0 — 구멍이 대상 위젯의 테두리에 딱 맞는다.
  final double padding;

  /// [CameraTourShape.rrect] 구멍의 모서리 반경.
  final double radius;

  /// 이 스텝이 유효한 프리뷰 모드. 다르면 이 모드로 전환한 뒤 진행한다.
  final GuideViewMode? requiresMode;

  /// true 면 구멍 안쪽 터치를 실제 위젯으로 통과시킨다.
  /// (안내를 읽다가 바로 그 기능을 눌러볼 수 있게 하는 스텝)
  final bool allowTouch;

  /// 진입 전에 가이드 이미지 로딩을 기다릴지 여부.
  final bool waitForGuideImage;

  /// 값이 있으면 진입 후 코너 미니뷰가 접히는 모습을 한 번 보여주고,
  /// **접혀 있는 동안에는 이 타겟을 대신 가리킨다.**
  ///
  /// 접으면 미니뷰가 트리에서 사라져 [targetId] 를 못 찾으므로, 그 자리에 남는
  /// 손잡이를 대체 타겟으로 지정해야 구멍이 빈 자리를 가리키지 않는다.
  final String? foldDemoTargetId;

  /// 접혀 있는 동안 쓸 구멍 반경.
  /// 대체 타겟은 모양이 달라 [radius] 를 그대로 쓰면 테두리가 겉돈다.
  /// (기본값은 `CornerMiniHandle` 의 모서리 반경)
  final double foldDemoRadius;
}
