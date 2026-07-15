import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_detail_response.freezed.dart';
part 'group_detail_response.g.dart';

@freezed
abstract class GroupDetailResponse with _$GroupDetailResponse {
  const factory GroupDetailResponse({
    required int groupId,
    required String name,
    required String description,
    required String inviteCode,
    required int ownerUserId,
    required int memberCount,
    required List<GroupMemberResponse> members,
    // 진행 중인 사이클이 없으면 null.
    required GroupCycleResponse? currentCycle,
    // 현재 사용자가 새 사이클을 시작할 수 있는지 여부.
    required bool canStartCycle,
    required DateTime createdAt,
  }) = _GroupDetailResponse;

  factory GroupDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupDetailResponseFromJson(json);
}

@freezed
abstract class GroupMemberResponse with _$GroupMemberResponse {
  const factory GroupMemberResponse({
    required int userId,
    required String nickname,
    required String? profileImageUrl,
    required String role,
  }) = _GroupMemberResponse;

  factory GroupMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberResponseFromJson(json);
}

@freezed
abstract class GroupCycleResponse with _$GroupCycleResponse {
  const factory GroupCycleResponse({
    required int cycleId,
    required int cycleNumber,
    required String topic,
    required int starterUserId,
    required String starterNickname,
    required String? starterImageUrl,
    required String status,
    required DateTime startedAt,
    required DateTime deadlineAt,
  }) = _GroupCycleResponse;

  factory GroupCycleResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupCycleResponseFromJson(json);
}
