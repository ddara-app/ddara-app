import 'package:ddara/core/model/group/create_group.dart';

import '../../repository/group_repository.dart';

class CreateGroupUseCase {
  final GroupRepository _groupRepository;

  CreateGroupUseCase(this._groupRepository);

  Future<CreateGroup> call(
    String groupName,
    String description,
    String nickName,
  ) async {
    final createGroup = await _groupRepository.createGroup(
      groupName,
      description,
      nickName
    );

    return createGroup;
  }
}
