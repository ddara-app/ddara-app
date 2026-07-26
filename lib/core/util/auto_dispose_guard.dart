import 'package:flutter_riverpod/flutter_riverpod.dart';

/// autoDispose notifier 가 폐기된 뒤 도착한 응답으로 `state` 를 만지지 않도록
/// 막아 주는 가드.
///
/// autoDispose provider 는 화면을 벗어나면 폐기되는데, `build()` 가 조회를
/// fire-and-forget 으로 시작하므로 응답이 그 뒤에 도착할 수 있다. 폐기된
/// notifier 에 `state` 를 대입하면 StateError 가 나고, 그것을 `catch (_)` 가
/// 잡아 다시 `state` 를 대입하면 결국 unhandled error 가 된다. 화면을 빠르게
/// 진입-이탈하면 재현되는 크래시다.
///
/// 쓰는 쪽은 `build()` 첫 줄에서 [watchDispose] 를 부르고, `await` 뒤의 상태
/// 대입 앞에 [isDisposed] 를 확인한다.
///
/// ```dart
/// class FooNotifier extends AutoDisposeNotifier<FooState>
///     with AutoDisposeGuard<FooState> {
///   @override
///   FooState build() {
///     watchDispose();
///     _load();
///     return const FooState(isLoading: true);
///   }
///
///   Future<void> _load() async {
///     final result = await useCase();
///     if (isDisposed) return;
///     state = state.copyWith(data: result);
///   }
/// }
/// ```
mixin AutoDisposeGuard<StateT> {
  /// notifier 가 제공하는 ref. (별도 구현이 필요 없다)
  ///
  /// riverpod 2.x 의 `Notifier.ref` 가 이 타입이라 그대로 따른다.
  /// (riverpod 3 승급 시 `Ref` 로 교체)
  // ignore: deprecated_member_use
  AutoDisposeNotifierProviderRef<StateT> get ref;

  bool _disposed = false;

  /// 폐기된 뒤인지 여부. `await` 뒤 상태 대입 앞에서 확인한다.
  bool get isDisposed => _disposed;

  /// 폐기 감시를 시작한다. `build()` 안에서 한 번 호출한다.
  void watchDispose() {
    // invalidate 로 같은 인스턴스가 재빌드될 수 있어 매번 리셋한다.
    _disposed = false;
    ref.onDispose(() => _disposed = true);
  }
}
