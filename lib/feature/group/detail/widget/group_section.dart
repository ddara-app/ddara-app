import 'package:ddara/core/design_system/foundation/app_spacing.dart';
import 'package:flutter/cupertino.dart';

/// 모임 상세의 한 섹션. 상단 [title](헤드라인·액션 행 등) 아래 [body](콘텐츠)를 쌓는다.
class GroupSection extends StatelessWidget {
  const GroupSection({
    super.key,
    required this.title,
    required this.body,
    this.spacing = AppSpacing.s5,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
  });

  /// 섹션 제목 영역. (예: 헤드라인, 또는 헤드라인 + 더보기 버튼 Row)
  final Widget title;

  /// 섹션 본문 영역. (예: 멤버 목록, 지난 따라찍기 목록)
  final Widget body;

  /// [title] 과 [body] 사이 세로 간격.
  final double spacing;

  /// [title] 좌우 여백. body 는 가장자리까지 채우되 제목만 안쪽으로 들여쓴다.
  final EdgeInsetsGeometry titlePadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing,
      children: [Padding(padding: titlePadding, child: title), body],
    );
  }
}
