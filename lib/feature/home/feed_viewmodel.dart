import 'package:ddara/core/util/auto_dispose_guard.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/home/util/feed_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedViewModel extends AutoDisposeNotifier<FeedState>
    with AutoDisposeGuard<FeedState> {
  @override
  FeedState build() {
    // 폐기 후 도착한 in-flight 응답이 state 를 만지지 않도록 감시를 건다.
    // (홈 진입 직후 로그아웃 등으로 폐기된 뒤 응답이 도착하면 StateError)
    watchDispose();
    _load();

    return const FeedLoading();
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(FeedState Function(FeedState state) updater) {
    if (isDisposed) return;
    state = updater(state);
  }

  /// 최근 업데이트 피드를 조회해 state 에 담는다.
  ///
  /// 실패 시: 피드를 이미 보고 있으면(재조회) 토스트용 actionError 로,
  /// 아직 로드 전이면 본문 에러로 전환한다.
  Future<void> _load() async {
    final getFeedUseCase = ref.read(getFeedUseCaseProvider);

    try {
      // size 는 생략해 서버 기본값(최신 30개)을 따른다.
      final feed = await getFeedUseCase();
      _update((_) => FeedLoaded(feed: feed));
    } catch (e) {
      debugPrint('[Feed] 조회 실패: $e');
      _update(
        (s) => s is FeedLoaded
            ? s.copyWith(actionError: const FeedRefreshFailed())
            : const FeedLoadError(),
      );
    }
  }

  /// 피드를 다시 조회한다. (당겨서 새로고침)
  Future<void> refresh() => _load();

  /// 액션 에러를 소비한 뒤(토스트로 노출 후) 다시 비운다.
  /// 같은 에러가 이후 상태 변경 때 재노출되는 것을 막는다.
  void clearActionError() {
    _update((s) => s is FeedLoaded ? s.copyWith(clearActionError: true) : s);
  }
}
