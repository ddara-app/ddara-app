import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_detail.freezed.dart';

@freezed
abstract class GroupDetail with _$GroupDetail {
  const factory GroupDetail({
    required int groupId,
    required String name,
    required String inviteCode,
    required List<GroupMember> members,
    // 진행 중인 사이클이 없으면 null.
    required GroupCycle? currentCycle,
    required DateTime createdAt,
  }) = _GroupDetail;
}

@freezed
abstract class GroupMember with _$GroupMember {
  const factory GroupMember({
    required int userId,
    required String nickname,
    required String? profileImageUrl,
    required String role,
  }) = _GroupMember;
}

@freezed
abstract class GroupCycle with _$GroupCycle {
  const factory GroupCycle({
    required int cycleId,
    required int cycleNumber,
    required String topic,
    required int starterUserId,
    required String starterNickname,
    required String? starterImageUrl,
    required String status,
    required DateTime startedAt,
    required DateTime deadlineAt,
  }) = _GroupCycle;
}
