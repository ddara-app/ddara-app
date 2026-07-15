import 'package:ddara/core/model/group/join_group.dart';

import '../../repository/group_repository.dart';

class JoinGroupUseCase {
  final GroupRepository _groupRepository;

  JoinGroupUseCase(this._groupRepository);

  Future<JoinGroup> call(String inviteCode, String nickName) async {

    return await _groupRepository.joinGroup(inviteCode, nickName);
  }
}
