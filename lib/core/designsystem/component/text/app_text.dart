import 'package:ddara/core/designsystem/theme/app_colors.dart';
import 'package:ddara/core/designsystem/theme/app_typography.dart';
import 'package:flutter/widgets.dart';

/// 디자인시스템 공통 텍스트.
///
/// 타이포 스타일별 named constructor 로 생성하며, 스타일마다 기본색을 갖는다.
/// 색이 다른 경우 [color] 로 override 한다. (정렬은 [textAlign])
/// 한 줄 제한·줄임 처리는 [maxLines] 와 [overflow] 로 지정한다.
///
/// ```dart
/// AppText.headlineLarge('모임 만들기');
/// AppText.body('설명', color: AppColors.textPrimary); // 색 override
/// AppText.title(name, maxLines: 1, overflow: TextOverflow.ellipsis); // 한 줄 줄임
/// ```
class AppText extends StatelessWidget {
  /// Display · 화면에 한 번 쓰는 제일 큰 글자. (기본색 textPrimary)
  const AppText.display(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
  }) : _style = AppTypography.display,
       _defaultColor = AppColors.textPrimary;

  /// Headline/Large · 화면·섹션 제목. (기본색 textPrimary)
  const AppText.headlineLarge(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
  }) : _style = AppTypography.headlineLarge,
       _defaultColor = AppColors.textPrimary;

  /// Headline/Medium · 여러 줄 소제목. (기본색 textPrimary)
  const AppText.headlineMedium(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
  }) : _style = AppTypography.headlineMedium,
       _defaultColor = AppColors.textPrimary;

  /// Title · 한 줄 카드·항목 제목. (기본색 textPrimary)
  const AppText.title(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
  }) : _style = AppTypography.title,
       _defaultColor = AppColors.textPrimary;

  /// Label · 버튼·탭·칩 글자. (기본색 textSecondary)
  const AppText.label(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
  }) : _style = AppTypography.label,
       _defaultColor = AppColors.textSecondary;

  /// Body · 본문·설명. (기본색 textSecondary)
  const AppText.body(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
  }) : _style = AppTypography.body,
       _defaultColor = AppColors.textSecondary;

  /// Caption · 시간·상태 등 제일 작은 글자. (기본색 textSecondary)
  const AppText.caption(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
  }) : _style = AppTypography.caption,
       _defaultColor = AppColors.textSecondary;

  final String text;
  final TextAlign? textAlign;

  /// 색 override. null 이면 스타일별 기본색을 사용한다.
  final Color? color;

  /// 최대 줄 수. null 이면 제한 없음.
  final int? maxLines;

  /// 넘칠 때 처리 방식. (예: [TextOverflow.ellipsis]) null 이면 기본 동작.
  final TextOverflow? overflow;

  final TextStyle _style;
  final Color _defaultColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: _style.copyWith(color: color ?? _defaultColor),
    );
  }
}
