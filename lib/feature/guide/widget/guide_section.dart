import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/widgets.dart';

/// 가이드 화면 본문의 '제목 + 내용' 한 쌍.
///
/// 제목 문구만 다르고 구성은 같아서, 섹션이 늘어도 이 위젯을 반복하면 된다.
/// 섹션끼리의 간격(s8)은 이 위젯이 아니라 나열하는 쪽이 정한다.
class GuideSection extends StatelessWidget {
  const GuideSection({super.key, required this.title, required this.child});

  /// 섹션 제목.
  final String title;

  /// 제목 아래에 오는 내용. 섹션마다 구성이 달라 위젯으로 받는다.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // 제목과 내용 사이 간격.
      spacing: AppSpacing.s6,
      children: [AppText.titleLarge(title), child],
    );
  }
}
