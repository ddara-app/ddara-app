import 'package:ddara/core/network/dto/cycle/follower_upload_response.dart';
import 'package:ddara/core/network/dto/cycle/starter_upload_response.dart';
import 'package:ddara/data/repository/mapper/cycle_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StarterUploadMapper', () {
    test('cycleId 만 도메인 모델로 옮긴다', () {
      final response = StarterUploadResponse(
        cycleId: 7,
        groupId: 1,
        cycleNumber: 2,
        topic: 'topic',
        starterUserId: 3,
        status: 'in_progress',
        startedAt: DateTime(2026, 1, 1),
        deadlineAt: DateTime(2026, 1, 2),
        starterShot: const StarterShotResponse(
          shotId: 9,
          imageUrl: 'https://img',
          type: 'starter',
        ),
      );

      final result = response.toDomain();

      expect(result.cycleId, 7);
    });
  });

  group('FollowerUploadMapper', () {
    test('cycleId 만 도메인 모델로 옮긴다', () {
      final response = FollowerUploadResponse(
        shotId: 1,
        cycleId: 8,
        userId: 2,
        type: 'member',
        imageUrl: 'https://img',
        uploadedAt: DateTime(2026, 1, 1),
      );

      final result = response.toDomain();

      expect(result.cycleId, 8);
    });
  });
}
