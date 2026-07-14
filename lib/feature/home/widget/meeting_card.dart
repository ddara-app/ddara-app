import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/group_list.dart';
import 'package:ddara/core/widget/effect/bottom_scrim.dart';
import 'package:ddara/core/widget/effect/progressive_blur_image.dart';
import 'package:ddara/core/widget/image/empty_thumbnail.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 모임 카드. (대표 이미지 위에 상태·이름·멤버 요약을 얹은 형태) — 비율 균일
class MeetingCard extends StatelessWidget {
  const MeetingCard({super.key, required this.group, required this.onTap});

  final Group group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cycle = group.currentCycle;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onTap,
      // 디자인 기준 186×245 비율. 폭은 열에 맞춰 stretch 되고 높이는 비율로 따라간다.
      child: AspectRatio(
        aspectRatio: 186 / 245,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: AppColors.bgSurfaceAlt,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
          child: Stack(
            children: [
              // 대표 이미지(모임 썸네일). 없거나 로드 실패면 갤러리 아이콘.
              // 하단 스크림 구간(heightFactor 0.4)에 맞춰 아래로 갈수록 흐려진다.
              Positioned.fill(
                child: ProgressiveBlurImage(
                  sharpUntil: 0.6,
                  builder: (_) => group.thumbnailUrl != null
                      ? Image.network(
                          group.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const EmptyThumbnail(),
                        )
                      : const EmptyThumbnail(),
                ),
              ),
              // 하단 스크림. (텍스트 가독성 + 하단 경계를 배경과 자연스럽게 잇기)
              const BottomScrim(),
              // 상단: 마감까지 남은 시간 (진행 중인 사이클이 있을 때만)
              if (cycle != null)
                Positioned(
                  top: AppSpacing.s3,
                  left: AppSpacing.s3,
                  right: AppSpacing.s3,
                  child: AppText.caption(
                    _remainingLabel(l10n, cycle.deadlineAt),
                    color: AppColors.textPrimary,
                    textAlign: TextAlign.right,
                  ),
                ),
              // 하단: 이름 · 멤버 요약 (가독성은 위의 스크림 레이어가 담당)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s3,
                    vertical: AppSpacing.s3,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.s1,
                    children: [
                      AppText.title(
                        group.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppText.caption(_memberSummary(l10n, group)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
