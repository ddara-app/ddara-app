import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/feature/group/starter/provider/notifier_provider.dart';
import 'package:ddara/feature/group/starter/starter_camera.dart';
import 'package:ddara/feature/group/starter/starter_info.dart';
import 'package:ddara/feature/group/starter/util/starter_state.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 스타터 시작 화면. 본문(촬영 · 정보 입력)만 단계별로 교체한다.
class StarterPage extends ConsumerWidget {
  const StarterPage({super.key, required this.groupId});

  /// 스타터를 시작할 모임 식별자. (업로드 시 사이클 생성 대상)
  final int groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final step = ref.watch(starterNotifierProvider.select((s) => s.step));
    final notifier = ref.read(starterNotifierProvider.notifier);

    final body = switch (step) {
      StarterStep.camera => const StarterCamera(),
      StarterStep.info => StarterInfo(groupId: groupId),
    };

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.starterTitle,
        // 단계에 따라 뒤로가기 동작을 달리한다.
        onBack: () {
          // 촬영(시작 단계)에서는 화면을 닫고, 본문에서는 촬영으로 돌아간다.
          if (step == StarterStep.camera) {
            context.pop();
          } else {
            notifier.goToCamera();
          }
        },
      ),
      child: body,
    );
  }
}
