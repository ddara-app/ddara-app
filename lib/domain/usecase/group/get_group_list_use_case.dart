import 'package:ddara/core/model/group/group_list.dart';

import '../../repository/group_repository.dart';

class GetGroupListUseCase {
  final GroupRepository _groupRepository;

  GetGroupListUseCase(this._groupRepository);

  Future<GroupList> call() async {
    return await _groupRepository.getGroupList();
  }
}
