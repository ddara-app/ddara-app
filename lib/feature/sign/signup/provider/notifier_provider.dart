import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../sign_notifier.dart';
import '../util/sign_up_page_state.dart';

final signNotifierProvider =
    NotifierProvider.family<SignNotifier, SignUpPageState, SocialLoginType>(
      SignNotifier.new,
    );
