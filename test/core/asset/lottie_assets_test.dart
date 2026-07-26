import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

/// 앱이 참조하는 Lottie 에셋이 lottie 패키지로 실제 파싱되는지 검증한다.
///
/// 파싱에 실패하면 위젯의 errorBuilder 로 빠져 연출이 통째로 생략되는데,
/// 이는 런타임에 조용히 지나가므로 회귀를 테스트로 잡는다.
/// (예: slots(sid) 참조처럼 패키지가 지원하지 않는 최신 Lottie 스펙)
void main() {
  const assets = [
    'assets/lottie/ddara-invitation-open.json',
    'assets/lottie/starter-result-confetti-transparent.json',
  ];

  for (final path in assets) {
    test('$path 가 파싱된다', () async {
      final bytes = File(path).readAsBytesSync();
      final composition = await LottieComposition.fromBytes(bytes);
      expect(composition.duration.inMilliseconds, greaterThan(0));
    });
  }
}
