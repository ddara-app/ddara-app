/// 진행 중(busy) 플래그가 켜져 있는 동안 탭 콜백을 비활성화하는 공용 가드.
///
/// 이 앱의 버튼류(AppButton·CupertinoButton·ProfileRow 등)는 콜백이 null 이면
/// 비활성 상태로 렌더링·차단된다. 네트워크 요청 등 비동기 작업이 진행되는 동안
/// [busy] 에 로딩 플래그를 넘겨 중복 탭을 UI 차원에서 막는다.
/// (notifier 의 재진입 가드와 함께 이중 방어로 사용)
///
/// [callback] 이 이미 null(다른 조건으로 비활성)이어도 그대로 null 을 돌려주므로
/// 기존 활성화 조건과 자연스럽게 합성된다.
///
/// ```dart
/// AppButton(
///   label: l10n.groupJoin,
///   onPressed: tapGuard(state.isLoading, () => notifier.joinGroup()),
/// )
/// ```
T? tapGuard<T extends Function>(bool busy, T? callback) =>
    busy ? null : callback;