import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/design_system/component/avatar/profile_avatar.dart';
import 'package:ddara/core/widget/circle_avatar_label.dart';
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
});

/// 롱프레스 메뉴의 항목 하나. (라벨 + 글자색 + 선택 콜백)
typedef _MenuAction = ({String label, Color? color, VoidCallback onSelect});

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
      padding: const EdgeInsets.only(left: AppSpacing.s4),
      child: Row(
        spacing: AppSpacing.s2,
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
class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({
    required this.member,
    required this.onReport,
    required this.onBlock,
  });

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

    // 본인 프로필은 신고·차단 대상이 아니므로 메뉴 없이 아바타만 보여준다.
    if (member.isMe) {
      return CircleAvatarLabel(
        label: label,
        labelDecoration: labelDecoration,
        child: ProfileAvatar(
          size: CircleAvatarLabel.circleSize,
          imageUrl: imageUrl,
        ),
      );
    }

    final actions = <_MenuAction>[
      (
        label: l10n.memberBlock,
        color: AppColors.statusDanger,
        onSelect: onBlock,
      ),
      (
        label: l10n.memberReportUser,
        color: AppColors.statusDanger,
        onSelect: onReport,
      ),
    ];

    return _MenuAvatar(
      label: label,
      labelDecoration: labelDecoration,
      imageUrl: imageUrl,
      actions: actions,
    );
  }
}

/// 롱프레스하면 위쪽에 컨텍스트 메뉴(오버레이)를 띄우는 아바타 + 이름 라벨.
///
/// 아바타에 앵커된 작은 메뉴로, 바깥을 탭하면 닫힌다. 메뉴가 열리면 대상
/// 아바타·라벨 사본을 스크림 위로 띄워 선명하게 유지한다.
class _MenuAvatar extends StatefulWidget {
  const _MenuAvatar({
    required this.label,
    required this.imageUrl,
    required this.actions,
    this.labelDecoration,
  });

  /// 아바타 아래 라벨.
  final String label;

  /// 라벨 글자 장식. (예: 차단 멤버 취소선)
  final TextDecoration? labelDecoration;

  final String? imageUrl;

  /// 메뉴에 나열할 항목들. (위에서부터 순서대로)
  final List<_MenuAction> actions;

  @override
  State<_MenuAvatar> createState() => _MenuAvatarState();
}

class _MenuAvatarState extends State<_MenuAvatar> {
  /// 아바타 위치를 메뉴가 따라가게 잇는 링크.
  final LayerLink _link = LayerLink();

  /// 열려 있는 메뉴 라우트. 닫혀 있으면 null.
  Route<void>? _menuRoute;

  void _open() {
    if (_menuRoute != null) return;
    // 메뉴를 라우트로 띄워 뒤로가기(Android)가 화면 pop 대신 메뉴 닫기가
    // 되도록 한다. (스크림·바깥 탭 닫기는 라우트 배리어가 처리)
    final route = RawDialogRoute<void>(
      barrierColor: AppColorPrimitives.black60,
      barrierLabel: AppLocalizations.of(context).commonCancel,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, _, _) => _buildOverlay(dialogContext),
    );
    _menuRoute = route;
    Navigator.of(context).push(route).then((_) => _menuRoute = null);
  }

  /// 메뉴를 닫은 뒤 선택한 항목의 콜백을 실행한다.
  void _select(BuildContext dialogContext, VoidCallback onSelect) {
    Navigator.of(dialogContext).pop();
    onSelect();
  }

  @override
  void dispose() {
    // 아바타가 사라지면(목록 갱신 등) 열려 있던 메뉴 라우트도 함께 닫는다.
    final route = _menuRoute;
    if (route != null && route.isActive) {
      route.navigator?.removeRoute(route);
    }
    super.dispose();
  }

  Widget _buildOverlay(BuildContext dialogContext) {
    return Stack(
      children: [
        // 대상 아바타·라벨 사본을 스크림 위로 띄워 선명하게 유지한다.
        // 원본과 같은 위젯을 그대로 쓰므로 위치·간격을 따로 맞출 필요가 없다.
        // (원본 위에 정확히 겹쳐 아바타만 떠오른 것처럼 보인다)
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.topLeft,
          followerAnchor: Alignment.topLeft,
          child: IgnorePointer(child: _avatarLabel()),
        ),
        // 아바타 위쪽(좌측 정렬)에 앵커. (아바타 위로 s2 만큼 띄움)
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.topLeft,
          followerAnchor: Alignment.bottomLeft,
          offset: const Offset(0, -AppSpacing.s2),
          child: _menu(dialogContext),
        ),
      ],
    );
  }

  Widget _menu(BuildContext dialogContext) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: const [
          BoxShadow(
            color: AppColorPrimitives.black40,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      // 항목들의 폭을 가장 긴 라벨에 맞춰 통일한다.
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < widget.actions.length; i++) ...[
              if (i > 0) Container(height: 1, color: AppColors.borderDefault),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s4,
                  vertical: AppSpacing.s3,
                ),
                minimumSize: Size.zero,
                onPressed: () =>
                    _select(dialogContext, widget.actions[i].onSelect),
                child: AppText.body(
                  widget.actions[i].label,
                  color: widget.actions[i].color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 아바타 + 이름 라벨. 원본과 오버레이 사본이 같은 위젯을 쓴다.
  Widget _avatarLabel() {
    return CircleAvatarLabel(
      label: widget.label,
      labelDecoration: widget.labelDecoration,
      child: ProfileAvatar(
        size: CircleAvatarLabel.circleSize,
        imageUrl: widget.imageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(onLongPress: _open, child: _avatarLabel()),
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
