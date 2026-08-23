import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 이름 라벨을 그대로 보여줄 최대 글자 수. (6자까지는 줄이지 않는다)
const int _maxNameLength = 6;

/// 줄일 때 남기는 글자 수. (7자 이상이면 앞 5자 + 말줄임표)
const int _truncatedNameLength = 5;

/// [name] 이 [_maxNameLength] 자를 초과하면 앞 [_truncatedNameLength] 자
/// + 말줄임표(…)로 줄인다.
///
/// 이모지 등 서로게이트 쌍이 잘리지 않도록 자소(grapheme) 단위로 센다.
String ellipsizeName(String name) {
  final chars = name.characters;
  if (chars.length <= _maxNameLength) return name;
  return '${chars.take(_truncatedNameLength)}…';
}

/// [child](원형 콘텐츠) 아래 caption 라벨을 둔 공통 레이아웃.
///
/// 멤버 아바타·추가 버튼처럼 "동그란 것 + 이름"이 짝을 이루는 자리에 쓴다.
/// [onTap] 을 주면 [child] 영역이 버튼이 된다.
///
/// 오버레이에 이 위젯의 사본을 띄우는 화면(롱프레스 컨텍스트 메뉴 등)이 원본과
/// 픽셀 단위로 겹치도록, 지름·간격·취소선 굵기를 상수로 노출한다.
class CircleAvatarLabel extends StatelessWidget {
  const CircleAvatarLabel({
    super.key,
    required this.child,
    required this.label,
    this.labelDecoration,
    this.labelColor,
    this.onTap,
  });

  /// 원형 콘텐츠의 기본 지름. (아바타·+버튼 공용)
  static const double circleSize = 60;

  /// 원형 콘텐츠와 라벨 사이 간격.
  static const double labelGap = AppSpacing.s3;

  /// 차단 멤버 닉네임 취소선 굵기. (폰트 기본 굵기의 배수)
  static const double strikeThickness = 2.0;

  /// 원형으로 보여줄 콘텐츠. (프로필 아바타 · 아이콘 등)
  final Widget child;

  /// 아래에 붙는 이름 라벨.
  final String label;

  /// 라벨 글자 장식. (예: 차단 멤버 취소선)
  final TextDecoration? labelDecoration;

  /// 라벨 글자색. null 이면 caption 기본색을 따른다.
  final Color? labelColor;

  /// [child] 를 눌렀을 때의 콜백. null 이면 탭에 반응하지 않는다.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: labelGap,
      children: [
        if (onTap != null)
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: onTap,
            child: child,
          )
        else
          child,
        AppText.caption(
          label,
          color: labelColor,
          decoration: labelDecoration,
          decorationThickness: strikeThickness,
        ),
      ],
    );
  }
}
