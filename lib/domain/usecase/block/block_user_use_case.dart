import '../../repository/block_repository.dart';

class BlockUserUseCase {
  final BlockRepository _blockRepository;

  BlockUserUseCase(this._blockRepository);

  Future<void> call(int userId, {required int groupId}) async {
    await _blockRepository.blockUser(userId, groupId: groupId);
  }
}
