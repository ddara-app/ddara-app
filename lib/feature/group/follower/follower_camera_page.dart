import 'package:ddara/core/analytics/analytics_events.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/loading/app_loading_overlay.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/permission/provider/permission_provider.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_steps.dart';
import 'package:ddara/core/exception/group_action_error.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group/detail/provider/viewmodel_provider.dart'
    as group_detail;
import 'package:ddara/feature/group/follower/widget/follower_camera.dart';
import 'package:ddara/feature/group/follower/widget/follower_photo_check.dart';
import 'package:ddara/feature/group/follower/provider/viewmodel_provider.dart';
import 'package:ddara/feature/group/gallery/provider/viewmodel_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 따라찍기 촬영 화면. 공유 AppBar 하나 아래에서 촬영/사진 확인 본문만 교체한다.
class FollowerCameraPage extends ConsumerStatefulWidget {
  const FollowerCameraPage({
    super.key,
    required this.cycleId,
    required this.guideImageUrl,
    this.forceTour = false,
  });

  /// 따라찍는 대상 사이클 id. (업로드 시 서버에 전달)
  final int cycleId;

  /// 따라찍기 가이드(스타터가 미리 찍은) 사진 URL.
  final String guideImageUrl;

  /// 이미 본 적이 있어도 가이드 투어를 처음부터 다시 띄운다.
  /// (모임 메뉴의 투어 확인용 진입에서만 true)
  final bool forceTour;

  @override
  ConsumerState<FollowerCameraPage> createState() => _FollowerCameraPageState();
}

class _FollowerCameraPageState extends ConsumerState<FollowerCameraPage> {
  /// 촬영된 사진 경로. null 이면 촬영 단계, 값이 있으면 사진 확인 단계.
  String? _capturedPath;

  @override
  void initState() {
    super.initState();
    AnalyticsEvents.followerPageViewed(widget.cycleId);
    // 가이드 투어를 이미 봤는지는 이 화면에서만 필요해 여기서 확인한다.
    // (결과가 오기 전까지 카메라는 투어를 열지 않고 기다린다)
    ref.read(followerViewModelProvider.notifier).loadTourSeen();
  }

  /// 게시 확인을 받고 촬영본을 올린다. 성공하면 스택 아래 갤러리를 새로고침한
  /// 뒤 이 화면을 닫아 그 갤러리로 돌아간다.
  /// (실패 시 ViewModel 이 error 를 채우고 화면이 토스트로 안내한다)
  Future<void> _upload(String path) async {
    final l10n = AppLocalizations.of(context);
    // 게시는 되돌릴 수 없으므로 확인을 한 번 받는다.
    final confirmed = await AppDialog.show(
      context,
      title: l10n.photoPostWarningTitle,
      confirmLabel: l10n.commonConfirm,
    );
    if (!confirmed || !mounted) return;

    final cycleId = await ref
        .read(followerViewModelProvider.notifier)
        .upload(widget.cycleId, path);
    if (cycleId == null || !mounted) return;

    AnalyticsEvents.followerPhotoPosted(cycleId);
    // 스택 아래의 갤러리를 새로고침한 뒤 촬영 화면을 닫아 그 갤러리로 돌아간다.
    // (pushReplacement 로 갤러리를 새로 쌓으면 중복·미갱신 문제가 생긴다)
    ref.invalidate(cyclePhotoGalleryViewModelProvider(cycleId));
    // 스택 아래에 모임 상세가 있으면 새 사진(참여 현황)이 반영되도록 함께
    // 무효화한다. (groupId 를 모르는 화면이라 family 전체를 무효화)
    ref.invalidate(group_detail.groupPageViewModelProvider);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final capturedPath = _capturedPath;
    final l10n = AppLocalizations.of(context);
    final viewModel = ref.read(followerViewModelProvider.notifier);
    final permission = ref.read(permissionServiceProvider);
    final isLoading = ref.watch(
      followerViewModelProvider.select((s) => s.isLoading),
    );
    final cornerTourSeen = ref.watch(
      followerViewModelProvider.select((s) => s.isCornerTourSeen),
    );
    final ghostTourSeen = ref.watch(
      followerViewModelProvider.select((s) => s.isGhostTourSeen),
    );

    // 업로드 실패는 토스트로 알린다. (성공 후 이동은 _upload 가 직접 처리)
    ref.listen(followerViewModelProvider, (prev, next) {
      final error = next.error;
      if (error != null) {
        Toast.showToast(context, error.message(l10n), type: ToastType.error);
        viewModel.clearError();
      }
    });

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.followerCameraTitle,
        // 기본 동작(maybePop)은 가이드 투어의 PopScope 에 가로채여 투어만 닫힌다.
        // 이 버튼은 "화면을 나가겠다"는 뜻이므로 투어와 무관하게 바로 닫는다.
        // (시스템 뒤로가기는 그대로 투어를 먼저 닫는다)
        onBack: () => context.pop(),
        // 촬영 단계에서만 도움말을 둔다. 사진 확인 단계에는 안내할 것이 없다.
        // (Semantics 로 버튼을 감싸면 AppBar 가 AppBarIconButton 을 알아보지
        //  못해 우측 여백 보정이 빠진다 — 라벨은 아이콘 쪽에 붙인다)
        trailing: capturedPath == null
            ? AppBarIconButton(
                onPressed: () => context.push(RoutePath.guide),
                child: Semantics(
                  button: true,
                  label: l10n.guidePageTitle,
                  child: const AppIcon(
                    AppIcons.help,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),
                ),
              )
            : null,
      ),
      child: Stack(
        children: [
          capturedPath == null
              ? FollowerCamera(
                  guideImageUrl: widget.guideImageUrl,
                  forceTour: widget.forceTour,
                  cornerTourSeen: cornerTourSeen,
                  ghostTourSeen: ghostTourSeen,
                  // 끝난 안내의 종류에 맞는 완료 처리로 나눈다.
                  onTourFinished: (kind) => switch (kind) {
                    CameraTourKind.corner => viewModel.completeCornerTour(),
                    CameraTourKind.ghost => viewModel.completeGhostTour(),
                  },
                  onRequestCameraPermission: permission.ensureCameraGranted,
                  onOpenSettings: permission.openSettings,
                  // 촬영하면 사진 확인 단계로 전환한다.
                  onCapture: (path) => setState(() => _capturedPath = path),
                )
              : FollowerPhotoCheck(
                  imagePath: capturedPath,
                  // 다시 찍기 → 촬영 단계로 돌아간다.
                  onRetake: () => setState(() => _capturedPath = null),
                  onUpload: () => _upload(capturedPath),
                ),

          // 업로드 처리 중 로딩 오버레이 (입력 차단 + 인디케이터)
          if (isLoading) const AppLoadingOverlay(),
        ],
      ),
    );
  }
}
