import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/block/blocked_users.dart';
import 'package:ddara/core/util/date_format.dart';
import 'package:ddara/core/design_system/component/avatar/profile_avatar.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/profile/blocked/provider/notifier_provider.dart';
import 'package:ddara/feature/profile/blocked/util/blocked_users_state.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 목록 항목의 아바타 지름.
const double _avatarSize = 48;

/// 차단한 유저 목록 화면. (프로필 → 차단한 유저 목록)
///
/// 차단한 유저를 아바타·이름·차단 날짜와 함께 나열하고, 각 항목에서
/// 차단을 해제할 수 있다.
class BlockedUsersPage extends ConsumerWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(blockedUsersNotifierProvider);

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.blockedUsersTitle,
        onBack: () => context.pop(),
      ),
      child: SafeArea(bottom: false, child: _body(context, ref, l10n, state)),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    BlockedUsersState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    final blockedUsers = state.blockedUsers;
    if (blockedUsers == null) {
      // 조회 실패. (로딩이 끝났는데 목록이 없으면 실패로 본다)
      return Center(child: AppText.body(l10n.blockedUsersLoadFailed));
    }

    final users = blockedUsers.users;
    if (users.isEmpty) {
      return Center(child: AppText.body(l10n.blockedUsersEmpty));
    }

    // 안내 문구를 목록 마지막 항목(footer)으로 붙인다. 유저가 적으면 타일
    // 바로 아래에, 많아지면 목록 끝(하단)으로 자연스럽게 밀려난다.
    // (빈 목록은 위에서 조기 반환하므로 안내도 함께 숨는다)
    return ListView.builder(
      padding: EdgeInsets.only(
        left: AppSpacing.s4,
        right: AppSpacing.s4,
        // 마지막 항목이 홈 인디케이터와 겹치지 않도록 인셋만큼 더 띄운다.
        bottom: AppSpacing.s6 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: users.length + 1,
      itemBuilder: (context, index) {
        if (index == users.length) {
          return Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s5),
            child: AppText.caption(
              l10n.blockedUsersNotice,
              textAlign: TextAlign.left,
            ),
          );
        }
        return _BlockedUserTile(
          user: users[index],
          // 이 항목이 해제 진행 중이면 버튼 자리에 로딩을 표시한다.
          isUnblocking: state.unblockingUserIds.contains(users[index].userId),
          onUnblock: () => _unblock(context, ref, users[index]),
        );
      },
    );
  }

  /// 확인 다이얼로그를 띄우고, 확인 시에만 차단을 해제한 뒤 결과를 토스트로
  /// 안내한다. (성공 시 목록은 notifier 가 재조회)
  Future<void> _unblock(
    BuildContext context,
    WidgetRef ref,
    BlockedUser user,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ok = await AppDialog.show(
      context,
      title: l10n.blockedUsersUnblockConfirmTitle(user.name),
      message: l10n.blockedUsersUnblockConfirmBody,
      confirmLabel: l10n.blockedUsersUnblockConfirmAction,
    );
    if (!ok || !context.mounted) return;

    final success = await ref
        .read(blockedUsersNotifierProvider.notifier)
        .unblock(user.userId);
    if (!context.mounted) return;

    Toast.showToast(
      context,
      success
          ? l10n.blockedUsersUnblockedToast
          : l10n.blockedUsersUnblockFailed,
      type: success ? ToastType.info : ToastType.error,
    );
  }
}

/// 차단한 유저 한 명. (기본 프로필 아이콘 + 차단 정보 + 차단 해제 버튼)
class _BlockedUserTile extends StatelessWidget {
  const _BlockedUserTile({
    required this.user,
    required this.isUnblocking,
    required this.onUnblock,
  });

  final BlockedUser user;

  /// 이 항목의 차단 해제가 진행 중인지. true 면 버튼 대신 로딩을 표시한다.
  final bool isUnblocking;

  /// '차단 해제' 버튼을 눌렀을 때.
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: AppSpacing.s4,
            children: [
              // 차단 목록은 프로필 이미지를 내려주지 않으므로 항상 기본 아이콘.
              const ProfileAvatar(size: _avatarSize),
              // 차단 정보: 이름 + 차단 날짜.
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s1,
                children: [
                  AppText.label(user.name, color: AppColors.textPrimary),
                  AppText.caption(
                    AppLocalizations.of(context).blockedUsersNicknameDate(
                      user.blockedNickname,
                      formatDate(user.blockedAt),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isUnblocking)
            const SizedBox(
              width: _avatarSize,
              child: Center(child: CupertinoActivityIndicator()),
            )
          else
            _UnblockButton(
              label: AppLocalizations.of(context).blockedUsersUnblock,
              onPressed: onUnblock,
            ),
        ],
      ),
    );
  }
}

/// 목록 항목용 작은 테두리 버튼.
///
/// [AppButton.outline] 과 같은 톤(투명 배경 + 강조색 테두리·글자)이지만,
/// 목록 항목 안에 들어가도록 콘텐츠 크기에 맞는 작은 치수로 그린다.
class _UnblockButton extends StatelessWidget {
  const _UnblockButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s5,
          vertical: AppSpacing.s2,
        ),
        decoration: ShapeDecoration(
          // 완전히 둥근(pill) 아웃라인. (AppRadius 로는 살짝만 둥글다)
          shape: const StadiumBorder(
            side: BorderSide(color: AppColors.borderSelected),
          ),
        ),
        child: AppText.label(label, color: AppColors.textAccent),
      ),
    );
  }
}
