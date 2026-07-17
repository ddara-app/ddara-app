import 'package:ddara/feature/profile/blocked/blocked_users_notifier.dart';
import 'package:ddara/feature/profile/blocked/util/blocked_users_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// autoDispose: 화면을 떠나면 폐기되어 재진입 시 항상 최신 목록을 조회한다.
final blockedUsersNotifierProvider =
    NotifierProvider.autoDispose<BlockedUsersNotifier, BlockedUsersState>(
      BlockedUsersNotifier.new,
    );
