import 'package:ddara/core/local/provider/local_provider.dart';
import 'package:ddara/core/local/storage_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 온보딩 노출 여부 상태. 읽기(초기값)와 쓰기(complete)를 한곳에 모아,
/// 완료 시 저장소와 캐시가 함께 갱신되므로 수동 invalidate 가 필요 없다.
class OnboardingSeenViewModel extends Notifier<bool> {
  @override
  bool build() {
    return ref
            .watch(sharedPreferencesProvider)
            .getBool(StorageKey.onboardingSeen) ??
        false;
  }

  /// 온보딩 완료 플래그 저장 → 다음 실행부터는 노출되지 않는다.
  Future<void> complete() async {
    await ref
        .read(sharedPreferencesProvider)
        .setBool(StorageKey.onboardingSeen, true);
    state = true;
  }
}
