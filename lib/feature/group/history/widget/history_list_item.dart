import 'dart:math' as math;

import 'package:ddara/core/designsystem/component/surface/app_surface.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/model/group/history_cycles.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/empty_thumbnail.dart';
import 'package:ddara/core/widget/profile_avatar.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// 목록에 함께 보여줄 참가자 아바타 최대 개수.
const int _maxAvatars = 4;

/// 참가자 아바타 지름.
const double _avatarSize = 24;

/// 겹침 나열 시 아바타 간 가로 간격. (지름보다 작아 일부 겹친다)
const double _avatarStep = 16;

/// 썸네일 한 변 크기.
const double _thumbnailSize = 100;

/// 지난 따라찍기 단일 아이템.
/// (좌: 썸네일 · 우: 주제 / 참가 인원 / 날짜 / 참가자 프로필)
class HistoryListItem extends StatelessWidget {
  const HistoryListItem({super.key, required this.cycle});

  /// 표시할 지난 사이클.
  final HistoryCycle cycle;

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
        spacing: AppSpacing.s3,
        children: [
          _thumbnail(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s1,
              children: [
                AppText.titleLarge(cycle.topic),
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
  Widget _thumbnail() {
    final url = cycle.thumbnailUrl;
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
      child: url == null || url.isEmpty
          ? const EmptyThumbnail()
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const EmptyThumbnail(),
            ),
    );
  }

  /// 날짜 라벨. (예: '6월 12일')
  String _dateLabel(AppLocalizations l10n, DateTime date) {
    final d = date.toLocal();
    return l10n.historyDate(d.month, d.day);
  }

  /// 참가자 프로필 아바타를 일부 겹쳐 나열. (최대 [_maxAvatars]개)
  /// TODO: 참가자 프로필 이미지 URL 데이터 연동. (현재 기본 아이콘)
  Widget _participantAvatars() {
    final count = math.min(cycle.participantCount, _maxAvatars);
    if (count == 0) return const SizedBox.shrink();
    return SizedBox(
      width: _avatarSize + (count - 1) * _avatarStep,
      height: _avatarSize,
      child: Stack(
        children: [
          for (var i = 0; i < count; i++)
            Positioned(
              left: i * _avatarStep,
              child: const ProfileAvatar(size: _avatarSize),
            ),
        ],
      ),
    );
  }
}
