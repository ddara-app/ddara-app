import 'package:freezed_annotation/freezed_annotation.dart';

part 'cycle_gallery.freezed.dart';

@freezed
abstract class CycleGallery with _$CycleGallery {
  const factory CycleGallery({
    required int groupId,
    required String groupName,
    required CycleGalleryCycle cycle,
    // 현재 사용자의 업로드 여부.
    required bool viewerUploaded,
    required List<CycleGalleryMember> members,
  }) = _CycleGallery;
}

@freezed
abstract class CycleGalleryCycle with _$CycleGalleryCycle {
  const factory CycleGalleryCycle({
    required int cycleId,
    required int cycleNumber,
    required String topic,
    required int starterUserId,
    required String starterNickname,
    // 스타터 샷의 shot id. (사진 신고의 targetId 로 사용)
    required int starterShotId,
    // 스타터가 올린 사진 URL. 없으면 null.
    required String? starterImageUrl,
    // 스타터 사진이 신고 접수로 검토 중인지 여부.
    required bool starterImageUnderReview,
    required String status,
    required DateTime deadlineAt,
  }) = _CycleGalleryCycle;
}

@freezed
abstract class CycleGalleryMember with _$CycleGalleryMember {
  const factory CycleGalleryMember({
    required int userId,
    // 멤버가 올린 사진의 shot id. 미업로드면 null. (사진 신고의 targetId 로 사용)
    required int? shotId,
    required String nickname,
    // 프로필 이미지 URL. 없으면 null.
    required String? profileImageUrl,
    required bool isStarter,
    // 사진 카드 상태.
    // (open: 공개 / empty: 미업로드 / locked: 잠금 / reported: 신고 검토 중)
    required String status,
    // 멤버가 따라찍은 사진 URL. 없으면 null.
    required String? imageUrl,
    // 업로드 시각. 미업로드면 null.
    required DateTime? uploadedAt,
  }) = _CycleGalleryMember;
}
