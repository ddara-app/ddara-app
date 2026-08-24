import 'package:freezed_annotation/freezed_annotation.dart';

part 'unread_notification_response.freezed.dart';
part 'unread_notification_response.g.dart';

@freezed
abstract class UnreadNotificationResponse with _$UnreadNotificationResponse {
  const factory UnreadNotificationResponse({required bool hasUnread}) =
      _UnreadNotificationResponse;

  factory UnreadNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$UnreadNotificationResponseFromJson(json);
}
