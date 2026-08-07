import 'dart:async' show unawaited;

import 'package:ddara/core/comment/comment_actions.dart';
import 'package:ddara/core/widget/bottom_sheet/report_sheets.dart';
import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:ddara/core/widget/image/comment/photo_comment_mapper.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

Set<int> _noBlockedUserIds() => const {};

/// 사진 뷰어(showPhotoViewer)의 댓글 콜백 배선 묶음.
///
/// 목록 조회·등록·삭제·수정·신고의 배선(도메인 → PhotoComment 변환, 댓글 id
/// 가드, 신고 사유 시트 + 낙관적 접수 + 완료 토스트)이 홈 피드·사이클 갤러리
/// 에서 동일하므로 한곳에 모은다. 화면마다 다른 것만 주입받는다:
/// 내 userId([myUserId])·차단 목록([blockedUserIds])·차단 플로우([onBlockComment]).
///
/// ```dart
/// final handlers = CommentSheetHandlers(
///   context: context,
///   viewModel: viewModel, // CommentActions mixin 을 가진 ViewModel
///   shotId: item.shotId,
///   myUserId: () => profile?.id,
///   onBlockComment: (comment) => _blockCommentAuthor(...),
/// );
/// showPhotoViewer(context, ..., onLoadComments: handlers.onLoadComments, ...);
/// ```
class CommentSheetHandlers {
  CommentSheetHandlers({
    required this.context,
    required this.viewModel,
    required this.shotId,
    required this.myUserId,
    this.blockedUserIds = _noBlockedUserIds,
    required this.onBlockComment,
  });

  /// 뷰어를 연 화면의 context. (l10n·토스트·mounted 확인에 사용)
  final BuildContext context;

  /// 댓글 CRUD 를 제공하는 ViewModel. (CommentActions mixin)
  final CommentActions<dynamic> viewModel;

  /// 댓글 대상 사진 id.
  final int shotId;

  /// 내 userId. (내 댓글 구분용 — 호출 시점의 최신 값을 읽는다)
  final int? Function() myUserId;

  /// 조회 시점의 최신 차단 목록. (뷰어가 열린 동안 차단이 늘 수 있어 함수로
  /// 받는다. 필터를 ViewModel 이 자체 처리하는 화면은 기본값(빈 집합)을 쓴다)
  final Set<int> Function() blockedUserIds;

  /// 댓글 작성자 차단. 화면마다 차단 대상 ViewModel·후처리가 달라 주입받는다.
  final Future<bool> Function(PhotoComment comment) onBlockComment;

  /// 댓글 목록을 조회해 화면 표시용으로 변환한다. 실패하면 null.
  /// (실패 안내는 ViewModel 이 실패 종류 → 화면 토스트로 처리)
  Future<List<PhotoComment>?> onLoadComments() async {
    final comments = await viewModel.loadComments(
      shotId: shotId,
      blockedUserIds: blockedUserIds(),
    );
    if (comments == null || !context.mounted) return null;

    final l10n = AppLocalizations.of(context);
    final userId = myUserId();
    return comments
        .map((comment) => toPhotoComment(comment, l10n, userId))
        .toList();
  }

  /// [content] 댓글을 등록하고, 성공 시 화면에 추가할 [PhotoComment] 를
  /// (작성자·시각 포함), 실패 시 null 을 반환한다.
  Future<PhotoComment?> onSubmitComment(String content) async {
    final created = await viewModel.submitComment(
      shotId: shotId,
      content: content,
    );
    if (created == null || !context.mounted) return null;

    return toPhotoComment(created, AppLocalizations.of(context), myUserId());
  }

  /// [comment] 를 삭제한다. 성공하면 true. (삭제 확인창은 뷰어가 처리)
  Future<bool> onDeleteComment(PhotoComment comment) async {
    final id = comment.commentId;
    if (id == null) return false;
    return viewModel.deleteComment(commentId: id);
  }

  /// [comment] 를 [newContent] 로 수정하고, 성공 시 갱신된 [PhotoComment] 를
  /// (내용만 바꿔) 반환한다. 실패·id 없음이면 null.
  Future<PhotoComment?> onEditComment(
    PhotoComment comment,
    String newContent,
  ) async {
    final id = comment.commentId;
    if (id == null) return null;

    final content = await viewModel.editComment(
      commentId: id,
      content: newContent,
    );
    if (content == null) return null;

    // 수정에 성공했으므로 '수정됨' 표시를 켠다.
    return comment.copyWith(content: content, isEdited: true);
  }

  /// 댓글 신고 사유 시트를 띄우고, 확정하면 즉시 true 를 반환해 시트가
  /// 댓글을 바로 지우게 한다. (낙관적 — 접수는 백그라운드로 진행)
  /// 접수 성공 시 완료 토스트를, 실패 시 ViewModel 이 실패 종류 → 토스트로
  /// 안내한다. (실패하면 서버에 신고가 남지 않았으므로 다음 목록 조회 때
  /// 댓글이 되살아난다)
  Future<bool> onReportComment(PhotoComment comment) async {
    final commentId = comment.commentId;
    if (commentId == null) return false;

    final result = await CommentReportSheet.show(context);
    if (result == null || !context.mounted) return false;

    // 접수 결과를 기다리지 않는다. (확정 즉시 댓글을 지우는 낙관적 처리)
    unawaited(
      viewModel
          .reportComment(
            commentId: commentId,
            reason: result.reason,
            reasonText: result.detail.isEmpty ? null : result.detail,
          )
          .then((success) {
            if (!success || !context.mounted) return;
            Toast.showToast(
              context,
              AppLocalizations.of(context).reportSubmitted,
            );
          }),
    );
    return true;
  }
}
