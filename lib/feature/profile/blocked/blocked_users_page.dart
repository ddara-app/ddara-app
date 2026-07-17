import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/model/block/blocked_users.dart';
import 'package:ddara/core/util/date_format.dart';
import 'package:ddara/core/widget/profile_avatar.dart';
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
      child: SafeArea(bottom: false, child: _body(context, l10n, state)),
    );
  }

  Widget _body(
    BuildContext context,
    AppLocalizations l10n,
    BlockedUsersState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    final blockedUsers = state.blockedUsers;
    if (blockedUsers == null) {
      // 조회 실패. (errorMessage 는 notifier 가 채운다)
      return Center(child: AppText.body(state.errorMessage));
    }

    final users = blockedUsers.users;
    if (users.isEmpty) {
      return Center(child: AppText.body(l10n.blockedUsersEmpty));
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        left: AppSpacing.s4,
        right: AppSpacing.s4,
        // 마지막 항목이 홈 인디케이터와 겹치지 않도록 인셋만큼 더 띄운다.
        bottom: AppSpacing.s6 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) => _BlockedUserTile(
        user: users[index],
        onUnblock: () {
          // TODO: 차단 해제 API 연결. (백엔드 스펙 대기)
        },
      ),
    );
  }
}

/// 차단한 유저 한 명. (기본 프로필 아이콘 + 차단 정보 + 차단 해제 버튼)
class _BlockedUserTile extends StatelessWidget {
  const _BlockedUserTile({required this.user, required this.onUnblock});

  final BlockedUser user;

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
                  AppText.caption(formatDate(user.blockedAt)),
                ],
              ),
            ],
          ),
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
          horizontal: AppSpacing.s3,
          vertical: AppSpacing.s2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.accentDefault),
        ),
        child: AppText.label(label, color: AppColors.accentDefault),
      ),
    );
  }
}
