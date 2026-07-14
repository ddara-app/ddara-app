import 'package:ddara/feature/group/history/history_list_notifier.dart';
import 'package:ddara/feature/group/history/util/history_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// autoDispose: 화면을 벗어나면 폐기되어 이전 모임의 히스토리가 남지 않는다.
final historyListNotifierProvider = NotifierProvider.autoDispose
    .family<HistoryListNotifier, HistoryListState, int>(
      HistoryListNotifier.new,
    );
