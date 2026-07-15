import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../follower_notifier.dart';
import '../util/follower_state.dart';

// autoDispose: 화면을 벗어나면 폐기되어 이전 업로드 상태가 남지 않는다.
final followerNotifierProvider =
    NotifierProvider.autoDispose<FollowerNotifier, FollowerState>(
      FollowerNotifier.new,
    );
