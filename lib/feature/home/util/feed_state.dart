import 'package:ddara/core/model/feed/feed.dart';

class FeedState {
  /// 최근 업데이트 피드. (조회 전이면 null)
  ///
  /// 갤러리와 같은 규칙으로, 이 값이 null 인 동안의 [errorMessage] 는 본문에
  /// 표시하는 조회 실패이고, 로드된 뒤의 [errorMessage] 는 댓글 등 액션 실패라
  /// 토스트로 안내한다.
  final Feed? feed;

  /// 내 userId. (댓글 시트에서 내 댓글을 구분하는 데 쓴다)
  final int? myUserId;

  /// 내 닉네임. (내가 단 댓글의 작성자 표기에 쓴다)
  final String myNickname;

  final bool isLoading;
  final String errorMessage;

  const FeedState({
    this.feed,
    this.myUserId,
    this.myNickname = '',
    this.isLoading = false,
    this.errorMessage = '',
  });

  FeedState copyWith({
    Feed? feed,
    int? myUserId,
    String? myNickname,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FeedState(
      feed: feed ?? this.feed,
      myUserId: myUserId ?? this.myUserId,
      myNickname: myNickname ?? this.myNickname,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
