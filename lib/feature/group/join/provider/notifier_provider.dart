import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../invite/invite_code_input_notifier.dart';
import '../join_group_notifier.dart';
import '../util/invite_code_input_state.dart';
import '../util/join_group_state.dart';

// autoDispose: 화면을 벗어나면 폐기되어 이전 사용자의 입력 폼이 남지 않는다.
final inviteCodeInputNotifierProvider =
    NotifierProvider.autoDispose<InviteCodeInputNotifier, InviteCodeInputState>(
      InviteCodeInputNotifier.new,
    );

// autoDispose: 화면을 벗어나면 폐기되어 이전 입력(닉네임)이 남지 않는다.
final joinGroupNotifierProvider =
    NotifierProvider.autoDispose<JoinGroupNotifier, JoinGroupState>(
      JoinGroupNotifier.new,
    );
