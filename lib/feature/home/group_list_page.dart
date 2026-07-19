import 'dart:ui' show lerpDouble;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/comment/comment.dart';
import 'package:ddara/core/model/feed/feed.dart';
import 'package:ddara/core/model/group/group_list.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/util/time_ago.dart';
import 'package:ddara/core/widget/image/photo_viewer.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group/gallery/widget/comment_report_sheet.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:ddara/feature/home/util/feed_state.dart';
import 'package:ddara/feature/home/widget/fab_speed_dial.dart';
import 'package:ddara/feature/home/widget/feed_card.dart';
import 'package:ddara/feature/home/widget/home_dashboard.dart';
import 'package:ddara/feature/home/widget/meeting_card.dart';
import 'package:ddara/feature/home/widget/photo_card_shell.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 우측 하단 FAB 의 지름.
const double _fabSize = 56;

/// 탭 터치 시 페이지 이동 애니메이션 시간.
const Duration _tabSwitchDuration = Duration(milliseconds: 300);

/// 탭 인디케이터 두께.
const double _indicatorHeight = 3;

/// 홈 탭(페이지) 개수.
const int _tabCount = 2;

/// 참여한 모임이 하나 이상일 때 보여주는 홈 본문.
///
/// 상단에 좌측 정렬 탭 2개(따라찍기 모임 / 최근 업데이트)를 두고,
/// 아래 [PageView] 를 좌우 스와이프해 두 화면을 오간다.
/// FAB 는 탭과 무관하게 항상 우하단에 떠 있다.
class GroupListPage extends StatefulWidget {
  const GroupListPage({
    super.key,
    required this.groups,
    this.blockedUserIds = const {},
  });

  /// 표시할 모임 목록. (상위 HomePage 에서 조회 결과를 주입)
  final List<Group> groups;

  /// 내가 차단한 사용자 userId 집합.
  /// (차단한 멤버가 올린 썸네일은 차단 자리표시로 가린다)
  final Set<int> blockedUserIds;

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  final PageController _pageController = PageController();

  /// 현재 선택된 탭 인덱스. (0 = 따라찍기 모임, 1 = 최근 업데이트)
  int _tabIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// PageView 의 현재 페이지 값(스와이프 진행도 포함).
  /// 첫 레이아웃 전(치수 미확정)에는 선택 인덱스로 대체한다.
  double get _currentPage {
    final hasPage =
        _pageController.hasClients && _pageController.position.haveDimensions;
    return hasPage ? _pageController.page! : _tabIndex.toDouble();
  }

  void _onTabTap(int index) {
    if (index == _tabIndex) return;
    _pageController.animateToPage(
      index,
      duration: _tabSwitchDuration,
      // 빠르게 출발해 부드럽게 감속 착지.
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Stack(
      // 콘텐츠가 짧아도(빈 목록 등) 화면 전체 높이를 채워 FAB 가 항상 바닥에 붙도록.
      fit: StackFit.expand,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s4,
                AppSpacing.s4,
                AppSpacing.s4,
                AppSpacing.s3,
              ),
              child: _buildTabHeader(l10n),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                // 스와이프로 넘겨도 탭 라벨 강조가 따라오도록 인덱스를 동기화.
                onPageChanged: (index) => setState(() => _tabIndex = index),
                children: [
                  _GroupListView(
                    groups: widget.groups,
                    blockedUserIds: widget.blockedUserIds,
                  ),
                  _RecentUpdatesView(blockedUserIds: widget.blockedUserIds),
                ],
              ),
            ),
          ],
        ),
        // 백드롭 + FAB + 펼침 모션을 모두 내장한 완결형 위젯.
        // Stack 의 맨 위(마지막 자식)에 얹어 콘텐츠 위를 덮도록 한다.
        // FAB 는 따라찍기 모임 탭 전용이라, 최근 업데이트 탭으로 갈수록
        // 스와이프 진행도에 맞춰 페이드 아웃되고 완전히 넘어가면 사라진다.
        AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            final visibility = (1 - _currentPage).clamp(0.0, 1.0);
            // 완전히 사라졌으면 터치 영역까지 제거한다.
            if (visibility == 0) return const SizedBox.shrink();
            return IgnorePointer(
              // 반쯤 사라진 상태에서 잘못 눌리지 않도록 일찍 막는다.
              ignoring: visibility < 0.5,
              child: Opacity(opacity: visibility, child: child),
            );
          },
          child: SpeedDialFab(
            actions: [
              SpeedDialAction(
                label: l10n.groupCreate,
                filled: true,
                onTap: () => context.push(RoutePath.groupCreate),
              ),
              SpeedDialAction(
                label: l10n.groupJoin,
                onTap: () => context.push(RoutePath.inviteCodeInput),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 좌측 정렬 탭 헤더 (라벨 2개 + 밑줄 인디케이터).
  ///
  /// 고정 프레임 애니메이션 대신 [PageView] 의 스크롤 진행도(0.0~1.0)를 매 프레임
  /// 읽어 라벨 색과 인디케이터 위치·폭을 보간한다. 그래서 손가락 드래그를
  /// 그대로 따라오고, 탭 터치 시에도 페이지 이동과 완전히 동기화된다.
  Widget _buildTabHeader(AppLocalizations l10n) {
    final labels = [l10n.homeTabGroups, l10n.homeTabRecentUpdates];
    return AnimatedBuilder(
      // PageController 가 스크롤마다 notify 하므로 진행도를 프레임 단위로 반영.
      animation: _pageController,
      builder: (context, _) {
        final page = _currentPage;
        final t = page.clamp(0.0, 1.0);

        // 라벨별 실제 렌더링 폭. (인디케이터 위치·폭 보간의 기준)
        final textScaler = MediaQuery.textScalerOf(context);
        final widths = [
          for (final label in labels) _labelWidth(label, textScaler),
        ];
        // 각 라벨의 시작 x 좌표. (Row 간격 s4 반영)
        final lefts = [0.0, widths[0] + AppSpacing.s4];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: AppSpacing.s4,
              children: [
                for (var i = 0; i < labels.length; i++)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onTabTap(i),
                    child: Text(
                      labels[i],
                      style: AppTypography.label.copyWith(
                        // 진행도에 비례해 회색↔흰색을 섞어 드래그를 따라온다.
                        color: Color.lerp(
                          AppColors.textTertiary,
                          AppColors.textPrimary,
                          (1 - (page - i).abs()).clamp(0.0, 1.0),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s3),
            // 선택 라벨 아래로 미끄러지는 인디케이터. 위치·폭을 진행도로 보간한다.
            SizedBox(
              height: _indicatorHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    left: lerpDouble(lefts[0], lefts[1], t)!,
                    width: lerpDouble(widths[0], widths[1], t)!,
                    top: 0,
                    bottom: 0,
                    child: const ColoredBox(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// [AppTypography.label] 스타일 기준 라벨의 렌더링 폭.
  double _labelWidth(String label, TextScaler textScaler) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: AppTypography.label),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }
}

/// 따라찍기 모임 탭: 진행 중인 모임 카드 목록.
class _GroupListView extends StatelessWidget {
  const _GroupListView({required this.groups, required this.blockedUserIds});

  final List<Group> groups;

  /// 내가 차단한 사용자 userId 집합.
  /// (차단한 멤버가 올린 썸네일은 차단 자리표시로 가린다)
  final Set<int> blockedUserIds;

  @override
  Widget build(BuildContext context) {
    return _CardGridView(
      items: groups,
      dashboard: HomeDashboard.groupCount(
        count: groups.length,
        pageIndex: 0,
        pageCount: _tabCount,
      ),
      cardBuilder: (context, group) => MeetingCard(
        group: group,
        // 차단한 멤버가 올린 썸네일은 차단 자리표시로 가린다.
        thumbnailBlocked: blockedUserIds.contains(group.thumbnailUserId),
        onTap: () => _openGroup(context, group.groupId),
      ),
    );
  }
}

/// 최근 업데이트 탭: 따라찍기 모임 탭과 같은 그리드 구조를 공유한다.
///
/// 모임 카드 자리에 피드 카드(회차 주제 · 업로더 닉네임)를 채우고,
/// 잠긴 사진은 블러 + 자물쇠로 가린다.
class _RecentUpdatesView extends ConsumerWidget {
  const _RecentUpdatesView({required this.blockedUserIds});

  /// 내가 차단한 사용자 userId 집합.
  /// (차단한 멤버가 올린 사진은 차단 자리표시로 가린다)
  final Set<int> blockedUserIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedNotifierProvider);

    // 댓글 등 액션 실패를 토스트로 안내한다.
    // (초기 조회 실패는 본문에 표시되므로 피드가 로드된 뒤의 에러만 다룬다)
    ref.listen(feedNotifierProvider, (prev, next) {
      if (next.feed != null && next.errorMessage.isNotEmpty) {
        Toast.showToast(context, next.errorMessage, type: ToastType.error);
        ref.read(feedNotifierProvider.notifier).clearError();
      }
    });

    final feed = state.feed;
    // 조회 완료 전: 로딩 인디케이터 또는 에러 메시지. (홈 본문과 같은 분기)
    if (feed == null) {
      return state.errorMessage.isNotEmpty
          ? Center(child: AppText.body(state.errorMessage))
          : const Center(child: CupertinoActivityIndicator());
    }

    // 차단한 멤버가 올린 사진은 목록에서 아예 뺀다. (자리표시로도 남기지 않는다)
    final items = feed.items
        .where((item) => !blockedUserIds.contains(item.userId))
        .toList();

    return _CardGridView(
      items: items,
      dashboard: HomeDashboard.updateCount(
        count: feed.updateCount,
        pageIndex: 1,
        pageCount: _tabCount,
      ),
      cardBuilder: (context, item) => FeedCard(
        item: item,
        // 차단한 멤버의 댓글은 미리보기에서 뺀다.
        blockedUserIds: blockedUserIds,
        onCommentTap: () => _openPhotoViewer(context, ref, item, state),
        // 카드를 누르면 그 사진이 속한 회차의 갤러리로 들어간다.
        onTap: () => context.push(RoutePath.follower, extra: item.cycleId),
      ),
    );
  }

  /// 피드 사진을 크게 띄우고, 댓글 시트가 열린 상태로 시작한다.
  ///
  /// 카드에서 보이던 프레임(186:245) 그대로 잘라 보여주고, 잠긴 사진은 뷰어에서도
  /// 블러 + 자물쇠를 유지한다. (서버가 잠긴 사진의 댓글 작성을 막으므로 뷰어가
  /// 입력창을 비활성화한다)
  void _openPhotoViewer(
    BuildContext context,
    WidgetRef ref,
    FeedItem item,
    FeedState state,
  ) {
    final imageUrl = item.imageUrl;
    if (imageUrl == null) return;

    final notifier = ref.read(feedNotifierProvider.notifier);
    showPhotoViewer(
      context,
      image: CachedNetworkImageProvider(imageUrl),
      aspectRatio: photoCardAspectRatio,
      // 댓글 시트 헤더: 업로더 닉네임 + 따라찍기 주제.
      title: item.nickname,
      body: item.topic,
      myNickname: state.myNickname,
      locked: item.locked,
      // 댓글을 눌러 들어왔으므로 시트를 연 채로 시작한다.
      openCommentSheet: true,
      onLoadComments: () async {
        final comments = await notifier.loadComments(
          shotId: item.shotId,
          blockedUserIds: blockedUserIds,
        );
        if (comments == null || !context.mounted) return null;
        final l10n = AppLocalizations.of(context);
        return comments
            .map((comment) => _toPhotoComment(comment, l10n, state.myUserId))
            .toList();
      },
      onSubmitComment: (content) async {
        final created = await notifier.submitComment(
          shotId: item.shotId,
          content: content,
        );
        if (created == null || !context.mounted) return null;
        return _toPhotoComment(
          created,
          AppLocalizations.of(context),
          state.myUserId,
        );
      },
      // 삭제·수정은 댓글 id 로 처리한다. (대상 사진 shotId 와 무관)
      onDeleteComment: (comment) async {
        final id = comment.commentId;
        if (id == null) return false;
        return notifier.deleteComment(commentId: id);
      },
      onEditComment: (comment, newContent) async {
        final id = comment.commentId;
        if (id == null) return null;
        final content = await notifier.editComment(
          commentId: id,
          content: newContent,
        );
        if (content == null) return null;
        // 수정에 성공했으므로 '수정됨' 표시를 켠다.
        return comment.copyWith(content: content, isEdited: true);
      },
      onReportComment: (comment) => _reportComment(context, ref, comment),
    );
  }

  /// 댓글 신고 사유 시트를 띄우고, 확정하면 접수한다.
  /// 성공 시 완료 토스트를 띄운다. (신고해도 댓글은 그대로 노출 — 관리자 검토 후 처리)
  Future<void> _reportComment(
    BuildContext context,
    WidgetRef ref,
    PhotoComment comment,
  ) async {
    final commentId = comment.commentId;
    if (commentId == null) return;

    final result = await CommentReportSheet.show(context);
    if (result == null || !context.mounted) return;

    final success = await ref
        .read(feedNotifierProvider.notifier)
        .reportComment(
          commentId: commentId,
          reason: result.reason,
          reasonText: result.detail.isEmpty ? null : result.detail,
        );
    if (!success || !context.mounted) return;

    Toast.showToast(context, AppLocalizations.of(context).photoReportSubmitted);
  }
}

/// 도메인 [Comment] 를 뷰어 표시용 [PhotoComment] 로 변환한다.
/// 검토 중인 댓글은 내용 대신 자리표시 문구를 넣고, 작성자가 [myUserId] 와
/// 같으면 내 댓글로 표시한다. (더보기 메뉴 구성이 달라진다)
PhotoComment _toPhotoComment(
  Comment comment,
  AppLocalizations l10n,
  int? myUserId,
) {
  return PhotoComment(
    commentId: comment.commentId,
    nickname: comment.nickname,
    content: comment.underReview
        ? l10n.photoViewerCommentUnderReview
        : (comment.content ?? ''),
    timeLabel: timeAgoLabel(comment.createdAt, l10n),
    profileImageUrl: comment.profileImageUrl,
    isUnderReview: comment.underReview,
    isMine: myUserId != null && comment.userId == myUserId,
    // 수정 시각이 있으면 수정된 댓글로 본다.
    isEdited: comment.updatedAt != null,
  );
}

void _openGroup(BuildContext context, int groupId) {
  context.push(RoutePath.group, extra: groupId);
}

/// 두 탭이 공유하는 카드 그리드 본문.
///
/// 화면을 세로로 반 나눠 좌/우 두 열에 카드를 번갈아(지그재그) 배치한다.
/// 우측 열 맨 위에는 카드보다 작은 고정 위젯([HomeDashboard])이 들어가, 그 높이
/// 차이만큼 우측 카드들이 위로 덜 내려오면서 자연스러운 지그재그가 만들어진다.
///
/// 카드 높이가 균일하므로 Masonry 패키지 없이 `Row` + `Column` 2개로 충분하다.
class _CardGridView<T> extends StatelessWidget {
  const _CardGridView({
    required this.items,
    required this.dashboard,
    required this.cardBuilder,
  });

  /// 카드로 그릴 항목 목록. (탭마다 타입이 다르다 — 모임 / 피드 항목)
  final List<T> items;

  /// 우측 열 맨 위에 고정되는 요약 위젯. (탭마다 담는 내용이 다르다)
  final Widget dashboard;

  /// 카드 생성자. (탭마다 카드에 담는 내용이 달라 주입받는다)
  final Widget Function(BuildContext context, T item) cardBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // 콘텐츠가 화면에 들어가면 스크롤 없음, 카드가 많아지면 스크롤로
      // 전환되도록 뷰포트 높이를 최소 높이로 강제한다. (프로필과 동일 패턴)
      builder: (context, constraints) => SingleChildScrollView(
        // 카드가 적어 화면에 다 들어가도 당김(바운스)이 되도록 항상
        // 스크롤 가능하게 둔다.
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            // 패딩이 스크롤 범위에 더해져 항상 스크롤되지 않도록
            // (minHeight 초과) ConstrainedBox 안쪽에 둔다.
            // 위는 탭 헤더가 있어 s4, 좌우 s4. (하단은 FAB 에 가리지 않도록
            // 버튼 높이 + Safe Area 인셋만큼 더 여유)
            padding: EdgeInsets.fromLTRB(
              AppSpacing.s4,
              AppSpacing.s4,
              AppSpacing.s4,
              AppSpacing.s6 +
                  _fabSize +
                  AppSpacing.s4 +
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Row(
              // 핵심: 두 열을 위 기준으로 정렬해야 고정 위젯이 만든 오프셋이 유지된다.
              crossAxisAlignment: CrossAxisAlignment.start,
              // 두 열 사이 간격.
              spacing: AppSpacing.s3,
              children: [
                // 좌측 열: 짝수 인덱스 카드 (0, 2, 4 …)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.s3,
                    children: [
                      for (var i = 0; i < items.length; i += 2)
                        cardBuilder(context, items[i]),
                    ],
                  ),
                ),
                // 우측 열: 맨 위 고정 위젯 + 홀수 인덱스 카드 (1, 3, 5 …)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.s3,
                    children: [
                      // 지그재그 오프셋용 고정 위젯. (내용은 탭별로 주입)
                      dashboard,
                      for (var i = 1; i < items.length; i += 2)
                        cardBuilder(context, items[i]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
