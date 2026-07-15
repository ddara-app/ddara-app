import 'package:ddara/core/model/group/create_group.dart';
import 'package:ddara/core/model/group/change_nickname.dart';
import 'package:ddara/core/model/group/cycle_gallery.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/model/group/history_cycles.dart';
import 'package:ddara/core/model/group/invite_group.dart';
import 'package:ddara/core/model/group/join_group.dart';
import 'package:ddara/core/network/dto/group/create_group_response.dart';
import 'package:ddara/core/network/dto/group/change_nickname_response.dart';
import 'package:ddara/core/network/dto/group/cycle_gallery_response.dart';
import 'package:ddara/core/network/dto/group/group_detail_response.dart';
import 'package:ddara/core/network/dto/group/group_list_response.dart';
import 'package:ddara/core/network/dto/group/history_cycles_response.dart';
import 'package:ddara/core/network/dto/group/invite_group_response.dart';
import 'package:ddara/core/network/dto/group/join_group_response.dart';

import '../../../core/model/group/group_list.dart';

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
              status: cycle.status,
              startedAt: cycle.startedAt,
              deadlineAt: cycle.deadlineAt,
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
  HistoryCycles toDomain() {
    return HistoryCycles(
      cycles: cycles
          .map(
            (cycle) => HistoryCycle(
              cycleId: cycle.cycleId,
              topic: cycle.topic,
              thumbnailUrl: cycle.thumbnailUrl,
              participantCount: cycle.participantCount,
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
        starterNickname: cycle.starterNickname,
        starterImageUrl: cycle.starterImageUrl,
        status: cycle.status,
        deadlineAt: cycle.deadlineAt,
      ),
      viewerUploaded: viewerUploaded,
      members: members
          .map(
            (member) => CycleGalleryMember(
              userId: member.userId,
              nickname: member.nickname,
              profileImageUrl: member.profileImageUrl,
              isStarter: member.isStarter,
              status: member.status,
              imageUrl: member.imageUrl,
              uploadedAt: member.uploadedAt,
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
              currentCycle: group.currentCycle == null
                  ? null
                  : CurrentCycle(
                      cycleId: group.currentCycle!.cycleId,
                      topic: group.currentCycle!.topic,
                      deadlineAt: group.currentCycle!.deadlineAt,
                    ),
            ),
          )
          .toList(),
    );
  }
}
