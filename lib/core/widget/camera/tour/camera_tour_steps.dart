import 'package:ddara/core/design_system/foundation/app_radius.dart';
import 'package:ddara/core/widget/camera/mode/camera_mode_toggle.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_step.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_target.dart';

/// 가이드 투어 종류.
///
/// 모드마다 안내할 것이 달라 투어를 둘로 나눈다. 각자 별도 시점에 뜬다.
///
/// 시청 여부를 어디에 남기는지는 이 위젯이 알지 못한다. 화면(feature)이
/// 조회해 `Camera.tourSeen` 으로 내려주고, 완료는 `Camera.onTourFinished`
/// 로 돌려받아 저장한다.
enum CameraTourKind {
  /// 진입 직후. 가이드 사진과 고스트 확대라는 기능이 있다는 것을 알린다.
  corner(cameraCornerTourSteps),

  /// 고스트 확대로 처음 전환했을 때. 겹쳐 보기와 투명도를 알린다.
  ghost(cameraGhostTourSteps);

  const CameraTourKind(this.steps);

  final List<CameraTourStep> steps;

  /// 이 모드에 해당하는 투어.
  static CameraTourKind of(GuideViewMode mode) => switch (mode) {
    GuideViewMode.cornerMini => CameraTourKind.corner,
    GuideViewMode.ghostZoom => CameraTourKind.ghost,
  };
}

/// 코너 미니뷰(진입 기본 모드) 투어.
///
/// 마지막 스텝은 고스트 확대를 **소개만** 한다. 눌러보길 강요하지 않고
/// '시작하기'로 닫을 수 있으며, 실제로 눌러서 전환하면 그때
/// [cameraGhostTourSteps] 가 이어받는다.
const cameraCornerTourSteps = <CameraTourStep>[
  CameraTourStep(
    id: CameraTourStepId.miniGuide,
    targetId: CameraTourTargets.miniGuide,
    placement: CameraTourPlacement.bottom,
    requiresMode: GuideViewMode.cornerMini,
    // 가이드 사진이 처음 그려지는 스텝이라 여기서 로딩을 기다린다.
    waitForGuideImage: true,
  ),
  // 같은 미니뷰를 가리킨 채 '왼쪽으로 밀어 접어두기'만 따로 알린다.
  // (스와이프로만 닿는 기능이라 안내가 없으면 발견하기 어렵다)
  // 말로만 설명하지 않고 실제로 한 번 접었다 편다.
  CameraTourStep(
    id: CameraTourStepId.miniGuideFold,
    targetId: CameraTourTargets.miniGuide,
    placement: CameraTourPlacement.bottom,
    requiresMode: GuideViewMode.cornerMini,
    foldDemoTargetId: CameraTourTargets.miniGuideHandle,
  ),
  CameraTourStep(
    id: CameraTourStepId.modeToggle,
    targetId: CameraTourTargets.ghostZoomMode,
    placement: CameraTourPlacement.top,
    requiresMode: GuideViewMode.cornerMini,
    radius: AppRadius.full,
    // 안내를 읽다가 바로 눌러볼 수 있게 구멍 안쪽 터치를 통과시킨다.
    allowTouch: true,
  ),
];

/// 고스트 확대 투어. 사용자가 그 모드로 처음 전환했을 때 이어서 뜬다.
///
/// [CameraTourStepId.ghostGuide] 는 [CameraTourStepId.opacity] 보다 앞에 와야
/// 한다. 사용자가 투명도를 0 으로 바꾸면 가이드 사진이 보이지 않아, 그 뒤에
/// 가이드 사진을 하이라이트하면 빈 화면을 가리키게 된다.
const cameraGhostTourSteps = <CameraTourStep>[
  CameraTourStep(
    id: CameraTourStepId.ghostGuide,
    targetId: CameraTourTargets.ghostGuide,
    placement: CameraTourPlacement.top,
    requiresMode: GuideViewMode.ghostZoom,
    // 구멍이 프리뷰의 90% 라 일반 딤이면 하이라이트 효과가 거의 없다.
    // 이미 투명도 40% 인 가이드 사진 위에 진한 딤이 겹치는 것도 피한다.
    dim: 0.35,
  ),
  CameraTourStep(
    id: CameraTourStepId.opacity,
    targetId: CameraTourTargets.opacityTabs,
    placement: CameraTourPlacement.bottom,
    requiresMode: GuideViewMode.ghostZoom,
    radius: AppRadius.full,
  ),
];
