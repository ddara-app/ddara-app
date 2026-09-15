import 'package:ddara/core/local/provider/local_provider.dart';
import 'package:ddara/core/local/storage_key.dart';
import 'package:ddara/feature/onboarding/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> buildContainer({bool seen = false}) async {
  SharedPreferences.setMockInitialValues({
    if (seen) StorageKey.onboardingSeen: true,
  });
  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  return container;
}

void main() {
  test('저장된 값이 없으면 온보딩을 아직 안 본 것(false)으로 본다', () async {
    final container = await buildContainer();
    addTearDown(container.dispose);

    expect(container.read(onboardingSeenProvider), false);
  });

  test('저장된 값이 true 면 그대로 읽는다', () async {
    final container = await buildContainer(seen: true);
    addTearDown(container.dispose);

    expect(container.read(onboardingSeenProvider), true);
  });

  test('complete 호출 시 저장소와 상태가 함께 true 로 갱신된다', () async {
    final container = await buildContainer();
    addTearDown(container.dispose);

    await container.read(onboardingSeenProvider.notifier).complete();

    expect(container.read(onboardingSeenProvider), true);
    final prefs = container.read(sharedPreferencesProvider);
    expect(prefs.getBool(StorageKey.onboardingSeen), true);
  });
}
