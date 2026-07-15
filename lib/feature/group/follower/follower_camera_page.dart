import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/component/loading/app_loading_overlay.dart';
import 'package:ddara/core/widget/app_dialog.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group/detail/provider/notifier_provider.dart'
    as group_detail;
import 'package:ddara/feature/group/follower/follower_camera.dart';
import 'package:ddara/feature/group/follower/follower_photo_check.dart';
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
  Widget build(BuildContext context) {
    final capturedPath = _capturedPath;
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(followerNotifierProvider.notifier);
    final isLoading = ref.watch(
      followerNotifierProvider.select((s) => s.isLoading),
    );

    // 업로드 결과를 감지해 에러는 토스트로, 성공은 갤러리 이동으로 처리한다.
    ref.listen(followerNotifierProvider, (prev, next) {
      if (next.errorMessage.isNotEmpty) {
        Toast.showToast(context, next.errorMessage, type: ToastType.error);
        notifier.clearError();
      }

      final cycleId = next.uploadedCycleId;
      if (prev?.uploadedCycleId == null && cycleId != null) {
        // 스택 아래의 갤러리를 새로고침한 뒤 촬영 화면을 닫아 그 갤러리로 돌아간다.
        // (pushReplacement 로 갤러리를 새로 쌓으면 중복·미갱신 문제가 생긴다)
        ref.invalidate(cyclePhotoGalleryNotifierProvider(cycleId));
        // 스택 아래에 모임 상세가 있으면 새 사진(참여 현황)이 반영되도록 함께
        // 무효화한다. (groupId 를 모르는 화면이라 family 전체를 무효화)
        ref.invalidate(group_detail.groupPageNotifierProvider);
        context.pop();
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
                  onUpload: () async {
                    // 게시는 되돌릴 수 없으므로 확인을 한 번 받는다.
                    final ok = await AppDialog.show(
                      context,
                      title: l10n.photoPostWarningTitle,
                      confirmLabel: l10n.commonConfirm,
                    );
                    if (!ok) return;
                    // 촬영본을 S3에 올리고 따라찍기 사진을 등록한다.
                    // (성공/실패는 위 listen 에서 처리)
                    await notifier.upload(widget.cycleId, capturedPath);
                  },
                ),

          // 업로드 처리 중 로딩 오버레이 (입력 차단 + 인디케이터)
          if (isLoading) const AppLoadingOverlay(),
        ],
      ),
    );
  }
}
