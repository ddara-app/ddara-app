import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 소셜 로그인 버튼. (브랜드 색 기반 · 전체폭 · 좌측 브랜드 아이콘)
class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  /// 브랜드 아이콘 한 변 크기.
  static const double _iconSize = 20;

  final String label;

  /// 좌측에 표시할 브랜드 아이콘 SVG 에셋 경로.
  final String iconPath;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onPressed: onPressed,
      // 아이콘은 왼쪽 끝(버튼 패딩 16 안쪽)에 고정, 라벨은 버튼 정중앙.
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: _iconSize, height: _iconSize),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.headlineMedium.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // 아이콘 폭만큼 우측을 비워 라벨이 버튼 정중앙에 오도록 보정.
          const SizedBox(width: _iconSize),
        ],
      ),
    );
  }
}
