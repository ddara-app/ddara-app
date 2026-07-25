import 'package:ddara/domain/repository/block_repository.dart';

/// 내가 차단한 사용자 userId 집합을 조회한다.
///
/// 차단 목록 조회가 실패해도 화면(사진·썸네일 가림이 동반되는 목록)을 막지
/// 않도록, 실패 시 빈 집합으로 대체한다. (가림이 한 번 빠질 뿐 치명적이지 않다)
/// 이 실패 폴백 정책을 여러 화면에서 공유하기 위해 별도 유스케이스로 둔다.
class GetBlockedUserIdsUseCase {
  final BlockRepository _blockRepository;

  GetBlockedUserIdsUseCase(this._blockRepository);

  Future<Set<int>> call() async {
    try {
      final blockedUsers = await _blockRepository.getBlockedUsers();
      return blockedUsers.users.map((user) => user.userId).toSet();
    } catch (_) {
      return const {};
    }
  }
}
