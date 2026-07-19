import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/model/feed/feed.dart';
import 'package:ddara/data/datasource/feed/feed_datasource.dart';
import 'package:ddara/domain/repository/feed_repository.dart';
import 'package:dio/dio.dart';

import 'mapper/feed_mapper.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedDataSource _feedDataSource;

  FeedRepositoryImpl(this._feedDataSource);

  @override
  Future<Feed> getFeed({int? size}) async {
    try {
      final response = await _feedDataSource.getFeed(size: size);
      return response.toDomain();
    } on DioException {
      // 401(미인증)은 인터셉터에서 따로 처리한다.
      // 그 밖에 서버가 정의한 실패 코드가 없어 네트워크 오류로 일괄 처리한다.
      throw NetworkException();
    }
  }
}
