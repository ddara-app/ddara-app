import 'package:ddara/domain/model/notification/notification_item.dart';
import 'package:ddara/domain/model/notification/notification_type.dart';
import 'package:ddara/l10n/app_localizations.dart';

/// 알림 목록을 좁혀 보는 기준. (화면 상단 칩)
enum NotificationFilter {
  /// 모든 알림.
  all,

  /// 채팅을 제외한 일반 알림.
  notice,

  /// 사진에 달린 댓글 알림.
  chat;

  String label(AppLocalizations l10n) => switch (this) {
    NotificationFilter.all => l10n.notificationFilterAll,
    NotificationFilter.notice => l10n.notificationFilterNotice,
    NotificationFilter.chat => l10n.notificationFilterChat,
  };

  /// [item] 이 이 기준에 걸리는지.
  ///
  /// 채팅은 [NotificationType.comment] 하나뿐이라, 나머지를 모두 일반 알림으로
  /// 본다. 앱이 모르는 종류(unknown)도 일반 알림에 남겨 목록에서 사라지지 않게 한다.
  bool matches(NotificationItem item) => switch (this) {
    NotificationFilter.all => true,
    NotificationFilter.notice => item.type != NotificationType.comment,
    NotificationFilter.chat => item.type == NotificationType.comment,
  };
}
