import 'package:ddara/core/design_system/component/indicator/page_indicator.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

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
/// 하단 점은 페이지 인디케이터 자리다.
class HomeDashboard extends StatelessWidget {
  /// 현재 참여 중인 모임 개수([count]/[maxCount]) 대시보드.
  const HomeDashboard.groupCount({
    super.key,
    required this.count,
    required this.pageIndex,
    required this.pageCount,
    this.maxCount = 20,
  }) : _variant = _HomeDashboardVariant.groupCount;

  /// 친구들의 업데이트 개수([count]개) 대시보드.
  const HomeDashboard.updateCount({
    super.key,
    required this.count,
    required this.pageIndex,
    required this.pageCount,
  }) : maxCount = 0,
       _variant = _HomeDashboardVariant.updateCount;

  /// 표시할 개수. (외부 주입)
  final int count;

  /// 참여 가능한 최대 모임 개수. (groupCount 변형에서만 사용)
  final int maxCount;

  /// 이 대시보드가 놓인 탭(페이지)의 인덱스. 대시보드는 페이지와 함께
  /// 스와이프되므로, 점은 자기 탭 위치를 정적으로 켜두면 항상 맞다.
  final int pageIndex;

  /// 홈 탭(페이지) 개수. (인디케이터 점 개수)
  final int pageCount;

  final _HomeDashboardVariant _variant;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (label, value, caption) = switch (_variant) {
      _HomeDashboardVariant.groupCount => (
        l10n.groupCountLabel,
        l10n.groupCountValue(count, maxCount),
        l10n.groupCountCaption,
      ),
      _HomeDashboardVariant.updateCount => (
        l10n.updateCountLabel,
        l10n.updateCountValue(count),
        l10n.updateCountCaption,
      ),
    };

    return Container(
      // 높이는 카드보다 낮게 고정해 지그재그 오프셋을 만든다. (폭은 열에 맞춰 stretch)
      height: 142,
      padding: const EdgeInsets.all(AppSpacing.s4),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.50, 0),
          end: Alignment(0.50, 1.00),
          colors: [AppColors.bgSurface, AppColorPrimitives.sky900],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title(label, color: AppColors.textAccent),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s1,
                  children: [
                    AppText.display(value),
                    AppText.caption(caption),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s1),
          // 하단 페이지 인디케이터. 자기 탭 위치의 점을 켜두고, 가로 중앙에 배치한다.
          Center(
            child: PageIndicator(
              currentIndex: pageIndex,
              count: pageCount,
              size: 6,
              spacing: AppSpacing.s1,
            ),
          ),
        ],
      ),
    );
  }
}