import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/domain/model/group/cycle_gallery.dart';
import 'package:ddara/domain/model/group/cycle_shot_status.dart';
import 'package:ddara/feature/group/gallery/cycle_photo_gallery_actions.dart';
import 'package:ddara/feature/group/gallery/util/cycle_photo_gallery_state.dart';
import 'package:ddara/feature/group/widget/anchored_context_menu.dart';
import 'package:ddara/feature/group/widget/member_photo_card.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 멤버 사진 그리드의 카드 한 장. 표시 상태(차단·검토중·잠김·본인 여부)를
/// 여기서 판정하고, 타인의 보이는 사진이면 롱프레스 메뉴로 감싼다.
class GalleryMemberTile extends StatelessWidget {
  const GalleryMemberTile({
    super.key,
    required this.state,
    required this.member,
    required this.cycle,
    required this.isDoneCycle,
    required this.starterBlocked,
    required this.actions,
  });

  /// 내 userId · 차단 목록 · 댓글 읽음 여부를 읽는다.
  final CyclePhotoGalleryLoaded state;

  final CycleGalleryMember member;
  final CycleGalleryCycle cycle;

  /// 마감된 회차인지. (본인 카드의 촬영 버튼을 숨기는 데 쓴다)
  final bool isDoneCycle;

  /// 스타터를 차단했는지. (가이드 사진을 볼 수 없어 촬영 버튼을 숨긴다)
  final bool starterBlocked;

  final CyclePhotoGalleryActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
      void show({bool withComments = false}) => actions.showShotViewer(
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
          ? () => actions.pushFollowerCamera(
              guideImageUrl: cycle.starterImageUrl ?? '',
            )
          : null,
      // 모든 사진을 볼 수 없는 상태면 사진이 있는 멤버를 블러+자물쇠로 가린다.
      // (실제 블러/자물쇠는 image 가 있을 때만 그려진다)
      // 단, 마감(done) 회차는 항상 공개하므로 잠금하지 않는다.
      isLocked: locked,
    );

    // 선명하게 보이는 사진이면 본인 것이라도 저장할 수 있다. (잠김·차단 제외)
    // imageUrl 은 canView 면 항상 있지만, 저장에 넘기려면 명시적으로 좁힌다.
    if (!canView || imageUrl == null) return card;

    return AnchoredContextMenu(
      // 카드가 커서 위쪽에 붙이면 손가락과 멀어진다 — 누른 지점에 띄운다.
      placement: ContextMenuPlacement.atPointer,
      // 사본은 Hero 태그 충돌을 피해 태그·콜백 없이 만든다.
      // (오버레이에는 그리드 제약이 없어 원본 카드 폭을 그대로 준다)
      overlayBuilder: (_, targetSize) => SizedBox(
        width: targetSize.width,
        // 이름 표기는 원본 카드와 같아야 한다. (본인 카드는 '나')
        child: MemberPhotoCard(
          name: isMe ? l10n.galleryMyCardLabel : member.nickname,
          image: image,
        ),
      ),
      // 멤버 아바타 메뉴와 같은 순서. (저장하기 → 차단하기 → 신고하기)
      // 경고색은 되돌릴 수 없는 신고에만 쓴다. (차단은 해제할 수 있다)
      // 본인 사진은 차단·신고 대상이 아니므로 저장 항목만 남는다.
      actions: [
        (
          label: l10n.photoSave,
          color: null,
          onSelect: () => actions.savePhoto(imageUrl),
        ),
        if (!isMe && shotId != null) ...[
          (
            label: l10n.memberBlock,
            color: null,
            onSelect: () => actions.blockUser(
              userId: member.userId,
              nickname: member.nickname,
            ),
          ),
          (
            label: l10n.report,
            color: AppColors.statusDanger,
            onSelect: () => actions.reportPhoto(shotId),
          ),
        ],
      ],
      child: card,
    );
  }
}
