import 'package:ddara/core/design_system/design_system.dart';
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
    // 진행 중 사이클이 없는데 대표 썸네일이 남아 있으면 지난 회차가 끝난 상태다.
    // (서버는 마감되면 currentCycle 을 비우고 썸네일만 남긴다 — 썸네일조차
    //  없으면 따라찍기를 한 번도 하지 않은 모임이라 표시할 상태가 없다)
    final finished = cycle == null && (group.thumbnailUrl?.isNotEmpty ?? false);
    // 서버가 currentCycle 을 비우기 전이라도 마감 시각이 지났으면 끝난 것으로 본다.
    final expired = cycle != null && !cycle.deadlineAt.isAfter(DateTime.now());
    final closed = finished || expired;
    // 진행 중도 종료도 아니면(따라찍기 이력 없음) 라벨을 두지 않는다.
    final hasStatus = cycle != null || finished;

    return PhotoCardShell(
      imageUrl: group.thumbnailUrl,
      title: group.name,
      subtitle: _memberSummary(l10n, group),
      // 상단: 진행 중이면 남은 시간, 끝났으면 '진행 종료'.
      topLabel: !hasStatus
          ? null
          : closed
          ? l10n.meetingClosed
          : _remainingLabel(l10n, cycle!.deadlineAt),
      // 라벨 옆 점으로 진행/종료를 색으로도 구분한다.
      topIndicatorColor: !hasStatus
          ? null
          : closed
          ? AppColors.statusClosed
          : AppColors.statusSuccess,
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

/// 마감까지 남은 시간 라벨. (호출부가 마감 전임을 이미 판별해 넘긴다)
/// 1시간 이상이면 시간 단위(분은 버림), 1시간 미만이면 분 단위.
String _remainingLabel(AppLocalizations l10n, DateTime deadline) {
  final remaining = deadline.difference(DateTime.now());
  if (remaining.inHours >= 1) {
    return l10n.meetingRemainingHours(remaining.inHours);
  }
  // 1분 미만 남았어도 '0분'이 아닌 '1분'으로 보여 아직 시간이 있음을 알린다.
  return l10n.meetingRemainingMinutes(remaining.inMinutes.clamp(1, 59));
}
