import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_image_response.freezed.dart';
part 'profile_image_response.g.dart';

@freezed
abstract class ProfileImageResponse with _$ProfileImageResponse {
  const factory ProfileImageResponse({
    // 업로드 후 서버가 반환하는 새 프로필 이미지 URL.
    required String profileImageUrl,
  }) = _ProfileImageResponse;

  factory ProfileImageResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageResponseFromJson(json);
}
