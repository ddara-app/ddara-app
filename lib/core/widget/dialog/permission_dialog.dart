import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 권한이 영구 거부된 상태에서 앱 설정으로 이동하도록 안내하는 다이얼로그.
///
/// '설정으로 이동' 선택 시 [PermissionService.openSettings] 를 호출하고 true 를,
/// '취소' 선택 시 false 를 반환한다.
/// [permissionName] 은 호출부가 l10n 에서 가져온 표시명(예: [AppLocalizations.permissionCamera]).
Future<bool?> showPermissionDialog(
  BuildContext context, {
  required PermissionService permission,
  required String permissionName,
}) {
  final l10n = AppLocalizations.of(context);
  return showCupertinoDialog<bool>(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text(l10n.permissionDialogTitle(permissionName)),
      content: Text(l10n.permissionDialogContent),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.commonCancel),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(dialogContext).pop(true);
            permission.openSettings();
          },
          child: Text(l10n.permissionGoToSettings),
        ),
      ],
    ),
  );
}
