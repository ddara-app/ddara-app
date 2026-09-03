import 'package:ddara/core/design_system/component/indicator/page_indicator.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/domain/model/group/group_constraints.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 대시보드 높이. 모임 카드보다 낮게 고정해, 우측 열 카드들이 이 높이 차이만큼
/// 위로 덜 내려오며 지그재그 오프셋이 만들어진다. (카드 높이는 열 폭 ×
/// photoCardAspectRatio 로 가변이라 토큰 스케일과 무관한 디자인 고정값)
const double _dashboardHeight = 142;

/// 좌우로 넘겨 볼 수 있는 대시보드의 페이지 수.
const int _dashboardPageCount = 2;

/// 대시보드 인디케이터 점의 지름. (온보딩보다 작은 홈 전용 크기)
const double _indicatorDotSize = 6;

/// 가이드 페이지 우측 상단 이미지의 가로:세로 비율. (사진 프레임과 같다)
const double _guideImageRatio = AppRatio.photo;

/// 대시보드에 담는 내용의 종류. (탭마다 문구 구성이 다르다)
enum _HomeDashboardVariant {
  /// 따라찍기 모임 탭: 현재 참여 중인 모임 개수 (N/최대 개).
  groupCount,

  /// 최근 업데이트 탭: 친구들의 업데이트 개수 (N개).
  updateCount,
}

/// 홈 화면 우측 상단에 고정되는 요약 위젯.
///
/// 모임 리스트의 지그재그 오프셋을 위해 모임 카드보다 낮은 높이를 갖는다.
///
/// 따라찍기 모임 탭에서는 좌우로 넘겨 볼 수 있고 아래에 인디케이터가 붙는다.
/// 최근 업데이트 탭은 넘길 것이 없어 요약 하나만 보여준다.
class HomeDashboard extends StatefulWidget {
  /// 현재 참여 중인 모임 개수([count]/[maxCount]) 대시보드.
  const HomeDashboard.groupCount({
    super.key,
    required this.count,
    required this.onGuideTap,
    this.maxCount = maxJoinedGroupCount,
  }) : _variant = _HomeDashboardVariant.groupCount;

  /// 친구들의 업데이트 개수([count]개) 대시보드.
  const HomeDashboard.updateCount({super.key, required this.count})
    : maxCount = 0,
      onGuideTap = null,
      _variant = _HomeDashboardVariant.updateCount;

  /// 표시할 개수. (외부 주입)
  final int count;

  /// 참여 가능한 최대 모임 개수. (groupCount 변형에서만 사용)
  final int maxCount;

  /// 가이드 페이지를 눌렀을 때. (groupCount 변형에서만 쓰이므로 nullable)
  final VoidCallback? onGuideTap;

  final _HomeDashboardVariant _variant;

  /// 좌우로 넘겨 보는 구성인지. (따라찍기 모임 탭 전용)
  bool get _paged => _variant == _HomeDashboardVariant.groupCount;

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final PageController _pageController = PageController();

  /// 현재 보고 있는 대시보드 페이지. (인디케이터 강조 위치)
  int _pageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 폭은 열에 맞춰 stretch 되고 높이는 고정. (_dashboardHeight 주석 참고)
      height: _dashboardHeight,
      // 하단만 s4. 인디케이터가 아래 끝에 들어가 다른 면보다 바깥으로
      // 더 떨어져 보이는 것을 줄인다.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s5,
        AppSpacing.s5,
        AppSpacing.s5,
        AppSpacing.s4,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.50, 0),
          end: Alignment(0.50, 1.00),
          colors: [AppColors.bgSurface, AppColors.bgAccentDeep],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      child: widget._paged ? _pagedBody(context) : _summary(context),
    );
  }

  /// 좌우로 넘겨 보는 본문. 페이지만 움직이고 인디케이터는 아래에 고정된다.
  ///
  /// 카드 높이가 [_dashboardHeight] 로 고정이라 인디케이터가 차지하는 만큼
  /// 요약이 쓸 세로 공간이 줄어든다. 간격을 내용과 같은 s2 로 좁혀, 시스템
  /// 글자 크기를 키웠을 때 넘치기까지의 여유를 남긴다.
  Widget _pagedBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s2,
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            // 스와이프로 넘겨도 인디케이터 강조가 따라오도록 인덱스를 동기화.
            onPageChanged: (index) => setState(() => _pageIndex = index),
            children: [_summary(context), _guide(context)],
          ),
        ),
        // 점은 카드 가로 가운데에 둔다. (PageIndicator 는 내용만큼만 차지한다)
        Center(
          child: PageIndicator(
            currentIndex: _pageIndex,
            count: _dashboardPageCount,
            size: _indicatorDotSize,
          ),
        ),
      ],
    );
  }

  /// 따라찍기 사용법을 안내하는 두 번째 페이지.
  ///
  /// 문구는 자기 폭만큼만 쓰고, 우측 상단 이미지가 남는 폭을 가져간다.
  /// 남는 폭이 넓어 3:4 높이가 페이지를 넘길 상황이면 [AspectRatio] 가 높이에
  /// 맞춰 폭을 되줄이므로 카드 밖으로 삐져나가지 않는다.
  Widget _guide(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      // 문구·이미지 사이 빈 곳을 눌러도 반응하도록 영역 전체를 받는다.
      behavior: HitTestBehavior.opaque,
      onTap: widget.onGuideTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // 문구와 이미지 사이 간격.
        spacing: AppSpacing.s4,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s2,
            children: [
              AppText.title(l10n.guideLabel, color: AppColors.textAccent),
              AppText.titleLarge(l10n.guideDescription),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: AspectRatio(
                aspectRatio: _guideImageRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  // 원본(52x72)이 3:4 보다 살짝 세로로 길어, 폭에 맞추고 위아래를
                  // 아주 조금 잘라 낸다. (여백을 남기는 것보다 자연스럽다)
                  child: Image.asset(
                    'assets/images/dashboard_guide.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 라벨 · 값 · 설명을 s2 간격으로 쌓은 요약 페이지.
  ///
  /// 인디케이터가 있는 대시보드는 카드 상단(패딩 s5)부터 내용을 시작하고,
  /// 남는 여백은 인디케이터 쪽으로 몰아 준다. 인디케이터가 없으면 기댈 기준이
  /// 없으므로 남는 여백을 위아래로 나눠 갖도록 가운데에 둔다.
  Widget _summary(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (label, value, caption) = switch (widget._variant) {
      _HomeDashboardVariant.groupCount => (
        l10n.groupCountLabel,
        l10n.groupCountValue(widget.count, widget.maxCount),
        l10n.groupCountCaption,
      ),
      _HomeDashboardVariant.updateCount => (
        l10n.updateCountLabel,
        l10n.updateCountValue(widget.count),
        l10n.updateCountCaption,
      ),
    };

    return Column(
      mainAxisAlignment: widget._paged
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s2,
      children: [
        AppText.title(label, color: AppColors.textAccent),
        AppText.display(value),
        AppText.caption(caption),
      ],
    );
  }
}
