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
    // 다음 사이클의 스타터. 아직 지정되지 않았으면 null.
    required GroupNextStarter? nextStarter,
    required DateTime createdAt,
  }) = _GroupDetail;
}

@freezed
abstract class GroupNextStarter with _$GroupNextStarter {
  const factory GroupNextStarter({
    required int userId,
    required String nickname,
    // 랜덤 스타터 공개를 이미 봤는지 여부. (진입 시 재노출 여부 판단에 사용)
    @Default(false) bool seen,
  }) = _GroupNextStarter;
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
    // 스타터 사진이 신고 접수로 검토 중인지 여부.
    required bool starterImageUnderReview,
    required String status,
    required DateTime startedAt,
    required DateTime deadlineAt,
    // 이번 사이클에 사진을 올린 멤버 userId 목록. (미제출 프로필을 흐리게 표시하는 데 사용)
    @Default(<int>[]) List<int> uploadedUserIds,
  }) = _GroupCycle;
}
