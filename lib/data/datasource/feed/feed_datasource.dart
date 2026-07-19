import 'package:ddara/core/network/dto/feed/feed_response.dart';
import 'package:dio/dio.dart';

class FeedDataSource {
  FeedDataSource(this._dio);

  final Dio _dio;

  /// 홈 최근 업데이트 피드를 조회한다.
  ///
  /// [size] 는 가져올 최신 항목 수. null 이면 생략해 서버 기본값(30)을 따른다.
  Future<FeedResponse> getFeed({int? size}) async {
    final response = await _dio.get(
      '/api/feed',
      queryParameters: {'size': ?size},
    );

    return FeedResponse.fromJson(response.data);
  }
}
