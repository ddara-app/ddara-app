import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../login_notifier.dart';
import '../util/login_state.dart';

final loginNotifierProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
