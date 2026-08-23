import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 알림이 하나도 없을 때 보여주는 빈 상태 화면.
///
/// 탭마다 비어 있는 이유가 달라 문구만 바꾸고 구성은 같이 쓴다.
class NotificationEmpty extends StatelessWidget {
  /// 전체 탭 — 받은 알림 자체가 없다.
  const NotificationEmpty({super.key}) : _unread = false;

  /// 안 읽음 탭 — 받은 알림은 있지만 모두 읽은 상태다.
  const NotificationEmpty.unread({super.key}) : _unread = true;

  final bool _unread;

  /// 빈 상태 일러스트 이미지 폭.
  static const double _imageWidth = 160;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleDescription(
          title: _unread
              ? l10n.notificationUnreadEmptyTitle
              : l10n.notificationEmptyTitle,
          description: _unread
              ? l10n.notificationUnreadEmptyDescription
              : l10n.notificationEmptyDescription,
          centered: true,
        ),
        const SizedBox(height: AppSpacing.s4),
        Image.asset(
          'assets/images/empty_notification.png',
          width: _imageWidth,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
