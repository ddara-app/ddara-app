import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// DDARA 초대장 열림 애니메이션 위젯.
///
/// 원본 스펙: 512x512, 90fps, 174프레임 (약 1.93초).
/// 마커: closed(0) · prep(12) · flap-open(64) · letter-settled(110) · sparkles-done(138)
///
/// 사용 예:
/// ```dart
/// DdaraInvitationAnimation(
///   size: 240,
///   autoPlay: true,
///   onCompleted: () => print('열림 완료'),
/// )
/// ```
class DdaraInvitationAnimation extends StatefulWidget {
  const DdaraInvitationAnimation({
    super.key,
    this.size = 256,
    this.autoPlay = true,
    this.repeat = false,
    this.onCompleted,
  });

  /// 위젯의 가로/세로 크기 (원본은 정사각형).
  final double size;

  /// 위젯이 나타나면 바로 재생할지 여부.
  final bool autoPlay;

  /// 재생 후 반복할지 여부.
  final bool repeat;

  /// 1회 재생이 끝났을 때 호출 (repeat=false 일 때만).
  final VoidCallback? onCompleted;

  @override
  State<DdaraInvitationAnimation> createState() => DdaraInvitationAnimationState();
}

class DdaraInvitationAnimationState extends State<DdaraInvitationAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onCompleted?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 처음부터 재생.
  void play() => _controller.forward(from: 0);

  /// 정지 후 첫 프레임(closed)으로.
  void reset() => _controller.reset();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Lottie.asset(
        'assets/lottie/ddara-invitation-open.json',
        controller: _controller,
        repeat: widget.repeat,
        fit: BoxFit.contain,
        onLoaded: (composition) {
          // JSON 안의 fps/프레임 수를 그대로 반영해 정확한 속도로 재생.
          _controller.duration = composition.duration;
          if (widget.autoPlay) {
            widget.repeat
                ? _controller.repeat()
                : _controller.forward(from: 0);
          }
        },
      ),
    );
  }
}
