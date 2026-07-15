import 'package:ddara/feature/home/home_notifier.dart';
import 'package:ddara/feature/home/util/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// autoDispose: 로그아웃으로 HomePage 가 언마운트되면 함께 폐기되어, 다음 로그인
// 시 새 세션 기준으로 그룹 목록을 다시 조회한다. (이전 사용자 데이터 잔존 방지)
final homeNotifierProvider =
    NotifierProvider.autoDispose<HomeNotifier, HomeState>(HomeNotifier.new);
