import 'package:ddara/core/util/scroll_to_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// [controller] 를 붙인 스크롤 가능한 목록을 화면 크기보다 훨씬 길게 그린다.
/// (충분히 스크롤할 거리가 있어야 offset 을 밀어 넣을 수 있다)
Widget _scrollableList(ScrollController controller) {
  return MaterialApp(
    home: Scaffold(
      body: ListView.builder(
        controller: controller,
        itemCount: 200,
        itemBuilder: (context, index) => SizedBox(height: 50, child: Text('$index')),
      ),
    ),
  );
}

void main() {
  testWidgets('이미 최상단(offset<=0)이면 아무 애니메이션도 일으키지 않는다', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_scrollableList(controller));

    controller.animateToTop();
    await tester.pump();

    expect(controller.offset, 0);
  });

  testWidgets('스크롤된 상태에서 호출하면 최상단(0)으로 애니메이션한다', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_scrollableList(controller));
    controller.jumpTo(500);
    expect(controller.offset, 500);

    controller.animateToTop();
    await tester.pumpAndSettle();

    expect(controller.offset, 0);
  });

  testWidgets('멀리 스크롤되어 있어도 결국 최상단(0)에 도착한다', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_scrollableList(controller));
    controller.jumpTo(controller.position.maxScrollExtent);
    final farOffset = controller.offset;
    expect(farOffset, greaterThan(500));

    controller.animateToTop();
    await tester.pumpAndSettle();

    expect(controller.offset, 0);
  });

  testWidgets('아직 Scrollable 에 붙지 않은(hasClients=false) 컨트롤러는 예외 없이 무시한다', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    expect(controller.hasClients, false);
    expect(controller.animateToTop, returnsNormally);
  });
}
