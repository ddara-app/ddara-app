import 'dart:async';

import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/feature/permission/util/permission_request_recovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 테스트 전용 위젯. [PermissionRequestRecovery] 를 실제 화면(PermissionPage 등)과
/// 같은 방식으로 섞어 쓴다.
class _Harness extends StatefulWidget {
  const _Harness();

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness>
    with WidgetsBindingObserver, PermissionRequestRecovery<_Harness> {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

Future<_HarnessState> _pumpHarness(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: _Harness()));
  return tester.state<_HarnessState>(find.byType(_Harness));
}

void main() {
  group('runBusy', () {
    testWidgets('실행 동안 isBusy 가 true 였다가 끝나면 false 로 돌아온다', (tester) async {
      final state = await _pumpHarness(tester);
      final gate = Completer<void>();

      final future = state.runBusy(() => gate.future);
      await tester.pump();
      expect(state.isBusy, true);

      gate.complete();
      await future;
      await tester.pump();

      expect(state.isBusy, false);
    });

    testWidgets('이미 진행 중이면 재호출은 무시한다', (tester) async {
      final state = await _pumpHarness(tester);
      var runCount = 0;
      final gate = Completer<void>();

      final first = state.runBusy(() {
        runCount++;
        return gate.future;
      });
      await tester.pump();
      final second = state.runBusy(() async {
        runCount++;
      });
      await second;

      expect(runCount, 1);

      gate.complete();
      await first;
    });

    testWidgets('action 이 실패해도 isBusy 는 false 로 돌아오고 예외는 전파된다', (tester) async {
      final state = await _pumpHarness(tester);

      await expectLater(
        () => state.runBusy(() async => throw Exception('fail')),
        throwsA(isA<Exception>()),
      );
      await tester.pump();

      expect(state.isBusy, false);
    });
  });

  group('awaitPermission', () {
    testWidgets('request 가 정상 완료되면 그 결과를 그대로 반환한다', (tester) async {
      final state = await _pumpHarness(tester);

      final result = await state.awaitPermission(
        () async => PermissionResult.granted,
        () async => PermissionResult.denied,
      );

      expect(result, PermissionResult.granted);
    });

    testWidgets('request 가 즉시 실패하면 readStatus 결과로 대체한다', (tester) async {
      final state = await _pumpHarness(tester);
      // 본문이 throw 뿐인 인라인 람다는 Future<Never> 로 추론돼 카드에서
      // catchError 매칭이 어긋난다(테스트 코드만의 함정). 명시적 시그니처로 선언한다.
      Future<PermissionResult> failingRequest() async {
        throw Exception('permission_handler busy');
      }

      final result = await state.awaitPermission(
        failingRequest,
        () async => PermissionResult.granted,
      );

      expect(result, PermissionResult.granted);
    });

    testWidgets(
      '뒤로가기로 다이얼로그가 닫혀 request 가 끝나지 않아도, 앱이 백그라운드→포그라운드로 '
      '돌아오면 readStatus 로 결과를 매듭짓는다',
      (tester) async {
        final state = await _pumpHarness(tester);
        // 뒤로가기로 유실된 콜백을 흉내낸다 — request() 의 Future 는 영영 완료되지 않는다.
        final stuckRequest = Completer<PermissionResult>();

        final resultFuture = state.awaitPermission(
          () => stuckRequest.future,
          () async => PermissionResult.granted,
        );

        // 권한 다이얼로그 때문에 앱이 백그라운드로 나갔다가(paused) 돌아온다(resumed).
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump();
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

        final result = await resultFuture;

        expect(result, PermissionResult.granted);
      },
    );

    testWidgets('한 번도 백그라운드로 나간 적 없는 resume(false positive)은 무시한다', (
      tester,
    ) async {
      final state = await _pumpHarness(tester);
      final stuckRequest = Completer<PermissionResult>();

      final resultFuture = state.awaitPermission(
        () => stuckRequest.future,
        () async => PermissionResult.granted,
      );

      // 백그라운드로 나간 적 없이 resumed 만 발생 — 매듭짓지 않는다.
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump(const Duration(milliseconds: 50));

      // request() 가 실제로 끝나면 그 결과를 그대로 쓴다.
      stuckRequest.complete(PermissionResult.denied);
      final result = await resultFuture;

      expect(result, PermissionResult.denied);
    });
  });
}
