import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/util/tap_guard.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group_create/provider/notifier_provider.dart';
import 'package:ddara/feature/group_create/widget/set_group_name.dart';
import 'package:ddara/core/widget/set_nickname.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GroupCreatePage extends ConsumerStatefulWidget {
  const GroupCreatePage({super.key});

  @override
  ConsumerState<GroupCreatePage> createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends ConsumerState<GroupCreatePage> {
  /// 현재 스텝. 0: 모임 이름, 1: 닉네임.
  int _step = 0;

  /// 뒤로가기: 닉네임 스텝이면 이름 스텝으로, 첫 스텝이면 화면을 닫는다.
  void _handleBack() {
    if (_step > 0) {
      setState(() => _step = 0);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createGroupNotifierProvider);
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(createGroupNotifierProvider.notifier);

    final nicknameError = validateNickname(l10n, state.nickname);

    // 스텝별 다음 진행 가능 조건.
    final canSubmit = switch (_step) {
      0 =>
        state.groupName.trim().isNotEmpty &&
            state.groupName.length <= 20 &&
            state.description.length <= 100,
      _ => state.nickname.isNotEmpty && nicknameError == null,
    };

    ref.listen(createGroupNotifierProvider, (prev, next) {
      if (prev?.createGroupId == -1 && next.createGroupId > -1) {
        // 홈 목록을 무효화해, 상세에서 뒤로 돌아왔을 때 새 모임이 반영되게 한다.
        // (HomePage 는 스택에 남아 있어 재조회가 자동으로 일어나지 않는다)
        ref.invalidate(homeNotifierProvider);
        context.pushReplacement(RoutePath.group, extra: next.createGroupId);
        return;
      }

      final errorMessage = next.errorMessage;

      if (errorMessage.isNotEmpty) {
        Toast.showToast(context, errorMessage, type: ToastType.error);
      }
    });

    return PopScope(
      // 닉네임 스텝에선 시스템 뒤로가기를 가로채 이름 스텝으로 되돌린다.
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        setState(() => _step = 0);
      },
      child: CupertinoPageScaffold(
        navigationBar: AppBar(title: l10n.groupCreate, onBack: _handleBack),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.s4,
              right: AppSpacing.s4,
              top: AppSpacing.s2,
              bottom: AppSpacing.s6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 두 스텝을 모두 살려둬(컨트롤러 유지) 뒤로 가도 입력이 보존된다.
                IndexedStack(
                  index: _step,
                  sizing: StackFit.loose,
                  children: [
                    const SetGroupName(),
                    SetNickname(
                      groupName: state.groupName,
                      onChanged: notifier.nicknameOnChanged,
                      errorText: nicknameError,
                    ),
                  ],
                ),
                const Spacer(),
                // 스텝 간 공유하는 하단 버튼.
                AppButton(
                  label: _step == 0 ? l10n.commonNext : l10n.commonStart,
                  // 생성 요청이 진행되는 동안 중복 탭을 차단한다.
                  onPressed: tapGuard(
                    state.isLoading,
                    canSubmit
                        ? () {
                            if (_step == 0) {
                              setState(() => _step = 1);
                            } else {
                              notifier.createGroup();
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
