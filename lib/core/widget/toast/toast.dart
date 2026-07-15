import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:flutter/widgets.dart';

/// 토스트 종류. (좌측 뱃지의 기호·색이 달라진다)
enum ToastType {
  /// 일반 안내. (강조색 'i')
  info,

  /// 오류 안내. (빨간색 '!')
  error,
}

/// 안내 메시지를 잠깐 띄우는 토스트.
///
/// 좌측 원형 뱃지([type]) + 메시지로 구성된다. 폭은 부모가 정한 만큼 채우고,
/// 메시지가 길면 줄바꿈된다.
///
/// 화면에 띄울 때는 [Toast.showToast] 를 쓴다. (오버레이 + 자동 제거)
class Toast extends StatelessWidget {
  const Toast({super.key, required this.message, this.type = ToastType.info});

  /// 토스트에 보여줄 메시지.
  final String message;

  /// 토스트 종류. (기본 [ToastType.info])
  final ToastType type;

  /// 화면 하단에 토스트를 잠깐 띄운다.
  ///
  /// 페이드·슬라이드로 나타났다가 [duration] 후 사라지고 스스로 제거된다.
  /// 터치는 가로채지 않으므로 토스트 뒤의 UI 는 그대로 조작할 수 있다.
  static void showToast(
    BuildContext context,
    String message, {
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastOverlay(
        message: message,
        type: type,
        duration: duration,
        onDismissed: entry.remove,
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 좌우 s4(16). 상하는 토큰에 없는 14 라 그대로 둔다.
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      decoration: ShapeDecoration(
        color: AppColors.bgSurfaceAlt,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSpacing.s3,
        children: [
          _ToastBadge(type: type),
          // 고정 폭 대신 남는 공간을 채우고 길면 줄바꿈한다.
          Expanded(child: AppText.body(message, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

/// 원 안에 기호를 넣은 토스트 뱃지. (info: 강조색 'i' / error: 빨간색 '!')
class _ToastBadge extends StatelessWidget {
  const _ToastBadge({required this.type});

  final ToastType type;

  @override
  Widget build(BuildContext context) {
    final (symbol, color) = switch (type) {
      ToastType.info => ('i', AppColors.accentDefault),
      ToastType.error => ('!', AppColors.statusDanger),
    };

    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(color: color, shape: const CircleBorder()),
      child: AppText.label(symbol, color: AppColors.textPrimary),
    );
  }
}

/// 토스트의 등장·유지·퇴장 애니메이션을 관리하는 오버레이 본체.
class _ToastOverlay extends StatefulWidget {
  const _ToastOverlay({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.3),
    end: Offset.zero,
  ).animate(_fade);

  @override
  void initState() {
    super.initState();
    _play();
  }

  /// 등장 → [duration] 유지 → 퇴장 → 제거.
  Future<void> _play() async {
    await _controller.forward();
    await Future<void>.delayed(widget.duration);
    if (!mounted) return;
    await _controller.reverse();
    if (!mounted) return;
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s4,
              0,
              AppSpacing.s4,
              AppSpacing.s6,
            ),
            // 토스트는 안내용이라 뒤 UI 의 터치를 막지 않는다.
            child: IgnorePointer(
              child: SlideTransition(
                position: _slide,
                child: FadeTransition(
                  opacity: _fade,
                  child: Toast(message: widget.message, type: widget.type),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
