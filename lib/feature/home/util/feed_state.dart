import 'package:ddara/core/model/feed/feed.dart';

/// 최근 업데이트 피드 화면 상태. 로딩·실패·완료가 상호배타인 sealed 설계다.
///
/// 본문을 대체하는 초기 조회 실패는 [FeedLoadError]로, 피드가 떠 있는 상태의
/// 액션(댓글·새로고침) 실패는 [FeedLoaded.actionError]로 분리해, 한 필드가
/// 피드 유무에 따라 본문 에러/토스트로 읽히던 암묵 규약을 타입으로 대체한다.
sealed class FeedState {
  const FeedState();
}

final class FeedLoading extends FeedState {
  const FeedLoading();
}

/// 초기 조회 실패. (본문에 안내 문구를 표시하고 당겨서 재시도)
final class FeedLoadError extends FeedState {
  const FeedLoadError(this.message);

  final String message;
}

final class FeedLoaded extends FeedState {
  const FeedLoaded({
    required this.feed,
    this.myUserId,
    this.myNickname = '',
    this.myProfileImageUrl,
    this.actionError,
  });

  final Feed feed;

  /// 내 userId. (댓글 시트에서 내 댓글을 구분하는 데 쓴다) 조회 실패 시 null.
  final int? myUserId;

  /// 내 닉네임. (내가 단 댓글의 작성자 표기에 쓴다)
  final String myNickname;

  /// 내 프로필 이미지 URL. (전송 중 댓글의 아바타에 쓴다) 없으면 null.
  final String? myProfileImageUrl;

  /// 액션(댓글·새로고침 등) 실패의 토스트용 일회성 에러.
  /// 화면이 소비한 뒤 clearActionError 로 비운다.
  final String? actionError;

  FeedLoaded copyWith({
    Feed? feed,
    String? actionError,
    bool clearActionError = false,
  }) {
    return FeedLoaded(
      feed: feed ?? this.feed,
      myUserId: myUserId,
      myNickname: myNickname,
      myProfileImageUrl: myProfileImageUrl,
      // copyWith(actionError: null) 은 기존 값을 유지하므로 리셋은 clear 로만.
      actionError: clearActionError ? null : (actionError ?? this.actionError),
    );
  }
}
