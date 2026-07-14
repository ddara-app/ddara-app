import 'package:flutter/material.dart';

/// Primitive 컬러 팔레트 (Figma `Primitive` collection - Default mode).
///
/// 원시 토큰으로, UI 코드에서 직접 사용하기보다 [AppColors] 같은
/// Semantic 토큰을 통해 참조하는 것을 권장한다.
abstract final class AppColorPrimitives {
  const AppColorPrimitives._();

  // Sky
  static const Color sky50 = Color(0xFFF2F7FE);
  static const Color sky100 = Color(0xFFD6E6FC);
  static const Color sky200 = Color(0xFFC3DAFA);
  static const Color sky300 = Color(0xFFA7C9F8);
  static const Color sky400 = Color(0xFF96BEF6);
  static const Color sky500 = Color(0xFF7CAEF4);
  static const Color sky600 = Color(0xFF719EDE);
  static const Color sky700 = Color(0xFF587CAD);
  static const Color sky800 = Color(0xFF446086);
  static const Color sky900 = Color(0xFF344966);

  // Cream
  static const Color cream50 = Color(0xFFFEFEFB);
  static const Color cream100 = Color(0xFFFDFBF2);
  static const Color cream200 = Color(0xFFFBF9EC);
  static const Color cream300 = Color(0xFFFAF6E4);
  static const Color cream400 = Color(0xFFF9F4DE);
  static const Color cream500 = Color(0xFFF7F1D6);
  static const Color cream600 = Color(0xFFE1DBC3);
  static const Color cream700 = Color(0xFFAFAB98);
  static const Color cream800 = Color(0xFF888576);
  static const Color cream900 = Color(0xFF68655A);

  // Grayscale
  static const Color grayscale50 = Color(0xFFF3F3F4);
  static const Color grayscale100 = Color(0xFFE8E8E8);
  static const Color grayscale200 = Color(0xFFD0D1D1);
  static const Color grayscale300 = Color(0xFFB9B9BB);
  static const Color grayscale400 = Color(0xFFA2A2A4);
  static const Color grayscale500 = Color(0xFF8A8B8D);
  static const Color grayscale600 = Color(0xFF737476);
  static const Color grayscale700 = Color(0xFF5C5D5F);
  static const Color grayscale800 = Color(0xFF454549);
  static const Color grayscale900 = Color(0xFF2D2E32);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF16171B);

  // Green
  static const Color green50 = Color(0xFFE9F9EF);
  static const Color green100 = Color(0xFFBAEDCD);
  static const Color green200 = Color(0xFF99E4B5);
  static const Color green300 = Color(0xFF6BD893);
  static const Color green400 = Color(0xFF4ED17E);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green600 = Color(0xFF1FB356);
  static const Color green700 = Color(0xFF188C43);
  static const Color green800 = Color(0xFF136C34);
  static const Color green900 = Color(0xFF0E5327);

  // Yellow
  static const Color yellow50 = Color(0xFFFEF5E7);
  static const Color yellow100 = Color(0xFFFCE1B3);
  static const Color yellow200 = Color(0xFFFAD28F);
  static const Color yellow300 = Color(0xFFF8BE5C);
  static const Color yellow400 = Color(0xFFF7B13C);
  static const Color yellow500 = Color(0xFFF59E0B);
  static const Color yellow600 = Color(0xFFDF900A);
  static const Color yellow700 = Color(0xFFAE7008);
  static const Color yellow800 = Color(0xFF875706);
  static const Color yellow900 = Color(0xFF674205);

  // Red
  static const Color red50 = Color(0xFFFDECEC);
  static const Color red100 = Color(0xFFFAC5C5);
  static const Color red200 = Color(0xFFF8A9A9);
  static const Color red300 = Color(0xFFF48282);
  static const Color red400 = Color(0xFFF26969);
  static const Color red500 = Color(0xFFEF4444);
  static const Color red600 = Color(0xFFD93E3E);
  static const Color red700 = Color(0xFFAA3030);
  static const Color red800 = Color(0xFF832525);
  static const Color red900 = Color(0xFF641D1D);

  // Alpha
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white40 = Color(0x66FFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white80 = Color(0xCCFFFFFF);
  static const Color black20 = Color(0x33000000);
  static const Color black40 = Color(0x66000000);
  static const Color black60 = Color(0x99000000);
  static const Color black80 = Color(0xCC000000);
}
