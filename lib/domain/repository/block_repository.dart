import 'package:ddara/core/model/block/blocked_users.dart';

abstract interface class BlockRepository {
  Future<void> blockUser(int userId, {required int groupId});

  Future<BlockedUsers> getBlockedUsers();

  Future<void> unblockUser(int userId);
}
