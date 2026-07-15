import '../../repository/group_repository.dart';

class ExitGroupUseCase {
  final GroupRepository _groupRepository;

  ExitGroupUseCase(this._groupRepository);

  Future<void> call(int groupId) async {
    await _groupRepository.exitGroup(groupId);
  }
}
