import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/button/app_text_button.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/model/group/history_cycles.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/util/tap_guard.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/bottom_sheet/invite_share_sheet.dart';
import 'package:ddara/feature/group/detail/provider/notifier_provider.dart';
import 'package:ddara/feature/group/detail/util/group_page_state.dart';
import 'package:ddara/feature/group/detail/widget/body/history_photos.dart';
import 'package:ddara/feature/group/detail/widget/body/members.dart';
import 'package:ddara/feature/group/detail/widget/edit_nickname_sheet.dart';
import 'package:ddara/feature/group/detail/widget/group_section.dart';
import 'package:ddara/feature/group/detail/widget/header/group_header.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:ddara/feature/profile/provider/notifier_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widget/toast/toast.dart';

/// 모임 화면. 전달받은 [groupId] 로 상세를 조회해 그린다.
class GroupPage extends ConsumerWidget {
  const GroupPage({super.key, required this.groupId});

  /// 진입 시 전달받은 모임 식별자. (이 id 로 모임 상세를 조회)
  final int groupId;

  /// 초대 공유 카드에 넣을 모임 대표 이미지. (카카오가 접근 가능한 공개 https URL)
  // TODO: 모임 대표 이미지로 대체. (현재 응답에 없음 — 임시 placeholder)
  static const _shareImageUrl = 'https://placehold.co/800x400.png';

  /// 초대 시트를 자동으로 띄우는 인원 기준. (이 수 미만이면 띄운다)
  static const _inviteThreshold = 3;

  /// 따라찍기를 시작할 수 있는 최소 인원. (이 수 미만이면 시작 버튼 비활성화)
  static const _minMembersToStart = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // groupId 를 그대로 provider 에 넘기면 notifier.build(int groupId) 가 받아 로드한다.
    final state = ref.watch(groupPageNotifierProvider(groupId));

    ref.listen(groupPageNotifierProvider(groupId), (prev, next) {
      final errorMessage = next.errorMessage;

      if (errorMessage.isNotEmpty) {
        Toast.showToast(context, errorMessage, type: ToastType.error);
        // 토스트로 소비했으니 비워, 이후 상태 변경 때 같은 에러가 재노출되지 않게 한다.
        ref.read(groupPageNotifierProvider(groupId).notifier).clearError();
      }

      // 진입해 상세가 처음 로드됐을 때, 인원이 기준 미만이면 초대 시트를 띄운다.
      final detail = next.groupDetail;
      if (prev?.groupDetail == null &&
          detail != null &&
          detail.members.length < _inviteThreshold) {
        // 빌드/네비게이션 도중 모달을 띄우지 않도록 다음 프레임에 연다.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          InviteShareSheet.show(
            context,
            inviteCode: detail.inviteCode,
            imageUrl: _shareImageUrl,
            // 인원 부족으로 자동으로 띄운 경우라 머리말을 안내 문구로 바꾼다.
            memberShortage: true,
          );
        });
      }
    });

    // 스택이 있으면 뒤로가기(AppBar·iOS 스와이프·Android 버튼)는 이전 화면으로
    // 돌아간다. canPop=false 로 고정하면 iOS 스와이프 제스처 자체가 비활성화되므로
    // 자연스러운 pop 을 허용하고, 홈 목록 무효화는 pop 콜백에서 일괄 처리한다.
    return PopScope(
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          // 이 화면에서 생긴 변경(스타터 시작 사진 등)이 복귀한 홈 카드에
          // 반영되도록 재조회시킨다.
          ref.invalidate(homeNotifierProvider);
          return;
        }
        // 딥링크 진입 등으로 스택이 없으면(canPop=false) 시스템 뒤로가기
        // (Android)를 가로채 홈으로 보낸다.
        _goHome(context, ref);
      },
      child: CupertinoPageScaffold(
        navigationBar: AppBar(
          title: state.groupDetail?.name ?? '',
          onBack: () => _back(context, ref),
          trailing: AppBarIconButton(
            // 상세 로딩·나가기·닉네임 변경이 진행되는 동안 메뉴 재진입을 차단한다.
            onPressed: tapGuard(state.isLoading, () => _showMenu(context, ref)),
            child: const Icon(
              CupertinoIcons.ellipsis_vertical,
              size: 24,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        child: SafeArea(bottom: false, child: _body(context, ref, state)),
      ),
    );
  }

  /// AppBar 뒤로가기: 스택이 있으면 이전 화면으로 pop 하고, 없으면(딥링크
  /// 진입 등) 홈으로 보낸다. (홈 무효화는 PopScope 의 pop 콜백에서 처리)
  void _back(BuildContext context, WidgetRef ref) {
    if (context.canPop()) {
      context.pop();
    } else {
      _goHome(context, ref);
    }
  }

  /// 홈으로 돌아간다. 나가기 직전 홈 목록을 무효화해, 복귀 시 최신 상태로
  /// 재조회되도록 한다. (스타터 시작 사진 등 이 화면에서 생긴 변경을 홈 카드에 반영)
  void _goHome(BuildContext context, WidgetRef ref) {
    ref.invalidate(homeNotifierProvider);
    context.go(RoutePath.home);
  }

  /// 하위 화면(스타터·갤러리)으로 이동했다가 돌아오면 모임 상세를 무효화해
  /// 재조회한다. (하위 화면에서 생긴 변경을 복귀 시 반영 — 홈 복귀 갱신과 동일 패턴)
  Future<void> _pushThenRefresh(
    BuildContext context,
    WidgetRef ref,
    String path,
    Object extra,
  ) async {
    await context.push(path, extra: extra);
    ref.invalidate(groupPageNotifierProvider(groupId));
  }

  /// 우측 메뉴 버튼을 눌렀을 때 뜨는 모임 메뉴(액션 시트).
  void _showMenu(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(sheetContext).pop();
              _editNickname(context, ref);
            },
            child: AppText.title(l10n.groupMenuEditNickname),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(sheetContext).pop();
              _exitGroup(context, ref);
            },
            child: AppText.title(
              l10n.groupMenuExit,
              color: AppColors.statusDanger,
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(sheetContext).pop(),
          child: AppText.title(l10n.commonCancel),
        ),
      ),
    );
  }

  /// 닉네임 수정 바텀시트를 띄우고, 입력을 받으면 변경을 요청한다.
  /// (실패 시 notifier 가 errorMessage → 토스트로 처리, 성공 시 상세 재조회로 반영)
  Future<void> _editNickname(BuildContext context, WidgetRef ref) async {
    final detail = ref.read(groupPageNotifierProvider(groupId)).groupDetail;

    final nickName = await EditNicknameSheet.show(
      context,
      groupName: detail?.name ?? '',
      // 멤버가 이미 쓰는 닉네임은 시트에서 중복 에러로 미리 막는다.
      takenNicknames: {...?detail?.members.map((m) => m.nickname)},
    );
    if (nickName == null || !context.mounted) return;

    await ref
        .read(groupPageNotifierProvider(groupId).notifier)
        .changeNickName(nickName);
  }

  /// 모임 나가기를 실행한다. 먼저 확인 다이얼로그를 띄우고, 확인 시에만 진행한다.
  /// 성공하면 홈의 목록을 새로 조회(invalidate)해 나간 모임이 사라지도록 반영한
  /// 뒤 홈으로 이동한다. (실패 시 notifier 가 에러 토스트 처리)
  Future<void> _exitGroup(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await AppDialog.show(
      context,
      title: l10n.groupExitConfirmTitle,
      confirmLabel: l10n.groupExitConfirmAction,
      confirmColor: AppColors.statusDanger,
      confirmLabelColor: AppColors.textPrimary,
    );
    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(groupPageNotifierProvider(groupId).notifier)
        .exitGroup();
    if (!success || !context.mounted) return;

    ref.invalidate(homeNotifierProvider);
    context.go(RoutePath.home);
  }

  Widget _body(BuildContext context, WidgetRef ref, GroupPageState state) {
    final l10n = AppLocalizations.of(context);
    if (state.isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    // 최상단에서 아래로 당기면 상세·히스토리를 다시 조회한다.
    // 조회가 아무리 빨리 끝나도 인디케이터를 최소 1초는 상단에 고정했다가
    // 풀어, 새로고침이 일어났음을 인지할 수 있게 한다.
    Future<void> onRefresh() => Future.wait([
      ref.read(groupPageNotifierProvider(groupId).notifier).refresh(),
      Future<void>.delayed(const Duration(seconds: 1)),
    ]);

    // 당겨서 새로고침에 필요한 상단 overscroll(바운스)을 허용하고, 콘텐츠가
    // 화면보다 짧아도 당길 수 있도록 AlwaysScrollable 을 부모로 둔다.
    const physics = BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );

    final groupDetail = state.groupDetail;
    if (groupDetail == null) {
      // 최초 조회 실패 화면에서도 당겨서 재시도할 수 있게 한다.
      return CustomScrollView(
        physics: physics,
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: AppText.body(
                state.errorMessage.isEmpty
                    ? l10n.groupDetailLoadError
                    : state.errorMessage,
              ),
            ),
          ),
        ],
      );
    }

    final cycles = state.historyCycles?.cycles ?? const [];

    return CustomScrollView(
      physics: physics,
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: onRefresh),
        SliverPadding(
          // 상하 s6 여백만. (좌우 여백은 일단 헤더에만 적용) 하단은 콘텐츠가
          // 홈 인디케이터와 겹치지 않도록 Safe Area 인셋만큼 더 띄운다.
          padding: EdgeInsets.only(
            top: AppSpacing.s6,
            bottom: AppSpacing.s6 + MediaQuery.of(context).padding.bottom,
          ),
          sliver: SliverToBoxAdapter(
            child: _content(context, ref, state, groupDetail, cycles),
          ),
        ),
      ],
    );
  }

  Widget _content(
    BuildContext context,
    WidgetRef ref,
    GroupPageState state,
    GroupDetail groupDetail,
    List<HistoryCycle> cycles,
  ) {
    final l10n = AppLocalizations.of(context);
    // 현재 사용자 id. (본인 프로필에는 신고·차단 메뉴를 띄우지 않기 위함)
    final myUserId = ref.watch(currentProfileProvider).valueOrNull?.id;
    return Column(
      // 상단부터 쌓되 가로는 중앙 정렬.
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s8,
      children: [
        // 좌우 여백은 일단 헤더에만 적용한다.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
          child: GroupHeader(
            // 진행 중인 사이클을 그대로 전달. null 이면 헤더가 빈 상태를 보여준다.
            progress: groupDetail.currentCycle,
            // 멤버가 최소 인원 미만이면 시작 버튼을 비활성화한다.
            canStart: groupDetail.members.length >= _minMembersToStart,
            // 스타터를 차단했으면 헤더에 사진 대신 차단 자리표시를 보여준다.
            starterBlocked: state.blockedUserIds.contains(
              groupDetail.currentCycle?.starterUserId,
            ),
            navigateToStart: () =>
                _pushThenRefresh(context, ref, RoutePath.starter, groupId),
            // 촬영 버튼은 진행 중 사이클이 있을 때만 노출되므로 cycleId 가 존재한다.
            onTakePhoto: () {
              final cycleId = groupDetail.currentCycle?.cycleId;
              if (cycleId == null) return;
              _pushThenRefresh(context, ref, RoutePath.follower, cycleId);
            },
          ),
        ),
        GroupSection(
          title: AppText.headlineLarge(l10n.groupMembersTitle),
          body: Members(
            members: groupDetail.members
                .map(
                  (member) => (
                    userId: member.userId,
                    name: member.nickname,
                    imageUrl: member.profileImageUrl,
                    // 차단한 멤버는 기본 아이콘 + 취소선 닉네임으로 표시된다.
                    isBlocked: state.blockedUserIds.contains(member.userId),
                    // 본인 프로필에는 롱프레스 메뉴를 띄우지 않는다.
                    isMe: member.userId == myUserId,
                  ),
                )
                .toList(),
            onAddMember: () => InviteShareSheet.show(
              context,
              inviteCode: groupDetail.inviteCode,
              imageUrl: _shareImageUrl,
            ),
            onReportMember: (member) => _reportMember(context, member.name),
            onBlockMember: (member) => _blockMember(context, ref, member),
          ),
        ),
        GroupSection(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText.headlineLarge(l10n.groupHistoryTitle),
              AppTextButton(
                label: l10n.groupHistoryMore,
                // 지난 따라찍기 전체 목록으로 이동. (복귀 시 상세 갱신)
                onPressed: () => _pushThenRefresh(
                  context,
                  ref,
                  RoutePath.historyList,
                  groupId,
                ),
              ),
            ],
          ),
          // 히스토리가 있으면 사진 카드들을, 없으면 같은 높이의 빈 상태 안내를 보여준다.
          body: cycles.isEmpty
              ? SizedBox(
                  height: 225 + AppSpacing.s4 * 2,
                  child: Center(child: AppText.body(l10n.groupHistoryEmpty)),
                )
              : HistoryPhotos(
                  cycles: cycles,
                  // 차단한 스타터의 썸네일은 차단 자리표시로 가린다.
                  blockedUserIds: state.blockedUserIds,
                  // 카드 탭 → 해당 사이클의 사진 갤러리로 이동. (복귀 시 상세 갱신)
                  onCycleTap: (cycleId) => _pushThenRefresh(
                    context,
                    ref,
                    RoutePath.follower,
                    cycleId,
                  ),
                ),
        ),
      ],
    );
  }

  /// 닉네임 신고 수신 주소. (프로필 문의하기와 동일한 팀 메일)
  static const String _reportEmail = 'ddara.team3@gmail.com';

  /// 기본 메일 앱으로 닉네임 신고 메일 작성 화면을 띄운다. (제목·본문 미리 채움)
  Future<void> _reportMember(BuildContext context, String nickname) async {
    final l10n = AppLocalizations.of(context);

    // mailto 쿼리는 공백을 '+' 가 아닌 '%20' 으로 인코딩해야 메일 앱이 제대로 읽는다.
    final query =
        <String, String>{
              'subject': l10n.memberReportMailSubject,
              'body': l10n.memberReportMailBody(nickname),
            }.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&');

    final mailUri = Uri(scheme: 'mailto', path: _reportEmail, query: query);

    // 메일 앱이 없거나 실행에 실패하면 사용자에게 안내한다.
    final launched = await launchUrl(mailUri).catchError((_) => false);
    if (!launched && context.mounted) {
      Toast.showToast(
        context,
        l10n.memberReportMailFailed(_reportEmail),
        type: ToastType.error,
      );
    }
  }

  /// 멤버를 차단한다. 먼저 확인 다이얼로그를 띄우고, 확인 시에만 진행한다.
  /// 성공하면 차단이 반영된 상세를 다시 조회하고 완료 토스트를 띄운다.
  /// (실패 시 notifier 가 errorMessage → 토스트로 처리)
  Future<void> _blockMember(
    BuildContext context,
    WidgetRef ref,
    MemberDisplay member,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await AppDialog.show(
      context,
      title: l10n.memberBlockConfirmTitle(member.name),
      message: l10n.memberBlockConfirmMessage,
      confirmLabel: l10n.memberBlockConfirmAction,
      confirmColor: AppColors.statusDanger,
      confirmLabelColor: AppColors.textPrimary,
    );
    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(groupPageNotifierProvider(groupId).notifier)
        .blockMember(member.userId);
    if (!success || !context.mounted) return;

    Toast.showToast(context, l10n.memberBlockedToast(member.name));
  }
}
