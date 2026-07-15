import 'package:ddara/core/model/group/change_nickname.dart';
import 'package:ddara/domain/repository/group_repository.dart';

class ChangeNicknameUseCase {
  final GroupRepository _groupRepository;

  ChangeNicknameUseCase(this._groupRepository);

  Future<ChangeNickName> call(int groupId, String nickName) async {
    return await _groupRepository.changeNickName(groupId, nickName);
  }
}
