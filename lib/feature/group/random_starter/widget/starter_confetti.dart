import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

/// 스타터 결과 축하 confetti 오버레이. (412×320 · 60fps · 1.8초 · 1회 재생)
///
/// 배경 투명 버전을 사용한다 — 화면 배경(bgBase)은 페이지가 그리고, 이
/// 위젯은 색종이·반짝임만 결과 리빌 위에 얹는다. 하단 CTA 터치를 막지
/// 않도록 [IgnorePointer] 로 감싼다.
class StarterConfetti extends StatelessWidget {
  const StarterConfetti({super.key, required this.controller});

  /// 재생 컨트롤러. 페이지가 소유하며 결과 리빌과 함께 forward 한다.
  ///
  /// duration 은 로드 시 JSON 의 실측 길이로 갱신된다. 로드에 실패해도
  /// 컨트롤러의 기본 duration 으로 재생 시퀀스가 진행되므로 CTA 활성화가
  /// 막히지 않는다.
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Lottie.asset(
        'assets/lottie/starter-result-confetti-transparent.json',
        controller: controller,
        fit: BoxFit.contain,
        onLoaded: (composition) => controller.duration = composition.duration,
        // 로드 실패 시 연출만 생략한다. (빈 위젯)
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}
