class CreateGroupState {
  final String groupName;
  final String description;
  final String nickname;

  final bool isLoading;
  final int createGroupId;
  final String errorMessage;

  const CreateGroupState({
    this.groupName = '',
    this.description = '',
    this.nickname = '',
    this.isLoading = false,
    this.createGroupId = -1,
    this.errorMessage = '',
  });

  CreateGroupState copyWith({
    String? groupName,
    String? description,
    String? nickname,
    bool? isLoading,
    int? createGroupId,
    String? errorMessage,
  }) {
    return CreateGroupState(
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      nickname: nickname ?? this.nickname,
      isLoading: isLoading ?? this.isLoading,
      createGroupId: createGroupId ?? this.createGroupId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
