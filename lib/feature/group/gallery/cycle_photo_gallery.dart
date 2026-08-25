import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/analytics/analytics_events.dart';
import 'package:ddara/core/exception/comment_action_error.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/domain/model/group/cycle_gallery.dart';
import 'package:ddara/core/exception/group_action_error.dart';
import 'package:ddara/feature/group/gallery/cycle_photo_gallery_actions.dart';
import 'package:ddara/feature/group/gallery/provider/viewmodel_provider.dart';
import 'package:ddara/feature/group/gallery/util/cycle_photo_gallery_state.dart';
import 'package:ddara/feature/group/gallery/widget/gallery_member_tile.dart';
import 'package:ddara/feature/group/widget/started_header.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 스타터(따라찍기 시작) 화면.
///
/// 스타터의 사진을 멤버들이 따라찍은 결과 사진을 모아 보여준다.
/// (헤더 + 모임명 + 멤버 사진 그리드)
///
/// 뷰어·차단·신고·저장 배선은 [CyclePhotoGalleryActions] 가, 그리드 카드 한
/// 장은 [GalleryMemberTile] 이 맡는다. 이 파일에는 상태 분기와 화면 골격만 둔다.
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
    AnalyticsEvents.galleryPageViewed(cycleId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cyclePhotoGalleryViewModelProvider(cycleId));
    final actions = CyclePhotoGalleryActions(
      context: context,
      ref: ref,
      cycleId: cycleId,
    );

    // 신고 등 액션 실패를 토스트로 안내한다.
    // (초기 조회 실패는 본문에 표시되므로 갤러리가 로드된 뒤의 에러만 다룬다)
    ref.listen(cyclePhotoGalleryViewModelProvider(cycleId), (prev, next) {
      if (next is! CyclePhotoGalleryLoaded) return;

      final error = next.actionError;
      if (error != null) {
        Toast.showToast(
          context,
          error.message(AppLocalizations.of(context)),
          type: ToastType.error,
        );
        ref
            .read(cyclePhotoGalleryViewModelProvider(cycleId).notifier)
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
            .read(cyclePhotoGalleryViewModelProvider(cycleId).notifier)
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
          CyclePhotoGalleryLoaded() => _buildContent(context, state, actions),
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    CyclePhotoGalleryLoaded state,
    CyclePhotoGalleryActions actions,
  ) {
    final gallery = state.gallery;
    final cycle = gallery.cycle;

    // 스타터를 차단했으면 헤더에 사진 대신 차단 자리표시를 보여준다.
    final starterBlocked = state.blockedUserIds.contains(cycle.starterUserId);

    // 마감된(done) 회차는 사진이 있는 카드만 보여준다. (미업로드 빈 카드는 숨김)
    final isDoneCycle = cycle.status.toLowerCase() == 'done';

    final members = _orderedMembers(state, isDoneCycle);

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
          _header(
            state,
            actions,
            starterBlocked: starterBlocked,
            isDoneCycle: isDoneCycle,
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
            itemBuilder: (context, index) => GalleryMemberTile(
              state: state,
              member: members[index],
              cycle: cycle,
              isDoneCycle: isDoneCycle,
              starterBlocked: starterBlocked,
              actions: actions,
            ),
          ),
        ],
      ),
    );
  }

  /// 그리드에 세울 멤버 순서. 스타터는 헤더에 노출되므로 제외한다.
  ///
  /// 마감 회차는 사진이 있는 멤버를 앞에 모으고, 진행 중 회차는 (내가 스타터가
  /// 아닐 때) 본인 카드를 맨 앞으로 끌어올린다.
  List<CycleGalleryMember> _orderedMembers(
    CyclePhotoGalleryLoaded state,
    bool isDoneCycle,
  ) {
    final myUserId = state.myUserId;
    final nonStarters = state.gallery.members
        .where((m) => !m.isStarter)
        .toList();

    if (isDoneCycle) {
      // 마감 회차: 사진이 있는 멤버를 앞에, 없는 멤버를 뒤에 둔다. (모두 표시)
      return [
        ...nonStarters.where((m) => m.imageUrl != null),
        ...nonStarters.where((m) => m.imageUrl == null),
      ];
    }

    // 본인이 스타터면 본인 카드가 그리드에 없으므로 정렬할 것이 없다.
    // (사진을 볼 수 있는지는 서버가 멤버별 status 로 내려준다 — 여기서 계산하지 않는다)
    if (state.gallery.cycle.starterUserId == myUserId) return nonStarters;

    // 진행 중: 내가 스타터가 아니면 본인 카드를 항상 맨 앞에 둔다.
    final myIndex = nonStarters.indexWhere((m) => m.userId == myUserId);
    if (myIndex > 0) nonStarters.insert(0, nonStarters.removeAt(myIndex));
    return nonStarters;
  }

  /// 스타터 사진·주제·마감을 보여주는 상단 헤더.
  ///
  /// 스타터 사진은 탭하면 크게, 댓글 버튼으로는 댓글 시트가 열린 채로 뜬다.
  /// (사진이 없으면 두 콜백 모두 null 이라 열리지 않는다)
  Widget _header(
    CyclePhotoGalleryLoaded state,
    CyclePhotoGalleryActions actions, {
    required bool starterBlocked,
    required bool isDoneCycle,
  }) {
    final gallery = state.gallery;
    final cycle = gallery.cycle;
    // 본인이 스타터인지 여부. (본인 사진은 신고·차단 대상이 아니다)
    final iAmStarter = cycle.starterUserId == state.myUserId;

    // 스타터 사진에 읽지 않은 댓글이 있는지. (이 화면에서 이미 열어 봤으면 해제)
    final commentUnread = state.isCommentUnread(
      cycle.starterShotId,
      hasUnreadComments: cycle.hasUnreadComments,
    );

    // 스타터 대표 사진 크게 보기. (사진이 없으면 열지 않는다)
    // 헤더에서 보이던 프레임 그대로 보여준다. 댓글은 스타터 shot id 로 등록·조회한다.
    VoidCallback? openViewer;
    VoidCallback? openComments;
    final starterImageUrl = cycle.starterImageUrl;
    if (starterImageUrl != null && starterImageUrl.isNotEmpty) {
      void show({bool withComments = false}) => actions.showShotViewer(
        shotId: cycle.starterShotId,
        image: CachedNetworkImageProvider(starterImageUrl),
        aspectRatio: AppRatio.photo,
        // 댓글 시트 헤더: 스타터 닉네임 + 따라찍기 주제.
        title: cycle.starterNickname,
        body: cycle.topic,
        openCommentSheet: withComments,
        commentUnread: commentUnread,
      );
      openViewer = () => show();
      openComments = () => show(withComments: true);
    }

    return StartedHeader(
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
      // 스타터 사진 롱프레스 → 신고·차단 메뉴. (본인이 스타터면 두 콜백이
      // 없어 저장 항목만 뜬다)
      onReport: iAmStarter
          ? null
          : () => actions.reportPhoto(cycle.starterShotId),
      onBlock: iAmStarter
          ? null
          : () => actions.blockUser(
              userId: cycle.starterUserId,
              nickname: cycle.starterNickname,
            ),
      // 스타터 대표 사진 탭 → 헤더에서 보이던 프레임 그대로 크게 보여준다.
      onImageTap: openViewer,
      // 우상단 댓글 버튼 → 댓글 시트가 열린 채로 크게 보기.
      onComment: openComments,
      commentUnread: commentUnread,
    );
  }
}

// (롱프레스 컨텍스트 메뉴는 feature/group/widget/anchored_context_menu.dart 공용)
