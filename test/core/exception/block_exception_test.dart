import 'package:ddara/core/exception/block_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlockException.fromCode', () {
    test('INVALID_INPUT → InvalidBlockInputException', () {
      expect(BlockException.fromCode('INVALID_INPUT'), isA<InvalidBlockInputException>());
    });

    test('USER_NOT_FOUND → BlockTargetNotFoundException', () {
      expect(BlockException.fromCode('USER_NOT_FOUND'), isA<BlockTargetNotFoundException>());
    });

    test('매칭되지 않는 code 는 null (호출부가 NetworkException 으로 대체)', () {
      expect(BlockException.fromCode('UNKNOWN_CODE'), isNull);
    });

    test('code 가 null 이어도 null', () {
      expect(BlockException.fromCode(null), isNull);
    });
  });
}
