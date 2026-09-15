import 'package:ddara/domain/model/feed/feed.dart';
import 'package:ddara/domain/repository/feed_repository.dart';
import 'package:ddara/domain/usecase/feed/get_feed_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late MockFeedRepository repository;
  late GetFeedUseCase useCase;

  setUp(() {
    repository = MockFeedRepository();
    useCase = GetFeedUseCase(repository);
  });

  test('size 를 그대로 Repository 에 위임한다', () async {
    const feed = Feed(updateCount: 1, items: []);
    when(() => repository.getFeed(size: 10)).thenAnswer((_) async => feed);

    final result = await useCase.call(size: 10);

    expect(result, feed);
  });

  test('size 를 생략하면 null 로 위임해 서버 기본값을 따른다', () async {
    const feed = Feed();
    when(() => repository.getFeed(size: null)).thenAnswer((_) async => feed);

    final result = await useCase.call();

    expect(result, feed);
    verify(() => repository.getFeed(size: null)).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.getFeed(size: any(named: 'size')),
    ).thenThrow(Exception('fail'));

    expect(() => useCase.call(), throwsA(isA<Exception>()));
  });
}
