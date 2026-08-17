import 'package:ddara/core/analytics/app_analytics.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/loading/app_loading_overlay.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/util/refresh_with_min_duration.dart';
import 'package:ddara/core/util/tap_guard.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/domain/model/group/group_action_error.dart';
import 'package:ddara/feature/group/detail/group_page_actions.dart';
import 'package:ddara/feature/group/detail/provider/viewmodel_provider.dart';
import 'package:ddara/feature/group/detail/util/group_page_state.dart';
import 'package:ddara/feature/group/detail/widget/body/group_header_section.dart';
import 'package:ddara/feature/group/detail/widget/body/history_section.dart';
import 'package:ddara/feature/group/detail/widget/body/members_section.dart';
import 'package:ddara/feature/group/detail/widget/group_page_skeleton.dart';
import 'package:ddara/feature/home/provider/viewmodel_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 모임 화면. 전달받은 [groupId] 로 상세를 조회해 그린다.
///
/// 이동·액션 배선은 [GroupPageActions] 가, 본문 섹션은 `widget/body/` 의
/// 세 위젯이 맡는다. 이 파일에는 상태 분기와 화면 골격만 둔다.
class GroupPage extends ConsumerWidget {
  const GroupPage({
    super.key,
    required this.groupId,
    this.groupName,
    this.hasCurrentCycle,
    this.thumbnailUrl,
  });

  /// 진입 시 전달받은 모임 식별자. (이 id 로 모임 상세를 조회)
  final int groupId;

  /// 호출부가 미리 알고 있는 모임 이름. 조회가 끝나기 전 AppBar 를 채우는 데만
  /// 쓰고, 상세가 도착하면 서버 값으로 대체된다. (모르면 null → 빈 제목)
  final String? groupName;

  /// 호출부가 미리 알고 있는 진행 중 사이클 유무.
  /// 조회 전 골격([GroupPageSkeleton])의 헤더 높이를 맞추는 데만 쓴다.
  final bool? hasCurrentCycle;

  /// 호출부가 미리 알고 있는 스타터 썸네일 URL.
  /// 조회 전 골격의 사진 자리를 캐시 이미지로 채우는 데만 쓴다.
  final String? thumbnailUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // groupId 를 그대로 provider 에 넘기면 ViewModel.build(int groupId) 가 받아 로드한다.
    final state = ref.watch(groupPageViewModelProvider(groupId));
    final actions = GroupPageActions(
      context: context,
      ref: ref,
      groupId: groupId,
    );

    ref.listen(groupPageViewModelProvider(groupId), (prev, next) {
      if (next is! GroupPageLoaded) return;

      // 액션 실패는 종류(enum)로 오므로 l10n 으로 문구를 매핑한다.
      // (초기 조회 실패는 본문에 표시되므로 여기서 다루지 않는다)
      final error = next.actionError;
      if (error != null) {
        Toast.showToast(
          context,
          error.message(AppLocalizations.of(context)),
          type: ToastType.error,
        );
        // 토스트로 소비했으니 비워, 이후 상태 변경 때 같은 에러가 재노출되지 않게 한다.
        ref
            .read(groupPageViewModelProvider(groupId).notifier)
            .clearActionError();
      }

      // 진입해 상세가 처음 로드된 시점을 조회 이벤트로 남긴다.
      if (prev is! GroupPageLoaded) {
        AppAnalytics.track(
          'group_page_viewed',
          properties: {'group_id': groupId},
        );

        actions.onDetailLoaded(next.groupDetail);
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
          ref.invalidate(homeViewModelProvider);
          return;
        }
        // 딥링크 진입 등으로 스택이 없으면(canPop=false) 시스템 뒤로가기
        // (Android)를 가로채 홈으로 보낸다.
        actions.goHome();
      },
      child: CupertinoPageScaffold(
        navigationBar: AppBar(
          // 조회 전에는 호출부가 넘긴 이름으로 먼저 채운다.
          // (모르고 들어왔거나 조회에 실패하면 빈 제목)
          title: state is GroupPageLoaded
              ? state.groupDetail.name
              : groupName ?? '',
          onBack: actions.back,
          trailing: AppBarIconButton(
            // 상세가 뜨기 전이거나 나가기·닉네임 변경이 진행되는 동안 메뉴
            // 진입을 차단한다. (메뉴 항목이 모두 상세를 전제로 한다)
            onPressed: tapGuard(
              state is! GroupPageLoaded || state.isBusy,
              actions.showMenu,
            ),
            child: const AppIcon(
              AppIcons.moreVertical,
              size: 24,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: _body(context, ref, state, actions),
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    GroupPageState state,
    GroupPageActions actions,
  ) {
    // 최상단에서 아래로 당기면 상세·히스토리를 다시 조회한다.
    Future<void> onRefresh() => refreshWithMinDuration(
      () => ref.read(groupPageViewModelProvider(groupId).notifier).refresh(),
    );

    // 당겨서 새로고침에 필요한 상단 overscroll(바운스)을 허용하고, 콘텐츠가
    // 화면보다 짧아도 당길 수 있도록 AlwaysScrollable 을 부모로 둔다.
    const physics = BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );

    // 본문 슬리버 패딩. 조회 전 골격과 본문이 같은 자리에서 시작하도록 공유한다.
    final bodyPadding = EdgeInsets.only(
      top: AppSpacing.s7,
      bottom: AppSpacing.s7 + MediaQuery.of(context).padding.bottom,
    );

    return switch (state) {
      // 최초 조회 전에는 스피너로 화면을 덮는 대신 골격을 먼저 그린다.
      // (응답이 오면 빈 자리만 메워져 화면이 통째로 바뀌지 않는다)
      GroupPageLoading() => CustomScrollView(
        physics: physics,
        slivers: [
          SliverPadding(
            padding: bodyPadding,
            sliver: SliverToBoxAdapter(
              child: GroupPageSkeleton(
                hasCurrentCycle: hasCurrentCycle,
                thumbnailUrl: thumbnailUrl,
              ),
            ),
          ),
        ],
      ),
      // 최초 조회 실패 화면에서도 당겨서 재시도할 수 있게 한다.
      GroupPageLoadError(:final error) => CustomScrollView(
        physics: physics,
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: AppText.body(error.message(AppLocalizations.of(context))),
            ),
          ),
        ],
      ),
      GroupPageLoaded() => Stack(
        children: [
          CustomScrollView(
            physics: physics,
            slivers: [
              CupertinoSliverRefreshControl(onRefresh: onRefresh),
              SliverPadding(
                // 상하 s6 여백만. (좌우 여백은 일단 헤더에만 적용) 하단은 콘텐츠가
                // 홈 인디케이터와 겹치지 않도록 Safe Area 인셋만큼 더 띄운다.
                padding: bodyPadding,
                sliver: SliverToBoxAdapter(child: _content(state, actions)),
              ),
            ],
          ),
          // 차단·닉네임 변경 등 처리 중에는 본문을 그대로 둔 채 덮는다.
          // (본문이 살아 있어 완료 후 스크롤 위치가 그대로 유지된다)
          if (state.isBusy) const AppLoadingOverlay(),
        ],
      ),
    };
  }

  /// 헤더 · 친구들 · 지난 따라찍기 세 섹션.
  Widget _content(GroupPageLoaded state, GroupPageActions actions) {
    final detail = state.groupDetail;
    return Column(
      // 상단부터 쌓되 가로는 중앙 정렬.
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s9,
      children: [
        GroupHeaderSection(
          detail: detail,
          blockedUserIds: state.blockedUserIds,
          actions: actions,
        ),
        MembersSection(
          detail: detail,
          blockedUserIds: state.blockedUserIds,
          actions: actions,
        ),
        HistorySection(
          cycles: state.historyCycles.cycles,
          blockedUserIds: state.blockedUserIds,
          groupId: groupId,
          actions: actions,
        ),
      ],
    );
  }
}
