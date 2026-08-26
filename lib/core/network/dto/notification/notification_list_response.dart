import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_list_response.freezed.dart';
part 'notification_list_response.g.dart';

@freezed
abstract class NotificationListResponse with _$NotificationListResponse {
  const factory NotificationListResponse({
    required List<NotificationItemResponse> items,
    // 아직 읽지 않은 알림 개수. (배지 표시 등에 사용)
    @Default(0) int unreadCount,
  }) = _NotificationListResponse;

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);
}

@freezed
abstract class NotificationItemResponse with _$NotificationItemResponse {
  const factory NotificationItemResponse({
    required int id,
    // 알림 종류. (예: 'MEMBER_JOIN', 'NEW_CYCLE')
    required String type,
    // 알림 종류별로 스키마가 다른 부가 정보. (해당 종류에 없는 필드는 null)
    required NotificationPayloadResponse payload,
    // 아직 읽지 않은 경우 null.
    required DateTime? readAt,
    required DateTime createdAt,
  }) = _NotificationItemResponse;

  factory NotificationItemResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemResponseFromJson(json);
}

@freezed
abstract class NotificationPayloadResponse with _$NotificationPayloadResponse {
  const factory NotificationPayloadResponse({
    // 관련 모임 id/이름.
    required int? groupId,
    required String? groupName,
    // 참여자 정보가 있는 알림(MEMBER_JOIN 등)에만 존재.
    required String? actorNickname,
    // 사이클 관련 알림(NEW_CYCLE·CYCLE_COMPLETED·DEADLINE·FRIEND_SHOT·COMMENT)에만 존재.
    required int? cycleId,
    // 대상 사진 id. (FRIEND_SHOT·COMMENT 에 존재)
    int? shotId,
    // 사이클 마감 시각. (NEW_CYCLE·DEADLINE 에 존재)
    DateTime? deadlineAt,
    // 서버가 계산한 마감까지 남은 단계. 60·30·5·1 중 하나. (DEADLINE 에 존재)
    int? remainingMinutes,
    // 알림 썸네일 이미지 URL. 사진이 딸린 알림(NEW_CYCLE·CYCLE_COMPLETED 의
    // 스타터 가이드샷, FRIEND_SHOT·COMMENT 의 인증샷)에만 값이 오고,
    // 나머지는 null 이다. (검토 중·삭제된 사진도 null)
    required String? imageUrl,
    // 썸네일이 신고 접수로 검토 중인지 여부.
    // (NEW_CYCLE·CYCLE_COMPLETED·FRIEND_SHOT·COMMENT 에 존재)
    bool? imageUnderReview,
    // 썸네일이 잠긴 사진인지 여부. 잠겨도 imageUrl 은 그대로 온다.
    // (FRIEND_SHOT·COMMENT 에 존재)
    bool? locked,
    // 썸네일을 올린 스타터의 userId. (NEW_CYCLE·CYCLE_COMPLETED 에 존재)
    int? starterUserId,
    // 댓글이 달린 사진의 주인. (COMMENT 에 존재)
    // isMyShot 이 false 면 문구에 이 닉네임을 넣어 남의 사진임을 알린다.
    int? shotOwnerUserId,
    String? shotOwnerNickname,
    // 댓글이 달린 사진이 내 사진인지 여부. (COMMENT 에 존재)
    bool? isMyShot,
  }) = _NotificationPayloadResponse;

  factory NotificationPayloadResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadResponseFromJson(json);
}
