import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/group_action_error.dart';
import 'package:ddara/core/model/group/history_list.dart';
import 'package:ddara/core/widget/list/lazy_reveal_list.dart';
import 'package:ddara/core/widget/scrollable_page_body.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group/history/provider/notifier_provider.dart';
import 'package:ddara/feature/group/history/util/history_list_state.dart';
import 'package:ddara/feature/group/history/widget/history_month_section.dart';
import 'package:ddara/feature/group/history/widget/record_section.dart';
import 'package:ddara/feature/group/history/widget/year_month_picker.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 지난 따라찍기 전체 목록 화면.
///
/// 모임 상세의 '더보기' 로 진입해, 전달받은 [groupId] 의 지난 사이클을
/// 보여준다. (본문 UI는 디자인 확정 후 구현 예정)
class HistoryListPage extends ConsumerStatefulWidget {
  const HistoryListPage({super.key, required this.groupId});

  /// 진입 시 전달받은 모임 식별자. (이 id 로 히스토리 목록을 조회)
  final int groupId;

  @override
  ConsumerState<HistoryListPage> createState() => _HistoryListPageState();
}

class _HistoryListPageState extends ConsumerState<HistoryListPage> {
  /// 한 번에 화면에 드러내는 월 섹션 개수. (클라이언트 사이드 페이징 단위)
  static const _sectionPageSize = 4;

  /// 년·월 선택 카드 표시 여부. (필터 버튼 탭으로 토글)
  bool _pickerVisible = false;

  /// 피커에 표시 중인 연도. (선택과 무관하게 ‹ › 로 이동)
  int _displayYear = DateTime.now().year;

  /// 선택된 필터 년·월. 둘 다 null 이면 전체보기.
  int? _selectedYear;
  int? _selectedMonth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(historyListNotifierProvider(widget.groupId));

    // 필터 재조회 실패를 토스트로 안내한다. (보던 목록은 그대로 둔다)
    // 초기 조회 실패는 본문에 표시되므로 목록이 뜬 뒤의 에러만 다룬다.
    ref.listen(historyListNotifierProvider(widget.groupId), (prev, next) {
      if (next is! HistoryListLoaded) return;

      final error = next.actionError;
      if (error == null) return;
      Toast.showToast(context, error.message(l10n), type: ToastType.error);
      ref
          .read(historyListNotifierProvider(widget.groupId).notifier)
          .clearActionError();
    });

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.groupHistoryTitle,
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        bottom: false,
        // 전량 받아둔 사이클을 월 섹션 단위 청크로만 그린다.
        // (docs/client_side_paging.md)
        child: LazyRevealList(
          items: _groupedSections(state),
          pageSize: _sectionPageSize,
          // 필터가 바뀌면 목록이 새로 조회되므로 첫 페이지부터 다시 드러낸다.
          resetKey: (_selectedYear, _selectedMonth),
          // 페이지 표준 스크롤 본문. 콘텐츠가 짧아도 뷰포트를 채워 스크롤이
          // 가능하고, 마지막 항목이 홈 인디케이터와 겹치지 않는다.
          builder: (context, visibleSections) => ScrollablePageBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s7,
              children: [
                // 조회 전(로딩)엔 통계가 없어 0/0 으로 보여준다.
                RecordSection(
                  myCount: state is HistoryListLoaded
                      ? state.historyList.stats.myCount
                      : 0,
                  totalCount: state is HistoryListLoaded
                      ? state.historyList.stats.totalCount
                      : 0,
                ),
                _filterSection(l10n),
                ..._monthSections(l10n, state, visibleSections),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 필터 버튼 + (펼쳤을 때) 년·월 선택 카드.
  Widget _filterSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s3,
      children: [
        _filterButton(l10n),
        if (_pickerVisible)
          YearMonthPicker(
            year: _displayYear,
            // 표시 중인 연도에 선택된 월이 있을 때만 강조한다.
            selectedMonth: _displayYear == _selectedYear
                ? _selectedMonth
                : null,
            onPrevYear: () => setState(() => _displayYear--),
            onNextYear: () => setState(() => _displayYear++),
            onMonthSelected: _onMonthSelected,
            onReset: _onFilterReset,
          ),
      ],
    );
  }

  /// 목록 범위 선택 버튼. (기본 '전체보기', 선택 시 '2026년 6월' 형식)
  Widget _filterButton(AppLocalizations l10n) {
    final label = _selectedMonth == null
        ? l10n.groupHistoryFilterAll
        : l10n.groupHistoryFilterYearMonth(_selectedYear!, _selectedMonth!);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _pickerVisible = !_pickerVisible),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSpacing.s1,
        children: [
          AppText.headlineMedium(label),
          AppIcon(
            _pickerVisible ? AppIcons.chevronUp : AppIcons.chevronDown,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  /// 년·월 섹션 목록. (조회 전엔 로딩/에러, 결과 없으면 빈 안내)
  List<Widget> _monthSections(
    AppLocalizations l10n,
    HistoryListState state,
    List<_MonthSection> sections,
  ) {
    if (state is! HistoryListLoaded) {
      return [
        SizedBox(
          width: double.infinity,
          child: switch (state) {
            HistoryListLoadError(:final error) => AppText.body(
              error.message(l10n),
              textAlign: TextAlign.center,
            ),
            _ => const CupertinoActivityIndicator(),
          },
        ),
      ];
    }

    // 필터링은 서버(year·month 쿼리)가 처리하므로 받은 목록을 그대로 보여준다.
    if (sections.isEmpty) {
      return [
        SizedBox(
          width: double.infinity,
          child: AppText.body(
            l10n.groupHistoryEmpty,
            textAlign: TextAlign.center,
          ),
        ),
      ];
    }

    // 년·월 필터 중엔 제목을 숨기고, 전체보기에서 올해 섹션은 월만 표시한다.
    final currentYear = DateTime.now().year;
    return [
      for (final section in sections)
        HistoryMonthSection(
          year: section.year,
          month: section.month,
          cycles: section.cycles,
          blockedUserIds: state.blockedUserIds,
          showTitle: _selectedMonth == null,
          showYear: section.year != currentYear,
        ),
    ];
  }

  /// 사이클을 년·월 단위 섹션으로 묶는다. (목록 순서 유지 · 조회 전엔 빈 목록)
  List<_MonthSection> _groupedSections(HistoryListState state) {
    if (state is! HistoryListLoaded) return const [];
    final cycles = state.historyList.cycles;

    final grouped = <(int, int), List<HistoryListCycle>>{};
    for (final cycle in cycles) {
      final d = cycle.date.toLocal();
      grouped.putIfAbsent((d.year, d.month), () => []).add(cycle);
    }
    return [
      for (final entry in grouped.entries)
        (year: entry.key.$1, month: entry.key.$2, cycles: entry.value),
    ];
  }

  /// 초기화 → 전체보기로 되돌리고 피커를 닫는다. (서버 전체 재조회)
  void _onFilterReset() {
    setState(() {
      _selectedYear = null;
      _selectedMonth = null;
      _displayYear = DateTime.now().year;
      _pickerVisible = false;
    });
    ref
        .read(historyListNotifierProvider(widget.groupId).notifier)
        .applyFilter();
  }

  /// 월 선택 → 필터 확정 후 피커를 닫고, 선택한 연·월로 서버 재조회한다.
  void _onMonthSelected(int month) {
    setState(() {
      _selectedYear = _displayYear;
      _selectedMonth = month;
      _pickerVisible = false;
    });
    ref
        .read(historyListNotifierProvider(widget.groupId).notifier)
        .applyFilter(year: _selectedYear, month: _selectedMonth);
  }
}

/// 년·월로 묶은 사이클 섹션. (클라이언트 사이드 페이징의 청크 단위)
typedef _MonthSection = ({int year, int month, List<HistoryListCycle> cycles});
