import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/widgets.dart';

/// 페이지 공용 스크롤 본문.
///
/// 콘텐츠가 화면에 들어가면 스크롤 없음, 작은 기기·큰 글자 설정에서는 스크롤로
/// 전환되도록 뷰포트 높이를 최소 높이로 강제한다. 페이지 표준 패딩 정책을
/// 한곳에 모은다 — 상 s3 · 좌우 s5(16, Page 규칙) · 하 s6 + Safe Area 인셋
/// (하단까지 배경을 잇되 마지막 항목이 홈 인디케이터와 겹치지 않도록).
class ScrollablePageBody extends StatelessWidget {
  const ScrollablePageBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            // 패딩이 스크롤 범위에 더해져 항상 스크롤되지 않도록
            // (minHeight 초과) ConstrainedBox 안쪽에 둔다.
            padding: EdgeInsets.only(
              top: AppSpacing.s3,
              left: AppSpacing.s5,
              right: AppSpacing.s5,
              bottom: AppSpacing.s6 + MediaQuery.of(context).padding.bottom,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
