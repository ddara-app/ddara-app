import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/analytics/mixpanel_manager.dart';
import 'package:ddara/core/comment/comment_action_error.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/cycle_gallery.dart';
import 'package:ddara/core/model/group/cycle_shot_status.dart';
import 'package:ddara/core/model/group/group_action_error.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/bottom_sheet/report_sheets.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/image/comment/comment_sheet_handlers.dart';
import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:ddara/core/widget/image/photo_viewer.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group/gallery/provider/notifier_provider.dart';
import 'package:ddara/feature/group/gallery/util/cycle_photo_gallery_state.dart';
import 'package:ddara/feature/group/widget/anchored_context_menu.dart';
import 'package:ddara/feature/group/widget/member_photo_card.dart';
import 'package:ddara/feature/group/widget/started_header.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 스타터(따라찍기 시작) 화면.
///
/// 스타터의 사진을 멤버들이 따라찍은 결과 사진을 모아 보여준다.
/// (헤더 + 모임명 + 멤버 사진 그리드)
class CyclePhotoGallery extends ConsumerStatefulWidget {
  const CyclePhotoGallery({super.key, required this.cycleId});

  final int cycleId;

  @override
  ConsumerState<CyclePhotoGallery> createState() => _CyclePhotoGalleryState();
}

class _CyclePhotoGalleryState extends ConsumerState<CyclePhotoGallery> {
  int get cycleId => widget.cycleId;

  @override
  void initState() {
    super.initState();
    MixpanelManager.instance.track(
      'gallery_page_viewed',
      properties: {'cycle_id': cycleId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cyclePhotoGalleryNotifierProvider(cycleId));

    // 신고 등 액션 실패를 토스트로 안내한다.
    // (초기 조회 실패는 본문에 표시되므로 갤러리가 로드된 뒤의 에러만 다룬다)
    ref.listen(cyclePhotoGalleryNotifierProvider(cycleId), (prev, next) {
      if (next is! CyclePhotoGalleryLoaded) return;

      final error = next.actionError;
      if (error != null) {
        Toast.showToast(
          context,
          error.message(AppLocalizations.of(context)),
          type: ToastType.error,
        );
        ref
            .read(cyclePhotoGalleryNotifierProvider(cycleId).notifier)
            .clearActionError();
      }
      // 댓글 액션 실패는 종류(enum)로 오므로 l10n 으로 문구를 매핑한다.
      final commentError = next.commentError;
      if (commentError != null) {
        Toast.showToast(
          context,
          commentError.message(AppLocalizations.of(context)),
          type: ToastType.error,
        );
        ref
            .read(cyclePhotoGalleryNotifierProvider(cycleId).notifier)
            .clearCommentError();
      }
    });

    return CupertinoPageScaffold(
      // 조회 전·실패 시에는 제목이 없으므로 빈 문자열.
      navigationBar: AppBar(
        title: state is CyclePhotoGalleryLoaded ? state.groupName : '',
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        bottom: false,
        child: switch (state) {
          CyclePhotoGalleryLoading() => const Center(
            child: CupertinoActivityIndicator(),
          ),
          CyclePhotoGalleryLoadError(:final error) => Center(
            child: AppText.body(error.message(AppLocalizations.of(context))),
          ),
          CyclePhotoGalleryLoaded() => _buildContent(context, ref, state),
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    CyclePhotoGalleryLoaded state,
  ) {
    final l10n = AppLocalizations.of(context);
    final gallery = state.gallery;
    final myUserId = state.myUserId;
    final blockedUserIds = state.blockedUserIds;
    final cycle = gallery.cycle;

    // 스타터를 차단했으면 헤더에 사진 대신 차단 자리표시를 보여준다.
    final starterBlocked = blockedUserIds.contains(cycle.starterUserId);

    // 마감된(done) 회차는 사진이 있는 카드만 보여준다. (미업로드 빈 카드는 숨김)
    final isDoneCycle = cycle.status.toLowerCase() == 'done';

    // 본인이 스타터인지 여부.
    // (사진을 볼 수 있는지는 서버가 멤버별 status 로 내려준다 — 여기서 계산하지 않는다)
    final iAmStarter = cycle.starterUserId == myUserId;

    // 스타터는 헤더에 노출되므로 그리드에서는 제외한다.
    final nonStarters = gallery.members.where((m) => !m.isStarter).toList();

    final List<CycleGalleryMember> members;
    if (isDoneCycle) {
      // 마감 회차: 사진이 있는 멤버를 앞에, 없는 멤버를 뒤에 둔다. (모두 표시)
      members = [
        ...nonStarters.where((m) => m.imageUrl != null),
        ...nonStarters.where((m) => m.imageUrl == null),
      ];
    } else {
      members = nonStarters;
      // 진행 중: 내가 스타터가 아니면 본인 카드를 항상 맨 앞에 둔다.
      if (!iAmStarter) {
        final myIndex = members.indexWhere((m) => m.userId == myUserId);
        if (myIndex > 0) {
          members.insert(0, members.removeAt(myIndex));
        }
      }
    }

    // 스타터 사진에 읽지 않은 댓글이 있는지. (이 화면에서 이미 열어 봤으면 해제)
    final starterCommentUnread = state.isCommentUnread(
      cycle.starterShotId,
      hasUnreadComments: cycle.hasUnreadComments,
    );

    // 스타터 대표 사진 크게 보기. (사진이 없으면 열지 않는다)
    // 헤더에서 보이던 프레임 그대로 보여준다. 댓글은 스타터 shot id 로 등록·조회한다.
    VoidCallback? openStarterViewer;
    VoidCallback? openStarterComments;
    final starterImageUrl = cycle.starterImageUrl;
    if (starterImageUrl != null && starterImageUrl.isNotEmpty) {
      void show({bool withComments = false}) => _showShotViewer(
        context,
        ref,
        shotId: cycle.starterShotId,
        image: CachedNetworkImageProvider(starterImageUrl),
        aspectRatio: AppRatio.photo,
        // 댓글 시트 헤더: 스타터 닉네임 + 따라찍기 주제.
        title: cycle.starterNickname,
        body: cycle.topic,
        openCommentSheet: withComments,
        commentUnread: starterCommentUnread,
      );
      openStarterViewer = () => show();
      openStarterComments = () => show(withComments: true);
    }

    return SingleChildScrollView(
      // 끝에서 더 당겨지는 바운스(overscroll)를 막고 가장자리에서 멈춘다.
      physics: const ClampingScrollPhysics(),
      // 상 s6, 하 s8 + Safe Area 인셋, 좌우 s4 여백. (마지막 카드가 홈
      // 인디케이터와 겹치지 않도록)
      padding: EdgeInsets.only(
        top: AppSpacing.s6,
        bottom: AppSpacing.s8 + MediaQuery.of(context).padding.bottom,
        left: AppSpacing.s5,
        right: AppSpacing.s5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s5,
        children: [
          StartedHeader(
            info: StarterHeaderInfo(
              topic: cycle.topic,
              starterNickname: cycle.starterNickname,
              imageUrl: cycle.starterImageUrl,
              imageUnderReview: cycle.starterImageUnderReview,
              isDone: isDoneCycle,
              deadlineAt: cycle.deadlineAt,
              // 사진을 올린 멤버(스타터 제외) + 스타터 본인.
              // 모임 페이지와 같은 기준으로 참여 인원을 센다.
              participantCount:
                  gallery.members
                      .where((m) => !m.isStarter && m.uploadedAt != null)
                      .length +
                  1,
            ),
            starterBlocked: starterBlocked,
            // 모임 페이지와 동일하게 참여 인원(n/총원)을 표시한다.
            memberCount: gallery.members.length,
            // 스타터 사진 롱프레스 → 신고·차단 메뉴. (본인이 스타터면 띄우지
            // 않는다)
            onReport: iAmStarter
                ? null
                : () => _reportPhoto(context, ref, cycle.starterShotId),
            onBlock: iAmStarter
                ? null
                : () => _blockUser(
                    context,
                    ref,
                    userId: cycle.starterUserId,
                    nickname: cycle.starterNickname,
                  ),
            // 스타터 대표 사진 탭 → 헤더에서 보이던 프레임 그대로 크게 보여준다.
            onImageTap: openStarterViewer,
            // 우상단 댓글 버튼 → 댓글 시트가 열린 채로 크게 보기.
            onComment: openStarterComments,
            commentUnread: starterCommentUnread,
          ),
          // 헤더↔제목 간격 52: Column spacing(s5)×2 + 이 SizedBox(s6).
          const SizedBox(height: AppSpacing.s6),
          AppText.headlineLarge(gallery.groupName),
          // 제목↔그리드 간격 s5 는 Column spacing 으로 처리.
          // 멤버 사진 카드 2칸 그리드. (카드 비율은 MemberPhotoCard 가 정한다)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.s4,
              mainAxisSpacing: AppSpacing.s4,
              childAspectRatio: AppRatio.photo,
            ),
            itemCount: members.length,
            itemBuilder: (context, index) => _memberTile(
              context,
              ref,
              l10n: l10n,
              state: state,
              member: members[index],
              cycle: cycle,
              isDoneCycle: isDoneCycle,
              starterBlocked: starterBlocked,
            ),
          ),
        ],
      ),
    );
  }

  /// 멤버 사진 그리드의 카드 한 장. 표시 상태(차단·검토중·잠김·본인 여부)를
  /// 여기서 판정하고, 타인의 보이는 사진이면 롱프레스 메뉴로 감싼다.
  Widget _memberTile(
    BuildContext context,
    WidgetRef ref, {
    required AppLocalizations l10n,
    required CyclePhotoGalleryLoaded state,
    required CycleGalleryMember member,
    required CycleGalleryCycle cycle,
    required bool isDoneCycle,
    required bool starterBlocked,
  }) {
    final isMe = member.userId == state.myUserId;
    // 차단한 멤버는 사진을 아예 로드하지 않고 자리표시만 보여준다.
    final isBlockedMember = state.blockedUserIds.contains(member.userId);
    // 신고 접수로 검토 중인 사진. (검토 안내 자리표시로 가린다)
    final isReported = member.status == CycleShotStatus.reported;
    final imageUrl = isBlockedMember || isReported ? null : member.imageUrl;
    // 잠긴(블러) 사진. 크게 볼 때도 블러+자물쇠는 유지하지만,
    // 뷰어와 댓글에는 접근할 수 있다.
    // (뷰어 맥락까지 반영한 판정은 서버가 status 로 내려준다)
    final locked = member.status == CycleShotStatus.locked;
    final ImageProvider? image = imageUrl == null
        ? null
        : CachedNetworkImageProvider(imageUrl);
    // 사진이 있으면(잠겨 있어도) 탭해서 뷰어를 열 수 있다.
    final canOpen = image != null;
    // 선명하게 볼 수 있는(= Hero 전환·신고 가능) 상태.
    final canView = canOpen && !locked;
    // 잠긴 사진은 카드가 블러라 Hero 전환을 하지 않는다.
    final heroTag = canView ? 'gallery-photo-${member.userId}' : null;
    // 댓글 등록 대상 shot id. (미업로드면 null → 댓글 불가)
    final shotId = member.shotId;
    // 읽지 않은 댓글이 있는지. (이 화면에서 이미 열어 봤으면 해제)
    final commentUnread = state.isCommentUnread(
      shotId,
      hasUnreadComments: member.hasUnreadComments,
    );

    // 사진이 있으면 잠겨 있어도 탭해 뷰어·댓글을 열 수 있다.
    // 잠긴 사진은 뷰어에서도 블러+자물쇠를 유지한다(locked 전달).
    // (사진이 있으면 shot id 도 함께 오지만, 없으면 열지 않는다)
    VoidCallback? openViewer;
    VoidCallback? openComments;
    if (canOpen && shotId != null) {
      void show({bool withComments = false}) => _showShotViewer(
        context,
        ref,
        shotId: shotId,
        image: image,
        heroTag: heroTag,
        // 카드에서 잘려 보이던 프레임 그대로 크게 보여준다.
        aspectRatio: AppRatio.photo,
        // 댓글 시트 헤더: 멤버 닉네임 + 따라찍기 주제.
        title: member.nickname,
        body: cycle.topic,
        locked: locked,
        openCommentSheet: withComments,
        commentUnread: commentUnread,
      );
      openViewer = () => show();
      openComments = () => show(withComments: true);
    }

    final card = MemberPhotoCard(
      // 본인 카드는 닉네임 대신 '나' 로 표시한다.
      name: isMe ? l10n.galleryMyCardLabel : member.nickname,
      image: image,
      heroTag: heroTag,
      isBlocked: isBlockedMember,
      isUnderReview: isReported,
      onTap: openViewer,
      // 우측 상단 댓글 버튼 → 댓글 시트가 열린 채로 크게 보기.
      onComment: openComments,
      commentUnread: commentUnread,
      // 본인 카드만 촬영 콜백을 연결한다. (타인은 null)
      // 마감(done) 회차는 촬영할 수 없으므로 본인 카드도 버튼을 숨긴다.
      // 스타터 차단·신고 검토 중이면 가이드 사진을 볼 수 없으므로 역시 숨긴다.
      onTakePhoto:
          isMe &&
              !isDoneCycle &&
              !starterBlocked &&
              !cycle.starterImageUnderReview
          ? () => context.push(
              RoutePath.followerCamera,
              // 대상 사이클 id 와 가이드용 스타터 사진 URL 을 넘긴다.
              extra: (
                cycleId: cycle.cycleId,
                guideImageUrl: cycle.starterImageUrl ?? '',
              ),
            )
          : null,
      // 모든 사진을 볼 수 없는 상태면 사진이 있는 멤버를 블러+자물쇠로 가린다.
      // (실제 블러/자물쇠는 image 가 있을 때만 그려진다)
      // 단, 마감(done) 회차는 항상 공개하므로 잠금하지 않는다.
      isLocked: locked,
    );

    // 타인의 보이는 사진만 신고·차단할 수 있다. (본인·잠김·차단 제외)
    if (isMe || !canView || shotId == null) return card;

    return AnchoredContextMenu(
      // 사본은 Hero 태그 충돌을 피해 태그·콜백 없이 만든다.
      // (오버레이에는 그리드 제약이 없어 원본 카드 폭을 그대로 준다)
      overlayBuilder: (_, targetSize) => SizedBox(
        width: targetSize.width,
        child: MemberPhotoCard(name: member.nickname, image: image),
      ),
      // 멤버 아바타 메뉴와 같은 순서. (차단하기 → 신고하기)
      actions: [
        (
          label: l10n.memberBlock,
          color: AppColors.statusDanger,
          onSelect: () => _blockUser(
            context,
            ref,
            userId: member.userId,
            nickname: member.nickname,
          ),
        ),
        (
          label: l10n.report,
          color: AppColors.statusDanger,
          onSelect: () => _reportPhoto(context, ref, shotId),
        ),
      ],
      child: card,
    );
  }

  /// 사진 뷰어를 연다. 댓글 시트 배선(내 프로필·핸들러 6종)은 어느 사진이든
  /// 같으므로 여기서 한 번만 구성한다 — 호출부는 사진마다 다른 값만 넘긴다.
  void _showShotViewer(
    BuildContext context,
    WidgetRef ref, {
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
    final state = ref.read(cyclePhotoGalleryNotifierProvider(cycleId));
    final me = state is CyclePhotoGalleryLoaded
        ? state.gallery.members
              .where((member) => member.userId == state.myUserId)
              .firstOrNull
        : null;

    final handlers = _commentHandlers(context, ref, shotId);
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
        if (comments != null) {
          ref
              .read(cyclePhotoGalleryNotifierProvider(cycleId).notifier)
              .markCommentsRead(shotId);
        }
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
  /// 차단 유저 필터는 notifier 가 자체 처리하므로 blockedUserIds 는 기본값)
  CommentSheetHandlers _commentHandlers(
    BuildContext context,
    WidgetRef ref,
    int shotId,
  ) {
    return CommentSheetHandlers(
      context: context,
      notifier: ref.read(cyclePhotoGalleryNotifierProvider(cycleId).notifier),
      shotId: shotId,
      myUserId: () {
        final state = ref.read(cyclePhotoGalleryNotifierProvider(cycleId));
        return state is CyclePhotoGalleryLoaded ? state.myUserId : null;
      },
      onBlockComment: (comment) => _blockCommentAuthor(context, ref, comment),
    );
  }

  /// [userId] 유저(멤버·스타터·댓글 작성자 공용)를 차단한다. 먼저 확인
  /// 다이얼로그를 띄우고, 확인 시에만 진행한다. 성공하면 차단이 반영된
  /// (사진 가림) 갤러리를 다시 조회하고 완료 토스트를 띄운 뒤 true 를
  /// 반환한다. (실패 시 notifier 가 error → 토스트로 처리)
  Future<bool> _blockUser(
    BuildContext context,
    WidgetRef ref, {
    required int userId,
    required String nickname,
  }) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await AppDialog.show(
      context,
      title: l10n.memberBlockConfirmTitle(nickname),
      message: l10n.memberBlockConfirmMessage,
      confirmLabel: l10n.memberBlockConfirmAction,
      confirmColor: AppColors.statusDanger,
      confirmLabelColor: AppColors.textPrimary,
    );
    if (!confirmed || !context.mounted) return false;

    final success = await ref
        .read(cyclePhotoGalleryNotifierProvider(cycleId).notifier)
        .blockMember(userId);
    if (!success || !context.mounted) return false;

    Toast.showToast(context, l10n.memberBlockedToast(nickname));
    return true;
  }

  /// 댓글 작성자를 차단한다. ([_blockUser] 의 댓글용 래퍼 — 뷰어 댓글 시트의
  /// onBlockComment 콜백으로 연결되며, 성공 시 시트가 목록을 재조회한다)
  Future<bool> _blockCommentAuthor(
    BuildContext context,
    WidgetRef ref,
    PhotoComment comment,
  ) {
    final userId = comment.userId;
    if (userId == null) return Future.value(false);
    return _blockUser(context, ref, userId: userId, nickname: comment.nickname);
  }

  /// 사진 신고 사유 시트를 띄우고, 확정하면 신고를 접수한다.
  /// 성공 시 검토 상태가 반영된 갤러리를 다시 조회하고 완료 토스트를 띄운다.
  /// (실패 시 notifier 가 error → 토스트로 처리)
  Future<void> _reportPhoto(
    BuildContext context,
    WidgetRef ref,
    int shotId,
  ) async {
    final result = await PhotoReportSheet.show(context);
    if (result == null || !context.mounted) return;

    final success = await ref
        .read(cyclePhotoGalleryNotifierProvider(cycleId).notifier)
        .reportShot(
          shotId: shotId,
          reason: result.reason,
          reasonText: result.detail.isEmpty ? null : result.detail,
        );
    if (!success || !context.mounted) return;

    Toast.showToast(context, AppLocalizations.of(context).reportSubmitted);
  }
}

// (롱프레스 컨텍스트 메뉴는 feature/group/widget/anchored_context_menu.dart 공용)
