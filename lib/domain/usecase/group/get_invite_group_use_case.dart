import 'package:ddara/core/model/group/invite_group.dart';
import 'package:ddara/domain/repository/group_repository.dart';

class GetInviteGroupUseCase {
  final GroupRepository _groupRepository;

  GetInviteGroupUseCase(this._groupRepository);

  Future<InviteGroup> call(String inviteCode) async {

    return await _groupRepository.getInviteGroup(inviteCode);
  }
}
