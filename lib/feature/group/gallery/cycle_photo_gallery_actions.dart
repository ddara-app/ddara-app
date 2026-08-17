import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/util/image_saver.dart';
import 'package:ddara/core/widget/bottom_sheet/report_sheets.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/image/comment/comment_sheet_handlers.dart';
import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:ddara/core/widget/image/photo_viewer.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group/gallery/cycle_photo_gallery_viewmodel.dart';
import 'package:ddara/feature/group/gallery/provider/viewmodel_provider.dart';
import 'package:ddara/feature/group/gallery/util/cycle_photo_gallery_state.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 사이클 갤러리의 뷰어·액션 배선 묶음.
///
/// 사진 뷰어 열기(댓글 시트 배선 포함) · 차단 · 신고 · 저장 · 촬영 이동이
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

  CyclePhotoGalleryState get _state =>
      ref.read(cyclePhotoGalleryViewModelProvider(cycleId));

  // ── 사진 뷰어 ─────────────────────────────────────────────────────

  /// 사진 뷰어를 연다. 댓글 시트 배선(내 프로필·핸들러 6종)은 어느 사진이든
  /// 같으므로 여기서 한 번만 구성한다 — 호출부는 사진마다 다른 값만 넘긴다.
  void showShotViewer({
    required int shotId,
    required ImageProvider image,
    required String title,
    required String body,
    Object? heroTag,
    double? aspectRatio,
    bool locked = false,
    bool openCommentSheet = false,
    bool commentUnread = false,
  }) {
    // 전송 중 댓글을 서버 응답 전에 보여주기 위한 내 작성자 정보.
    // (뷰어는 갤러리가 떠 있어야만 열리므로 여기선 항상 Loaded 다)
    final state = _state;
    final me = state is CyclePhotoGalleryLoaded
        ? state.gallery.members
              .where((member) => member.userId == state.myUserId)
              .firstOrNull
        : null;

    final handlers = _commentHandlers(shotId);
    showPhotoViewer(
      context,
      image: image,
      heroTag: heroTag,
      aspectRatio: aspectRatio,
      title: title,
      body: body,
      myNickname: me?.nickname ?? '',
      myProfileImageUrl: me?.profileImageUrl,
      // 잠긴 사진은 뷰어에서도 블러+자물쇠 유지.
      // (서버가 SHOT_LOCKED 로 작성 거부 → 토스트 안내)
      locked: locked,
      // 댓글 버튼으로 들어왔으면 시트를 연 채로 시작한다.
      openCommentSheet: openCommentSheet,
      // 카드의 댓글 버튼과 같은 강조 표시를 뷰어 말풍선에도 유지한다.
      commentUnread: commentUnread,
      // 댓글 시트를 열어 목록을 받아왔으면 읽은 것으로 본다.
      // (돌아왔을 때 카드의 강조 표시가 내려간다)
      onLoadComments: () async {
        final comments = await handlers.onLoadComments();
        if (comments != null) _viewModel.markCommentsRead(shotId);
        return comments;
      },
      onSubmitComment: handlers.onSubmitComment,
      onDeleteComment: handlers.onDeleteComment,
      onEditComment: handlers.onEditComment,
      onReportComment: handlers.onReportComment,
      onBlockComment: handlers.onBlockComment,
    );
  }

  /// [shotId] 사진용 댓글 시트 배선. (조회·등록·삭제·수정·신고는 공용 배선,
  /// 차단 유저 필터는 ViewModel 이 자체 처리하므로 blockedUserIds 는 기본값)
  CommentSheetHandlers _commentHandlers(int shotId) {
    return CommentSheetHandlers(
      context: context,
      viewModel: _viewModel,
      shotId: shotId,
      myUserId: () {
        final state = _state;
        return state is CyclePhotoGalleryLoaded ? state.myUserId : null;
      },
      onBlockComment: blockCommentAuthor,
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

  /// [userId] 유저(멤버·스타터·댓글 작성자 공용)를 차단한다. 먼저 확인
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

  /// 댓글 작성자를 차단한다. ([blockUser] 의 댓글용 래퍼 — 뷰어 댓글 시트의
  /// onBlockComment 콜백으로 연결되며, 성공 시 시트가 목록을 재조회한다)
  Future<bool> blockCommentAuthor(PhotoComment comment) {
    final userId = comment.userId;
    if (userId == null) return Future.value(false);
    return blockUser(userId: userId, nickname: comment.nickname);
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
