import 'package:ddara/core/model/group/group_list.dart';

/// 홈(모임 목록) 화면 상태. 로딩·실패·완료가 상호배타인 sealed 설계라
/// "로딩 중인데 에러", "목록 있는데 에러 화면" 같은 조합이 타입상 불가능하다.
sealed class HomeState {
  const HomeState();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

/// 초기 조회 실패. (본문에 안내 문구를 표시)
final class HomeLoadError extends HomeState {
  const HomeLoadError(this.message);

  final String message;
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required this.groups, required this.blockedUserIds});

  /// 참여 중인 모임 목록. (비어 있으면 빈 상태 화면)
  final List<Group> groups;

  /// 내가 차단한 사용자 userId 집합. (차단한 멤버의 썸네일을 가리는 데 사용)
  final Set<int> blockedUserIds;
}
