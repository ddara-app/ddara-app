import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/widgets.dart';

/// 페이지 공용 스크롤 본문.
///
/// 뷰포트 높이를 최소 높이로 강제해 콘텐츠가 짧아도 배경이 화면을 채운다.
/// 콘텐츠가 다 들어가는 경우에도 당기면 반응하도록 iOS 식 바운스를 쓴다.
/// 페이지 표준 패딩 정책을 한곳에 모은다 — 상 s4 · 좌우 s5(16, Page 규칙) ·
/// 하 s7 + Safe Area 인셋 (하단까지 배경을 잇되 마지막 항목이 홈 인디케이터와
/// 겹치지 않도록).
class ScrollablePageBody extends StatelessWidget {
  const ScrollablePageBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        // 콘텐츠가 화면에 다 들어가도(AlwaysScrollable) 당기면 늘어났다
        // 돌아오도록(Bouncing) — 안드로이드에서도 iOS 와 같은 반응을 준다.
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            // 패딩이 스크롤 범위에 더해져 항상 스크롤되지 않도록
            // (minHeight 초과) ConstrainedBox 안쪽에 둔다.
            padding: EdgeInsets.only(
              top: AppSpacing.s4,
              left: AppSpacing.s5,
              right: AppSpacing.s5,
              bottom: AppSpacing.s7 + MediaQuery.of(context).padding.bottom,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
