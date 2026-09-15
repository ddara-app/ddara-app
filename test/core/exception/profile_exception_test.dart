import 'package:ddara/core/exception/profile_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileException.fromCode', () {
    test('USER_NOT_FOUND → UserNotFoundException', () {
      expect(
        ProfileException.fromCode('USER_NOT_FOUND'),
        isA<UserNotFoundException>(),
      );
    });

    test('INVALID_IMAGE_FILE → InvalidImageFileException', () {
      expect(
        ProfileException.fromCode('INVALID_IMAGE_FILE'),
        isA<InvalidImageFileException>(),
      );
    });

    test('INVALID_INPUT → InvalidInputException', () {
      expect(
        ProfileException.fromCode('INVALID_INPUT'),
        isA<InvalidInputException>(),
      );
    });

    test('매칭되지 않는 code 는 null', () {
      expect(ProfileException.fromCode('UNKNOWN_CODE'), isNull);
    });

    test('code 가 null 이어도 null', () {
      expect(ProfileException.fromCode(null), isNull);
    });
  });
}
