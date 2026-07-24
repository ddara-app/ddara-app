import 'dart:ui' show ImageFilter;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/blocked_photo_placeholder.dart';
import 'package:ddara/core/widget/effect/bottom_scrim.dart';
import 'package:ddara/core/widget/effect/baked_progressive_blur_image.dart';
import 'package:ddara/core/widget/image/empty_thumbnail.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 홈 카드의 가로:세로 비율. (디자인 기준 186×245)
///
/// 카드에서 보이던 프레임 그대로 사진을 크게 볼 때도 같은 값을 쓴다.
const double photoCardAspectRatio = 186 / 245;

/// 잠금 사진에 씌우는 블러 세기. (멤버 사진 카드와 동일)
const double _lockedBlurSigma = 12;

/// 홈 카드 그리드의 공통 카드 껍데기.
///
/// 대표 이미지 위에 하단 스크림을 깔고, 그 위에 제목·부제(좌하단)와
/// 선택적 상단 라벨(우상단)을 얹은 형태다. 담는 내용만 다르고 생김새가 같은
/// 두 탭의 카드([MeetingCard]·[FeedCard])가 이 껍데기를 공유한다.
///
/// - [blocked] 이면(차단한 멤버) 사진 대신 차단 자리표시를 보여준다.
/// - [underReview] 이면(신고 접수) 사진 대신 검토 안내 자리표시를 보여준다.
/// - [locked] 이면(내 인증샷 미업로드) 사진을 블러 처리하고 가운데에 자물쇠를 얹는다.
class PhotoCardShell extends StatelessWidget {
  const PhotoCardShell({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.topLabel,
    this.topAction,
    this.blocked = false,
    this.underReview = false,
    this.locked = false,
  });

  /// 대표 이미지 URL. 없거나 로드 실패면 갤러리 아이콘으로 대체된다.
  final String? imageUrl;

  /// 좌하단 제목. (모임명 / 회차 주제)
  final String title;

  /// 제목 아래 부제. (멤버 요약 / 업로더 닉네임)
  final String subtitle;

  final VoidCallback onTap;

  /// 우상단에 표시할 짧은 라벨. null 이면 표시하지 않는다.
  final String? topLabel;

  /// 카드 상단에 얹을 위젯. 좌우 여백(s3) 안을 가득 쓸 수 있고, 정렬은
  /// 주입한 쪽에서 정한다. null 이면 표시하지 않는다.
  /// ([topLabel] 과 자리가 겹치므로 둘 중 하나만 쓴다)
  final Widget? topAction;

  /// 사진을 올린 멤버를 차단한 상태인지 여부.
  final bool blocked;

  /// 사진이 신고 접수로 검토 중인지 여부.
  final bool underReview;

  /// 잠긴 사진인지 여부. (블러 + 자물쇠)
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final imageUrl = this.imageUrl;
    // 사진 대신 자리표시를 보여줘야 하는 상태. (차단이 검토보다 우선)
    final obscured = blocked || underReview;
    // 잠금은 보여줄 사진이 있을 때만 의미가 있다. (자리표시는 잠그지 않는다)
    final locked = !obscured && this.locked && imageUrl != null;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onTap,
      // 폭은 열에 맞춰 stretch 되고 높이는 비율로 따라간다.
      child: AspectRatio(
        aspectRatio: photoCardAspectRatio,
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
              // 배경: 차단·검토 자리표시 / 잠금 블러 / 대표 이미지.
              // 잠기지 않은 사진은 하단 스크림 구간에 맞춰 아래로 갈수록 흐려진다.
              // 점진 블러는 베이크 버전이라 디코딩 직후 1회만 계산해 캐시한다.
              // (잠금 사진은 이미 전체가 블러라 추가로 흐리지 않는다)
              Positioned.fill(
                child: blocked
                    ? const BlockedPhotoPlaceholder()
                    : underReview
                    ? BlockedPhotoPlaceholder(
                        message: AppLocalizations.of(
                          context,
                        ).photoUnderReviewPlaceholder,
                      )
                    : locked
                    ? ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: _lockedBlurSigma,
                          sigmaY: _lockedBlurSigma,
                        ),
                        child: _image(imageUrl),
                      )
                    : imageUrl == null
                    ? _image(null)
                    : BakedProgressiveBlurImage(
                        imageUrl: imageUrl,
                        sharpUntil: 0.6,
                        builder: (_) => _image(imageUrl),
                      ),
              ),
              // 하단 스크림. (텍스트 가독성 확보)
              const BottomScrim(color: AppColorPrimitives.pureBlack),
              // 잠금: 가운데 자물쇠.
              if (locked)
                const Center(
                  child: AppIcon(AppIcons.lock, size: 32, color: AppColors.textPrimary),
                ),
              // 상단 우측 라벨. (모임 카드의 남은 시간 등)
              if (topLabel != null)
                Positioned(
                  top: AppSpacing.s3,
                  left: AppSpacing.s3,
                  right: AppSpacing.s3,
                  child: AppText.caption(
                    topLabel!,
                    color: AppColors.textPrimary,
                    textAlign: TextAlign.right,
                  ),
                ),
              // 상단 오버레이. (피드 카드의 댓글 버튼·댓글 미리보기)
              // 좌우 여백만 잡아 주고, 그 안에서의 정렬은 주입한 쪽이 정한다.
              if (topAction != null)
                Positioned(
                  top: AppSpacing.s3,
                  left: AppSpacing.s3,
                  right: AppSpacing.s3,
                  child: topAction!,
                ),
              // 하단: 제목 · 부제 (가독성은 위의 스크림 레이어가 담당)
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
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppText.caption(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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

  /// 대표 이미지. URL 이 없거나 로드에 실패하면 갤러리 아이콘으로 대체한다.
  Widget _image(String? imageUrl) {
    if (imageUrl == null) return const EmptyThumbnail();
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, _) => const EmptyThumbnail(),
      errorWidget: (_, _, _) => const EmptyThumbnail(),
    );
  }
}
