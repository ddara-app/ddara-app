import 'package:ddara/core/model/group/group_detail.dart';

import '../../repository/group_repository.dart';

class GetGroupDetailUseCase {
  final GroupRepository _groupRepository;

  GetGroupDetailUseCase(this._groupRepository);

  Future<GroupDetail> call(int groupId) async {
    final response = await _groupRepository.getGroupDetail(groupId);
    return response;
  }
}
