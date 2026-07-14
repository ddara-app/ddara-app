import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/cycle_gallery.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/image/photo_viewer.dart';
import 'package:ddara/feature/group/detail/widget/header/started_header.dart';
import 'package:ddara/feature/group/gallery/provider/notifier_provider.dart';
import 'package:ddara/feature/group/widget/member_photo_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 스타터(따라찍기 시작) 화면.
///
/// 스타터의 사진을 멤버들이 따라찍은 결과 사진을 모아 보여준다.
/// (헤더 + 모임명 + 멤버 사진 그리드)
class CyclePhotoGallery extends ConsumerWidget {
  const CyclePhotoGallery({super.key, required this.cycleId});

  final int cycleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cyclePhotoGalleryNotifierProvider(cycleId));
    final gallery = state.gallery;

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
          _ => _buildContent(context, gallery, state.myUserId),
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    CycleGallery gallery,
    int? myUserId,
  ) {
    final cycle = gallery.cycle;

    // 본인 닉네임. (사진 뷰어에서 내가 단 댓글의 작성자 표기에 쓴다)
    final myNickname = gallery.members
        .where((m) => m.userId == myUserId)
        .map((m) => m.nickname)
        .firstOrNull;

    // 마감된(done) 회차는 사진이 있는 카드만 보여준다. (미업로드 빈 카드는 숨김)
    final isDoneCycle = cycle.status.toLowerCase() == 'done';

    // 본인이 스타터인지 여부. (내 멤버가 스타터 플래그를 가졌는지)
    final iAmStarter = gallery.members.any(
      (m) => m.userId == myUserId && m.isStarter,
    );
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
                  ),
          ),
          // 헤더↔제목 간격 s14(56): Column spacing(s4)×2 + 이 SizedBox(s6).
          const SizedBox(height: AppSpacing.s6),
          AppText.headlineLarge(gallery.groupName),
          // 제목↔그리드 간격 s4 는 Column spacing 으로 처리.
          // 멤버 사진 카드 2칸 그리드. (카드 높이는 225 고정)
          LayoutBuilder(
            builder: (context, constraints) {
              // 카드 한 장의 실제 비율. 크게 보기에서 카드와 동일한 프레임으로
              // 잘라 보여주는 데 쓴다. (2열 - 열 간격) / 고정 높이 225
              final cardAspectRatio =
                  ((constraints.maxWidth - AppSpacing.s3) / 2) / 225;
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
                  final imageUrl = member.imageUrl;
                  // 잠긴(블러) 사진은 크게 볼 수 없다.
                  final locked = !isDoneCycle && !canSeeAll;
                  final ImageProvider? image = imageUrl == null
                      ? null
                      : NetworkImage(imageUrl);
                  // 사진이 있고 잠기지 않았을 때만 탭해서 크게 볼 수 있다.
                  final canView = image != null && !locked;
                  final heroTag = canView
                      ? 'gallery-photo-${member.userId}'
                      : null;
                  return MemberPhotoCard(
                    // 본인 카드는 이름 대신 '본인' 으로 표시한다.
                    name: isMe ? '나' : member.nickname,
                    image: image,
                    heroTag: heroTag,
                    onTap: canView
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
                          )
                        : null,
                    // 본인 카드만 촬영 콜백을 연결한다. (타인은 null)
                    // 마감(done) 회차는 촬영할 수 없으므로 본인 카드도 버튼을 숨긴다.
                    onTakePhoto: isMe && !isDoneCycle
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
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// [StartedHeader] 가 요구하는 [GroupCycle] 로 변환한다.
  /// (헤더는 회차·주제·스타터·마감만 쓰므로 응답에 없는 값은 기본값으로 채운다)
  GroupCycle _toGroupCycle(CycleGallery gallery) {
    final cycle = gallery.cycle;
    // 응답 cycle 에 starterUserId 가 없어, 닉네임이 일치하는 멤버의 userId 로 채운다.
    final starterUserId = gallery.members
        .where((m) => m.nickname == cycle.starterNickname)
        .map((m) => m.userId)
        .firstOrNull;

    return GroupCycle(
      cycleId: cycle.cycleId,
      cycleNumber: cycle.cycleNumber,
      topic: cycle.topic,
      starterUserId: starterUserId ?? 0,
      starterNickname: cycle.starterNickname,
      starterImageUrl: cycle.starterImageUrl,
      status: cycle.status,
      startedAt: cycle.deadlineAt,
      deadlineAt: cycle.deadlineAt,
    );
  }
}
