import 'package:ddara/core/model/group/change_nickname.dart';
import 'package:ddara/core/model/group/create_group.dart';
import 'package:ddara/core/model/group/history_cycles.dart';
import 'package:ddara/core/model/group/invite_group.dart';

import '../../core/model/group/group_detail.dart';
import '../../core/model/group/group_list.dart';
import '../../core/model/group/join_group.dart';

abstract interface class GroupRepository {
  Future<CreateGroup> createGroup(
    String groupName,
    String description,
    String nickName,
  );

  Future<GroupList> getGroupList();

  Future<GroupDetail> getGroupDetail(int groupId);

  Future<InviteGroup> getInviteGroup(String inviteCode);

  Future<JoinGroup> joinGroup(String inviteCode, String nickName);

  Future<void> exitGroup(int groupId);

  Future<HistoryCycles> getHistoryCycles(int groupId);

  Future<ChangeNickName> changeNickName(int groupId, String nickName);
}
