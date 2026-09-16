import 'package:ddara/core/util/refresh_with_min_duration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('refresh 가 금방 끝나도 최소 시간이 지날 때까지 완료되지 않는다', () async {
    var refreshed = false;
    final stopwatch = Stopwatch()..start();

    await refreshWithMinDuration(
      () async => refreshed = true,
      min: const Duration(milliseconds: 100),
    );

    stopwatch.stop();
    expect(refreshed, true);
    expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(100));
  });

  test('refresh 가 최소 시간보다 오래 걸리면 그 시간만큼 기다린다', () async {
    final stopwatch = Stopwatch()..start();

    await refreshWithMinDuration(
      () => Future<void>.delayed(const Duration(milliseconds: 150)),
      min: const Duration(milliseconds: 50),
    );

    stopwatch.stop();
    expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(150));
  });

  test('refresh 가 실패하면 예외를 그대로 전파한다', () async {
    expect(
      () => refreshWithMinDuration(
        () async => throw Exception('fail'),
        min: const Duration(milliseconds: 10),
      ),
      throwsA(isA<Exception>()),
    );
  });
}
