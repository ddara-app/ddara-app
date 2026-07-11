import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/component/button/app_button.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/exception/group_join_error_code.dart';
import 'package:ddara/core/model/group/invite_group.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/util/tap_guard.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group/join/confirm/join_confirm.dart';
import 'package:ddara/feature/group/join/provider/notifier_provider.dart';
import 'package:ddara/feature/group/widget/set_nickname.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// [JoinGroupPage] 로 전달할 인자. (go_router `extra` 로 넘긴다)
class JoinGroupArgs {
  const JoinGroupArgs({required this.group, required this.inviteCode});

  /// 조회된 모임 정보. 조회 실패 시 null.
  final InviteGroup? group;

  /// 진입에 사용한 초대 코드. (참여 API 호출에 사용)
  final String inviteCode;
}

/// 모임 참여 흐름을 한 화면에서 두 스텝으로 진행한다.
///
/// - 0: 모임 정보 확인([JoinConfirm])
/// - 1: 모임에서 쓸 닉네임 입력([SetNickname])
///
/// AppBar·하단 버튼은 이 화면이 공유로 들고, 본문만 [IndexedStack] 으로 교체한다.
/// (두 스텝을 모두 살려둬 뒤로 가도 입력이 보존된다)
class JoinGroupPage extends ConsumerStatefulWidget {
  const JoinGroupPage({
    super.key,
    required this.group,
    required this.inviteCode,
  });

  /// 참여할 모임 정보. 조회 실패 시 null.
  final InviteGroup? group;

  /// 진입에 사용한 초대 코드. (참여 API 호출에 사용)
  final String inviteCode;

  @override
  ConsumerState<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends ConsumerState<JoinGroupPage> {
  /// 현재 스텝. 0: 모임 정보 확인, 1: 닉네임.
  int _step = 0;

  InviteGroup? get _group => widget.group;

  /// 유효하고 참여 가능한 모임인지. (확인 스텝의 다음 진행 조건)
  bool get _canJoin {
    final group = _group;
    return group != null && !group.alreadyJoined && !group.isFull;
  }

  /// 뒤로가기: 닉네임 스텝이면 확인 스텝으로, 첫 스텝이면 pop(없으면 홈).
  void _handleBack() {
    if (_step > 0) {
      setState(() => _step = 0);
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go(RoutePath.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    final state = ref.watch(joinGroupNotifierProvider);
    final notifier = ref.read(joinGroupNotifierProvider.notifier);
    final l10n = AppLocalizations.of(context);

    // 닉네임 필드 에러: 클라이언트 검증 우선, 없으면 서버의 닉네임 중복 에러.
    final nicknameError =
        validateNickname(l10n, state.nickname) ??
        (state.errorCode == GroupJoinErrorCode.duplicateGroupNickname
            ? GroupJoinErrorCode.duplicateGroupNickname.message
            : null);

    // 스텝별 다음 진행 가능 조건.
    final canSubmit = switch (_step) {
      0 => _canJoin,
      _ => state.nickname.isNotEmpty && nicknameError == null,
    };

    ref.listen(joinGroupNotifierProvider, (prev, next) {
      // 참여 성공 시 모임 화면으로 이동. (홈 목록을 무효화해 새 모임이 반영되게 한다)
      // 모임 화면의 뒤로가기(AppBar·OS)는 GroupPage 가 항상 홈으로 처리한다.
      if (prev?.joinedGroupId == -1 && next.joinedGroupId > -1) {
        ref.invalidate(homeNotifierProvider);
        context.pushReplacement(RoutePath.group, extra: next.joinedGroupId);
        return;
      }

      final errorCode = next.errorCode;
      // 닉네임 중복은 입력 필드 인라인으로 보여주므로 토스트에서 제외.
      if (errorCode != null &&
          errorCode != GroupJoinErrorCode.duplicateGroupNickname) {
        Toast.showToast(context, errorCode.message, type: ToastType.error);
      }
    });

    return PopScope(
      // 확인 스텝이고 pop 할 스택이 있을 때만 시스템 뒤로가기를 허용한다.
      canPop: _step == 0 && context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_step > 0) {
          setState(() => _step = 0);
        } else {
          context.go(RoutePath.home);
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: AppBar(title: l10n.groupJoinTitle, onBack: _handleBack),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.s4,
              right: AppSpacing.s4,
              top: AppSpacing.s2,
              bottom: AppSpacing.s4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: IndexedStack(
                    index: _step,
                    sizing: StackFit.expand,
                    children: [
                      JoinConfirm(group: group),
                      SetNickname(
                        groupName: group?.name ?? '',
                        onChanged: notifier.nicknameOnChanged,
                        errorText: nicknameError,
                      ),
                    ],
                  ),
                ),
                // 스텝 간 공유하는 하단 버튼.
                AppButton(
                  label: _step == 0 ? l10n.groupJoin : l10n.commonStart,
                  // 참여 요청이 진행되는 동안 중복 탭을 차단한다.
                  onPressed: tapGuard(
                    state.isLoading,
                    canSubmit
                        ? () {
                            if (_step == 0) {
                              setState(() => _step = 1);
                            } else {
                              notifier.joinGroup(widget.inviteCode);
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
