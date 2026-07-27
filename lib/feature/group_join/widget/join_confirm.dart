import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/invite_group.dart';
import 'package:ddara/core/util/date_format.dart';
import 'package:ddara/core/design_system/component/avatar/profile_avatar.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 모임 참여 확인 화면의 본문. (모임 정보 + 멤버 미리보기)
///
/// 스캐폴드·하단 버튼은 상위 화면([JoinGroupPage])이 들고 있고,
/// 이 위젯은 [group] 으로부터 표시 값을 파생해 가운데 콘텐츠만 그린다.
/// (조회 실패·이미 참여 중·정원 초과면 이름 대신 안내 문구를 보여준다)
class JoinConfirm extends StatelessWidget {
  const JoinConfirm({super.key, required this.group});

  /// 참여할 모임 정보. 조회 실패 시 null.
  final InviteGroup? group;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final group = this.group;
    final groupName = group == null
        ? l10n.joinConfirmInvalid
        : group.alreadyJoined
        ? l10n.joinConfirmAlreadyJoined
        : group.isFull
        ? l10n.joinConfirmFull
        : group.name;
    final subtitle = group == null
        ? ''
        : l10n.joinConfirmSubtitle(
            formatDate(group.createdAt),
            group.memberCount,
          );
    final memberSummary = group == null
        ? ''
        : group.memberCount <= 1
        ? l10n.joinConfirmMemberOwner(group.ownerNickname)
        : l10n.joinConfirmMemberOthers(
            group.ownerNickname,
            group.memberCount - 1,
          );
    // 멤버 수만큼(1명이면 1개, 2명 이상이면 2개) 아바타를 보여준다.
    // 목록에 없거나 null(이미지 미설정)인 슬롯은 null 로 둬 기본 아바타로 표시한다.
    final memberAvatars = group?.memberAvatars ?? const <String?>[];
    final avatarCount = group == null ? 0 : (group.memberCount <= 1 ? 1 : 2);
    final memberAvatarUrls = List<String?>.generate(
      avatarCount,
      (i) => i < memberAvatars.length ? memberAvatars[i] : null,
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.s8,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.display(groupName, textAlign: TextAlign.center),
              AppText.body(subtitle, textAlign: TextAlign.center),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s4,
            children: [
              _MemberAvatars(avatarUrls: memberAvatarUrls),
              AppText.body(memberSummary, textAlign: TextAlign.center),
            ],
          ),
        ],
      ),
    );
  }
}

/// 멤버 아바타를 겹쳐 보여주는 묶음.
///
/// 넘어온 [avatarUrls] 슬롯(최대 2개)을 그대로 보여주고, 두 번째 아바타를
/// 첫 아바타의 5시 방향(우하단)에 겹쳐 올린다. 각 슬롯이 null 이면 기본 아바타.
class _MemberAvatars extends StatelessWidget {
  const _MemberAvatars({required this.avatarUrls});

  final List<String?> avatarUrls;

  /// 아바타 한 변 크기.
  static const double _size = 56;

  /// 두 번째 아바타의 5시 방향 겹침 오프셋. (작을수록 더 겹친다 · x·y 동일)
  static const double _offset = 20;

  @override
  Widget build(BuildContext context) {
    final shown = avatarUrls.take(2).toList();
    if (shown.isEmpty) return const SizedBox(height: _size);
    if (shown.length == 1) return _Avatar(url: shown.first);

    // 첫 아바타(좌상단) 위에 두 번째 아바타를 5시 방향(우하단)으로 겹친다.
    const extent = _size + _offset;
    return SizedBox(
      width: extent,
      height: extent,
      child: Stack(
        children: [
          Positioned(left: 0, top: 0, child: _Avatar(url: shown[0])),
          Positioned(
            left: _offset,
            top: _offset,
            child: _Avatar(url: shown[1]),
          ),
        ],
      ),
    );
  }
}

/// 원형 멤버 아바타. [ProfileAvatar] 를 쓰되, 겹침이 드러나도록 배경색(bg-base)
/// 테두리 링으로 감싼다.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});

  /// 링 두께.
  static const double _ring = 4;

  /// null·빈 값이면 [ProfileAvatar] 가 기본 아바타를 보여준다.
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _MemberAvatars._size,
      height: _MemberAvatars._size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.bgBase, width: _ring),
        ),
      ),
      // 링(_ring) 두께만큼 안쪽에 아바타가 들어간다.
      child: ProfileAvatar(
        size: _MemberAvatars._size - _ring * 2,
        imageUrl: url,
      ),
    );
  }
}
