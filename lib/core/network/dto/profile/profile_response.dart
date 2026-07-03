import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_response.freezed.dart';
part 'profile_response.g.dart';

@freezed
abstract class ProfileResponse with _$ProfileResponse {
  const factory ProfileResponse({
    required int id,
    required String name,
    // 프로필 이미지를 등록하지 않은 경우 null.
    required String? profileImageUrl,
    // 연동된 소셜 로그인 제공자. (예: 'KAKAO')
    required String provider,
    required DateTime createdAt,
  }) = _ProfileResponse;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}
