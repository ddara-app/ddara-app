import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/feature/group/photo_decoration/util/decoration_item.dart';
import 'package:flutter/widgets.dart';

/// 펜 색 선택지. (사진 위에서 잘 보이는 순서로 나열)
const List<Color> penPalette = <Color>[
  AppColorPrimitives.white,
  AppColorPrimitives.pureBlack,
  AppColorPrimitives.red500,
  AppColorPrimitives.yellow500,
  AppColorPrimitives.green500,
  AppColorPrimitives.sky500,
];

/// 펜 굵기 선택지. (사진 프레임 가로폭에 대한 비율)
const List<double> penWidths = <double>[0.006, 0.014, 0.028];

/// 지우개 굵기 선택지. 지울 때는 넉넉히 훑는 편이 편해서 펜보다 굵게 잡는다.
const List<double> eraserWidths = <double>[0.02, 0.045, 0.09];

/// 되돌리기로 거슬러 올라갈 수 있는 최대 단계.
const int _maxHistory = 30;

/// 되돌리기용 상태 스냅숏.
///
/// 요소는 전부 불변이라 목록만 얕게 복사하면 그 시점이 그대로 남는다.
class _Snapshot {
  const _Snapshot(this.strokes, this.overlays);

  final List<PenStroke> strokes;
  final List<OverlayItem> overlays;
}

/// 꾸미기 편집 상태.
///
/// 화면 밖으로 나가지 않는 순수 편집 상태라 서버·Riverpod 없이 화면이 직접
/// 들고 쓴다. (`camera_tour_controller` 와 같은 결)
///
/// 좌표는 전부 사진 프레임 기준 0~1 비율이라, 화면 크기가 달라져도 같은
/// 그림이 나온다.
class PhotoDecorationController extends ChangeNotifier {
  DecorationTool _tool = DecorationTool.pen;
  Color _penColor = penPalette.first;
  double _penWidth = penWidths[1];
  double _eraserWidth = eraserWidths[1];

  final List<PenStroke> _strokes = <PenStroke>[];
  final List<OverlayItem> _overlays = <OverlayItem>[];

  /// 되돌리기 스택. 사용자 동작 **하나가 시작될 때** 직전 상태를 쌓는다.
  final List<_Snapshot> _history = <_Snapshot>[];

  /// 그리는 중인 선. 손을 떼면 [_strokes] 로 옮긴다.
  PenStroke? _drawing;

  /// 선택된 오버레이 id. (테두리 + 삭제 배지 표시)
  int? _selectedId;

  /// 오버레이 id 발급기.
  int _nextId = 0;

  DecorationTool get tool => _tool;
  Color get penColor => _penColor;
  double get penWidth => _penWidth;
  double get eraserWidth => _eraserWidth;

  /// 지금 도구가 지우개인지. (획을 그을 때 파내기로 남길지 결정)
  bool get _isErasing => _tool == DecorationTool.eraser;

  /// 이미 그은 획들. (긋는 중인 획은 [drawing])
  List<PenStroke> get strokes => List.unmodifiable(_strokes);
  PenStroke? get drawing => _drawing;
  List<OverlayItem> get overlays => List.unmodifiable(_overlays);
  int? get selectedId => _selectedId;

  /// 지울 것이 하나도 없는 상태. (초기화 버튼을 잠그는 기준)
  bool get isEmpty => _strokes.isEmpty && _overlays.isEmpty && _drawing == null;

  /// 되돌릴 동작이 남아 있는지. (되돌리기 버튼을 잠그는 기준)
  bool get canUndo => _history.isNotEmpty;

  // ── 되돌리기 ──────────────────────────────────────────────────────

  /// 동작 직전 상태를 스택에 쌓는다. 상태를 바꾸는 동작마다 **시작 시점에**
  /// 한 번만 부른다. (끄는 도중 여러 번 불리는 그리기·지우개는 시작에서 한 번)
  void _pushHistory() {
    _history.add(_Snapshot(List.of(_strokes), List.of(_overlays)));
    // 오래된 단계부터 버려 메모리가 무한정 늘지 않게 한다.
    if (_history.length > _maxHistory) _history.removeAt(0);
  }

  /// 마지막 동작 하나를 되돌린다.
  void undo() {
    if (_history.isEmpty) return;
    final snapshot = _history.removeLast();
    _strokes
      ..clear()
      ..addAll(snapshot.strokes);
    _overlays
      ..clear()
      ..addAll(snapshot.overlays);
    _drawing = null;
    // 되돌린 뒤 사라진 요소가 선택돼 있으면 선택을 푼다.
    if (!_overlays.any((item) => item.id == _selectedId)) _selectedId = null;
    notifyListeners();
  }

  // ── 도구 ──────────────────────────────────────────────────────────

  void selectTool(DecorationTool next) {
    if (_tool == next) return;
    _tool = next;
    // 도구가 바뀌면 선택 표시를 걷는다. (펜으로 그릴 때 배지가 걸리지 않도록)
    _selectedId = null;
    notifyListeners();
  }

  void selectPenColor(Color color) {
    if (_penColor == color) return;
    _penColor = color;
    notifyListeners();
  }

  void selectPenWidth(double width) {
    if (_penWidth == width) return;
    _penWidth = width;
    notifyListeners();
  }

  void selectEraserWidth(double width) {
    if (_eraserWidth == width) return;
    _eraserWidth = width;
    notifyListeners();
  }

  // ── 펜·지우개 ─────────────────────────────────────────────────────
  //
  // 둘은 같은 획을 남기고, 지우개만 칠할 때 파내는 붓이 된다.

  void beginStroke(Offset point) {
    _pushHistory();
    _drawing = PenStroke(
      points: <Offset>[point],
      color: _penColor,
      width: _isErasing ? _eraserWidth : _penWidth,
      isEraser: _isErasing,
    );
    notifyListeners();
  }

  void extendStroke(Offset point) {
    final drawing = _drawing;
    if (drawing == null) return;
    _drawing = drawing.addPoint(point);
    notifyListeners();
  }

  void endStroke() {
    final drawing = _drawing;
    if (drawing == null) return;
    // 점 하나짜리도 남긴다. (톡 찍은 점도 그림의 일부)
    _strokes.add(drawing);
    _drawing = null;
    notifyListeners();
  }

  // ── 오버레이 (텍스트·스티커) ──────────────────────────────────────

  void addText({
    required String text,
    required Offset position,
    required Color color,
  }) {
    _pushHistory();
    _overlays.add(
      TextOverlay(id: _nextId++, position: position, text: text, color: color),
    );
    _selectedId = _overlays.last.id;
    notifyListeners();
  }

  /// [id] 글자의 내용·색을 바꾼다. (자리는 그대로)
  void updateText({
    required int id,
    required String text,
    required Color color,
  }) {
    final index = _overlays.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final item = _overlays[index];
    if (item is! TextOverlay) return;
    _pushHistory();
    _overlays[index] = item.edited(text: text, color: color);
    notifyListeners();
  }

  void addSticker({required StickerData sticker, required Offset position}) {
    _pushHistory();
    _overlays.add(
      StickerOverlay(id: _nextId++, position: position, sticker: sticker),
    );
    _selectedId = _overlays.last.id;
    notifyListeners();
  }

  /// 요소를 골라 맨 위로 올린다.
  ///
  /// 목록 순서가 곧 겹침 순서(뒤에 있을수록 위)라, 맨 뒤로 옮기면 위로 온다.
  /// 이미 맨 위면 순서를 건드리지 않아 되돌리기 단계도 늘지 않는다.
  /// (탭할 때마다 되돌릴 거리가 쌓이면 곤란하다)
  void bringToFront(int id) {
    final index = _overlays.indexWhere((item) => item.id == id);
    if (index < 0) return;
    if (!_isTop(index)) _pushHistory();
    _raise(index);
    _selectedId = id;
    notifyListeners();
  }

  /// 끌기 시작. 집어 든 요소를 맨 위로 올리고, 끄는 동안의 이동과 순서 변경을
  /// 한 동작으로 묶어 되돌린다.
  void beginMove(int id) {
    final index = _overlays.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _pushHistory();
    _raise(index);
    _selectedId = id;
    notifyListeners();
  }

  bool _isTop(int index) => index == _overlays.length - 1;

  void _raise(int index) {
    if (_isTop(index)) return;
    _overlays.add(_overlays.removeAt(index));
  }

  /// [id] 오버레이를 [position] 으로 옮긴다. (프레임 밖으로는 나가지 않는다)
  void moveOverlay(int id, Offset position) {
    final index = _overlays.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _overlays[index] = _overlays[index].moveTo(
      Offset(position.dx.clamp(0.0, 1.0), position.dy.clamp(0.0, 1.0)),
    );
    notifyListeners();
  }

  void removeOverlay(int id) {
    _pushHistory();
    _overlays.removeWhere((item) => item.id == id);
    if (_selectedId == id) _selectedId = null;
    notifyListeners();
  }

  /// 선택 표시만 바꾼다. (겹침 순서는 건드리지 않는다)
  /// 요소를 고르는 것은 [bringToFront] 이고, 이쪽은 주로 선택 해제(null)에 쓴다.
  void select(int? id) {
    if (_selectedId == id) return;
    _selectedId = id;
    notifyListeners();
  }

  // ── 초기화 ────────────────────────────────────────────────────────

  /// 그림·텍스트·스티커를 모두 지운다. (도구·펜 설정은 그대로 둔다)
  /// 되돌리기로 살릴 수 있다.
  void reset() {
    if (isEmpty) return;
    _pushHistory();
    _strokes.clear();
    _overlays.clear();
    _drawing = null;
    _selectedId = null;
    notifyListeners();
  }
}
