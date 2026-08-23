import 'package:flutter/widgets.dart';

/// 가이드 투어가 하이라이트할 위젯의 식별자.
/// 문자열 오타를 컴파일 타임에 막으려고 상수로 모아 둔다.
abstract final class CameraTourTargets {
  const CameraTourTargets._();

  /// 헤더의 원본사진 투명도 탭. (고스트 확대 모드에서만 존재)
  static const opacityTabs = 'header.opacityTabs';

  /// 프리뷰에 크게 겹쳐 보이는 가이드 사진. (고스트 확대 모드)
  static const ghostGuide = 'preview.ghostGuide';

  /// 프리뷰 좌상단의 작은 가이드 사진. (코너 미니뷰 모드 · 치우지 않은 상태)
  static const miniGuide = 'preview.miniGuide';

  /// 미니뷰를 접어 뒀을 때 왼쪽 끝에 남는 손잡이.
  /// (접기 시연 중에는 구멍이 [miniGuide] 대신 이쪽을 따라간다)
  static const miniGuideHandle = 'preview.miniGuideHandle';

  /// 모드 토글의 '고스트 확대' 버튼.
  /// (토글 전체가 아니라 안내 대상인 버튼 하나만 가리킨다)
  static const ghostZoomMode = 'bottom.ghostZoomMode';
}

/// 타겟 id → 그 위젯의 [GlobalKey] 등록소.
///
/// 투어는 화면 위젯을 직접 참조하지 않고 이 등록소를 통해 좌표만 얻는다.
/// 덕분에 [CameraTourTarget] 으로 감싸기만 하면 어느 위젯이든 타겟이 된다.
abstract final class CameraTourRegistry {
  const CameraTourRegistry._();

  static final Map<String, GlobalKey> _keys = {};

  static void register(String id, GlobalKey key) => _keys[id] = key;

  /// 등록을 해제한다. 같은 id 로 이미 다른 키가 등록돼 있으면 건드리지 않는다.
  ///
  /// `AnimatedSwitcher` 로 위젯이 교체될 때 새 위젯의 `initState` 가 옛 위젯의
  /// `dispose` 보다 먼저 돈다. id 만 보고 지우면 방금 등록한 키가 지워진다.
  static void unregister(String id, GlobalKey key) {
    if (_keys[id] == key) _keys.remove(id);
  }

  /// 타겟 사각형. 아직 레이아웃되지 않았으면 null.
  ///
  /// [ancestor] 를 주면 그 RenderObject 기준 좌표로 돌려준다. 투어 오버레이는
  /// 화면 전체가 아니라 AppBar 아래(`CupertinoPageScaffold` 의 child)에 깔리므로,
  /// 오버레이의 RenderBox 를 넘겨야 구멍이 AppBar 높이만큼 밀리지 않는다.
  static Rect? rectOf(String id, {RenderObject? ancestor}) {
    final context = _keys[id]?.currentContext;
    if (context == null) return null;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return null;
    return box.localToGlobal(Offset.zero, ancestor: ancestor) & box.size;
  }
}

/// 자식 위젯을 투어 타겟으로 등록하는 래퍼.
///
/// [KeyedSubtree] 로 감싸는 이유는 자식에 key 를 직접 붙이면 그 위젯이 이미
/// 갖고 있던 key 와 충돌하기 때문이다.
class CameraTourTarget extends StatefulWidget {
  const CameraTourTarget({super.key, required this.id, required this.child});

  /// [CameraTourTargets] 의 상수.
  final String id;

  final Widget child;

  @override
  State<CameraTourTarget> createState() => _CameraTourTargetState();
}

class _CameraTourTargetState extends State<CameraTourTarget> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    CameraTourRegistry.register(widget.id, _key);
  }

  @override
  void didUpdateWidget(CameraTourTarget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      CameraTourRegistry.unregister(oldWidget.id, _key);
      CameraTourRegistry.register(widget.id, _key);
    }
  }

  @override
  void dispose() {
    CameraTourRegistry.unregister(widget.id, _key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: _key, child: widget.child);
}
