import 'package:ddara/feature/group/create/create_group_notifier.dart';
import 'package:ddara/feature/group/create/util/create_group_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// autoDispose: 화면을 벗어나면 폐기되어 이전 사용자의 입력 폼이 남지 않는다.
final createGroupNotifierProvider =
    NotifierProvider.autoDispose<CreateGroupNotifier, CreateGroupState>(
      CreateGroupNotifier.new,
    );
