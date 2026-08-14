import 'package:ddara/domain/model/group/create_group.dart';
import 'package:ddara/domain/model/group/change_nickname.dart';
import 'package:ddara/domain/model/group/cycle_gallery.dart';
import 'package:ddara/domain/model/group/cycle_shot_status.dart';
import 'package:ddara/domain/model/group/group_detail.dart';
import 'package:ddara/domain/model/group/group_list.dart';
import 'package:ddara/domain/model/group/history_cycles.dart';
import 'package:ddara/domain/model/group/history_list.dart';
import 'package:ddara/domain/model/group/invite_group.dart';
import 'package:ddara/domain/model/group/join_group.dart';
import 'package:ddara/core/network/dto/group/create_group_response.dart';
import 'package:ddara/core/network/dto/group/change_nickname_response.dart';
import 'package:ddara/core/network/dto/group/cycle_gallery_response.dart';
import 'package:ddara/core/network/dto/group/group_detail_response.dart';
import 'package:ddara/core/network/dto/group/group_list_response.dart';
import 'package:ddara/core/network/dto/group/history_cycles_response.dart';
import 'package:ddara/core/network/dto/group/invite_group_response.dart';
import 'package:ddara/core/network/dto/group/join_group_response.dart';

extension CreateGroupMapper on CreateGroupResponse {
  CreateGroup toDomain() {
    return CreateGroup(groupId: groupId);
  }
}

extension JoinGroupMapper on JoinGroupResponse {
  JoinGroup toDomain() {
    return JoinGroup(groupId: groupId);
  }
}

extension InviteGroupMapper on InviteGroupResponse {
  InviteGroup toDomain() {
    return InviteGroup(
      groupId: groupId,
      name: name,
      ownerNickname: ownerNickname,
      memberCount: memberCount,
      isFull: isFull,
      memberAvatars: memberAvatars,
      alreadyJoined: alreadyJoined,
      createdAt: createdAt,
    );
  }
}

extension GroupDetailMapper on GroupDetailResponse {
  GroupDetail toDomain() {
    final cycle = currentCycle;
    final next = nextStarter;

    return GroupDetail(
      groupId: groupId,
      name: name,
      inviteCode: inviteCode,
      members: members
          .map(
            (member) => GroupMember(
              userId: member.userId,
              nickname: member.nickname,
              profileImageUrl: member.profileImageUrl,
              role: member.role,
            ),
          )
          .toList(),
      currentCycle: cycle == null
          ? null
          : GroupCycle(
              cycleId: cycle.cycleId,
              cycleNumber: cycle.cycleNumber,
              topic: cycle.topic,
              starterUserId: cycle.starterUserId,
              starterNickname: cycle.starterNickname,
              starterImageUrl: cycle.starterImageUrl,
              starterImageUnderReview: cycle.starterImageUnderReview,
              status: cycle.status,
              startedAt: cycle.startedAt,
              deadlineAt: cycle.deadlineAt,
              uploadedUserIds: cycle.uploadedUserIds,
            ),
      nextStarter: next == null
          ? null
          : GroupNextStarter(
              userId: next.userId,
              nickname: next.nickname,
              seen: next.seen,
            ),
      createdAt: createdAt,
    );
  }
}

extension ChangeNickNameMapper on ChangeNickNameResponse {
  ChangeNickName toDomain() {
    return ChangeNickName(nickname: nickname);
  }
}

extension HistoryCyclesMapper on HistoryCyclesResponse {
  /// 모임 페이지 프리뷰용. (통계·참가자 목록은 버리고 카드에 필요한 필드만)
  HistoryCycles toGroupHistory() {
    return HistoryCycles(
      cycles: cycles
          .map(
            (cycle) => HistoryCycle(
              cycleId: cycle.cycleId,
              topic: cycle.topic,
              thumbnailUrl: cycle.thumbnailUrl,
              thumbnailUnderReview: cycle.thumbnailUnderReview,
              starterUserId: cycle.starterUserId,
              participantCount: cycle.participantCount,
              date: cycle.date,
            ),
          )
          .toList(),
    );
  }

  /// 더보기 화면용. (통계 + 참가자 목록까지 포함)
  /// 서버가 stats 를 안 주면 0/0 으로 채운다.
  HistoryList toHistoryList() {
    return HistoryList(
      stats: HistoryStats(
        myCount: stats?.myCount ?? 0,
        totalCount: stats?.totalCount ?? 0,
      ),
      cycles: cycles
          .map(
            (cycle) => HistoryListCycle(
              cycleId: cycle.cycleId,
              topic: cycle.topic,
              thumbnailUrl: cycle.thumbnailUrl,
              thumbnailUnderReview: cycle.thumbnailUnderReview,
              starterUserId: cycle.starterUserId,
              participantCount: cycle.participantCount,
              participants: cycle.participants
                  .map(
                    (participant) => HistoryParticipant(
                      userId: participant.userId,
                      profileImageUrl: participant.profileImageUrl,
                    ),
                  )
                  .toList(),
              date: cycle.date,
            ),
          )
          .toList(),
    );
  }
}

extension CycleGalleryMapper on CycleGalleryResponse {
  CycleGallery toDomain() {
    return CycleGallery(
      groupId: groupId,
      groupName: groupName,
      cycle: CycleGalleryCycle(
        cycleId: cycle.cycleId,
        cycleNumber: cycle.cycleNumber,
        topic: cycle.topic,
        starterUserId: cycle.starterUserId,
        starterNickname: cycle.starterNickname,
        starterShotId: cycle.starterShotId,
        starterImageUrl: cycle.starterImageUrl,
        starterImageUnderReview: cycle.starterImageUnderReview,
        hasUnreadComments: cycle.hasUnreadComments,
        status: cycle.status,
        deadlineAt: cycle.deadlineAt,
      ),
      viewerUploaded: viewerUploaded,
      members: members
          .map(
            (member) => CycleGalleryMember(
              userId: member.userId,
              shotId: member.shotId,
              nickname: member.nickname,
              profileImageUrl: member.profileImageUrl,
              isStarter: member.isStarter,
              status: CycleShotStatus.from(member.status),
              imageUrl: member.imageUrl,
              uploadedAt: member.uploadedAt,
              hasUnreadComments: member.hasUnreadComments,
            ),
          )
          .toList(),
    );
  }
}

extension GroupListMapper on GroupListResponse {
  GroupList toDomain() {
    return GroupList(
      groups: groups
          .map(
            (group) => Group(
              groupId: group.groupId,
              name: group.name,
              ownerNickname: group.ownerNickname,
              memberCount: group.memberCount,
              thumbnailUrl: group.thumbnailUrl,
              thumbnailUnderReview: group.thumbnailUnderReview,
              thumbnailUserId: group.thumbnailUserId,
              currentCycle: group.currentCycle == null
                  ? null
                  : CurrentCycle(
                      cycleId: group.currentCycle!.cycleId,
                      topic: group.currentCycle!.topic,
                      deadlineAt: group.currentCycle!.deadlineAt,
                    ),
              showStarterBorder: group.showStarterBorder,
            ),
          )
          .toList(),
    );
  }
}
