import 'package:ddara/core/designsystem/component/surface/app_surface.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/model/notification/notification_item.dart';
import 'package:ddara/core/widget/profile_avatar.dart';
import 'package:ddara/feature/notification/util/notification_display.dart';
import 'package:flutter/widgets.dart';

/// 알림 아바타 원 지름.
const double _avatarSize = 40;

/// 읽지 않음 표시 점의 지름.
const double _unreadDotSize = 8;

/// 알림 목록의 항목 한 개.
///
/// 좌측 원형 아바타 + 우측(분류 라벨·경과 시간 한 줄 / 본문) 으로 구성된 카드.
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
          // payload 에 이미지 URL 이 없으므로 기본 아바타를 사용한다.
          const ProfileAvatar(size: _avatarSize),
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
                    // 읽지 않은 알림이면 시간 텍스트의 우측 상단 모서리에 점을 띄운다.
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AppText.caption(
                          item.displayTimeAgo,
                          color: AppColors.textTertiary,
                        ),
                        if (!item.isRead)
                          // 카드 상단 padding(s4) 기준 indicator 와 상단 간격이 s3 가
                          // 되도록 (s4 - s3)=s1 만큼 위로 올린다. 우측도 카드 우측
                          // padding(s6) 기준 간격이 s3 가 되도록 s3 만큼 내민다.
                          const Positioned(
                            top: -AppSpacing.s1,
                            right: -AppSpacing.s3,
                            child: _UnreadDot(),
                          ),
                      ],
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

/// 읽지 않은 알림임을 나타내는 빨간 점.
class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _unreadDotSize,
      height: _unreadDotSize,
      decoration: const BoxDecoration(
        color: AppColors.statusDanger,
        shape: BoxShape.circle,
      ),
    );
  }
}
