import 'package:ddara/l10n/app_localizations.dart';

/// 모임 참여(`POST /api/groups/join`) 실패 시 서버가 내려주는 에러 코드.
///
/// enum 은 서버 코드 값만 갖고, 사용자 노출 문구는 화면에서
/// [GroupJoinErrorCodeMessage.message] 로 l10n 매핑한다.
enum GroupJoinErrorCode {
  invalidInput('INVALID_INPUT'),
  invalidInviteCode('INVALID_INVITE_CODE'),
  groupNotFound('GROUP_NOT_FOUND'),
  alreadyJoinedGroup('ALREADY_JOINED_GROUP'),
  groupFull('GROUP_FULL'),
  groupLimitExceeded('GROUP_LIMIT_EXCEEDED'),
  duplicateGroupNickname('DUPLICATE_GROUP_NICKNAME'),

  /// 네트워크 오류 등 매칭되는 서버 코드가 없을 때의 기본값.
  unknown('UNKNOWN');

  const GroupJoinErrorCode(this.value);

  final String value;

  /// 서버 응답의 code 문자열을 enum 으로 역매핑. 매칭 실패 시 null.
  static GroupJoinErrorCode? fromValue(String? value) {
    for (final code in GroupJoinErrorCode.values) {
      if (code.value == value) return code;
    }
    return null;
  }
}

extension GroupJoinErrorCodeMessage on GroupJoinErrorCode {
  /// 에러 코드를 사용자 노출 문구로 매핑한다. (초대 코드 입력·참여 화면 공용)
  String message(AppLocalizations l10n) {
    return switch (this) {
      GroupJoinErrorCode.invalidInput => l10n.groupJoinErrorInvalidInput,
      GroupJoinErrorCode.invalidInviteCode => l10n.groupJoinErrorInvalidCode,
      GroupJoinErrorCode.groupNotFound => l10n.groupJoinErrorGroupNotFound,
      GroupJoinErrorCode.alreadyJoinedGroup => l10n.groupJoinErrorAlreadyJoined,
      GroupJoinErrorCode.groupFull => l10n.groupJoinErrorGroupFull,
      GroupJoinErrorCode.groupLimitExceeded => l10n.groupJoinErrorLimitExceeded,
      GroupJoinErrorCode.duplicateGroupNickname =>
        l10n.groupJoinErrorDuplicateNickname,
      GroupJoinErrorCode.unknown => l10n.groupJoinErrorUnknown,
    };
  }
}
