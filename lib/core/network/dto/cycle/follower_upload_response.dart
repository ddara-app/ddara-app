import 'package:freezed_annotation/freezed_annotation.dart';

part 'follower_upload_response.freezed.dart';
part 'follower_upload_response.g.dart';

@freezed
abstract class FollowerUploadResponse with _$FollowerUploadResponse {
  const factory FollowerUploadResponse({
    required int shotId,
    required int cycleId,
    required int userId,
    // 사진 종류. (팔로워 사진은 'member')
    required String type,
    required String imageUrl,
    required DateTime uploadedAt,
  }) = _FollowerUploadResponse;

  factory FollowerUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$FollowerUploadResponseFromJson(json);
}
