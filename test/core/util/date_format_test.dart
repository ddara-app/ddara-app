import 'package:ddara/core/util/date_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('null 이면 빈 문자열을 반환한다', () {
    expect(formatDate(null), '');
  });

  test('월·일이 한 자리면 0으로 패딩한다', () {
    final local = DateTime(2026, 1, 5);

    expect(formatDate(local), '2026.01.05');
  });
}
