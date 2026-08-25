import 'package:ddara/domain/model/feed/feed.dart';

/// 최근 업데이트 피드 화면 상태. 로딩·실패·완료가 상호배타인 sealed 설계다.
///
/// 본문을 대체하는 초기 조회 실패는 [FeedLoadError]로, 피드가 떠 있는 상태의
/// 액션(새로고침) 실패는 [FeedLoaded.actionError]로 분리해, 한 필드가
/// 피드 유무에 따라 본문 에러/토스트로 읽히던 암묵 규약을 타입으로 대체한다.
sealed class FeedState {
  const FeedState();
}

final class FeedLoading extends FeedState {
  const FeedLoading();
}

/// 초기 조회 실패. (본문 문구는 화면이 l10n 으로 표시하고 당겨서 재시도)
final class FeedLoadError extends FeedState {
  const FeedLoadError();
}

/// 피드가 떠 있는 상태에서 발생한 일회성 실패. (토스트용 — 종류만 담고
/// 문구는 화면이 l10n 으로 매핑)
sealed class FeedActionError {
  const FeedActionError();
}

/// 당겨서 새로고침 실패.
final class FeedRefreshFailed extends FeedActionError {
  const FeedRefreshFailed();
}

final class FeedLoaded extends FeedState {
  const FeedLoaded({required this.feed, this.actionError});

  final Feed feed;

  /// 액션(새로고침 등) 실패의 토스트용 일회성 에러.
  /// 화면이 소비한 뒤 clearActionError 로 비운다.
  final FeedActionError? actionError;

  FeedLoaded copyWith({
    Feed? feed,
    FeedActionError? actionError,
    bool clearActionError = false,
  }) {
    return FeedLoaded(
      feed: feed ?? this.feed,
      // copyWith(actionError: null) 은 기존 값을 유지하므로 리셋은 clear 로만.
      actionError: clearActionError ? null : (actionError ?? this.actionError),
    );
  }
}
