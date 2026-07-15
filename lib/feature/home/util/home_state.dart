import 'package:ddara/core/model/group/group_list.dart';

class HomeState {
  final List<Group> groups;
  final bool isLoading;
  final String errorMessage;

  const HomeState({
    this.groups = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  HomeState copyWith({
    List<Group>? groups,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      groups: groups ?? this.groups,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
