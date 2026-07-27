import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/component/button/app_text_button.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/circle_avatar_label.dart';
import 'package:ddara/core/widget/image/empty_thumbnail.dart';
import 'package:ddara/feature/group/detail/widget/body/history_photos.dart';
import 'package:ddara/feature/group/detail/widget/group_section.dart';
import 'package:ddara/feature/group/detail/widget/header/empty_header.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 모임 상세를 조회하는 동안 본문 자리에 그리는 골격.
///
/// 전체 스피너로 덮으면 응답이 도착할 때 화면이 통째로 바뀌어 끊겨 보인다.
/// 데이터와 무관하게 고정된 부분(섹션 제목·버튼·여백)은 진짜로 그리고, 값이
/// 필요한 자리만 빈 상자로 채워 두면 응답 도착 시 그 자리만 메워진다.
///
/// 헤더는 진행 중 사이클 유무에 따라 높이가 크게 달라(빈 상태 ≈300 / 사진
/// 3:4 ≈500) 잘못 추측하면 오히려 레이아웃이 튄다. 그래서 호출부가 아는
/// 경우([hasCurrentCycle])에만 헤더 자리를 잡고, 모르면 헤더를 그리지 않는다.
class GroupPageSkeleton extends StatelessWidget {
  const GroupPageSkeleton({super.key, this.hasCurrentCycle, this.thumbnailUrl});

  /// 진행 중 사이클 유무. null 이면 헤더 모양을 알 수 없어 자리를 잡지 않는다.
  final bool? hasCurrentCycle;

  /// 진행 중 사이클의 스타터 썸네일 URL.
  /// 홈 목록에서 넘어왔다면 이미 캐시에 있어 즉시 그려진다.
  final String? thumbnailUrl;

  /// 자리만 채우는 멤버 아바타 개수. (실제 인원은 조회 후 확정)
  static const _placeholderMemberCount = 3;

  /// 자리만 채우는 히스토리 카드 개수.
  static const _placeholderHistoryCount = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s8,
      children: [
        // 좌우 여백은 본문과 동일하게 헤더에만 적용한다.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s5),
          child: _header(l10n),
        ),
        GroupSection(
          title: AppText.headlineLarge(l10n.groupMembersTitle),
          body: _members(),
        ),
        GroupSection(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText.headlineLarge(l10n.groupHistoryTitle),
              // 조회 전에는 이동할 대상이 없어 비활성으로 자리만 잡는다.
              AppTextButton(label: l10n.groupHistoryMore, onPressed: null),
            ],
          ),
          body: _history(),
        ),
      ],
    );
  }

  /// 헤더 자리. 진행 중 사이클 유무를 알 때만 그린다.
  Widget _header(AppLocalizations l10n) {
    return switch (hasCurrentCycle) {
      // 빈 상태 헤더는 데이터가 필요 없으므로 완성된 모습 그대로 그린다.
      // (버튼만 조회 전이라 비활성)
      false => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const EmptyHeader(),
          const SizedBox(height: AppSpacing.s6),
          AppButton(label: l10n.groupHeaderStart, onPressed: null),
        ],
      ),
      // 진행 중: 사진 프레임과 버튼 자리를 실제 헤더와 같은 크기로 잡는다.
      true => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: AspectRatio(
              aspectRatio: AppRatio.photo,
              child: _thumbnail(),
            ),
          ),
          const SizedBox(height: AppSpacing.s5),
          AppButton(label: l10n.groupHeaderTakePhoto, onPressed: null),
        ],
      ),
      // 모르면 헤더 자리를 비워 둔다. (잘못된 높이로 잡느니 나중에 채운다)
      null => const SizedBox.shrink(),
    };
  }

  /// 스타터 썸네일. 캐시에 있으면 즉시, 없으면 빈 자리표시.
  Widget _thumbnail() {
    final url = thumbnailUrl;
    if (url == null || url.isEmpty) return const EmptyThumbnail();

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => const EmptyThumbnail(),
      errorWidget: (_, _, _) => const EmptyThumbnail(),
    );
  }

  /// 멤버 자리. 원형 아바타 + 라벨 높이를 실제 목록과 맞춘다.
  Widget _members() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: AppSpacing.s5),
      child: Row(
        spacing: AppSpacing.s2,
        children: [
          for (var i = 0; i < _placeholderMemberCount; i++)
            const CircleAvatarLabel(
              label: '',
              child: _CircleBlank(size: CircleAvatarLabel.circleSize),
            ),
        ],
      ),
    );
  }

  /// 히스토리 자리. 실제 카드와 같은 크기·간격으로 늘어놓는다.
  Widget _history() {
    return SizedBox(
      height: HistoryPhotos.cardHeight + AppSpacing.s4 * 2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s4,
        ),
        child: Row(
          spacing: AppSpacing.s3,
          children: [
            for (var i = 0; i < _placeholderHistoryCount; i++)
              Container(
                width: HistoryPhotos.cardWidth,
                height: HistoryPhotos.cardHeight,
                decoration: ShapeDecoration(
                  color: AppColors.bgSurfaceAlt,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 아바타 자리를 채우는 빈 원.
class _CircleBlank extends StatelessWidget {
  const _CircleBlank({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const ShapeDecoration(
        color: AppColors.bgSurfaceAlt,
        shape: CircleBorder(),
      ),
    );
  }
}
