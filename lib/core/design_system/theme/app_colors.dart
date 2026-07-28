import 'package:flutter/material.dart';

import '../foundation/app_color_primitives.dart';

abstract final class AppColors {
  const AppColors._();

  // Background
  static const Color bgBase = AppColorPrimitives.black;
  static const Color bgSurface = AppColorPrimitives.grayscale900;
  static const Color bgSurfaceAlt = AppColorPrimitives.grayscale800;
  static const Color bgWarm = AppColorPrimitives.cream100;

  /// 배경을 칠하지 않는 표면. (아래 페이지 배경이 그대로 비친다 —
  /// 예: 눌렀을 때만 밝아지는 목록 아이템의 평상시 배경)
  static const Color bgTransparent = AppColorPrimitives.transparent;

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

  /// 짙은 강조 배경. (홈 대시보드 카드 그라데이션의 끝 색 등)
  static const Color bgAccentDeep = AppColorPrimitives.sky900;

  // Border
  static const Color borderDefault = AppColorPrimitives.grayscale800;
  static const Color borderStrong = AppColorPrimitives.grayscale700;

  /// [borderDefault] 보다 약한 경계. 영역을 나누되 시선을 끌지 않아야 하는
  /// 구분선에 쓴다. (예: 댓글 시트의 헤더·입력 영역 경계)
  static const Color borderSubtle = AppColorPrimitives.grayscale950;
  static const Color borderSelected = AppColorPrimitives.sky500;
  static const Color borderOnWarm = AppColorPrimitives.cream600;

  // Status
  static const Color statusSuccess = AppColorPrimitives.green500;
  static const Color statusWarning = AppColorPrimitives.yellow500;
  static const Color statusDanger = AppColorPrimitives.red500;

  /// 끝난 상태 표시. (진행 중을 뜻하는 [statusSuccess] 와 짝을 이루는 무채색 —
  /// 모임 카드의 '진행 종료' 인디케이터 등)
  static const Color statusClosed = AppColorPrimitives.grayscale800;

  static const Color statusSuccessBg = AppColorPrimitives.green900;
  static const Color statusWarningBg = AppColorPrimitives.yellow900;
  static const Color statusDangerBg = AppColorPrimitives.red900;

  // Overlay
  static const Color overlayScrim = AppColorPrimitives.black60;
  static const Color overlayBlurTint = AppColorPrimitives.black40;

  /// [overlayScrim] 보다 옅은 스크림. (사진을 어느 정도 비추면서 글자 대비를
  /// 확보해야 하는 곳 — 접힌 헤더 오버레이 등)
  static const Color overlayScrimSoft = AppColorPrimitives.black50;

  /// 사진 위에 얹는 컨트롤(버튼) 배경.
  static const Color overlayControl = AppColorPrimitives.gray12;

  /// 카드가 배경에서 살짝 떠 보이게 하는 그림자.
  static const Color shadowSoft = AppColorPrimitives.black10;
}
