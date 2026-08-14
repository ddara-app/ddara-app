import 'package:ddara/domain/model/block/blocked_users.dart';

import '../../repository/block_repository.dart';

class GetBlockedUsersUseCase {
  final BlockRepository _blockRepository;

  GetBlockedUsersUseCase(this._blockRepository);

  Future<BlockedUsers> call() async {
    return _blockRepository.getBlockedUsers();
  }
}
