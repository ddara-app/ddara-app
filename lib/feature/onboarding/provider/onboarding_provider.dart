import 'package:ddara/core/local/provider/local_provider.dart';
import 'package:ddara/core/local/storage_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingSeenProvider = Provider<bool>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getBool(StorageKey.onboardingSeen) ?? false;
});

final onboardingControllerProvider = Provider<OnboardingController>((ref) {
  return OnboardingController(ref.read(sharedPreferencesProvider));
});

class OnboardingController {
  final SharedPreferences _prefs;

  OnboardingController(this._prefs);

  /// 온보딩 완료
  Future<void> complete() async {
    await _prefs.setBool(StorageKey.onboardingSeen, true);
  }
}
