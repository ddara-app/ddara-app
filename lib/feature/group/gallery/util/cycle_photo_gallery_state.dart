import 'package:ddara/core/comment/comment_action_error.dart';
import 'package:ddara/domain/model/group/cycle_gallery.dart';
import 'package:ddara/domain/model/group/group_action_error.dart';

/// 사이클 사진 갤러리 화면 상태. 로딩·초기 조회 실패·본문이 상호배타인 sealed 설계다.
///
/// 본문을 대체하는 초기 조회 실패는 [CyclePhotoGalleryLoadError] 로, 갤러리가
/// 떠 있는 상태의 액션(신고·차단·댓글) 실패는
/// [CyclePhotoGalleryLoaded.actionError]·[CyclePhotoGalleryLoaded.commentError]
/// 로 분리해, 한 필드가 갤러리 유무에 따라 본문 에러/토스트로 읽히던 암묵
/// 규약을 타입으로 대체한다.
sealed class CyclePhotoGalleryState {
  const CyclePhotoGalleryState();
}

/// 최초 조회 중. (보여줄 갤러리가 없어 화면 전체가 로딩)
final class CyclePhotoGalleryLoading extends CyclePhotoGalleryState {
  const CyclePhotoGalleryLoading();
}

/// 최초 조회 실패. (본문 자리에 문구를 띄운다)
final class CyclePhotoGalleryLoadError extends CyclePhotoGalleryState {
  const CyclePhotoGalleryLoadError(this.error);

  final GroupActionError error;
}

/// 갤러리를 그릴 수 있는 상태.
final class CyclePhotoGalleryLoaded extends CyclePhotoGalleryState {
  const CyclePhotoGalleryLoaded({
    required this.gallery,
    required this.myUserId,
    required this.blockedUserIds,
    this.readShotIds = const {},
    this.isBusy = false,
    this.actionError,
    this.commentError,
  });

  /// 사이클 갤러리 데이터. (모임 이름·멤버별 사진)
  final CycleGallery gallery;

  /// 현재 사용자(뷰어)의 id. (멤버의 userId 와 비교해 본인 카드를 판별한다)
  final int myUserId;

  /// 내가 차단한 사용자 userId 집합. (차단한 멤버의 사진을 가리는 데 사용)
  final Set<int> blockedUserIds;

  /// 지금 담긴 [gallery] 를 받은 뒤 댓글을 열어 본 사진의 shot id 집합.
  ///
  /// 뷰어에서 댓글을 읽고 돌아와도 서버의 `hasUnreadComments` 는 그대로라
  /// 강조 표시가 남는다. 읽은 사진을 여기 담아 그 사이를 메운다.
  ///
  /// 갤러리를 다시 조회하면 비워진다 — 그 사이 새 댓글이 달렸을 수 있어
  /// 방금 받은 서버 값이 항상 더 정확하기 때문이다.
  final Set<int> readShotIds;

  /// 신고·차단 처리 중 여부. (중복 전송 방지 — 화면에는 표시하지 않는다)
  final bool isBusy;

  /// 액션 실패 종류. (토스트용 일회성 — 문구는 화면이 l10n 으로 매핑,
  /// 소비 후 clearActionError 로 비운다)
  final GroupActionError? actionError;

  /// 댓글 액션 실패 종류. (토스트용 일회성 — 문구는 화면이 l10n 으로 매핑,
  /// 소비 후 clearCommentError 로 비운다)
  final CommentActionError? commentError;

  /// 모임 이름.
  String get groupName => gallery.groupName;

  /// [shotId] 사진의 댓글 버튼을 강조해야 하는지.
  /// 서버가 읽지 않았다고 했고, 이 화면에서 아직 열어 보지도 않았을 때만 true.
  bool isCommentUnread(int? shotId, {required bool hasUnreadComments}) {
    if (!hasUnreadComments || shotId == null) return false;
    return !readShotIds.contains(shotId);
  }

  CyclePhotoGalleryLoaded copyWith({
    CycleGallery? gallery,
    int? myUserId,
    Set<int>? blockedUserIds,
    Set<int>? readShotIds,
    bool? isBusy,
    GroupActionError? actionError,
    bool clearActionError = false,
    CommentActionError? commentError,
    bool clearCommentError = false,
  }) {
    return CyclePhotoGalleryLoaded(
      gallery: gallery ?? this.gallery,
      myUserId: myUserId ?? this.myUserId,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      readShotIds: readShotIds ?? this.readShotIds,
      isBusy: isBusy ?? this.isBusy,
      // copyWith(actionError: null) 은 기존 값을 유지하므로 리셋은 clear 로만.
      actionError: clearActionError ? null : (actionError ?? this.actionError),
      commentError: clearCommentError
          ? null
          : (commentError ?? this.commentError),
    );
  }
}
