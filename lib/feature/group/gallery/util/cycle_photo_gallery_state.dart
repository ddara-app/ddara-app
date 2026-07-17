import 'package:ddara/core/model/group/cycle_gallery.dart';

class CyclePhotoGalleryState {
  /// 사이클 갤러리 데이터. 조회 전엔 null.
  final CycleGallery? gallery;

  /// 현재 사용자(뷰어)의 id. 조회 전엔 null.
  /// (멤버의 userId 와 비교해 본인 카드를 판별한다)
  final int? myUserId;

  /// 내가 차단한 사용자 userId 집합. (차단한 멤버의 사진을 가리는 데 사용)
  final Set<int> blockedUserIds;

  /// 갤러리 조회 중 여부.
  final bool isLoading;

  /// 조회 실패 메시지. 비어 있으면 에러 없음.
  final String errorMessage;

  const CyclePhotoGalleryState({
    this.gallery,
    this.myUserId,
    this.blockedUserIds = const {},
    this.isLoading = false,
    this.errorMessage = '',
  });

  /// 모임 이름. 조회 전엔 빈 문자열.
  String get groupName => gallery?.groupName ?? '';

  CyclePhotoGalleryState copyWith({
    CycleGallery? gallery,
    int? myUserId,
    Set<int>? blockedUserIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CyclePhotoGalleryState(
      gallery: gallery ?? this.gallery,
      myUserId: myUserId ?? this.myUserId,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
