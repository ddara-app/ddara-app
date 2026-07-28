import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/design_system/component/surface/app_surface.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/notification/notification_item.dart';
import 'package:ddara/feature/notification/util/notification_display.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 알림 좌측 썸네일 한 변 크기.
const double _thumbnailSize = 72;

/// payload 에 이미지가 없을 때 보여줄 기본 썸네일.
/// (72×72 라운드 배경 + 워드마크가 포함된 완성형 asset)
const String _defaultThumbnailAsset = 'assets/images/notification_default.svg';

/// 알림 목록의 항목 한 개.
///
/// 좌측 이미지 썸네일 + 우측(분류 라벨·경과 시간 한 줄 / 본문) 으로 구성된 카드.
/// 도메인 알림 모델([NotificationItem])을 받아 표시용 문자열로 풀어 그린다.
/// [onTap] 을 주면 카드 전체가 눌리는 영역이 된다.
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.item,
    this.onTap,
    this.blockedUserIds = const {},
  });

  final NotificationItem item;

  /// 카드 탭 콜백. null 이면 탭에 반응하지 않는다.
  final VoidCallback? onTap;

  /// 내가 차단한 사용자 userId 집합.
  /// (차단한 멤버가 올린 썸네일은 노출하지 않는다)
  final Set<int> blockedUserIds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final payload = item.payload;
    // 차단·신고 검토 중인 스타터 샷은 노출하지 않는다.
    // (72px 소형 썸네일이라 안내 문구 대신 기본 썸네일로 대체한다)
    final starterUserId = payload.starterUserId;
    final thumbnailObscured =
        payload.imageUnderReview ||
        (starterUserId != null && blockedUserIds.contains(starterUserId));
    return AppSurface(
      onTap: onTap,
      // 누르는 동안 살짝 밝게. (앱 전반의 Cupertino 페이드와 일관)
      pressedColor: AppColors.bgSurfaceAlt,
      padding: const EdgeInsets.all(AppSpacing.s5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s4,
        children: [
          _NotificationThumbnail(
            imageUrl: thumbnailObscured ? null : payload.imageUrl,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s3,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppText.caption(
                        item.displayLabel(l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppText.caption(
                      item.displayTimeAgo(l10n),
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
                AppText.body(
                  item.displayMessage(l10n),
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 알림 좌측 썸네일. 72×72 정사각형(라운드 8) 박스에 payload 이미지를 채운다.
///
/// 사진이 오는 알림(NEW_CYCLE·CYCLE_COMPLETED 의 스타터 가이드샷)만 박스에
/// 담고, [imageUrl] 이 없으면 배경·라운드가 이미 포함된 완성형 기본 썸네일을
/// 박스 없이 그대로 그린다. (박스가 겹쳐 이중 라운드가 생기지 않게 한다)
class _NotificationThumbnail extends StatelessWidget {
  const _NotificationThumbnail({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return SizedBox(
        width: _thumbnailSize,
        height: _thumbnailSize,
        child: SvgPicture.asset(_defaultThumbnailAsset),
      );
    }

    // 박스(bg-base 배경 + 라운드)에 이미지를 채운다. (잘림 방지 clip)
    return Container(
      width: _thumbnailSize,
      height: _thumbnailSize,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.bgBase,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
      ),
      child: _image(context, url),
    );
  }

  /// payload 이미지를 박스에 채워 그린다.
  /// 로딩 중·로드 실패면 기본 썸네일로 대체한다.
  Widget _image(BuildContext context, String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      // 표시 한 변(물리 픽셀)에 맞춰 디코딩해 메모리 사용을 줄인다.
      memCacheWidth: (_thumbnailSize * MediaQuery.devicePixelRatioOf(context))
          .round(),
      placeholder: (context, url) => SvgPicture.asset(_defaultThumbnailAsset),
      errorWidget: (context, url, error) =>
          SvgPicture.asset(_defaultThumbnailAsset),
    );
  }
}
