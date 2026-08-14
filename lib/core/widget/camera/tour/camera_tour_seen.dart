import 'package:ddara/core/local/provider/local_provider.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_steps.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 가이드 투어를 종류별로 이미 봤는지 여부.
///
/// 읽기(초기값)와 쓰기(complete)를 한곳에 모아, 완료 시 저장소와 캐시가 함께
/// 갱신되므로 수동 invalidate 가 필요 없다. (온보딩 노출 여부와 같은 구조)
class CameraTourSeenViewModel extends FamilyNotifier<bool, CameraTourKind> {
  @override
  bool build(CameraTourKind arg) {
    return ref.watch(sharedPreferencesProvider).getBool(arg.storageKey) ??
        false;
  }

  /// 완료 플래그 저장 → 다음부터는 자동으로 뜨지 않는다.
  /// (AppBar 의 도움말 버튼으로는 언제든 다시 볼 수 있다)
  Future<void> complete() async {
    if (state) return;
    await ref.read(sharedPreferencesProvider).setBool(arg.storageKey, true);
    state = true;
  }
}
