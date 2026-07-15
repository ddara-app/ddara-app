import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:flutter/widgets.dart';

/// 화면 상단의 "큰 제목 + 설명" 한 묶음.
///
/// [title] 은 headlineLarge, [description] 은 body 로 표시하며 둘 사이 간격은
/// 항상 [AppSpacing.s1] 이다. [centered] 가 true 면 가운데 정렬, 아니면 좌측 정렬.
///
/// 약관 동의·권한 안내·모임 생성·온보딩 등 여러 화면의 머리말을 통일한다.
class TitleDescription extends StatelessWidget {
  const TitleDescription({
    super.key,
    required this.title,
    required this.description,
    this.centered = false,
  });

  /// 큰 제목. (headlineLarge)
  final String title;

  /// 제목 아래 설명. (body)
  final String description;

  /// 가운데 정렬 여부. (기본 좌측 정렬)
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final textAlign = centered ? TextAlign.center : null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      spacing: AppSpacing.s1,
      children: [
        AppText.headlineLarge(title, textAlign: textAlign),
        AppText.body(description, textAlign: textAlign),
      ],
    );
  }
}
