import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_payload.freezed.dart';

/// 알림 종류별로 스키마가 다른 부가 정보를 평탄하게 펼친 모델.
/// 해당 종류에 존재하지 않는 필드는 null 이다.
@freezed
abstract class NotificationPayload with _$NotificationPayload {
  const factory NotificationPayload({
    required int? groupId,
    required String? groupName,
    // MEMBER_JOIN 등 참여자 정보가 있는 알림에만 존재.
    required String? actorNickname,
    // NEW_CYCLE 등 사이클 관련 알림에만 존재.
    required int? cycleId,
    // 사이클 마감 시각. DEADLINE 알림에서 남은 시간 계산에 사용. 없으면 null.
    required DateTime? deadlineAt,
    // 서버가 계산한 마감까지 남은 분. DEADLINE 알림에만 존재.
    required int? remainingMinutes,
    // 알림 아바타에 쓸 이미지 URL. 없으면 null → 기본 아바타.
    required String? imageUrl,
  }) = _NotificationPayload;
}
