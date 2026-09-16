import 'package:ddara/core/exception/notification_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationException.fromCode', () {
    test('NOTIFICATION_FORBIDDEN → NotificationForbiddenException', () {
      expect(
        NotificationException.fromCode('NOTIFICATION_FORBIDDEN'),
        isA<NotificationForbiddenException>(),
      );
    });

    test('NOTIFICATION_NOT_FOUND → NotificationNotFoundException', () {
      expect(
        NotificationException.fromCode('NOTIFICATION_NOT_FOUND'),
        isA<NotificationNotFoundException>(),
      );
    });

    test('매칭되지 않는 code 는 null', () {
      expect(NotificationException.fromCode('UNKNOWN_CODE'), isNull);
    });

    test('code 가 null 이어도 null', () {
      expect(NotificationException.fromCode(null), isNull);
    });
  });
}
