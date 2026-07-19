import 'package:ddara/core/model/feed/feed.dart';

import '../../repository/feed_repository.dart';

class GetFeedUseCase {
  final FeedRepository _feedRepository;

  GetFeedUseCase(this._feedRepository);

  /// 홈 최근 업데이트 피드를 조회한다.
  ///
  /// [size] 는 가져올 최신 항목 수. 생략하면 서버 기본값(30)을 따른다.
  Future<Feed> call({int? size}) async {
    return _feedRepository.getFeed(size: size);
  }
}
