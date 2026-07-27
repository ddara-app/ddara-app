import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/list/lazy_reveal_list.dart';
import 'package:ddara/feature/home/widget/fab_speed_dial.dart';
import 'package:flutter/cupertino.dart';

/// 홈 두 탭이 공유하는 카드 그리드 본문.
///
/// 화면을 세로로 반 나눠 좌/우 두 열에 카드를 번갈아(지그재그) 배치한다.
/// 우측 열 맨 위에는 카드보다 작은 고정 위젯([dashboard])이 들어가, 그 높이
/// 차이만큼 우측 카드들이 위로 덜 내려오면서 자연스러운 지그재그가 만들어진다.
///
/// 카드 높이가 균일하므로 Masonry 패키지 없이 `Row` + `Column` 2개로 충분하다.
class CardGridView<T> extends StatelessWidget {
  const CardGridView({
    super.key,
    required this.items,
    required this.dashboard,
    required this.cardBuilder,
    required this.onRefresh,
  });

  /// 카드로 그릴 항목 목록. (탭마다 타입이 다르다 — 모임 / 피드 항목)
  final List<T> items;

  /// 우측 열 맨 위에 고정되는 요약 위젯. (탭마다 담는 내용이 다르다)
  final Widget dashboard;

  /// 카드 생성자. (탭마다 카드에 담는 내용이 달라 주입받는다)
  final Widget Function(BuildContext context, T item) cardBuilder;

  /// 당겨서 새로고침 콜백. (탭마다 다시 조회할 데이터가 다르다)
  final Future<void> Function() onRefresh;

  /// 한 번에 화면에 드러내는 카드 개수. (클라이언트 사이드 페이징 단위 —
  /// 좌/우 열에 절반씩 나뉘므로 지그재그 5행 분량이다)
  static const _cardPageSize = 10;

  @override
  Widget build(BuildContext context) {
    // 전량 받아둔 목록을 청크 단위로만 그린다. (docs/client_side_paging.md)
    return LazyRevealList(
      items: items,
      pageSize: _cardPageSize,
      builder: (context, visibleItems) => _grid(visibleItems),
    );
  }

  /// 지그재그 그리드 본문. ([visibleItems] 만 카드로 만든다)
  Widget _grid(List<T> visibleItems) {
    return Builder(
      builder: (context) => CustomScrollView(
        // 당겨서 새로고침에 필요한 상단 overscroll(바운스)을 허용하고,
        // 카드가 적어 화면에 다 들어가도 당길 수 있도록 AlwaysScrollable 을
        // 부모로 둔다. (모임 페이지와 동일 패턴)
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // 최상단에서 아래로 당기면 탭 데이터를 다시 조회한다.
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          // 콘텐츠가 화면에 들어가면 스크롤 없음, 카드가 많아지면 스크롤로
          // 전환되도록 뷰포트 높이를 최소 높이로 강제한다.
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              // 위는 탭 헤더가 있어 s4, 좌우 s5(16, Page 규칙). (하단은 FAB 에
              // 가리지 않도록 버튼 높이 + Safe Area 인셋만큼 더 여유)
              padding: EdgeInsets.fromLTRB(
                AppSpacing.s5,
                AppSpacing.s4,
                AppSpacing.s5,
                AppSpacing.s6 +
                    SpeedDialFab.size +
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
                      spacing: AppSpacing.s4,
                      children: [
                        for (var i = 0; i < visibleItems.length; i += 2)
                          cardBuilder(context, visibleItems[i]),
                      ],
                    ),
                  ),
                  // 우측 열: 맨 위 고정 위젯 + 홀수 인덱스 카드 (1, 3, 5 …)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: AppSpacing.s4,
                      children: [
                        // 지그재그 오프셋용 고정 위젯. (내용은 탭별로 주입)
                        dashboard,
                        for (var i = 1; i < visibleItems.length; i += 2)
                          cardBuilder(context, visibleItems[i]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
