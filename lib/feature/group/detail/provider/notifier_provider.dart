import 'package:ddara/feature/group/detail/group_page_notifier.dart';
import 'package:ddara/feature/group/detail/util/group_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// autoDispose: 로그아웃 시 폐기되어 이전 사용자의 모임 상세 데이터가 남지 않는다.
final groupPageNotifierProvider =
    NotifierProvider.autoDispose.family<GroupPageNotifier, GroupPageState, int>(
      GroupPageNotifier.new,
    );
