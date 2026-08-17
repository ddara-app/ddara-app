import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_payload.freezed.dart';

/// 알림 종류별로 스키마가 다른 부가 정보를 평탄하게 펼친 모델.
/// 해당 종류에 존재하지 않는 필드는 null 이다.
@freezed
abstract class NotificationPayload with _$NotificationPayload {
  const factory NotificationPayload({
    required int? groupId,
    required String? groupName,
    // MEMBER_JOIN·FRIEND_SHOT·COMMENT 등 참여자 정보가 있는 알림에만 존재.
    required String? actorNickname,
    // NEW_CYCLE 등 사이클 관련 알림에만 존재.
    required int? cycleId,
    // 대상 사진 id. FRIEND_SHOT·COMMENT 외에는 null.
    required int? shotId,
    // 사이클 마감 시각. DEADLINE 알림에서 남은 시간 계산에 사용. 없으면 null.
    required DateTime? deadlineAt,
    // 서버가 계산한 마감까지 남은 단계(60·30·5·1). DEADLINE 알림에만 존재.
    required int? remainingMinutes,
    // 알림 썸네일 이미지 URL. 사진이 딸린 알림(NEW_CYCLE·CYCLE_COMPLETED 의
    // 스타터 가이드샷, FRIEND_SHOT·COMMENT 의 인증샷)에만 값이 오고,
    // 나머지는 null → 기본 썸네일.
    required String? imageUrl,
    // 썸네일이 신고 접수로 검토 중인지 여부.
    // (NEW_CYCLE·CYCLE_COMPLETED·FRIEND_SHOT·COMMENT 에만 존재)
    required bool imageUnderReview,
    // 썸네일이 잠긴 사진인지 여부. 잠겨도 imageUrl 은 그대로 오므로,
    // 사진을 지우는 대신 블러로 가린다. (FRIEND_SHOT·COMMENT 에만 존재)
    required bool locked,
    // 썸네일을 올린 스타터의 userId. NEW_CYCLE·CYCLE_COMPLETED 외에는 null.
    required int? starterUserId,
    // 댓글이 달린 사진의 주인. COMMENT 외에는 null.
    required int? shotOwnerUserId,
    required String? shotOwnerNickname,
    // 댓글이 달린 사진이 내 사진인지 여부. (COMMENT 에만 의미가 있다)
    // 값이 오지 않는 알림 종류는 false 로 취급한다.
    required bool isMyShot,
  }) = _NotificationPayload;
}
