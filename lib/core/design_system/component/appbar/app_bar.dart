import 'dart:math' as math;

import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/foundation/app_icons.dart';
import 'package:ddara/core/design_system/foundation/app_spacing.dart';
import 'package:ddara/core/design_system/theme/app_colors.dart';
import 'package:ddara/core/design_system/theme/app_theme.dart';
import 'package:ddara/core/design_system/theme/app_typography.dart';
import 'package:flutter/cupertino.dart';
// 이 파일의 클래스 이름이 Material 의 AppBar 와 같으므로 별칭으로 가져온다.
import 'package:flutter/material.dart' as material;

/// AppBar 아이콘 버튼 한 변 크기. (아이콘 24 + 내부 여백 12×2)
const double _buttonSize = 48;

/// AppBar 아이콘 크기. (leading·trailing 공통 스펙)
const double _iconSize = 24;

/// 아이콘(24)이 버튼(48) 안에서 가운데 정렬되며 생기는 한쪽 여백(12).
/// leading/trailing 슬롯 여백에서 이만큼 빼서 아이콘을 본문 패딩에 정렬한다.
/// (슬롯 4 + 내부 여백 12 = 아이콘 왼쪽 끝 16 = s5)
const double _iconInset = (_buttonSize - _iconSize) / 2;

/// 뒤로가기 chevron 글리프의 광학 보정값.
///
/// `arrow_back_ios_new` 는 획 폭이 24px 박스보다 좁아 박스 중앙에 그려지므로,
/// 박스를 s5 에 정렬해도 **보이는 획**은 그보다 오른쪽에서 시작한다. 글리프를
/// 이만큼 왼쪽으로 당겨 획 시작점이 s5 에 오도록 맞춘다. (실기기에서 획
/// 시작점을 재서 조정할 것 — 터치 영역에는 영향 없음)
const double _backGlyphOpticalOffset = 5;

/// 앱 공통 상단 바. ([CupertinoPageScaffold.navigationBar] 에 사용)
///
/// 내부 구현은 Material [material.AppBar] 를 사용하되, 겉모습(높이 44 ·
/// 가운데 제목 · 다크 배경)과 API 는 기존 CupertinoNavigationBar 시절과
/// 동일하게 유지한다. [CupertinoPageScaffold.navigationBar] 가 요구하는
/// [ObstructingPreferredSizeWidget] 을 그대로 구현하므로 호출부는 변경이 없다.
///
/// MaterialApp(ThemeData) 이 없는 앱이라 `Theme.of` 는 라이트 폴백을
/// 반환한다 — 색·정렬·높이 등 테마 유래 값은 전부 명시적으로 지정한다.
///
/// 아이콘 스펙은 leading(뒤로가기)·trailing 동일: 아이콘 24 · 터치 영역 48.
/// trailing 에는 [AppBarIconButton] 을 사용해야 여백 보정이 맞아떨어진다.
///
/// - 기본: 좌측 뒤로가기 버튼 + 가운데 제목.
/// - [showBackButton] 이 false 면 뒤로가기 버튼을 숨긴다. (제목만 표시 등)
/// - [leading] 을 지정하면 뒤로가기 버튼 대신 그 위젯을 사용한다. (예: 홈 로고)
/// - [trailing] 으로 우측 액션(알림/프로필 등)을 둘 수 있다.
///
/// ```dart
/// // 뒤로가기 + 제목
/// AppBar(title: '모임 만들기')
/// // 제목만
/// AppBar(title: '권한 안내', showBackButton: false)
/// // 커스텀 leading/trailing
/// AppBar(showBackButton: false, leading: Logo(), trailing: ...)
/// ```
class AppBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  const AppBar({
    super.key,
    this.title,
    this.onBack,
    this.showBackButton = true,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.padding = const EdgeInsetsDirectional.only(
      start: AppSpacing.s5,
      end: AppSpacing.s5,
    ),
  });

  /// 가운데 제목. null 이면 제목을 표시하지 않는다.
  final String? title;

  /// 뒤로가기 콜백. null 이면 기본 동작([Navigator.maybePop])을 한다.
  final VoidCallback? onBack;

  /// 뒤로가기 버튼 표시 여부. ([leading] 이 지정되면 무시)
  final bool showBackButton;

  /// 좌측 커스텀 위젯. 지정 시 뒤로가기 버튼 대신 사용한다.
  final Widget? leading;

  /// 우측 액션 위젯. 아이콘 버튼은 [AppBarIconButton] 을 쓴다.
  final Widget? trailing;

  /// 배경색. null 이면 Cupertino 테마 기본값.
  final Color? backgroundColor;

  /// 좌우 여백. (아이콘 기준 — 버튼 내부 여백은 슬롯 계산에서 보정)
  final EdgeInsetsDirectional padding;

  @override
  Widget build(BuildContext context) {
    final backButton = showBackButton
        ? AppBarIconButton(
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            // 글리프의 광학 여백만큼 왼쪽으로 당겨 보이는 획을 s4 에 정렬한다.
            child: Transform.translate(
              offset: const Offset(-_backGlyphOpticalOffset, 0),
              // 커스텀 chevron SVG. (테스트용 — Material rounded 아이콘과 비교 중)
              child: const AppIcon(
                AppIcons.back,
                size: _iconSize,
                color: AppColors.textPrimary,
              ),
            ),
          )
        : null;

    // Material 의 leading 슬롯은 고정폭(leadingWidth)이라, 슬롯별 배치를
    // 케이스에 따라 나눈다. (아래 지역 변수들을 조합해 AppBar 에 전달)
    Widget? leadingSlot;
    double? leadingWidth;
    Widget? titleSlot = title == null
        ? null
        : Text(
            title!,
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          );
    var centerTitle = true;

    if (leading != null) {
      if (title == null) {
        // 커스텀 leading(홈 로고 등)은 폭을 알 수 없어 고정폭 leading 슬롯에
        // 넣으면 잘린다. title 이 없을 때는 가변폭인 title 슬롯에 좌측 정렬로
        // 배치한다. (현재 커스텀 leading 사용처는 모두 title 이 없다)
        titleSlot = Padding(
          padding: EdgeInsetsDirectional.only(start: padding.start),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: leading,
          ),
        );
        centerTitle = false;
      } else {
        // 커스텀 leading + 제목 조합은 기본 슬롯 폭(56)에 배치된다.
        // 넓은 leading 이 필요해지면 leadingWidth 산정을 추가할 것.
        leadingSlot = Padding(
          padding: EdgeInsetsDirectional.only(start: padding.start),
          child: leading,
        );
      }
    } else if (backButton != null) {
      // 버튼 내부 좌측 여백(_iconInset)만큼 시작 여백에서 빼서, 아이콘 왼쪽
      // 끝이 정확히 padding.start 에 오게 한다.
      final slotStart = math.max(0.0, padding.start - _iconInset);
      leadingSlot = Padding(
        padding: EdgeInsetsDirectional.only(start: slotStart),
        child: backButton,
      );
      leadingWidth = slotStart + _buttonSize;
    }

    final bg = CupertinoDynamicColor.maybeResolve(
      backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor,
      context,
    );

    return material.AppBar(
      // leading 은 항상 직접 제어한다.
      automaticallyImplyLeading: false,
      backgroundColor: bg,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      // 스크롤 콘텐츠가 아래로 지나가도 배경 틴트/그림자가 생기지 않게 한다.
      scrolledUnderElevation: 0,
      surfaceTintColor: AppColors.bgTransparent,
      shadowColor: AppColors.bgTransparent,
      // Cupertino 시절 높이를 유지한다. (Material 기본 56 → 44)
      toolbarHeight: preferredSize.height,
      centerTitle: centerTitle,
      titleSpacing: 0,
      // 상태바 아이콘 스타일을 앱 전역 설정(main)과 동일하게 유지한다.
      systemOverlayStyle: AppTheme.systemOverlayStyle,
      leadingWidth: leadingWidth,
      leading: leadingSlot,
      title: titleSlot,
      actions: _buildActions(),
    );
  }

  /// trailing 을 actions 로 변환한다.
  ///
  /// leading 과 동일한 조건: trailing 이 [AppBarIconButton] 이면 그 버튼의
  /// 내부 여백만큼 끝 여백에서 빼서 아이콘을 padding.end 에 정렬한다.
  /// Row 등 복합 위젯은 여백을 호출부가 책임지므로 padding.end 를 그대로 쓴다.
  List<Widget>? _buildActions() {
    final trailing = this.trailing;
    if (trailing == null) return null;

    final inset = trailing is AppBarIconButton ? trailing.contentInset : 0.0;
    return [
      Padding(
        padding: EdgeInsetsDirectional.only(
          end: math.max(0.0, padding.end - inset),
        ),
        child: trailing,
      ),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    final bg =
        CupertinoDynamicColor.maybeResolve(
          backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor,
          context,
        ) ??
        AppColors.bgTransparent;
    return bg.a >= 1.0;
  }
}

/// [AppBar] 좌우에 쓰는 공통 아이콘 버튼.
///
/// 스펙은 leading·trailing 동일: **아이콘 24 · 터치 영역 48**.
/// 아이콘이 버튼 안에서 가운데 정렬되며 생기는 여백은 [AppBar] 가 슬롯
/// 여백에서 보정하므로, 이 버튼을 써야 아이콘이 본문 패딩과 정렬된다.
class AppBarIconButton extends StatelessWidget {
  const AppBarIconButton({
    super.key,
    required this.child,
    this.onPressed,
    this.size = _iconSize,
    this.hugContent = false,
  });

  /// [size]×[size] 로 그려질 아이콘 콘텐츠. (Icon · SvgPicture 등)
  final Widget child;

  /// 탭 콜백. null 이면 비활성(흐리게) 표시된다.
  final VoidCallback? onPressed;

  /// 아이콘 콘텐츠 한 변 크기. 기본 24. (예외: 홈 프로필 아바타 32)
  final double size;

  /// true 면 버튼이 콘텐츠 크기에 딱 맞는다. (최소 크기 해제 → 내부 여백 없음)
  /// 프로필 아바타처럼 콘텐츠 자체가 시각적 버튼일 때 사용한다.
  final bool hugContent;

  /// 버튼 내부에서 콘텐츠 바깥에 생기는 한쪽 여백.
  /// ([AppBar] 가 trailing 끝 여백 보정에 사용)
  double get contentInset =>
      hugContent ? 0 : math.max(0, (_buttonSize - size) / 2);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      // 기본 최소 크기(44) 대신 디자인 스펙(_buttonSize = 48)을 적용한다.
      minimumSize: hugContent ? Size.zero : const Size.square(_buttonSize),
      onPressed: onPressed,
      child: SizedBox.square(
        dimension: size,
        child: Center(child: child),
      ),
    );
  }
}
