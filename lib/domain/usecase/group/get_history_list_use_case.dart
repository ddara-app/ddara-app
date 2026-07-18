import 'package:ddara/core/model/group/history_list.dart';
import 'package:ddara/domain/repository/group_repository.dart';

/// 더보기 화면용 지난 따라찍기 조회. (통계 + 참가자 목록 포함)
class GetHistoryListUseCase {
  final GroupRepository _groupRepository;

  GetHistoryListUseCase(this._groupRepository);

  Future<HistoryList> call(int groupId, {int? year, int? month}) async {
    return await _groupRepository.getHistoryList(
      groupId,
      year: year,
      month: month,
    );
  }
}
