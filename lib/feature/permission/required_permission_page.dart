import 'package:ddara/core/deeplink/pending_invite.dart';
import 'package:ddara/core/designsystem/component/button/app_button.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/core/permission/provider/permission_provider.dart';
import 'package:ddara/core/widget/permission_dialog.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/feature/permission/permission_request_recovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 필수 권한 허용 안내 페이지.
class RequiredPermissionPage extends ConsumerStatefulWidget {
  const RequiredPermissionPage({super.key});

  @override
  ConsumerState<RequiredPermissionPage> createState() =>
      _RequiredPermissionPageState();
}

class _RequiredPermissionPageState extends ConsumerState<RequiredPermissionPage>
    with WidgetsBindingObserver, PermissionRequestRecovery {
  /// 권한 요청이 진행 중인지. 중복 탭·먹통 상태를 막고 버튼을 비활성화한다.
  bool _busy = false;

  /// 확인 버튼: 카메라 권한을 다시 요청한다.
  /// - 허용 → 홈 이동
  /// - 비허용:
  ///   - iOS: 프로그래밍 방식 종료 불가 → 설정 유도 다이얼로그 띄우고 머무름
  ///   - Android: 영구 거부면 설정 안내 후 '취소' 시 앱 종료 / 일반 거부면 앱 종료
  Future<void> _onConfirm() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final permission = ref.read(permissionServiceProvider);
      // 뒤로가기로 다이얼로그를 닫아도 resume 시 상태를 재확인해 매듭짓는다.
      final result = await awaitPermission(
        permission.requestCamera,
        permission.cameraStatus,
      );

      // 허용 → 보관된 초대코드가 있으면 모임 참여로, 없으면 홈으로.
      if (result == PermissionResult.granted) {
        ref.read(cameraNoticeAcknowledgedProvider.notifier).state = true;
        if (!mounted) return;
        await routeAfterAuth(ref, GoRouter.of(context));
        return;
      }

      if (!mounted) return;

      // iOS: 앱 종료가 막혀 있으므로 설정 유도 다이얼로그만 띄우고 화면에 머무른다.
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await showPermissionDialog(
          context,
          permission: permission,
          permissionName: '카메라',
        );
        return;
      }

      // Android: 영구 거부면 설정 안내 후 '취소' 시 종료, 일반 거부면 바로 종료.
      if (result == PermissionResult.permanentlyDenied) {
        final goSettings = await showPermissionDialog(
          context,
          permission: permission,
          permissionName: '카메라',
        );
        if (goSettings == true) return;
      }
      SystemNavigator.pop();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/permission.png'),
                    const SizedBox(height: AppSpacing.s3),
                    const TitleDescription(
                      title: '필수 권한을 허용해 주세요',
                      description:
                          '필수 권한을 거부하면 ddara를\n정상적으로 이용할 수 없어요.\n권한이 필요할 때 허용해 주세요.',
                      centered: true,
                    ),
                  ],
                ),
              ),

              // 하단 확인 버튼 (요청 중에는 비활성화)
              AppButton(label: '확인', onPressed: _busy ? null : _onConfirm),
            ],
          ),
        ),
      ),
    );
  }
}
