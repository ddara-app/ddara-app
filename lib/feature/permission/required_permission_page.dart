import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/core/permission/provider/permission_provider.dart';
import 'package:ddara/core/widget/dialog/permission_dialog.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/feature/permission/util/permission_request_recovery.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 필수 권한 허용 안내 페이지.
class RequiredPermissionPage extends ConsumerStatefulWidget {
  const RequiredPermissionPage({super.key});

  @override
  ConsumerState<RequiredPermissionPage> createState() =>
      _RequiredPermissionPageState();
}

class _RequiredPermissionPageState extends ConsumerState<RequiredPermissionPage>
    with WidgetsBindingObserver, PermissionRequestRecovery {
  /// 확인 버튼: 카메라 권한을 다시 요청한다.
  /// - 허용 → 홈 이동
  /// - 비허용:
  ///   - iOS: 프로그래밍 방식 종료 불가 → 설정 유도 다이얼로그 띄우고 머무름
  ///   - Android: 영구 거부면 설정 안내 후 '취소' 시 앱 종료 / 일반 거부면 앱 종료
  Future<void> _onConfirm() => runBusy(() async {
    final permission = ref.read(permissionServiceProvider);
    // 뒤로가기로 다이얼로그를 닫아도 resume 시 상태를 재확인해 매듭짓는다.
    final result = await awaitPermission(
      permission.requestCamera,
      permission.cameraStatus,
    );

    // 허용 → 보관된 초대코드가 있으면 모임 참여로, 없으면 홈으로.
    if (result == PermissionResult.granted) {
      await onCameraGranted(ref);
      return;
    }

    if (!mounted) return;

    // iOS: 앱 종료가 막혀 있으므로 설정 유도 다이얼로그만 띄우고 화면에 머무른다.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await showPermissionDialog(
        context,
        permission: permission,
        permissionName: AppLocalizations.of(context).permissionCamera,
      );
      return;
    }

    // Android: 영구 거부면 설정 안내 후 '취소' 시 종료, 일반 거부면 바로 종료.
    if (result == PermissionResult.permanentlyDenied) {
      final goSettings = await showPermissionDialog(
        context,
        permission: permission,
        permissionName: AppLocalizations.of(context).permissionCamera,
      );
      if (goSettings == true) return;
    }
    SystemNavigator.pop();
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.s5,
            right: AppSpacing.s5,
            bottom: AppSpacing.s4,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/permission.png'),
                    const SizedBox(height: AppSpacing.s3),
                    TitleDescription(
                      title: l10n.requiredPermissionTitle,
                      description: l10n.requiredPermissionDescription,
                      centered: true,
                    ),
                  ],
                ),
              ),

              // 하단 확인 버튼 (요청 중에는 비활성화)
              AppButton(
                label: l10n.commonConfirm,
                onPressed: isBusy ? null : _onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
