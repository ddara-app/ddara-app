import 'package:ddara/core/model/group/group_list.dart';

class HomeState {
  final List<Group> groups;

  /// 내가 차단한 사용자 userId 집합. (차단한 멤버의 썸네일을 가리는 데 사용)
  final Set<int> blockedUserIds;

  final bool isLoading;
  final String errorMessage;

  const HomeState({
    this.groups = const [],
    this.blockedUserIds = const {},
    this.isLoading = false,
    this.errorMessage = '',
  });

  HomeState copyWith({
    List<Group>? groups,
    Set<int>? blockedUserIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      groups: groups ?? this.groups,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
