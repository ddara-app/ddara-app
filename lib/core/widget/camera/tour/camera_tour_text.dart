import 'package:ddara/core/widget/camera/tour/camera_tour_step.dart';
import 'package:ddara/l10n/app_localizations.dart';

/// 스텝 제목. exhaustive switch 라 스텝을 추가하고 문구를 빠뜨리면 컴파일 에러다.
String cameraTourTitle(AppLocalizations l10n, CameraTourStepId id) =>
    switch (id) {
      CameraTourStepId.miniGuide => l10n.cameraTourMiniGuideTitle,
      CameraTourStepId.miniGuideFold => l10n.cameraTourMiniGuideFoldTitle,
      CameraTourStepId.modeToggle => l10n.cameraTourModeToggleTitle,
      CameraTourStepId.ghostGuide => l10n.cameraTourGhostGuideTitle,
      CameraTourStepId.opacity => l10n.cameraTourOpacityTitle,
    };

/// 스텝 본문.
String cameraTourBody(AppLocalizations l10n, CameraTourStepId id) =>
    switch (id) {
      CameraTourStepId.miniGuide => l10n.cameraTourMiniGuideBody,
      CameraTourStepId.miniGuideFold => l10n.cameraTourMiniGuideFoldBody,
      CameraTourStepId.modeToggle => l10n.cameraTourModeToggleBody,
      CameraTourStepId.ghostGuide => l10n.cameraTourGhostGuideBody,
      CameraTourStepId.opacity => l10n.cameraTourOpacityBody,
    };
