import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../sign_notifier.dart';
import '../util/sign_up_page_state.dart';

// autoDispose: 가입 화면을 벗어나면 폐기된다. keepAlive 로 두면 탈퇴 후
// 같은 소셜로 재가입할 때 이전 인스턴스의 약관 동의·성공 상태가 재사용된다.
final signNotifierProvider = NotifierProvider.autoDispose
    .family<SignNotifier, SignUpPageState, SocialLoginType>(SignNotifier.new);
