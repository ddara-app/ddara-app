import 'package:ddara/core/exception/group_exception.dart';

/// 신고 접수(`POST /api/reports`) 실패. (사진·댓글·유저·모임 신고 공통)
///
/// 서버 code 문자열 → 예외 매핑을 [fromCode] 한곳에 둔다.
sealed class ReportException implements Exception {
  /// 서버 응답의 code 문자열을 예외로 옮긴다. 매칭 실패 시 null —
  /// 호출부가 `?? NetworkException()` 으로 받는다.
  ///
  /// 신고는 대상이 사진·댓글·유저·모임이라 모임 쪽 예외도 함께 나온다.
  /// 그래서 반환 타입이 [ReportException] 이 아니라 [Exception] 이다.
  ///
  /// 401(UNAUTHORIZED)은 인터셉터가 따로 처리하므로 여기서 다루지 않는다.
  static Exception? fromCode(String? code) => switch (code) {
    'INVALID_INPUT' => InvalidReportInputException(),
    'NOT_GROUP_MEMBER' => NotGroupMemberException(),
    'SHOT_NOT_FOUND' => ShotNotFoundException(),
    'USER_NOT_FOUND' => ReportUserNotFoundException(),
    'GROUP_NOT_FOUND' => GroupNotFoundException(),
    _ => null,
  };
}

/// 400 — 필수값 누락, 본인 콘텐츠 신고, ETC 인데 reasonText 없음,
/// targetType 에 허용되지 않는 reasonCode, USER 인데 groupId 누락.
class InvalidReportInputException extends ReportException {}

/// 404 — 사진 없음. (운영 삭제된 사진 포함)
class ShotNotFoundException extends ReportException {}

/// 404 — 신고 대상 유저가 해당 모임의 멤버가 아니거나 없음.
class ReportUserNotFoundException extends ReportException {}
