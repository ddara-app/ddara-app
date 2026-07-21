import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:ddara/core/widget/image/comment/photo_comment_sheet.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

/// 시트를 열린 상태(진행도 1)로 띄운다.
/// [sheetController] 를 주면 부모(PhotoViewer)처럼 닫힘 진행도를 흉내 낸다.
Future<void> pumpSheet(
  WidgetTester tester, {
  required int commentCount,
  AnimationController? sheetController,
  void Function(DragEndDetails details)? onDragEnd,
}) async {
  final comments = [
    for (var i = 0; i < commentCount; i++)
      PhotoComment(nickname: 'user$i', content: 'comment $i', timeLabel: 'now'),
  ];
  await tester.pumpWidget(
    CupertinoApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Stack(
        children: [
          PhotoCommentSheet(
            position:
                sheetController?.drive(
                  Tween(begin: const Offset(0, 1), end: Offset.zero),
                ) ??
                const AlwaysStoppedAnimation(Offset.zero),
            onDragProgress: (delta) {
              if (sheetController != null) sheetController.value += delta;
            },
            onDragEnd: onDragEnd ?? (_) {},
            onSubmitComment: (_) async => null,
            onLoadComments: () async => null,
            onEditComment: (_, _) async => null,
            onDeleteComment: (_) async => false,
            onReportComment: (_) {},
            onBlockComment: (_) async => false,
            comments: comments,
          ),
        ],
      ),
    ),
  );
  await tester.pump();
}

/// 시트(최상위 Positioned 박스)의 현재 높이.
double sheetHeight(WidgetTester tester) =>
    tester.getSize(find.byType(PhotoCommentSheet)).height;

void main() {
  // 테스트 화면은 800x600 — 기본 높이 0.65*600=390, 최대 0.9*600=540.
  const base = 390.0;
  const max = 540.0;

  testWidgets('댓글이 있어도 핸들·헤더 드래그로 확장되고, 이후 본문 드래그도 동작한다', (tester) async {
    await pumpSheet(tester, commentCount: 5);
    expect(sheetHeight(tester), base);

    // 핸들(시트 상단) 위치에서 위로 드래그 → 확장.
    // (목록의 유휴 goBallistic 이 끼어들어 확장을 되돌리는 버그 회귀 방지)
    final sheetTop = tester.getRect(find.byType(PhotoCommentSheet)).top;
    await tester.timedDragFrom(
      Offset(400, sheetTop + 10),
      const Offset(0, -300),
      const Duration(milliseconds: 300),
    );
    await tester.pumpAndSettle();
    expect(sheetHeight(tester), max);

    // 이어서 본문을 아래로 드래그 → 기본 높이로 축소도 동작해야 한다.
    await tester.timedDrag(
      find.byType(ListView),
      const Offset(0, 300),
      const Duration(milliseconds: 300),
    );
    await tester.pumpAndSettle();
    expect(sheetHeight(tester), base);
  });

  testWidgets('댓글이 없어도 본문 드래그로 확장·축소된다', (tester) async {
    await pumpSheet(tester, commentCount: 0);
    expect(sheetHeight(tester), base);

    await tester.timedDrag(
      find.byType(ListView),
      const Offset(0, -300),
      const Duration(milliseconds: 300),
    );
    await tester.pumpAndSettle();
    expect(sheetHeight(tester), max);

    await tester.timedDrag(
      find.byType(ListView),
      const Offset(0, 300),
      const Duration(milliseconds: 300),
    );
    await tester.pumpAndSettle();
    expect(sheetHeight(tester), base);
  });

  testWidgets('댓글이 적어도(스크롤 불가) 본문 위로 드래그로 시트가 확장된다', (tester) async {
    await pumpSheet(tester, commentCount: 2);
    expect(sheetHeight(tester), base);

    await tester.timedDrag(
      find.byType(ListView),
      const Offset(0, -300),
      const Duration(milliseconds: 300),
    );
    await tester.pumpAndSettle();
    expect(sheetHeight(tester), max);
  });

  testWidgets('댓글이 많으면 확장이 끝난 뒤에 목록이 스크롤된다', (tester) async {
    await pumpSheet(tester, commentCount: 40);

    await tester.timedDrag(
      find.byType(ListView),
      const Offset(0, -400),
      const Duration(milliseconds: 400),
    );
    await tester.pumpAndSettle();
    expect(sheetHeight(tester), max);

    final scrollable = tester.state<ScrollableState>(
      find.byType(Scrollable).first,
    );
    // 확장 구간 150px 을 뺀 나머지만 스크롤됐어야 한다. (0 보다 크면 스크롤 시작)
    expect(scrollable.position.pixels, greaterThan(0));
  });

  testWidgets('확장된 시트는 목록 최상단에서 아래로 드래그하면 기본 높이로 줄어든다', (tester) async {
    await pumpSheet(tester, commentCount: 2);
    await tester.timedDrag(
      find.byType(ListView),
      const Offset(0, -300),
      const Duration(milliseconds: 300),
    );
    await tester.pumpAndSettle();
    expect(sheetHeight(tester), max);

    await tester.timedDrag(
      find.byType(ListView),
      const Offset(0, 300),
      const Duration(milliseconds: 300),
    );
    await tester.pumpAndSettle();
    expect(sheetHeight(tester), base);
  });

  testWidgets('기본 높이에서 본문을 아래로 드래그하면 시트가 닫히는 쪽으로 내려간다', (tester) async {
    final controller = AnimationController(
      vsync: const TestVSync(),
      duration: PhotoCommentSheet.duration,
    )..value = 1;
    addTearDown(controller.dispose);
    DragEndDetails? dragEnd;
    await pumpSheet(
      tester,
      commentCount: 5,
      sheetController: controller,
      onDragEnd: (details) => dragEnd = details,
    );
    expect(sheetHeight(tester), base);

    await tester.timedDrag(
      find.byType(ListView),
      const Offset(0, 200),
      const Duration(milliseconds: 300),
    );
    await tester.pump();
    // 드래그한 만큼 닫힘 진행도가 줄고, 닫을지 되돌릴지 판단(드래그 종료)이
    // 부모에 전달돼야 한다.
    expect(controller.value, lessThan(1));
    expect(dragEnd, isNotNull);
    expect(dragEnd!.primaryVelocity, greaterThan(0));
  });

  testWidgets('목록이 스크롤돼 있으면 맨 위로 돌아온 뒤에 줄어든다', (tester) async {
    await pumpSheet(tester, commentCount: 40);
    // 확장 + 목록 스크롤까지 진행해 둔다.
    await tester.timedDrag(
      find.byType(ListView),
      const Offset(0, -400),
      const Duration(milliseconds: 400),
    );
    await tester.pumpAndSettle();
    final scrollable = tester.state<ScrollableState>(
      find.byType(Scrollable).first,
    );
    final scrolled = scrollable.position.pixels;
    expect(scrolled, greaterThan(0));

    // 스크롤된 양보다 조금 더 아래로 끌면, 맨 위 복귀에 먼저 쓰이고
    // 나머지만 축소에 쓰인다. (아직 최대 높이 근처여서 스냅은 최대로)
    await tester.timedDrag(
      find.byType(ListView),
      Offset(0, scrolled + 20),
      const Duration(milliseconds: 400),
    );
    await tester.pumpAndSettle();
    expect(scrollable.position.pixels, 0);
    expect(sheetHeight(tester), max);

    // 이제 맨 위이므로 이어서 아래로 끌면 기본 높이까지 줄어든다.
    await tester.timedDrag(
      find.byType(ListView),
      const Offset(0, 300),
      const Duration(milliseconds: 300),
    );
    await tester.pumpAndSettle();
    expect(sheetHeight(tester), base);
  });
}
