import 'package:freezed_annotation/freezed_annotation.dart';

part 'starter_upload_response.freezed.dart';
part 'starter_upload_response.g.dart';

@freezed
abstract class StarterUploadResponse with _$StarterUploadResponse {
  const factory StarterUploadResponse({
    required int cycleId,
    required int groupId,
    required int cycleNumber,
    required String topic,
    required int starterUserId,
    required String status,
    required DateTime startedAt,
    required DateTime deadlineAt,
    required StarterShotResponse starterShot,
  }) = _StarterUploadResponse;

  factory StarterUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$StarterUploadResponseFromJson(json);
}

@freezed
abstract class StarterShotResponse with _$StarterShotResponse {
  const factory StarterShotResponse({
    required int shotId,
    required String imageUrl,
    required String type,
  }) = _StarterShotResponse;

  factory StarterShotResponse.fromJson(Map<String, dynamic> json) =>
      _$StarterShotResponseFromJson(json);
}
