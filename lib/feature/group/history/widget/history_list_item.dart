import 'package:ddara/core/design_system/component/surface/app_surface.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/history_list.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/blocked_photo_placeholder.dart';
import 'package:ddara/core/widget/image/empty_thumbnail.dart';
import 'package:ddara/core/design_system/component/avatar/profile_avatar.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 겹쳐 보여줄 참가자 아바타 최대 개수. (초과분은 '+n' 칩으로 표시)
const int _maxAvatars = 2;

/// 참가자 아바타 지름.
const double _avatarSize = 24;

/// 겹침 나열 시 아바타 간 가로 간격. (지름보다 작아 일부 겹친다)
const double _avatarStep = 16;

/// '+n' 칩 가로 크기. (아바타보다 살짝 넓은 알약 형태)
const double _moreChipWidth = 32;

/// 썸네일 한 변 크기.
const double _thumbnailSize = 100;

/// 지난 따라찍기 단일 아이템.
/// (좌: 썸네일 · 우: 주제 / 참가 인원 / 날짜 / 참가자 프로필)
class HistoryListItem extends StatelessWidget {
  const HistoryListItem({
    super.key,
    required this.cycle,
    this.thumbnailBlocked = false,
  });

  /// 표시할 지난 사이클.
  final HistoryListCycle cycle;

  /// 썸네일을 올린 스타터를 차단한 상태인지 여부. (차단 자리표시로 대체)
  final bool thumbnailBlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppSurface(
      // 페이지 배경 위 맨 아이템이라 평소엔 투명, 누르는 동안만 살짝 밝게.
      color: const Color(0x00000000),
      pressedColor: AppColors.bgSurface,
      // 탭 → 해당 사이클의 사진 갤러리로 이동.
      onTap: () => context.push(RoutePath.follower, extra: cycle.cycleId),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSpacing.s4,
        children: [
          _thumbnail(context),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s1,
              children: [
                // 차단한 스타터의 따라찍기는 주제 대신 차단 안내 문구를 보여준다.
                AppText.titleLarge(
                  thumbnailBlocked ? l10n.blockedCycleTopic : cycle.topic,
                  color: thumbnailBlocked ? AppColors.textSecondary : null,
                ),
                AppText.caption(
                  _dateLabel(l10n, cycle.date),
                  color: AppColors.textSecondary,
                ),
                AppText.caption(
                  l10n.historyParticipantCount(cycle.participantCount),
                  color: AppColors.textSecondary,
                ),
                _participantAvatars(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 좌측 정사각 썸네일. URL 이 없거나 로드 실패 시 자리표시로 대체한다.
  /// 스타터 차단 또는 신고 검토 중이면 사진 대신 안내 자리표시를 보여준다.
  Widget _thumbnail(BuildContext context) {
    return Container(
      width: _thumbnailSize,
      height: _thumbnailSize,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      child: _thumbnailContent(context),
    );
  }

  Widget _thumbnailContent(BuildContext context) {
    if (thumbnailBlocked) {
      // 차단은 문구 대신 자물쇠 아이콘만 중앙에 보여준다.
      return const ColoredBox(
        color: AppColors.bgSurfaceAlt,
        child: Center(
          child: Icon(
            CupertinoIcons.lock_fill,
            size: 32,
            color: AppColors.bgSurface,
          ),
        ),
      );
    }
    if (cycle.thumbnailUnderReview) {
      // 100×100 작은 썸네일이라 짧은 검토 안내 문구를 쓴다.
      return BlockedPhotoPlaceholder(
        message: AppLocalizations.of(context).photoUnderReviewPlaceholderShort,
      );
    }
    final url = cycle.thumbnailUrl;
    if (url == null || url.isEmpty) {
      return const EmptyThumbnail();
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const EmptyThumbnail(),
    );
  }

  /// 날짜 라벨. (예: '6월 12일')
  String _dateLabel(AppLocalizations l10n, DateTime date) {
    final d = date.toLocal();
    return l10n.historyDate(d.month, d.day);
  }

  /// 참가자 프로필을 최대 [_maxAvatars]개까지 겹쳐 나열하고,
  /// 더 있으면 마지막에 '+n' 칩을 잇는다.
  Widget _participantAvatars() {
    final avatars = cycle.participants.take(_maxAvatars).toList();
    if (avatars.isEmpty) return const SizedBox.shrink();
    // participants 목록이 잘려 올 수 있어 총원은 participantCount 로 센다.
    final remaining = cycle.participantCount - avatars.length;

    final children = <Widget>[
      for (var i = 0; i < avatars.length; i++)
        Positioned(
          left: i * _avatarStep,
          child: ProfileAvatar(
            size: _avatarSize,
            imageUrl: avatars[i].profileImageUrl,
          ),
        ),
    ];

    final double width;
    if (remaining > 0) {
      final chipLeft = avatars.length * _avatarStep;
      children.add(Positioned(left: chipLeft, child: _moreChip(remaining)));
      width = chipLeft + _moreChipWidth;
    } else {
      width = _avatarSize + (avatars.length - 1) * _avatarStep;
    }

    return SizedBox(
      width: width,
      height: _avatarSize,
      child: Stack(children: children),
    );
  }

  /// 표시하지 못한 나머지 참가자 수를 나타내는 '+n' 알약 칩.
  Widget _moreChip(int count) {
    return Container(
      width: _moreChipWidth,
      height: _avatarSize,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.bgSurfaceAlt,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.borderDefault),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      child: AppText.caption('+$count', color: AppColors.textPrimary),
    );
  }
}
