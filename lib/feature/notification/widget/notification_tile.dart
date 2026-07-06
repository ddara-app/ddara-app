import 'package:ddara/core/designsystem/component/surface/app_surface.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/model/notification/notification_item.dart';
import 'package:ddara/feature/notification/util/notification_display.dart';
import 'package:flutter/widgets.dart';

/// 알림 좌측 썸네일 한 변 크기.
const double _thumbnailSize = 72;

/// 알림 목록의 항목 한 개.
///
/// 좌측 이미지 썸네일 + 우측(분류 라벨·경과 시간 한 줄 / 본문) 으로 구성된 카드.
/// 도메인 알림 모델([NotificationItem])을 받아 표시용 문자열로 풀어 그린다.
/// [onTap] 을 주면 카드 전체가 눌리는 영역이 된다.
class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.item, this.onTap});

  final NotificationItem item;

  /// 카드 탭 콜백. null 이면 탭에 반응하지 않는다.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      onTap: onTap,
      // 누르는 동안 살짝 밝게. (앱 전반의 Cupertino 페이드와 일관)
      pressedColor: AppColors.bgSurfaceAlt,
      // 우측은 시간 텍스트가 모서리에 붙지 않도록 넓게 둔다.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s4,
        AppSpacing.s4,
        AppSpacing.s6,
        AppSpacing.s4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s3,
        children: [
          _NotificationThumbnail(
            imageUrl: item.payload.imageUrl,
            bare: item.showsBareThumbnail,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s2,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s1,
                  children: [
                    Expanded(
                      child: AppText.caption(
                        item.displayLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppText.caption(
                      item.displayTimeAgo,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
                AppText.body(item.displayMessage, color: AppColors.textPrimary),
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
/// [imageUrl] 이 없거나 로드 실패하면 bg-base 배경만 남긴다.
/// [bare] 가 true 면 박스(배경·라운드) 없이 이미지만 그대로 그린다. (앱 로고 등)
class _NotificationThumbnail extends StatelessWidget {
  const _NotificationThumbnail({this.imageUrl, this.bare = false});

  final String? imageUrl;
  final bool bare;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    if (bare) {
      // 박스 없이 이미지만. (로고가 잘리지 않도록 contain)
      return SizedBox(
        width: _thumbnailSize,
        height: _thumbnailSize,
        child: (url == null || url.isEmpty)
            ? null
            : Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
      );
    }

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
      child: (url == null || url.isEmpty)
          ? null
          : Image.network(
              url,
              fit: BoxFit.cover,
              // 로드 실패 시 배경(bg-base)만 남긴다.
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
    );
  }
}
