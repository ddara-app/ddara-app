import 'package:ddara/feature/home/feed_viewmodel.dart';
import 'package:ddara/feature/home/home_viewmodel.dart';
import 'package:ddara/feature/home/util/feed_state.dart';
import 'package:ddara/feature/home/util/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// autoDispose: 로그아웃으로 HomePage 가 언마운트되면 함께 폐기되어, 다음 로그인
// 시 새 세션 기준으로 그룹 목록을 다시 조회한다. (이전 사용자 데이터 잔존 방지)
final homeViewModelProvider =
    NotifierProvider.autoDispose<HomeViewModel, HomeState>(HomeViewModel.new);

// autoDispose 이유는 위와 같다. (최근 업데이트 피드도 세션마다 다시 조회)
final feedViewModelProvider =
    NotifierProvider.autoDispose<FeedViewModel, FeedState>(FeedViewModel.new);
