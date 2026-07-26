import 'package:ddara/core/analytics/mixpanel_manager.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/loading/app_loading_overlay.dart';
import 'package:ddara/core/model/group/group_action_error.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group/detail/provider/notifier_provider.dart'
    as group_detail;
import 'package:ddara/feature/group/follower/widget/follower_camera.dart';
import 'package:ddara/feature/group/follower/widget/follower_photo_check.dart';
import 'package:ddara/feature/group/follower/provider/notifier_provider.dart';
import 'package:ddara/feature/group/gallery/provider/notifier_provider.dart';
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
  });

  /// 따라찍는 대상 사이클 id. (업로드 시 서버에 전달)
  final int cycleId;

  /// 따라찍기 가이드(스타터가 미리 찍은) 사진 URL.
  final String guideImageUrl;

  @override
  ConsumerState<FollowerCameraPage> createState() => _FollowerCameraPageState();
}

class _FollowerCameraPageState extends ConsumerState<FollowerCameraPage> {
  /// 촬영된 사진 경로. null 이면 촬영 단계, 값이 있으면 사진 확인 단계.
  String? _capturedPath;

  @override
  void initState() {
    super.initState();
    MixpanelManager.instance.track(
      'follower_page_viewed',
      properties: {'cycle_id': widget.cycleId},
    );
  }

  /// 게시 확인을 받고 촬영본을 올린다. 성공하면 스택 아래 갤러리를 새로고침한
  /// 뒤 이 화면을 닫아 그 갤러리로 돌아간다.
  /// (실패 시 notifier 가 error 를 채우고 화면이 토스트로 안내한다)
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
        .read(followerNotifierProvider.notifier)
        .upload(widget.cycleId, path);
    if (cycleId == null || !mounted) return;

    MixpanelManager.instance.track(
      'follower_photo_posted',
      properties: {'cycle_id': cycleId},
    );
    // 스택 아래의 갤러리를 새로고침한 뒤 촬영 화면을 닫아 그 갤러리로 돌아간다.
    // (pushReplacement 로 갤러리를 새로 쌓으면 중복·미갱신 문제가 생긴다)
    ref.invalidate(cyclePhotoGalleryNotifierProvider(cycleId));
    // 스택 아래에 모임 상세가 있으면 새 사진(참여 현황)이 반영되도록 함께
    // 무효화한다. (groupId 를 모르는 화면이라 family 전체를 무효화)
    ref.invalidate(group_detail.groupPageNotifierProvider);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final capturedPath = _capturedPath;
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(followerNotifierProvider.notifier);
    final isLoading = ref.watch(
      followerNotifierProvider.select((s) => s.isLoading),
    );

    // 업로드 실패는 토스트로 알린다. (성공 후 이동은 _upload 가 직접 처리)
    ref.listen(followerNotifierProvider, (prev, next) {
      final error = next.error;
      if (error != null) {
        Toast.showToast(context, error.message(l10n), type: ToastType.error);
        notifier.clearError();
      }
    });

    return CupertinoPageScaffold(
      navigationBar: AppBar(title: l10n.followerCameraTitle),
      child: Stack(
        children: [
          capturedPath == null
              ? FollowerCamera(
                  guideImageUrl: widget.guideImageUrl,
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
