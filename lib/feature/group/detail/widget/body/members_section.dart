import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/domain/model/group/group_detail.dart';
import 'package:ddara/feature/group/detail/group_page_actions.dart';
import 'package:ddara/feature/group/detail/widget/body/members.dart';
import 'package:ddara/feature/group/detail/widget/group_section.dart';
import 'package:ddara/feature/profile/provider/viewmodel_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// '친구들' 섹션. 멤버 아바타 목록과 초대 버튼을 보여주고, 롱프레스 메뉴의
/// 신고·차단을 [GroupPageActions] 로 넘긴다.
class MembersSection extends ConsumerWidget {
  const MembersSection({
    super.key,
    required this.detail,
    required this.blockedUserIds,
    required this.actions,
  });

  final GroupDetail detail;

  /// 내가 차단한 유저 id 집합. (기본 아이콘 + 취소선 닉네임으로 표시)
  final Set<int> blockedUserIds;

  final GroupPageActions actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // 현재 사용자 id. (본인 프로필에는 신고·차단 메뉴를 띄우지 않기 위함)
    // id 만 보므로 닉네임·이미지 변경으로는 다시 그리지 않는다.
    final myUserId = ref.watch(
      currentProfileProvider.select((profile) => profile.valueOrNull?.id),
    );
    final starterUserId = _starterUserId(detail);

    return GroupSection(
      title: AppText.headlineLarge(l10n.groupMembersTitle),
      body: Members(
        members: detail.members
            .map(
              (member) => (
                userId: member.userId,
                name: member.nickname,
                imageUrl: member.profileImageUrl,
                // 차단한 멤버는 기본 아이콘 + 취소선 닉네임으로 표시된다.
                isBlocked: blockedUserIds.contains(member.userId),
                // 본인 프로필에는 롱프레스 메뉴를 띄우지 않는다.
                isMe: member.userId == myUserId,
                // 스타터는 프로필에 배지를 달아 목록에서도 알아볼 수 있게 한다.
                isStarter:
                    starterUserId != null && member.userId == starterUserId,
              ),
            )
            .toList(),
        onAddMember: () => actions.showInviteSheet(detail.inviteCode),
        onReportMember: (member) => actions.reportMember(member.userId),
        onBlockMember: (member) =>
            actions.blockMember(member.userId, member.name),
      ),
    );
  }

  /// 친구들 목록에서 스타터 배지를 달 멤버의 userId. 대상이 없으면 null.
  ///
  /// 따라찍기가 시작됐으면 그 사이클의 스타터를, 아직이면 다음 사이클의
  /// 스타터를 가리킨다. 다음 스타터는 랜덤 공개(룰렛)를 본 뒤에만 표시해,
  /// 아직 공개를 보지 못한 멤버에게 결과가 미리 새지 않게 한다.
  int? _starterUserId(GroupDetail detail) {
    final cycle = detail.currentCycle;
    if (cycle != null) return cycle.starterUserId;

    final nextStarter = detail.nextStarter;
    if (nextStarter == null || !nextStarter.seen) return null;
    return nextStarter.userId;
  }
}
