import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_group_response.freezed.dart';
part 'invite_group_response.g.dart';

@freezed
abstract class InviteGroupResponse with _$InviteGroupResponse {
  const factory InviteGroupResponse({
    required int groupId,
    required String name,
    required String description,
    required String ownerNickname,
    required int memberCount,
    required int capacity,
    required bool isFull,
    required List<String?> memberAvatars,
    required bool alreadyJoined,
    required DateTime createdAt,
  }) = _InviteGroupResponse;

  factory InviteGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$InviteGroupResponseFromJson(json);
}
