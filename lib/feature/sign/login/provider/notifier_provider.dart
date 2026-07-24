import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../login_notifier.dart';
import '../util/login_state.dart';

// autoDispose: 로그인 화면을 벗어나면 폐기되어, 로그아웃 후 재진입 시
// 이전 LoginSuccess/LoginFail 상태가 남지 않는다.
final loginNotifierProvider =
    NotifierProvider.autoDispose<LoginNotifier, LoginState>(LoginNotifier.new);
