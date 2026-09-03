import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/util/image_saver.dart';
import 'package:ddara/core/widget/bottom_sheet/report_sheets.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/feature/group/photo_viewer/util/photo_viewer_args.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group/gallery/cycle_photo_gallery_viewmodel.dart';
import 'package:ddara/feature/group/gallery/provider/viewmodel_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 사이클 갤러리의 뷰어·액션 배선 묶음.
///
/// 사진 뷰어 열기 · 차단 · 신고 · 저장 · 촬영 이동이
/// 모두 "시트·다이얼로그 → ViewModel → 토스트" 라는 같은 모양이라, 화면 조립
/// 코드 사이에 흩어 두지 않고 여기에 모은다.
///
/// ```dart
/// final actions = CyclePhotoGalleryActions(context: context, ref: ref, cycleId: cycleId);
/// GalleryMemberTile(..., actions: actions);
/// ```
class CyclePhotoGalleryActions {
  const CyclePhotoGalleryActions({
    required this.context,
    required this.ref,
    required this.cycleId,
  });

  /// 액션을 띄운 화면의 context. (l10n·토스트·이동·mounted 확인에 사용)
  final BuildContext context;

  final WidgetRef ref;

  /// 대상 사이클 식별자.
  final int cycleId;

  AppLocalizations get _l10n => AppLocalizations.of(context);

  CyclePhotoGalleryViewModel get _viewModel =>
      ref.read(cyclePhotoGalleryViewModelProvider(cycleId).notifier);

  // ── 사진 뷰어 ─────────────────────────────────────────────────────

  /// 사진 상세 화면을 연다.
  void pushShotViewer({
    required ImageProvider image,
    Object? heroTag,
    double? aspectRatio,
    bool locked = false,
  }) {
    context.push(
      RoutePath.photoViewer,
      extra: PhotoViewerArgs(
        image: image,
        heroTag: heroTag,
        aspectRatio: aspectRatio,
        // 잠긴 사진은 뷰어에서도 블러+자물쇠 유지.
        locked: locked,
        // TODO: 꾸미기 화면이 생기면 onDecorate 를 여기서 연결한다.
        // (지금은 넘기지 않아 상단 바 '꾸미기' 버튼이 비활성으로 보인다)
      ),
    );
  }

  // ── 이동 ──────────────────────────────────────────────────────────

  /// 따라찍기(팔로워) 촬영 화면으로 이동한다.
  /// 대상 사이클 id 와 가이드용 스타터 사진 URL 을 넘긴다.
  void pushFollowerCamera({required String guideImageUrl}) => context.push(
    RoutePath.followerCamera,
    extra: (cycleId: cycleId, guideImageUrl: guideImageUrl, forceTour: false),
  );

  // ── 액션 ──────────────────────────────────────────────────────────

  /// [userId] 유저(멤버·스타터 공용)를 차단한다. 먼저 확인
  /// 다이얼로그를 띄우고, 확인 시에만 진행한다. 성공하면 차단이 반영된
  /// (사진 가림) 갤러리를 다시 조회하고 완료 토스트를 띄운 뒤 true 를
  /// 반환한다. (실패 시 ViewModel 이 error → 토스트로 처리)
  Future<bool> blockUser({
    required int userId,
    required String nickname,
  }) async {
    final l10n = _l10n;
    final confirmed = await AppDialog.show(
      context,
      title: l10n.memberBlockConfirmTitle(nickname),
      message: l10n.memberBlockConfirmMessage,
      confirmLabel: l10n.memberBlockConfirmAction,
      confirmColor: AppColors.statusDanger,
      confirmLabelColor: AppColors.textPrimary,
    );
    if (!confirmed || !context.mounted) return false;

    final success = await _viewModel.blockMember(userId);
    if (!success || !context.mounted) return false;

    Toast.showToast(context, l10n.memberBlockedToast(nickname));
    return true;
  }

  /// 사진 신고 사유 시트를 띄우고, 확정하면 신고를 접수한다.
  /// 성공 시 검토 상태가 반영된 갤러리를 다시 조회하고 완료 토스트를 띄운다.
  /// (실패 시 ViewModel 이 error → 토스트로 처리)
  Future<void> reportPhoto(int shotId) async {
    final result = await PhotoReportSheet.show(context);
    if (result == null || !context.mounted) return;

    final success = await _viewModel.reportShot(
      shotId: shotId,
      reason: result.reason,
      reasonText: result.detail.isEmpty ? null : result.detail,
    );
    if (!success || !context.mounted) return;

    Toast.showToast(context, _l10n.reportSubmitted);
  }

  /// 사진을 기기 갤러리에 저장하고 결과를 토스트로 알린다.
  /// (권한 거부·저장 실패 모두 [SaveImageResult] 로 와서 문구만 갈린다)
  Future<void> savePhoto(String imageUrl) async {
    final l10n = _l10n;
    final result = await ImageSaver.saveNetworkImage(imageUrl);
    if (!context.mounted) return;

    Toast.showToast(
      context,
      result.message(l10n),
      type: result.isFailure ? ToastType.error : ToastType.info,
    );
  }
}
