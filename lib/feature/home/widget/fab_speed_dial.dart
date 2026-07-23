// ============================================================================
// DDARA · FAB Speed-dial 펼침 마이크로인터랙션
// 화면: [G1] 모임룸 — 우하단 플로팅 버튼
//
// ── 모션 스펙 ──────────────────────────────────────────────────────────────
//  · 펼침 360ms / 접힘 240ms (접힘이 살짝 빠름)
//  · 메뉴 항목 = 아래→위 "순차(stagger)": 버튼에 가까운 항목부터 솟음
//      - 항목 간 시작 시차 0.18 (컨트롤러 진행 비율)
//      - 각 항목: 20px 아래에서 제자리로 이동 + opacity 0→1
//      - Curve = easeOutBack (착지에서 살짝 오버슈트)
//  · 메인 FAB 아이콘: + → × (45° 회전, 컨트롤러 진행에 연동)
//  · 백드롭: 펼침 시 검정 0→50%, 백드롭/항목/× 탭하면 닫힘
//
// ── 백드롭 계층 (AppBar 까지 덮기) ─────────────────────────────────────────
//  백드롭·메뉴·× 는 화면 Stack 이 아니라 "루트 Overlay"(= Navigator 위 계층)
//  에 띄운다. 그래서 CupertinoPageScaffold 의 navigationBar(AppBar) 를 포함한
//  화면 전체가 어두워진다. (액션시트·CupertinoContextMenu 와 동일한 원리)
//  · FAB(+) 자체는 제자리(페이지)에 두고, 열리면 같은 위치에 ×(Overlay)가 뜬다.
//
// ── 사용법 ───────────────────────────────────────────────────────────────
//  화면 Stack 맨 위(마지막 자식)에 얹고, 표시할 액션을 주입한다.
//    SpeedDialFab(actions: [
//      SpeedDialAction(label: '모임 만들기', filled: true, onTap: ...),
//      SpeedDialAction(label: '모임 참여하기', onTap: ...),
//    ])
// ============================================================================

import 'dart:math' as math;

import 'package:ddara/core/design_system/component/button/app_pill_button.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 펼침/접힘 모션 지속 시간.
const Duration _openDuration = Duration(milliseconds: 360);
const Duration _closeDuration = Duration(milliseconds: 240);

/// 항목 간 stagger 시작 시차(컨트롤러 진행 비율)와 각 항목 애니메이션 구간 길이.
const double _itemStagger = 0.18;
const double _itemSpan = 0.6;

/// 각 항목이 솟아오르기 시작하는 오프셋(px).
const double _itemRise = 20;

/// 다이얼(FAB·메뉴) 위치. 제자리 FAB 와 Overlay 의 × 가 동일 좌표를 쓰도록 공유.
const double _dialInset = AppSpacing.s5;

/// 메인 FAB 지름.
const double _fabSize = 56;

/// Speed-dial 메뉴 항목 하나. (라벨·강조 여부·탭 동작)
class SpeedDialAction {
  const SpeedDialAction({
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final VoidCallback onTap;

  /// true 면 강조색으로 채운 버튼, false 면 테두리만 있는 보조 버튼.
  final bool filled;
}

/// 우하단 플로팅 액션 버튼(Speed-dial).
///
/// 백드롭·메뉴·×는 루트 Overlay 에 띄워 AppBar 를 포함한 화면 전체를 덮는다.
class SpeedDialFab extends StatefulWidget {
  const SpeedDialFab({super.key, required this.actions});

  /// 펼쳤을 때 위→아래로 나열할 액션. (아래 항목일수록 먼저 솟는다)
  final List<SpeedDialAction> actions;

  @override
  State<SpeedDialFab> createState() => _SpeedDialFabState();
}

class _SpeedDialFabState extends State<SpeedDialFab>
    with SingleTickerProviderStateMixin {
  // 필드 지연 초기화(late final = ...)로 두면 FAB 를 한 번도 안 연 채 dispose 될 때
  // dispose 안에서 첫 초기화가 일어나고, 그 시점의 vsync(TickerMode 조회)가
  // "Looking up a deactivated widget's ancestor" 크래시를 낸다 → initState 에서 즉시 생성.
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: _openDuration,
      reverseDuration: _closeDuration,
    );
  }

  /// 루트 Overlay 에 삽입된 백드롭+메뉴 엔트리. null 이면 닫힌 상태.
  OverlayEntry? _entry;

  void _toggle() {
    final opening = _c.status != AnimationStatus.completed &&
        _c.status != AnimationStatus.forward;
    opening ? _open() : _close();
  }

  /// 루트 Overlay 에 백드롭+메뉴를 삽입하고 펼침 애니메이션을 재생한다.
  /// 루트 Overlay 는 페이지(AppBar 포함)보다 위 계층이라 화면 전체가 덮인다.
  void _open() {
    if (_entry == null) {
      _entry = OverlayEntry(builder: _buildOverlay);
      Overlay.of(context, rootOverlay: true).insert(_entry!);
      setState(() {}); // 제자리 FAB(+) 숨김
    }
    _c.forward();
  }

  /// 접힘 애니메이션 후 Overlay 엔트리를 제거한다.
  void _close() {
    _c.reverse().whenComplete(() {
      // 접히는 도중 다시 열렸다면(재진입) 제거하지 않는다.
      if (_c.status != AnimationStatus.dismissed) return;
      _entry?.remove();
      _entry = null;
      if (mounted) setState(() {}); // 제자리 FAB(+) 복귀
    });
  }

  /// 항목 탭: 메뉴를 닫으며 해당 액션을 실행한다.
  void _onActionTap(SpeedDialAction action) {
    _close();
    action.onTap();
  }

  @override
  void dispose() {
    _entry?.remove();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 제자리에는 닫힌 FAB(+) 만 둔다. 열려 있으면(Overlay 존재) 숨긴다.
    // (Overlay 의 × 가 같은 위치에 뜨므로 이중 표시를 막는다)
    if (_entry != null) return const SizedBox.shrink();
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            right: _dialInset,
            bottom: _dialInset,
            child: _buildMainFab(rotate: false),
          ),
        ],
      ),
    );
  }

  /// 루트 Overlay 에 그려질 백드롭 + 메뉴 + × 다이얼.
  Widget _buildOverlay(BuildContext context) {
    return Stack(
      children: [
        // 백드롭: 화면 전체(AppBar 포함)를 검정 0→50% 로 덮고, 탭하면 닫힘.
        Positioned.fill(
          child: GestureDetector(
            onTap: _toggle,
            child: AnimatedBuilder(
              animation: _c,
              builder: (_, _) => ColoredBox(
                color: const Color(0xFF000000)
                    .withValues(alpha: _c.value * 0.5),
              ),
            ),
          ),
        ),
        // 우하단 다이얼 (항목 + × FAB). 페이지의 SafeArea 기준과 맞추기 위해 SafeArea.
        SafeArea(
          child: Stack(
            children: [
              Positioned(
                right: _dialInset,
                bottom: _dialInset,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // IntrinsicWidth + stretch = 항목들을 가장 긴 항목 기준 동일 폭으로
                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < widget.actions.length; i++)
                            _buildItem(i),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s3),
                    _buildMainFab(rotate: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(int i) {
    final action = widget.actions[i];
    final n = widget.actions.length;
    final order = n - 1 - i; // 아래일수록 0 → 먼저 솟음
    final start = order * _itemStagger;
    final end = (start + _itemSpan).clamp(0.0, 1.0);
    final anim = CurvedAnimation(
      parent: _c,
      curve: Interval(start, end, curve: Curves.easeOutBack),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (_, child) {
        final t = anim.value;
        return Opacity(
          // easeOutBack 은 1 을 넘길 수 있어 opacity 는 clamp 한다.
          opacity: t.clamp(0.0, 1.0),
          // 오프셋은 raw 값을 써 착지 시 살짝 위로 오버슈트한다.
          child: Transform.translate(
            offset: Offset(0, (1 - t) * _itemRise),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s3),
        child: action.filled
            ? AppPillButton(
                label: action.label,
                onPressed: () => _onActionTap(action),
              )
            : AppPillButton.outline(
                label: action.label,
                onPressed: () => _onActionTap(action),
              ),
      ),
    );
  }

  /// 메인 FAB. [rotate] 면 진행에 맞춰 + 가 × 로 45° 회전한다.
  /// 제자리(페이지) FAB 는 rotate=false(정지된 +), Overlay 의 FAB 는 rotate=true.
  Widget _buildMainFab({required bool rotate}) {
    Widget icon = const AppIcon(
      AppIcons.add,
      color: AppColors.textOnAccent,
      size: 28,
    );
    if (rotate) {
      icon = AnimatedBuilder(
        animation: _c,
        builder: (_, child) => Transform.rotate(
          angle: _c.value * (math.pi / 4), // 0 → 45° : + 가 × 로
          child: child,
        ),
        child: icon,
      );
    }
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        width: _fabSize,
        height: _fabSize,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.accentDefault,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColorPrimitives.black40,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: icon,
      ),
    );
  }
}
