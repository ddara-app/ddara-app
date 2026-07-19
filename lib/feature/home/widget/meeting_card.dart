import 'package:ddara/core/model/group/group_list.dart';
import 'package:ddara/feature/home/widget/photo_card_shell.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 모임 카드. (대표 이미지 위에 상태·이름·멤버 요약을 얹은 형태) — 비율 균일
class MeetingCard extends StatelessWidget {
  const MeetingCard({
    super.key,
    required this.group,
    required this.onTap,
    this.thumbnailBlocked = false,
  });

  final Group group;
  final VoidCallback onTap;

  /// 썸네일을 올린 멤버를 차단한 상태인지 여부. (차단 자리표시로 대체)
  final bool thumbnailBlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cycle = group.currentCycle;

    return PhotoCardShell(
      imageUrl: group.thumbnailUrl,
      title: group.name,
      subtitle: _memberSummary(l10n, group),
      // 상단: 마감까지 남은 시간 (진행 중인 사이클이 있을 때만)
      topLabel: cycle != null ? _remainingLabel(l10n, cycle.deadlineAt) : null,
      blocked: thumbnailBlocked,
      underReview: group.thumbnailUnderReview,
      onTap: onTap,
    );
  }
}

/// '${owner}님 외 N명' 형태의 멤버 요약. (멤버가 owner 뿐이면 '외 N명' 생략)
String _memberSummary(AppLocalizations l10n, Group group) {
  if (group.memberCount <= 1) {
    return l10n.meetingMemberOwner(group.ownerNickname);
  }
  return l10n.meetingMemberOthers(group.ownerNickname, group.memberCount - 1);
}

/// 마감까지 남은 시간 라벨.
/// 1시간 이상이면 시간 단위(분은 버림), 1시간 미만이면 분 단위, 이미 지났으면 '마감'.
String _remainingLabel(AppLocalizations l10n, DateTime deadline) {
  final remaining = deadline.difference(DateTime.now());
  if (remaining.inMinutes <= 0) return l10n.meetingClosed;
  if (remaining.inHours >= 1) return l10n.meetingRemainingHours(remaining.inHours);
  return l10n.meetingRemainingMinutes(remaining.inMinutes);
}
