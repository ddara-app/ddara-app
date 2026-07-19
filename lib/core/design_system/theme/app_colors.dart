import 'package:flutter/material.dart';

import '../foundation/app_color_primitives.dart';

abstract final class AppColors {
  const AppColors._();

  // Background
  static const Color bgBase = AppColorPrimitives.black;
  static const Color bgSurface = AppColorPrimitives.grayscale900;
  static const Color bgSurfaceAlt = AppColorPrimitives.grayscale800;
  static const Color bgWarm = AppColorPrimitives.cream100;

  // Text
  static const Color textPrimary = AppColorPrimitives.white;
  static const Color textSecondary = AppColorPrimitives.grayscale400;
  static const Color textTertiary = AppColorPrimitives.grayscale500;
  static const Color textDisabled = AppColorPrimitives.grayscale600;
  static const Color textOnAccent = AppColorPrimitives.black;
  static const Color textAccent = AppColorPrimitives.sky200;
  static const Color textLabel = AppColorPrimitives.grayscale200;
  static const Color textOnWarm = AppColorPrimitives.black;
  static const Color textOnWarmSecondary = AppColorPrimitives.grayscale700;

  // Accent
  static const Color accentDefault = AppColorPrimitives.sky500;
  static const Color accentPressed = AppColorPrimitives.sky700;
  static const Color accentSubtle = AppColorPrimitives.sky50;

  // Border
  static const Color borderDefault = AppColorPrimitives.grayscale800;
  static const Color borderStrong = AppColorPrimitives.grayscale700;
  static const Color borderSelected = AppColorPrimitives.sky500;
  static const Color borderOnWarm = AppColorPrimitives.cream600;

  // Status
  static const Color statusSuccess = AppColorPrimitives.green500;
  static const Color statusWarning = AppColorPrimitives.yellow500;
  static const Color statusDanger = AppColorPrimitives.red500;
  static const Color statusSuccessBg = AppColorPrimitives.green900;
  static const Color statusWarningBg = AppColorPrimitives.yellow900;
  static const Color statusDangerBg = AppColorPrimitives.red900;

  // Overlay
  static const Color overlayScrim = AppColorPrimitives.black60;
  static const Color overlayBlurTint = AppColorPrimitives.black40;
}
