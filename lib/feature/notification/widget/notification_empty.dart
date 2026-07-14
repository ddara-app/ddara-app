import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 알림이 하나도 없을 때 보여주는 빈 상태 화면.
class NotificationEmpty extends StatelessWidget {
  const NotificationEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleDescription(
          title: l10n.notificationEmptyTitle,
          description: l10n.notificationEmptyDescription,
          centered: true,
        ),
        const SizedBox(height: AppSpacing.s3),
        Image.asset(
          'assets/images/empty_notification.png',
          width: 160,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
