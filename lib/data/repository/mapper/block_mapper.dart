import 'package:ddara/core/model/block/blocked_users.dart';
import 'package:ddara/core/network/dto/block/block_list_response.dart';

extension BlockListMapper on BlockListResponse {
  BlockedUsers toDomain() {
    return BlockedUsers(
      users: blocks
          .map(
            (block) => BlockedUser(
              userId: block.userId,
              name: block.name,
              blockedAt: block.blockedAt,
            ),
          )
          .toList(),
    );
  }
}
