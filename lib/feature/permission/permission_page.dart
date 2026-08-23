import 'package:ddara/core/analytics/app_analytics.dart';
import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/core/permission/provider/permission_provider.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/dialog/permission_dialog.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/feature/permission/util/permission_request_recovery.dart';
import 'package:ddara/feature/permission/widget/permission_item.dart';
import 'package:ddara/feature/permission/widget/section_label.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PermissionPage extends ConsumerStatefulWidget {
  const PermissionPage({super.key});

  @override
  ConsumerState<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends ConsumerState<PermissionPage>
    with WidgetsBindingObserver, PermissionRequestRecovery {
  /// 확인 버튼: 카메라부터 순차로 권한을 요청한다.
  /// - 허용 → 홈
  /// - 이번 요청에서 프롬프트가 떴고 거부됨 → 필수 권한 안내 페이지
  /// - 이미 영구 거부라 프롬프트가 안 뜨는 경우 → 설정 안내 다이얼로그('취소' 시 필수 권한 안내)
  Future<void> _onConfirm() => runBusy(() async {
    final permission = ref.read(permissionServiceProvider);

    // 요청 '전' 상태로 프롬프트가 뜰지 판단한다.
    // (iOS 는 첫 거부에도 결과가 permanentlyDenied 로 와서, 결과만으론 구분 불가)
    final wasBlocked = await permission.isCameraPermanentlyDenied();

    // 카메라 → 알림 → 저장공간 순차 요청.
    // 뒤로가기로 다이얼로그를 닫아도 resume 시 상태를 재확인해 매듭짓는다.
    final cameraResult = await awaitPermission(
      permission.requestCamera,
      permission.cameraStatus,
    );
    _trackPermissionResult('camera', cameraResult);
    final notificationResult = await awaitPermission(
      permission.requestNotification,
      permission.notificationStatus,
    );
    _trackPermissionResult('notification', notificationResult);
    final photosResult = await awaitPermission(
      permission.requestPhotos,
      permission.photosStatus,
    );
    _trackPermissionResult('photos', photosResult);

    if (!mounted) return;

    // 카메라 허용 → 보관된 초대코드가 있으면 모임 참여로, 없으면 홈으로.
    if (cameraResult == PermissionResult.granted) {
      await onCameraGranted(ref);
      return;
    }

    // 이미 영구 거부라 프롬프트가 안 뜨는 경우에만 설정 안내.
    // '설정으로 이동' 시 머무르고, '취소' 시 필수 권한 안내 페이지로 이동.
    if (wasBlocked) {
      final goSettings = await showPermissionDialog(
        context,
        onGoToSettings: permission.openSettings,
        permissionName: AppLocalizations.of(context).permissionCamera,
      );
      if (goSettings == true) return;
      if (!mounted) return;
    }

    // 프롬프트가 떴고 거부됐거나, 설정 다이얼로그에서 취소 → 필수 권한 안내 페이지
    context.go(RoutePath.requiredPermission);
  });

  /// 권한을 요청하고, 영구 거부 상태면 설정 이동 안내를 띄운다.
  Future<void> _request(
    String permissionKey,
    String permissionName,
    Future<PermissionResult> Function() request,
    Future<PermissionResult> Function() readStatus,
  ) => runBusy(() async {
    final permission = ref.read(permissionServiceProvider);
    final result = await awaitPermission(request, readStatus);
    _trackPermissionResult(permissionKey, result);
    if (result != PermissionResult.permanentlyDenied) return;
    if (!mounted) return;

    await showPermissionDialog(
      context,
      onGoToSettings: permission.openSettings,
      permissionName: permissionName,
    );
  });

  /// 권한 요청 결과(허용/거부/영구거부)를 Mixpanel 로 전송한다.
  /// permission: camera·notification·photos, result: PermissionResult.name.
  void _trackPermissionResult(String permission, PermissionResult result) {
    AppAnalytics.track(
      'permission_result',
      properties: {'permission': permission, 'result': result.name},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final permission = ref.watch(permissionServiceProvider);

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.permissionPageTitle,
        showBackButton: false,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.s3,
            left: AppSpacing.s5,
            right: AppSpacing.s5,
            // 하단 버튼 아래 여백.
            bottom: AppSpacing.s7,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              TitleDescription(
                title: l10n.permissionHeaderTitle,
                description: l10n.permissionHeaderDescription,
              ),
              const SizedBox(height: AppSpacing.s9),

              // 필수 접근 권한
              SectionLabel(l10n.permissionSectionRequired),
              const SizedBox(height: AppSpacing.s4),
              PermissionItem(
                icon: AppIcons.cameraDefault,
                title: l10n.permissionCamera,
                description: l10n.permissionCameraDescription,
                onTap: () => _request(
                  'camera',
                  l10n.permissionCamera,
                  permission.requestCamera,
                  permission.cameraStatus,
                ),
              ),
              const SizedBox(height: AppSpacing.s7),

              // 선택 접근 권한
              SectionLabel(l10n.permissionSectionOptional),
              const SizedBox(height: AppSpacing.s4),
              PermissionItem(
                icon: AppIcons.bell,
                title: l10n.permissionNotification,
                description: l10n.permissionNotificationDescription,
                onTap: () => _request(
                  'notification',
                  l10n.permissionNotification,
                  permission.requestNotification,
                  permission.notificationStatus,
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              PermissionItem(
                icon: AppIcons.galleryDefault,
                title: l10n.permissionStorage,
                description: l10n.permissionStorageDescription,
                onTap: () => _request(
                  'photos',
                  l10n.permissionStorage,
                  permission.requestPhotos,
                  permission.photosStatus,
                ),
              ),

              const Spacer(),

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
