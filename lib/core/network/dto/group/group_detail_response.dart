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
    // 다음 사이클의 스타터. 아직 지정되지 않았으면 null.
    required GroupNextStarterResponse? nextStarter,
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
abstract class GroupNextStarterResponse with _$GroupNextStarterResponse {
  const factory GroupNextStarterResponse({
    required int userId,
    required String nickname,
    // 스타터가 지정된 시각. (서버 미제공 시 null)
    DateTime? assignedAt,
    // 이 모임에서 랜덤 스타터 공개를 이미 봤는지 여부. (서버 미제공 시 false)
    @Default(false) bool seen,
  }) = _GroupNextStarterResponse;

  factory GroupNextStarterResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupNextStarterResponseFromJson(json);
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
    // 스타터 사진이 신고 접수로 검토 중인지 여부.
    required bool starterImageUnderReview,
    required String status,
    required DateTime startedAt,
    required DateTime deadlineAt,
    // 이번 사이클에 사진을 올린 멤버 userId 목록. (서버 미제공 시 빈 목록)
    @Default(<int>[]) List<int> uploadedUserIds,
  }) = _GroupCycleResponse;

  factory GroupCycleResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupCycleResponseFromJson(json);
}
