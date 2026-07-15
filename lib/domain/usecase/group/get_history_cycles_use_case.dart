import 'package:ddara/core/model/group/history_cycles.dart';
import 'package:ddara/domain/repository/group_repository.dart';

class GetHistoryCyclesUseCase {
  final GroupRepository _groupRepository;

  GetHistoryCyclesUseCase(this._groupRepository);

  Future<HistoryCycles> call(int groupId) async {
    return await _groupRepository.getHistoryCycles(groupId);
  }
}
