import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../starter_notifier.dart';
import '../util/starter_state.dart';

// autoDispose: 화면을 벗어나면 폐기되어 이전 사용자의 입력 폼이 남지 않는다.
final starterNotifierProvider =
    NotifierProvider.autoDispose<StarterNotifier, StarterState>(
      StarterNotifier.new,
    );
