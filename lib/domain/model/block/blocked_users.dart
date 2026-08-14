import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocked_users.freezed.dart';

@freezed
abstract class BlockedUsers with _$BlockedUsers {
  const factory BlockedUsers({required List<BlockedUser> users}) =
      _BlockedUsers;
}

@freezed
abstract class BlockedUser with _$BlockedUser {
  const factory BlockedUser({
    required int userId,
    required String name,
    required String blockedNickname,
    required DateTime blockedAt,
  }) = _BlockedUser;
}
