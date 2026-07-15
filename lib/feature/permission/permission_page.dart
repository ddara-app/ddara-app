import 'package:ddara/core/deeplink/pending_invite.dart';
import 'package:ddara/core/designsystem/component/button/app_button.dart';
import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/core/permission/provider/permission_provider.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/permission_dialog.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/feature/permission/permission_request_recovery.dart';
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
  /// 권한 요청이 진행 중인지. 중복 탭·먹통 상태를 막고 버튼을 비활성화한다.
  bool _busy = false;

  /// 확인 버튼: 카메라부터 순차로 권한을 요청한다.
  /// - 허용 → 홈
  /// - 이번 요청에서 프롬프트가 떴고 거부됨 → 필수 권한 안내 페이지
  /// - 이미 영구 거부라 프롬프트가 안 뜨는 경우 → 설정 안내 다이얼로그('취소' 시 필수 권한 안내)
  Future<void> _onConfirm() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
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
      await awaitPermission(
        permission.requestNotification,
        permission.notificationStatus,
      );
      await awaitPermission(permission.requestPhotos, permission.photosStatus);

      if (!mounted) return;

      // 카메라 허용 → 보관된 초대코드가 있으면 모임 참여로, 없으면 홈으로.
      if (cameraResult == PermissionResult.granted) {
        ref.read(cameraNoticeAcknowledgedProvider.notifier).state = true;
        if (!mounted) return;
        await routeAfterAuth(ref, GoRouter.of(context));
        return;
      }

      // 이미 영구 거부라 프롬프트가 안 뜨는 경우에만 설정 안내.
      // '설정으로 이동' 시 머무르고, '취소' 시 필수 권한 안내 페이지로 이동.
      if (wasBlocked) {
        final goSettings = await showPermissionDialog(
          context,
          permission: permission,
          permissionName: AppLocalizations.of(context).permissionCamera,
        );
        if (goSettings == true) return;
        if (!mounted) return;
      }

      // 프롬프트가 떴고 거부됐거나, 설정 다이얼로그에서 취소 → 필수 권한 안내 페이지
      context.go(RoutePath.requiredPermission);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// 권한을 요청하고, 영구 거부 상태면 설정 이동 안내를 띄운다.
  Future<void> _request(
    String permissionName,
    Future<PermissionResult> Function() request,
    Future<PermissionResult> Function() readStatus,
  ) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final permission = ref.read(permissionServiceProvider);
      final result = await awaitPermission(request, readStatus);
      if (result != PermissionResult.permanentlyDenied) return;
      if (!mounted) return;

      await showPermissionDialog(
        context,
        permission: permission,
        permissionName: permissionName,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final permission = ref.read(permissionServiceProvider);

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.permissionPageTitle,
        showBackButton: false,
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(
            top: 8,
            left: 20,
            right: 20,
            bottom: 16,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              // 헤더
              TitleDescription(
                title: l10n.permissionHeaderTitle,
                description: l10n.permissionHeaderDescription,
              ),

              // 필수 접근 권한
              SectionLabel(l10n.permissionSectionRequired),
              PermissionItem(
                icon: CupertinoIcons.camera,
                title: l10n.permissionCamera,
                description: l10n.permissionCameraDescription,
                onTap: () => _request(
                  l10n.permissionCamera,
                  permission.requestCamera,
                  permission.cameraStatus,
                ),
              ),

              // 선택 접근 권한
              SectionLabel(l10n.permissionSectionOptional),
              PermissionItem(
                icon: CupertinoIcons.bell,
                title: l10n.permissionNotification,
                description: l10n.permissionNotificationDescription,
                onTap: () => _request(
                  l10n.permissionNotification,
                  permission.requestNotification,
                  permission.notificationStatus,
                ),
              ),
              PermissionItem(
                icon: CupertinoIcons.photo,
                title: l10n.permissionStorage,
                description: l10n.permissionStorageDescription,
                onTap: () => _request(
                  l10n.permissionStorage,
                  permission.requestPhotos,
                  permission.photosStatus,
                ),
              ),

              const Spacer(),

              // 하단 확인 버튼 (요청 중에는 비활성화)
              AppButton(
                label: l10n.commonConfirm,
                onPressed: _busy ? null : _onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
