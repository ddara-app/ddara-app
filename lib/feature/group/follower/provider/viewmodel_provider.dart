import 'package:ddara/feature/group/follower/follower_viewmodel.dart';
import 'package:ddara/feature/group/follower/util/follower_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// autoDispose: 화면을 벗어나면 폐기되어 이전 업로드 상태가 남지 않는다.
final followerViewModelProvider =
    NotifierProvider.autoDispose<FollowerViewModel, FollowerState>(
      FollowerViewModel.new,
    );
