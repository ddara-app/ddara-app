import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../invite/invite_code_input_viewmodel.dart';
import '../join_group_viewmodel.dart';
import '../invite/util/invite_code_input_state.dart';
import '../util/join_group_state.dart';

// autoDispose: 화면을 벗어나면 폐기되어 이전 사용자의 입력 폼이 남지 않는다.
final inviteCodeInputViewModelProvider =
    NotifierProvider.autoDispose<
      InviteCodeInputViewModel,
      InviteCodeInputState
    >(InviteCodeInputViewModel.new);

// autoDispose: 화면을 벗어나면 폐기되어 이전 입력(닉네임)이 남지 않는다.
final joinGroupViewModelProvider =
    NotifierProvider.autoDispose<JoinGroupViewModel, JoinGroupState>(
      JoinGroupViewModel.new,
    );
