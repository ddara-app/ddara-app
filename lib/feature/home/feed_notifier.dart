import 'package:ddara/core/comment/comment_actions.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/home/util/feed_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedNotifier extends AutoDisposeNotifier<FeedState>
    with CommentActions<FeedState> {
  /// autoDispose 폐기 후 in-flight 응답이 state 를 만지지 않도록 하는 가드.
  /// (홈 진입 직후 로그아웃 등으로 폐기된 뒤 응답이 도착하면 StateError)
  bool _disposed = false;

  @override
  FeedState build() {
    _disposed = false; // invalidate 재빌드(같은 인스턴스) 대비 리셋.
    ref.onDispose(() => _disposed = true);
    _load();
    return const FeedLoading();
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(FeedState Function(FeedState state) updater) {
    if (_disposed) return;
    state = updater(state);
  }

  /// 최근 업데이트 피드와 내 프로필을 조회해 state 에 담는다.
  /// (내 id·닉네임은 댓글 시트에서 내 댓글을 구분·표기하는 데 쓴다)
  ///
  /// 실패 시: 피드를 이미 보고 있으면(재조회) 토스트용 actionError 로,
  /// 아직 로드 전이면 본문 에러로 전환한다.
  Future<void> _load() async {
    final getFeedUseCase = ref.read(getFeedUseCaseProvider);

    try {
      // size 는 생략해 서버 기본값(최신 30개)을 따른다.
      final feed = await getFeedUseCase();
      final profile = await _loadProfile();
      _update(
        (_) => FeedLoaded(
          feed: feed,
          myUserId: profile?.$1,
          myNickname: profile?.$2 ?? '',
          myProfileImageUrl: profile?.$3,
        ),
      );
    } catch (_) {
      _update(
        (s) => s is FeedLoaded
            ? s.copyWith(actionError: '최근 업데이트를 불러오지 못했어요.')
            : const FeedLoadError('최근 업데이트를 불러오지 못했어요.'),
      );
    }
  }

  /// 내 (userId, 닉네임, 프로필 이미지 URL). 프로필 조회가 실패해도 피드는
  /// 보여줘야 하므로 실패 시 null 로 대체한다.
  /// (내 댓글 구분이 한 번 빠질 뿐 치명적이지 않다)
  Future<(int, String, String?)?> _loadProfile() async {
    try {
      final profile = await ref.read(getProfileUseCaseProvider)();
      return (profile.id, profile.name, profile.profileImageUrl);
    } catch (_) {
      return null;
    }
  }

  /// 피드를 다시 조회한다. (당겨서 새로고침)
  Future<void> refresh() => _load();

  /// 액션 에러를 소비한 뒤(토스트로 노출 후) 다시 비운다.
  /// 같은 에러가 이후 상태 변경 때 재노출되는 것을 막는다.
  void clearActionError() {
    _update((s) => s is FeedLoaded ? s.copyWith(clearActionError: true) : s);
  }

  @override
  void onCommentError(String message) {
    // 댓글 액션은 피드가 떠 있어야만 가능하므로 Loaded 외 상태에선 무시한다.
    _update((s) => s is FeedLoaded ? s.copyWith(actionError: message) : s);
  }

  /// 등록·삭제·신고 성공 시 댓글 수·미리보기가 반영되도록 피드를 다시 조회한다.
  @override
  Future<void> afterCommentMutation() => _refreshFeed();

  /// 피드만 조용히 다시 조회한다. (댓글 수·미리보기 갱신용)
  ///
  /// 실패해도 이미 보이는 피드를 지우거나 에러를 띄우지 않는다. 유발한 동작
  /// (댓글 등록·삭제·신고)은 이미 성공했고, 반영이 한 박자 늦을 뿐이다.
  Future<void> _refreshFeed() async {
    try {
      final feed = await ref.read(getFeedUseCaseProvider)();
      _update((s) => s is FeedLoaded ? s.copyWith(feed: feed) : s);
    } catch (_) {
      // 무시. (다음 진입 때 갱신된다)
    }
  }
}
