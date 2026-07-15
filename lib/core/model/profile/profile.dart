import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required int id,
    required String name,
    // 프로필 이미지를 등록하지 않은 경우 null.
    required String? profileImageUrl,
    // 연동된 소셜 로그인 제공자. (예: 'KAKAO')
    required String provider,
    required DateTime createdAt,
  }) = _Profile;
}
