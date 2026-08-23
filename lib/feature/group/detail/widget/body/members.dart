import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/design_system/component/avatar/profile_avatar.dart';
import 'package:ddara/core/widget/circle_avatar_label.dart';
import 'package:ddara/feature/group/widget/anchored_context_menu.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 모임 멤버 한 명의 표시 데이터.
///
/// TODO: 모임 조회 API 의 멤버 모델로 대체. (백엔드 스펙 대기 — 임시 record)
typedef MemberDisplay = ({
  int userId,
  String name,
  String? imageUrl,
  bool isBlocked,
  bool isMe,
  bool isStarter,
});

/// 모임 멤버 목록. (원형 프로필 + 이름, 끝에 멤버 추가 버튼)
class Members extends StatelessWidget {
  const Members({
    super.key,
    required this.members,
    required this.onAddMember,
    required this.onReportMember,
    required this.onBlockMember,
  });

  final List<MemberDisplay> members;

  /// 우측 끝 + 버튼(멤버 초대) 탭 콜백.
  final VoidCallback onAddMember;

  /// 멤버 아바타를 롱프레스해 '유저 신고'를 선택했을 때. (대상 멤버 전달)
  final ValueChanged<MemberDisplay> onReportMember;

  /// 멤버 아바타를 롱프레스해 '차단하기'를 선택했을 때. (대상 멤버 전달)
  final ValueChanged<MemberDisplay> onBlockMember;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // 첫 아바타는 좌측 여백을 두고 시작하되, 스와이프하면 여백째 밀려나
      // 가장자리까지 넘어가도록 스크롤 콘텐츠 안쪽 패딩으로 준다.
      padding: const EdgeInsets.only(left: AppSpacing.s5),
      child: Row(
        spacing: AppSpacing.s3,
        children: [
          for (final member in members)
            _MemberAvatar(
              member: member,
              onReport: () => onReportMember(member),
              onBlock: () => onBlockMember(member),
            ),
          // 멤버 목록 끝에 항상 붙는 추가 버튼.
          _AddMemberButton(onPressed: onAddMember),
        ],
      ),
    );
  }
}

/// 원형 프로필 아바타 + 이름 라벨.
///
/// 본인이 아니면 길게 눌러 신고·차단 메뉴를 띄울 수 있다.
class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({
    required this.member,
    required this.onReport,
    required this.onBlock,
  });

  /// 스타터가 아닌 프로필의 테두리 두께.
  static const double _ringWidth = 1;

  /// 스타터 프로필 바깥 테두리(강조색) 두께.
  static const double _starterOuterRingWidth = 2;

  /// 바깥 테두리 안쪽에 덧대는 배경색 테두리 두께.
  static const double _starterInnerRingWidth = 2;

  final MemberDisplay member;

  /// 컨텍스트 메뉴에서 '유저 신고'를 선택했을 때.
  final VoidCallback onReport;

  /// 컨텍스트 메뉴에서 '차단하기'를 선택했을 때.
  final VoidCallback onBlock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = ellipsizeName(member.name);

    // 차단한 멤버는 기본 프로필 아이콘 + 취소선 닉네임으로 표시한다.
    final imageUrl = member.isBlocked ? null : member.imageUrl;
    final labelDecoration = member.isBlocked
        ? TextDecoration.lineThrough
        : null;

    final avatar = CircleAvatarLabel(
      label: label,
      labelDecoration: labelDecoration,
      child: Stack(
        children: [
          ProfileAvatar(size: CircleAvatarLabel.circleSize, imageUrl: imageUrl),
          // 스타터는 프로필 원형 테두리에 색을 입혀 표시한다.
          // (이미지 위에 겹쳐 그려 아바타 지름은 그대로 유지한다)
          if (member.isStarter)
            Positioned.fill(
              child: Semantics(
                label: l10n.groupMembersStarterBadge,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(
                        width: _starterOuterRingWidth,
                        color: AppColors.statusSuccess,
                      ),
                    ),
                  ),
                  // 초록 테두리 바로 안쪽에 배경색 테두리를 한 겹 더 둬,
                  // 프로필 사진과 강조색 사이에 여백처럼 보이는 띠를 만든다.
                  child: Padding(
                    padding: EdgeInsets.all(_starterOuterRingWidth),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(
                            width: _starterInnerRingWidth,
                            color: AppColors.bgBase,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            // 그 외 프로필은 원 가장자리를 배경과 구분해 주는 테두리만 둔다.
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(
                      width: _ringWidth,
                      color: AppColors.borderDefault,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    // 본인 프로필은 신고·차단 대상이 아니므로 메뉴 없이 아바타만 보여준다.
    if (member.isMe) return avatar;

    // 아바타가 작아 메뉴가 위를 덮지 않도록 대각선으로 띄운다.
    return AnchoredContextMenu(
      placement: ContextMenuPlacement.aboveDiagonal,
      // 멤버 아바타 메뉴 순서. (차단하기 → 신고하기)
      // 경고색은 되돌릴 수 없는 신고에만 쓴다. (차단은 해제할 수 있다)
      actions: [
        (label: l10n.memberBlock, color: null, onSelect: onBlock),
        (
          label: l10n.memberReportUser,
          color: AppColors.statusDanger,
          onSelect: onReport,
        ),
      ],
      child: avatar,
    );
  }
}

/// 멤버 목록 끝 + 버튼. 누르면 초대 공유 시트를 연다.
class _AddMemberButton extends StatelessWidget {
  const _AddMemberButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatarLabel(
      label: AppLocalizations.of(context).groupMembersAdd,
      onTap: onPressed,
      child: const SizedBox(
        width: CircleAvatarLabel.circleSize,
        height: CircleAvatarLabel.circleSize,
        child: AppIcon(AppIcons.add, size: 28, color: AppColors.textPrimary),
      ),
    );
  }
}
