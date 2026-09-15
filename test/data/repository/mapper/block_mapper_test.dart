import 'package:ddara/core/network/dto/block/block_list_response.dart';
import 'package:ddara/data/repository/mapper/block_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlockListMapper', () {
    test('차단 목록 각 항목을 도메인 모델로 옮긴다', () {
      final blockedAt = DateTime(2026, 1, 1, 12);
      final response = BlockListResponse(
        blocks: [
          BlockedUserResponse(
            userId: 1,
            name: 'kim',
            blockedNickname: '닉네임',
            blockedAt: blockedAt,
          ),
        ],
      );

      final result = response.toDomain();

      expect(result.users, hasLength(1));
      final user = result.users.first;
      expect(user.userId, 1);
      expect(user.name, 'kim');
      expect(user.blockedNickname, '닉네임');
      expect(user.blockedAt, blockedAt);
    });

    test('빈 목록이면 빈 목록을 반환한다', () {
      const response = BlockListResponse(blocks: []);

      final result = response.toDomain();

      expect(result.users, isEmpty);
    });
  });
}
