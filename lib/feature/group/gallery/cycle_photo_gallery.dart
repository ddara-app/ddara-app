import 'package:ddara/core/analytics/mixpanel_manager.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/cycle_gallery.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/util/time_ago.dart';
import 'package:ddara/core/widget/image/photo_viewer.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group/detail/widget/header/started_header.dart';
import 'package:ddara/feature/group/gallery/provider/notifier_provider.dart';
import 'package:ddara/feature/group/gallery/widget/photo_report_sheet.dart';
import 'package:ddara/feature/group/widget/member_photo_card.dart';
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
    final gallery = state.gallery;

    // 신고 등 액션 실패를 토스트로 안내한다.
    // (초기 조회 실패는 본문에 표시되므로 갤러리가 로드된 뒤의 에러만 다룬다)
    ref.listen(cyclePhotoGalleryNotifierProvider(cycleId), (prev, next) {
      if (next.gallery != null && next.errorMessage.isNotEmpty) {
        Toast.showToast(context, next.errorMessage, type: ToastType.error);
        ref
            .read(cyclePhotoGalleryNotifierProvider(cycleId).notifier)
            .clearError();
      }
    });

    return CupertinoPageScaffold(
      // 조회 전엔 제목이 없으므로 빈 문자열.
      navigationBar: AppBar(
        title: state.groupName,
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        bottom: false,
        child: switch (gallery) {
          // 조회 완료 전: 로딩 인디케이터 또는 에러 메시지.
          null =>
            state.errorMessage.isNotEmpty
                ? Center(child: AppText.body(state.errorMessage))
                : const Center(child: CupertinoActivityIndicator()),
          _ => _buildContent(
            context,
            ref,
            gallery,
            state.myUserId,
            state.blockedUserIds,
          ),
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    CycleGallery gallery,
    int? myUserId,
    Set<int> blockedUserIds,
  ) {
    final cycle = gallery.cycle;

    // 스타터를 차단했으면 헤더에 사진 대신 차단 자리표시를 보여준다.
    final starterBlocked = blockedUserIds.contains(cycle.starterUserId);

    // 본인 닉네임. (사진 뷰어에서 내가 단 댓글의 작성자 표기에 쓴다)
    final myNickname = gallery.members
        .where((m) => m.userId == myUserId)
        .map((m) => m.nickname)
        .firstOrNull;

    // 마감된(done) 회차는 사진이 있는 카드만 보여준다. (미업로드 빈 카드는 숨김)
    final isDoneCycle = cycle.status.toLowerCase() == 'done';

    // 본인이 스타터인지 여부.
    final iAmStarter = cycle.starterUserId == myUserId;
    // 스타터이거나 본인이 사진을 올렸으면 모든 멤버의 사진을 볼 수 있다.
    // 그 외(스타터 아님 + 미업로드)면 사진이 있는 멤버는 블러+자물쇠로 가린다.
    final canSeeAll = iAmStarter || gallery.viewerUploaded;

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

    return SingleChildScrollView(
      // 끝에서 더 당겨지는 바운스(overscroll)를 막고 가장자리에서 멈춘다.
      physics: const ClampingScrollPhysics(),
      // 상 s6, 하 s8 + Safe Area 인셋, 좌우 s4 여백. (마지막 카드가 홈
      // 인디케이터와 겹치지 않도록)
      padding: EdgeInsets.only(
        top: AppSpacing.s6,
        bottom: AppSpacing.s8 + MediaQuery.of(context).padding.bottom,
        left: AppSpacing.s4,
        right: AppSpacing.s4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s4,
        children: [
          StartedHeader(
            imageUri: cycle.starterImageUrl ?? '',
            progress: _toGroupCycle(gallery),
            starterBlocked: starterBlocked,
            // 모임 페이지와 동일하게 참여 인원(n/총원)을 표시한다.
            memberCount: gallery.members.length,
            // 스타터 사진 롱프레스 → 신고 메뉴. (본인이 스타터면 띄우지 않는다)
            onReport: iAmStarter
                ? null
                : () => _reportPhoto(context, ref, cycle.starterShotId),
            // 스타터 대표 사진 탭 → 헤더에서 보이던 프레임 그대로 크게 보여준다.
            // (헤더 프레임: 가로 = 화면 - 좌우 s4 패딩, 세로 478 고정 — StartedHeader 참조)
            onImageTap: (cycle.starterImageUrl ?? '').isEmpty
                ? null
                : () => showPhotoViewer(
                    context,
                    image: NetworkImage(cycle.starterImageUrl!),
                    aspectRatio:
                        (MediaQuery.of(context).size.width -
                            AppSpacing.s4 * 2) /
                        478,
                    // 댓글 시트 헤더: 스타터 닉네임 + 따라찍기 주제.
                    title: cycle.starterNickname,
                    body: cycle.topic,
                    myNickname: myNickname,
                    // 스타터 사진 댓글은 스타터 shot id 로 등록한다.
                    onSubmitComment: (content) => _submitComment(
                      context,
                      ref,
                      cycle.starterShotId,
                      content,
                    ),
                  ),
          ),
          // 헤더↔제목 간격 s14(56): Column spacing(s4)×2 + 이 SizedBox(s6).
          const SizedBox(height: AppSpacing.s6),
          AppText.headlineLarge(gallery.groupName),
          // 제목↔그리드 간격 s4 는 Column spacing 으로 처리.
          // 멤버 사진 카드 2칸 그리드. (카드 높이는 225 고정)
          LayoutBuilder(
            builder: (context, constraints) {
              // 카드 한 장의 실제 폭. (2열 - 열 간격) 오버레이의 카드 사본 크기와
              // 크게 보기 비율 계산에 쓴다.
              final cardWidth = (constraints.maxWidth - AppSpacing.s3) / 2;
              // 카드 한 장의 실제 비율. 크게 보기에서 카드와 동일한 프레임으로
              // 잘라 보여주는 데 쓴다. (고정 높이 225)
              final cardAspectRatio = cardWidth / 225;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.s3,
                  mainAxisSpacing: AppSpacing.s3,
                  mainAxisExtent: 225,
                ),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final isMe = member.userId == myUserId;
                  // 차단한 멤버는 사진을 아예 로드하지 않고 자리표시만 보여준다.
                  final isBlockedMember = blockedUserIds.contains(
                    member.userId,
                  );
                  // 신고 접수로 검토 중인 사진. (검토 안내 자리표시로 가린다)
                  final isReported = member.status.toLowerCase() == 'reported';
                  final imageUrl = isBlockedMember || isReported
                      ? null
                      : member.imageUrl;
                  // 잠긴(블러) 사진. 크게 볼 때도 블러+자물쇠는 유지하지만,
                  // 뷰어와 댓글에는 접근할 수 있다.
                  final locked = !isDoneCycle && !canSeeAll;
                  final ImageProvider? image = imageUrl == null
                      ? null
                      : NetworkImage(imageUrl);
                  // 사진이 있으면(잠겨 있어도) 탭해서 뷰어를 열 수 있다.
                  final canOpen = image != null;
                  // 선명하게 볼 수 있는(= Hero 전환·신고 가능) 상태.
                  final canView = canOpen && !locked;
                  // 잠긴 사진은 카드가 블러라 Hero 전환을 하지 않는다.
                  final heroTag = canView
                      ? 'gallery-photo-${member.userId}'
                      : null;
                  // 댓글 등록 대상 shot id. (미업로드면 null → 댓글 불가)
                  final shotId = member.shotId;
                  final card = MemberPhotoCard(
                    // 본인 카드는 이름 대신 '본인' 으로 표시한다.
                    name: isMe ? '나' : member.nickname,
                    image: image,
                    heroTag: heroTag,
                    isBlocked: isBlockedMember,
                    isUnderReview: isReported,
                    // 사진이 있으면 잠겨 있어도 탭해 뷰어·댓글을 열 수 있다.
                    // 잠긴 사진은 뷰어에서도 블러+자물쇠를 유지한다(locked 전달).
                    onTap: canOpen
                        ? () => showPhotoViewer(
                            context,
                            image: image,
                            heroTag: heroTag,
                            // 카드에서 잘려 보이던 프레임 그대로 크게 보여준다.
                            aspectRatio: cardAspectRatio,
                            // 댓글 시트 헤더: 멤버 닉네임 + 따라찍기 주제.
                            title: member.nickname,
                            body: cycle.topic,
                            myNickname: myNickname,
                            // 잠긴 사진은 뷰어에서도 블러+자물쇠 유지.
                            locked: locked,
                            // 사진에 shot id 가 있으면 댓글을 등록할 수 있다.
                            // (잠긴 사진은 서버가 SHOT_LOCKED 로 거부 → 토스트 안내)
                            onSubmitComment: shotId == null
                                ? null
                                : (content) =>
                                      _submitComment(context, ref, shotId, content),
                          )
                        : null,
                    // 본인 카드만 촬영 콜백을 연결한다. (타인은 null)
                    // 마감(done) 회차는 촬영할 수 없으므로 본인 카드도 버튼을 숨긴다.
                    // 스타터 차단·신고 검토 중이면 가이드 사진을 볼 수 없으므로
                    // 역시 숨긴다.
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

                  // 타인의 보이는 사진만 신고할 수 있다. (본인·잠김·차단 제외)
                  if (isMe || !canView || shotId == null) return card;

                  return _MenuPhotoCard(
                    cardWidth: cardWidth,
                    // 사본은 Hero 태그 충돌을 피해 태그·콜백 없이 만든다.
                    copy: MemberPhotoCard(name: member.nickname, image: image),
                    onReport: () => _reportPhoto(context, ref, shotId),
                    child: card,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// [shotId] 사진에 [content] 댓글을 등록하고, 성공 시 화면에 추가할
  /// [PhotoComment] 를(작성자·시각 포함), 실패 시 null 을 반환한다.
  /// (실패 안내는 notifier 가 errorMessage → 토스트로 처리)
  Future<PhotoComment?> _submitComment(
    BuildContext context,
    WidgetRef ref,
    int shotId,
    String content,
  ) async {
    final l10n = AppLocalizations.of(context);
    final created = await ref
        .read(cyclePhotoGalleryNotifierProvider(cycleId).notifier)
        .submitComment(shotId: shotId, content: content);
    if (created == null) return null;

    return PhotoComment(
      nickname: created.nickname,
      content: created.content,
      timeLabel: timeAgoLabel(created.createdAt, l10n),
      profileImageUrl: created.profileImageUrl,
    );
  }

  /// 사진 신고 사유 시트를 띄우고, 확정하면 신고를 접수한다.
  /// 성공 시 검토 상태가 반영된 갤러리를 다시 조회하고 완료 토스트를 띄운다.
  /// (실패 시 notifier 가 errorMessage → 토스트로 처리)
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

    Toast.showToast(context, AppLocalizations.of(context).photoReportSubmitted);
  }

  /// [StartedHeader] 가 요구하는 [GroupCycle] 로 변환한다.
  /// (헤더는 회차·주제·스타터·마감만 쓰므로 응답에 없는 값은 기본값으로 채운다)
  GroupCycle _toGroupCycle(CycleGallery gallery) {
    final cycle = gallery.cycle;
    return GroupCycle(
      cycleId: cycle.cycleId,
      cycleNumber: cycle.cycleNumber,
      topic: cycle.topic,
      starterUserId: cycle.starterUserId,
      starterNickname: cycle.starterNickname,
      starterImageUrl: cycle.starterImageUrl,
      starterImageUnderReview: cycle.starterImageUnderReview,
      status: cycle.status,
      // 응답에 시작 시각이 없어 마감 시각으로 채운다. (헤더에서 쓰지 않음)
      startedAt: cycle.deadlineAt,
      deadlineAt: cycle.deadlineAt,
      // 참여 인원 표시용: 스타터를 제외하고 이번 사이클에 사진을 올린 멤버.
      // (헤더가 스타터 +1 로 참여자 수를 계산하므로 모임 페이지와 동일하게 맞춘다)
      uploadedUserIds: gallery.members
          .where((member) => !member.isStarter && member.uploadedAt != null)
          .map((member) => member.userId)
          .toList(),
    );
  }
}

/// 롱프레스하면 카드 위쪽에 '신고하기' 메뉴(오버레이)를 띄우는 사진 카드 래퍼.
///
/// 멤버 아바타 메뉴와 동일하게 배경을 블러 + 살짝 어둡게 하고, 대상 카드
/// 사본을 스크림 위로 띄운 채 메뉴를 보여준다. 바깥을 탭하면 닫힌다.
class _MenuPhotoCard extends StatefulWidget {
  const _MenuPhotoCard({
    required this.child,
    required this.copy,
    required this.cardWidth,
    required this.onReport,
  });

  final Widget child;

  /// 스크림 위로 띄울 카드 사본. (Hero 태그 충돌을 피해 태그·콜백 없이 만든 카드)
  final Widget copy;

  /// 사본에 적용할 카드 폭. (오버레이에는 그리드 제약이 없어 직접 지정)
  final double cardWidth;

  /// 메뉴에서 '신고하기'를 선택했을 때.
  final VoidCallback onReport;

  @override
  State<_MenuPhotoCard> createState() => _MenuPhotoCardState();
}

class _MenuPhotoCardState extends State<_MenuPhotoCard> {
  /// 카드 위치를 메뉴가 따라가게 잇는 링크.
  final LayerLink _link = LayerLink();

  /// 열려 있는 메뉴 라우트. 닫혀 있으면 null.
  Route<void>? _menuRoute;

  void _open() {
    if (_menuRoute != null) return;
    // 메뉴를 라우트로 띄워 뒤로가기(Android)가 화면 pop 대신 메뉴 닫기가
    // 되도록 한다. (스크림·바깥 탭 닫기는 라우트 배리어가 처리)
    final route = RawDialogRoute<void>(
      barrierColor: AppColorPrimitives.black60,
      barrierLabel: AppLocalizations.of(context).commonCancel,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, _, _) => _buildOverlay(dialogContext),
    );
    _menuRoute = route;
    Navigator.of(context).push(route).then((_) => _menuRoute = null);
  }

  /// 메뉴를 닫은 뒤 신고 콜백을 실행한다.
  void _select(BuildContext dialogContext) {
    Navigator.of(dialogContext).pop();
    widget.onReport();
  }

  @override
  void dispose() {
    // 카드가 사라지면(목록 갱신 등) 열려 있던 메뉴 라우트도 함께 닫는다.
    final route = _menuRoute;
    if (route != null && route.isActive) {
      route.navigator?.removeRoute(route);
    }
    super.dispose();
  }

  Widget _buildOverlay(BuildContext dialogContext) {
    return Stack(
      children: [
        // 대상 카드 사본을 스크림 위로 띄워 선명하게 유지한다.
        // (원본 위치에 정확히 겹치므로 카드만 떠오른 것처럼 보인다)
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.topLeft,
          followerAnchor: Alignment.topLeft,
          child: IgnorePointer(
            child: SizedBox(width: widget.cardWidth, child: widget.copy),
          ),
        ),
        // 카드 위쪽(좌측 정렬)에 앵커. (카드 위로 s2 만큼 띄움)
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.topLeft,
          followerAnchor: Alignment.bottomLeft,
          offset: const Offset(0, -AppSpacing.s2),
          child: _menu(dialogContext),
        ),
      ],
    );
  }

  Widget _menu(BuildContext dialogContext) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: const [
          BoxShadow(
            color: AppColorPrimitives.black40,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s3,
        ),
        minimumSize: Size.zero,
        onPressed: () => _select(dialogContext),
        child: AppText.body(
          AppLocalizations.of(context).photoReport,
          color: AppColors.statusDanger,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(onLongPress: _open, child: widget.child),
    );
  }
}
