import 'package:ddara/core/router/gallery_navigation.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/group/detail/util/group_page_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// 실제 화면 대신, 어떤 경로·extra 로 진입했는지 바로 알아볼 수 있게
/// 표시만 하는 자리표시 위젯.
class _Placeholder extends StatelessWidget {
  const _Placeholder(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(label);
}

/// production 의 home > group > cycle 중첩 구조를 그대로 흉내낸 최소 라우터.
/// (route_path.dart 의 경로 문자열과 정확히 일치해야 goXxx/pushXxx 가 맞물린다)
GoRouter _buildRouter({required String initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: RoutePath.home,
        builder: (_, _) => const _Placeholder('home'),
        routes: [
          GoRoute(
            path: 'group/:groupId',
            builder: (_, state) {
              final extra = state.extra;
              final args = extra is GroupPageArgs ? extra : null;
              return _Placeholder(
                'group:${state.pathParameters['groupId']}:${args?.groupName}',
              );
            },
            routes: [
              GoRoute(
                path: 'cycle/:cycleId',
                builder: (_, state) =>
                    _Placeholder('cycle:${state.pathParameters['cycleId']}'),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePath.notification,
        builder: (_, _) => const _Placeholder('notification'),
      ),
    ],
  );
}

Future<void> _pump(WidgetTester tester, GoRouter router) {
  return tester.pumpWidget(MaterialApp.router(routerConfig: router));
}

void main() {
  group('goCycleGallery', () {
    testWidgets('홈 > 모임 > 갤러리 스택을 한 번에 구성한다', (tester) async {
      final router = _buildRouter(initialLocation: RoutePath.home);
      await _pump(tester, router);

      goCycleGallery(router, groupId: 1, cycleId: 2, groupName: '내모임');
      await tester.pumpAndSettle();

      expect(router.state.uri.toString(), '/home/group/1/cycle/2');
      expect(find.text('cycle:2'), findsOneWidget);

      // 뒤로가기는 갤러리 → 모임 → 홈 순서로 이어진다.
      expect(router.canPop(), true);
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('group:1:내모임'), findsOneWidget);

      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('home'), findsOneWidget);
      expect(router.canPop(), false);
    });

    testWidgets('groupName 을 생략해도 진입할 수 있다', (tester) async {
      final router = _buildRouter(initialLocation: RoutePath.home);
      await _pump(tester, router);

      goCycleGallery(router, groupId: 5, cycleId: 9);
      await tester.pumpAndSettle();

      expect(find.text('cycle:9'), findsOneWidget);
    });
  });

  group('pushCycleGallery', () {
    testWidgets('모임 상세를 거치지 않고 갤러리만 스택 위에 쌓는다', (tester) async {
      final router = _buildRouter(initialLocation: RoutePath.notification);
      await _pump(tester, router);
      expect(find.text('notification'), findsOneWidget);

      pushCycleGallery(router, groupId: 1, cycleId: 2);
      await tester.pumpAndSettle();

      expect(find.text('cycle:2'), findsOneWidget);
      // 중간에 모임 상세가 끼지 않으므로, 한 번만 pop 하면 바로 알림 목록이다.
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('notification'), findsOneWidget);
    });
  });

  group('pushGroup', () {
    testWidgets('알림 목록 위에 모임 상세만 쌓는다', (tester) async {
      final router = _buildRouter(initialLocation: RoutePath.notification);
      await _pump(tester, router);

      pushGroup(router, groupId: 3, groupName: '스터디');
      await tester.pumpAndSettle();

      expect(find.text('group:3:스터디'), findsOneWidget);
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('notification'), findsOneWidget);
    });
  });

  group('goGroup', () {
    testWidgets('홈 > 모임 스택을 구성한다', (tester) async {
      final router = _buildRouter(initialLocation: RoutePath.home);
      await _pump(tester, router);

      goGroup(router, groupId: 7, groupName: '독서모임');
      await tester.pumpAndSettle();

      expect(router.state.uri.toString(), '/home/group/7');
      expect(find.text('group:7:독서모임'), findsOneWidget);

      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('home'), findsOneWidget);
    });
  });
}
