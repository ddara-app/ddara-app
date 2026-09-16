import 'package:ddara/domain/model/comment/comment.dart';
import 'package:ddara/domain/model/feed/feed.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/comment/create_comment_use_case.dart';
import 'package:ddara/domain/usecase/feed/get_feed_use_case.dart';
import 'package:ddara/feature/home/feed_viewmodel.dart';
import 'package:ddara/feature/home/provider/viewmodel_provider.dart';
import 'package:ddara/feature/home/util/feed_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFeedUseCase extends Mock implements GetFeedUseCase {}

class MockCreateCommentUseCase extends Mock implements CreateCommentUseCase {}

FeedViewModel notifierAlive(ProviderContainer container) {
  container.listen(feedViewModelProvider, (_, _) {});
  return container.read(feedViewModelProvider.notifier);
}

void main() {
  late MockGetFeedUseCase getFeed;
  late MockCreateCommentUseCase createComment;
  late ProviderContainer container;

  setUp(() {
    getFeed = MockGetFeedUseCase();
    createComment = MockCreateCommentUseCase();
    container = ProviderContainer(
      overrides: [
        getFeedUseCaseProvider.overrideWithValue(getFeed),
        createCommentUseCaseProvider.overrideWithValue(createComment),
      ],
    );
    addTearDown(container.dispose);
  });

  test('조회 성공하면 FeedLoaded 로 전환한다', () async {
    when(() => getFeed(size: null)).thenAnswer((_) async => const Feed(updateCount: 1, items: []));

    final notifier = notifierAlive(container);
    await notifier.refresh();

    final state = container.read(feedViewModelProvider);
    expect(state, isA<FeedLoaded>());
    expect((state as FeedLoaded).feed.updateCount, 1);
  });

  test('초기 조회 실패는 FeedLoadError 로 전환한다', () async {
    when(() => getFeed(size: null)).thenAnswer((_) async => throw Exception('fail'));

    final notifier = notifierAlive(container);
    await notifier.refresh();

    expect(container.read(feedViewModelProvider), isA<FeedLoadError>());
  });

  test('이미 피드가 떠 있으면 재조회 실패해도 actionError 로만 남는다', () async {
    when(() => getFeed(size: null)).thenAnswer((_) async => const Feed());
    final notifier = notifierAlive(container);
    await notifier.refresh();
    expect(container.read(feedViewModelProvider), isA<FeedLoaded>());

    when(() => getFeed(size: null)).thenAnswer((_) async => throw Exception('fail'));
    await notifier.refresh();

    final state = container.read(feedViewModelProvider);
    expect(state, isA<FeedLoaded>());
    expect((state as FeedLoaded).actionError, isA<FeedRefreshFailed>());
  });

  test('clearActionError 는 actionError 만 비운다', () async {
    when(() => getFeed(size: null)).thenAnswer((_) async => const Feed());
    final notifier = notifierAlive(container);
    await notifier.refresh();
    when(() => getFeed(size: null)).thenAnswer((_) async => throw Exception('fail'));
    await notifier.refresh();
    expect((container.read(feedViewModelProvider) as FeedLoaded).actionError, isNotNull);

    notifier.clearActionError();

    expect((container.read(feedViewModelProvider) as FeedLoaded).actionError, isNull);
  });

  test('댓글 등록 성공하면 후처리로 피드를 조용히 다시 조회한다', () async {
    when(() => getFeed(size: null)).thenAnswer((_) async => const Feed(updateCount: 1));
    final notifier = notifierAlive(container);
    await notifier.refresh();
    when(
      () => createComment(shotId: any(named: 'shotId'), content: any(named: 'content')),
    ).thenAnswer(
      (_) async => Comment(
        commentId: 1,
        userId: 1,
        nickname: 'nick',
        profileImageUrl: null,
        content: 'hi',
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    when(() => getFeed(size: null)).thenAnswer((_) async => const Feed(updateCount: 2));

    final result = await notifier.submitComment(shotId: 1, content: 'hi');

    expect(result, isNotNull);
    expect((container.read(feedViewModelProvider) as FeedLoaded).feed.updateCount, 2);
  });
}
