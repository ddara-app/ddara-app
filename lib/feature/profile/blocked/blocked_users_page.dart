import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/util/date_format.dart';
import 'package:ddara/core/widget/profile_avatar.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 목록 항목의 아바타 지름.
const double _avatarSize = 48;

/// 차단한 유저 한 명의 표시 데이터.
///
/// TODO: 차단 목록 조회 API 응답 모델로 대체. (백엔드 스펙 대기 — 임시 record)
typedef BlockedUserDisplay = ({int userId, String nickname, DateTime blockedAt});

/// 차단한 유저 목록 화면. (프로필 → 차단한 유저 목록)
///
/// 차단한 유저를 아바타·이름·차단 날짜와 함께 나열하고, 각 항목에서
/// 차단을 해제할 수 있다.
class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // TODO: 차단 목록 조회 API 연결. (백엔드 스펙 대기 — 임시 빈 목록)
    const blockedUsers = <BlockedUserDisplay>[];

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.blockedUsersTitle,
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        bottom: false,
        child: blockedUsers.isEmpty
            ? Center(child: AppText.body(l10n.blockedUsersEmpty))
            : ListView.builder(
                padding: EdgeInsets.only(
                  left: AppSpacing.s4,
                  right: AppSpacing.s4,
                  // 마지막 항목이 홈 인디케이터와 겹치지 않도록 인셋만큼 더 띄운다.
                  bottom: AppSpacing.s6 + MediaQuery.of(context).padding.bottom,
                ),
                itemCount: blockedUsers.length,
                itemBuilder: (context, index) => _BlockedUserTile(
                  user: blockedUsers[index],
                  onUnblock: () {
                    // TODO: 차단 해제 API 연결. (백엔드 스펙 대기)
                  },
                ),
              ),
      ),
    );
  }
}

/// 차단한 유저 한 명. (기본 프로필 아이콘 + 차단 정보 + 차단 해제 버튼)
class _BlockedUserTile extends StatelessWidget {
  const _BlockedUserTile({required this.user, required this.onUnblock});

  final BlockedUserDisplay user;

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
                  AppText.label(user.nickname, color: AppColors.textPrimary),
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
