import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/network/dto/feed/feed_response.dart';
import 'package:ddara/data/datasource/feed/feed_datasource.dart';
import 'package:ddara/data/repository/feed_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFeedDataSource extends Mock implements FeedDataSource {}

DioException _dioError() {
  final req = RequestOptions(path: '/api/feed');
  return DioException(requestOptions: req, response: Response(requestOptions: req, statusCode: 500));
}

void main() {
  late MockFeedDataSource dataSource;
  late FeedRepositoryImpl repository;

  setUp(() {
    dataSource = MockFeedDataSource();
    repository = FeedRepositoryImpl(dataSource);
  });

  test('size 를 그대로 DataSource 에 위임하고 응답을 도메인 모델로 변환한다', () async {
    when(() => dataSource.getFeed(size: 10)).thenAnswer(
      (_) async => const FeedResponse(updateCount: 1, items: []),
    );

    final result = await repository.getFeed(size: 10);

    expect(result.updateCount, 1);
    verify(() => dataSource.getFeed(size: 10)).called(1);
  });

  test('DioException 이 발생하면 NetworkException 으로 변환한다', () async {
    when(() => dataSource.getFeed(size: any(named: 'size'))).thenThrow(_dioError());

    expect(() => repository.getFeed(), throwsA(isA<NetworkException>()));
  });
}
