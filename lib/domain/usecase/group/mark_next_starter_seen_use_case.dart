import '../../repository/group_repository.dart';

/// 랜덤 스타터 공개를 확인했다고 서버에 표시한다.
/// (이후 모임 진입 시 이미 본 멤버에게는 공개 화면을 다시 띄우지 않기 위함)
class MarkNextStarterSeenUseCase {
  final GroupRepository _groupRepository;

  MarkNextStarterSeenUseCase(this._groupRepository);

  Future<void> call(int groupId) async {
    await _groupRepository.markNextStarterSeen(groupId);
  }
}
