import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

/// 앱 전역 테마. 현재는 다크 모드만 지원한다.
abstract final class AppTheme {
  const AppTheme._();

  /// 다크 모드 시스템 UI 오버레이 스타일.
  ///
  /// 배경이 어둡기 때문에 상태바/내비게이션 바 아이콘은 밝게(light) 표시한다.
  /// CupertinoApp 에는 [AppBarTheme] 같은 자동 적용 경로가 없으므로
  /// `main` 의 [SystemChrome.setSystemUIOverlayStyle] 또는 화면별
  /// `AnnotatedRegion` 으로 직접 적용한다.
  static const SystemUiOverlayStyle systemOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Color(0x00000000),
    statusBarIconBrightness: Brightness.light, // Android
    statusBarBrightness: Brightness.dark, // iOS
    systemNavigationBarColor: AppColors.bgBase,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  /// 다크 Cupertino 테마.
  ///
  /// `brightness` 를 [Brightness.dark] 로 고정해 기기 설정과 무관하게
  /// 항상 다크 모드로 동작한다. (CupertinoApp 에는 `themeMode` 가 없다.)
  /// `applyThemeToAll` 로 하위 Material 위젯에도 테마가 전파되게 한다.
  static const CupertinoThemeData dark = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.accentDefault,
    primaryContrastingColor: AppColors.textOnAccent,
    scaffoldBackgroundColor: AppColors.bgBase,
    barBackgroundColor: AppColors.bgBase,
    applyThemeToAll: true,
    textTheme: CupertinoTextThemeData(
      primaryColor: AppColors.textPrimary,
      textStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        decoration: TextDecoration.none,
      ),
    ),
  );
}
