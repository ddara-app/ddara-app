import 'package:ddara/core/design_system/component/text_field/app_text_field.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/exception/group_join_error_code.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/util/tap_guard.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group_join/join_group_page.dart';
import 'package:ddara/feature/group_join/provider/viewmodel_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 토스트 대신 입력 필드 아래 인라인 에러(errorText)로 보여줄 에러 코드.
const _inlineErrorCodes = {
  GroupJoinErrorCode.invalidInviteCode,
  GroupJoinErrorCode.groupFull,
  GroupJoinErrorCode.alreadyJoinedGroup,
};

/// 초대 딥링크(`kakao{KEY}://kakaolink?invite_code=...` 또는
/// `https://ddara.app/invite?code=...`)로 진입했을 때 보여줄 모임 참여 화면.
///
/// 딥링크에서 파싱한 [inviteCode] 가 있으면 입력 필드에 미리 채워준다.
class InviteCodeInputPage extends ConsumerStatefulWidget {
  const InviteCodeInputPage({super.key, required this.inviteCode});

  /// 딥링크로 전달받은 초대코드. (직접 입력으로 들어온 경우 빈 문자열)
  final String inviteCode;

  @override
  ConsumerState<InviteCodeInputPage> createState() =>
      _InviteCodeInputPageState();
}

class _InviteCodeInputPageState extends ConsumerState<InviteCodeInputPage> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    // 딥링크로 받은 코드가 있으면 입력값으로 미리 채운다.
    _codeController = TextEditingController(text: widget.inviteCode);

    // 미리 채워진 초대 코드를 State에도 반영한다.
    if (widget.inviteCode.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(inviteCodeInputViewModelProvider.notifier)
            .inviteCodeOnChanged(widget.inviteCode);
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(inviteCodeInputViewModelProvider.notifier);
    final state = ref.watch(inviteCodeInputViewModelProvider);
    final l10n = AppLocalizations.of(context);

    // 아래 에러 코드는 입력 필드 아래 인라인 에러로 표시한다.
    final errorCode = state.errorCode;
    final codeErrorText =
        errorCode != null && _inlineErrorCodes.contains(errorCode)
        ? errorCode.message(l10n)
        : null;

    ref.listen(inviteCodeInputViewModelProvider, (prev, next) {
      // 모든 검증 통과 시 참여 확인 화면으로 inviteGroup 을 담아 이동.
      final inviteGroup = next.inviteGroup;
      if (prev?.inviteGroup == null && inviteGroup != null) {
        context.push(
          RoutePath.joinGroup,
          extra: JoinGroupArgs(group: inviteGroup, inviteCode: next.inviteCode),
        );
        return;
      }

      final errorCode = next.errorCode;

      // 인라인(errorText)으로 보여주는 코드는 토스트에서 제외.
      if (errorCode != null && !_inlineErrorCodes.contains(errorCode)) {
        Toast.showToast(
          context,
          errorCode.message(l10n),
          type: ToastType.error,
        );
      }
    });

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.groupJoinTitle,
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.s5,
            right: AppSpacing.s5,
            top: AppSpacing.s3,
            bottom: AppSpacing.s7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleDescription(
                title: l10n.groupJoinHeadline,
                description: l10n.groupJoinSubtitle,
              ),
              const SizedBox(height: AppSpacing.s7),
              AppTextField(
                label: l10n.groupJoinCodeLabel,
                placeholder: l10n.groupJoinCodePlaceholder,
                controller: _codeController,
                highlightWhenFilled: true,
                errorText: codeErrorText,
                onChanged: viewModel.inviteCodeOnChanged,
              ),
              const Spacer(),
              AppButton(
                label: l10n.groupJoin,
                // 코드가 비어 있으면(빈 조회 방지) 또는 조회 중이면 탭을 막는다.
                onPressed: tapGuard(
                  state.isLoading || state.inviteCode.trim().isEmpty,
                  () => viewModel.fetchInviteGroup(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
