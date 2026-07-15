import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';

/// [AppTextButton] 글자 크기 변형.
enum AppTextButtonVariant {
  /// 제일 작은 글자. (기본색 [AppColors.textTertiary])
  caption,

  /// 본문 크기 글자. (기본색은 [AppText.body] 기본색)
  body,
}

/// 배경·테두리 없이 텍스트만 있는 버튼.
///
/// 약관 보기·"나중에 할게요" 같은 부가 액션에 쓴다.
/// 패딩 없이 글자 영역만 탭 대상이 된다.
/// 기본 생성자는 caption 크기, [AppTextButton.body] 는 본문 크기다.
/// [color] 를 주지 않으면 변형별 기본색을 사용한다.
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.textAlign = TextAlign.center,
  }) : variant = AppTextButtonVariant.caption;

  const AppTextButton.body({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.textAlign = TextAlign.center,
  }) : variant = AppTextButtonVariant.body;

  final String label;
  final VoidCallback? onPressed;

  /// 글자 색. null 이면 변형별 기본색을 사용한다.
  final Color? color;
  final TextAlign textAlign;
  final AppTextButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: switch (variant) {
        // caption 은 부가 액션 기본색으로 textTertiary 를 강제한다.
        AppTextButtonVariant.caption => AppText.caption(
          label,
          textAlign: textAlign,
          color: color ?? AppColors.textTertiary,
        ),
        AppTextButtonVariant.body => AppText.body(
          label,
          textAlign: textAlign,
          color: color,
        ),
      },
    );
  }
}
