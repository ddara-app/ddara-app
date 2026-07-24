import 'package:ddara/core/exception/group_create_error.dart';

class CreateGroupState {
  /// 모임 이름 최대 길이.
  static const nameMaxLength = 20;

  /// 모임 소개 최대 길이.
  static const introMaxLength = 100;

  final String groupName;
  final String description;
  final String nickname;

  final bool isLoading;
  final int createGroupId;

  /// 생성 실패 종류. 없으면 null. (사용자 문구는 화면에서 l10n 매핑)
  final GroupCreateError? errorCode;

  /// 모임 이름이 최대 길이를 초과했는지.
  bool get isNameOverLength => groupName.length > nameMaxLength;

  /// 모임 소개가 최대 길이를 초과했는지.
  bool get isIntroOverLength => description.length > introMaxLength;

  /// 이름 스텝(0)의 다음 진행 가능 조건. (이름 필수 + 두 필드 길이 이내)
  bool get isNameStepValid =>
      groupName.trim().isNotEmpty && !isNameOverLength && !isIntroOverLength;

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
