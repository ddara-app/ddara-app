import 'package:ddara/core/comment/comment_action_error.dart';
import 'package:ddara/core/model/group/cycle_gallery.dart';
import 'package:ddara/core/model/group/group_action_error.dart';

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

  /// 조회·액션 실패 종류. (토스트용 일회성 — 문구는 화면이 l10n 으로 매핑,
  /// 소비 후 clearError 로 비운다)
  final GroupActionError? error;

  /// 댓글 액션 실패 종류. (토스트용 일회성 — 문구는 화면이 l10n 으로 매핑,
  /// 소비 후 clearCommentError 로 비운다)
  final CommentActionError? commentError;

  const CyclePhotoGalleryState({
    this.gallery,
    this.myUserId,
    this.blockedUserIds = const {},
    this.isLoading = false,
    this.error,
    this.commentError,
  });

  /// 모임 이름. 조회 전엔 빈 문자열.
  String get groupName => gallery?.groupName ?? '';

  CyclePhotoGalleryState copyWith({
    CycleGallery? gallery,
    int? myUserId,
    Set<int>? blockedUserIds,
    bool? isLoading,
    GroupActionError? error,
    bool clearError = false,
    CommentActionError? commentError,
    bool clearCommentError = false,
  }) {
    return CyclePhotoGalleryState(
      gallery: gallery ?? this.gallery,
      myUserId: myUserId ?? this.myUserId,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      isLoading: isLoading ?? this.isLoading,
      // copyWith(error: null) 은 기존 값을 유지하므로 리셋은 clear 로만.
      error: clearError ? null : (error ?? this.error),
      commentError: clearCommentError
          ? null
          : (commentError ?? this.commentError),
    );
  }
}
