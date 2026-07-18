import '../../repository/block_repository.dart';

class UnblockUserUseCase {
  final BlockRepository _blockRepository;

  UnblockUserUseCase(this._blockRepository);

  Future<void> call(int userId) async {
    await _blockRepository.unblockUser(userId);
  }
}
