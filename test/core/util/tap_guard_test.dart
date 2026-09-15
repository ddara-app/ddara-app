import 'package:ddara/core/util/tap_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('busy 가 true 면 콜백과 무관하게 null 을 반환한다', () {
    void callback() {}

    expect(tapGuard(true, callback), isNull);
  });

  test('busy 가 false 면 콜백을 그대로 반환한다', () {
    void callback() {}

    expect(tapGuard(false, callback), same(callback));
  });

  test('콜백이 이미 null 이면 busy 와 무관하게 null 을 유지한다', () {
    expect(tapGuard<void Function()>(false, null), isNull);
  });
}
