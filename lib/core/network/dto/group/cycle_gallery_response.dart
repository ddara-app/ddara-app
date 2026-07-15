import 'package:freezed_annotation/freezed_annotation.dart';

part 'cycle_gallery_response.freezed.dart';
part 'cycle_gallery_response.g.dart';

@freezed
abstract class CycleGalleryResponse with _$CycleGalleryResponse {
  const factory CycleGalleryResponse({
    required int groupId,
    required String groupName,
    required CycleGalleryCycleResponse cycle,
    // 현재 사용자의 업로드 여부.
    required bool viewerUploaded,
    required List<CycleGalleryMemberResponse> members,
  }) = _CycleGalleryResponse;

  factory CycleGalleryResponse.fromJson(Map<String, dynamic> json) =>
      _$CycleGalleryResponseFromJson(json);
}

@freezed
abstract class CycleGalleryCycleResponse with _$CycleGalleryCycleResponse {
  const factory CycleGalleryCycleResponse({
    required int cycleId,
    required int cycleNumber,
    required String topic,
    required String starterNickname,
    // 스타터가 올린 사진 URL. 없으면 null.
    required String? starterImageUrl,
    required String status,
    required DateTime deadlineAt,
  }) = _CycleGalleryCycleResponse;

  factory CycleGalleryCycleResponse.fromJson(Map<String, dynamic> json) =>
      _$CycleGalleryCycleResponseFromJson(json);
}

@freezed
abstract class CycleGalleryMemberResponse with _$CycleGalleryMemberResponse {
  const factory CycleGalleryMemberResponse({
    required int userId,
    required String nickname,
    // 프로필 이미지 URL. 없으면 null.
    required String? profileImageUrl,
    required bool isStarter,
    // 사진 카드 상태. (open: 공개 / empty: 미업로드 / locked: 잠금)
    required String status,
    // 멤버가 따라찍은 사진 URL. 없으면 null.
    required String? imageUrl,
    // 업로드 시각. 미업로드면 null.
    required DateTime? uploadedAt,
  }) = _CycleGalleryMemberResponse;

  factory CycleGalleryMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$CycleGalleryMemberResponseFromJson(json);
}
