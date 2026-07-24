import 'package:ddara/core/exception/group_create_error.dart';

class CreateGroupState {
  final String groupName;
  final String description;
  final String nickname;

  final bool isLoading;
  final int createGroupId;

  /// 생성 실패 종류. 없으면 null. (사용자 문구는 화면에서 l10n 매핑)
  final GroupCreateError? errorCode;

  const CreateGroupState({
    this.groupName = '',
    this.description = '',
    this.nickname = '',
    this.isLoading = false,
    this.createGroupId = -1,
    this.errorCode,
  });

  CreateGroupState copyWith({
    String? groupName,
    String? description,
    String? nickname,
    bool? isLoading,
    int? createGroupId,
    GroupCreateError? errorCode,
    // errorCode 를 null 로 되돌린다. (입력 변경·요청 시작 시 이전 에러 해제용)
    bool clearErrorCode = false,
  }) {
    return CreateGroupState(
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      nickname: nickname ?? this.nickname,
      isLoading: isLoading ?? this.isLoading,
      createGroupId: createGroupId ?? this.createGroupId,
      errorCode: clearErrorCode ? null : (errorCode ?? this.errorCode),
    );
  }
}
