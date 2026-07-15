import 'package:ddara/feature/group/starter/provider/notifier_provider.dart';
import 'package:ddara/core/widget/camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 스타터(첫 따라찍기) 촬영 본문.
///
/// 가이드 사진이 없어 투명도·모드 영역은 띄우지 않는다.
/// → 프리뷰 · 플래시 · 전환 · 촬영 버튼만 표시된다.
class StarterCamera extends ConsumerWidget {
  const StarterCamera({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(starterNotifierProvider.notifier);

    // 촬영 버튼을 누르면 사진 확인 단계로 전환한다.
    return Camera(onCapture: notifier.capture);
  }
}
