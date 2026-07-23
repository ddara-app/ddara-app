import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../onboarding_notifier.dart';

// keepAlive: 앱 수명 동안 유지되는 전역 플래그다. (라우터·main 이 참조)
final onboardingSeenProvider = NotifierProvider<OnboardingSeenNotifier, bool>(
  OnboardingSeenNotifier.new,
);
