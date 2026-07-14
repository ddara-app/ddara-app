import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/history_cycles.dart';
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

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.groupHistoryTitle,
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          // 본문 여백: 상 s7, 좌우 s4.
          padding: const EdgeInsets.only(
            top: AppSpacing.s7,
            left: AppSpacing.s4,
            right: AppSpacing.s4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s7,
            children: [
              // TODO: 따라찍기 수·함께한 사진 수 데이터 연동. (임시 0)
              const RecordSection(ddaraCount: 0, photoCount: 0),
              _filterSection(l10n),
              ..._monthSections(l10n, state),
            ],
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
        spacing: AppSpacing.s1,
        children: [
          AppText.headlineMedium(label),
          Icon(
            _pickerVisible
                ? CupertinoIcons.chevron_up
                : CupertinoIcons.chevron_down,
            size: 24,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  /// 년·월 섹션 목록. (조회 전엔 로딩/에러, 결과 없으면 빈 안내)
  List<Widget> _monthSections(AppLocalizations l10n, HistoryListState state) {
    final cycles = state.historyCycles?.cycles;
    if (cycles == null) {
      return [
        SizedBox(
          width: double.infinity,
          child: state.errorMessage.isNotEmpty
              ? AppText.body(state.errorMessage, textAlign: TextAlign.center)
              : const CupertinoActivityIndicator(),
        ),
      ];
    }

    // 필터가 설정돼 있으면 해당 년·월의 사이클만 보여준다.
    final visible = _selectedMonth == null
        ? cycles
        : cycles.where((c) {
            final d = c.date.toLocal();
            return d.year == _selectedYear && d.month == _selectedMonth;
          }).toList();
    if (visible.isEmpty) {
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

    // 년·월 단위로 묶는다. (목록 순서 유지)
    final grouped = <(int, int), List<HistoryCycle>>{};
    for (final cycle in visible) {
      final d = cycle.date.toLocal();
      grouped.putIfAbsent((d.year, d.month), () => []).add(cycle);
    }
    // 년·월 필터 중엔 제목을 숨기고, 전체보기에서 올해 섹션은 월만 표시한다.
    final currentYear = DateTime.now().year;
    return [
      for (final entry in grouped.entries)
        HistoryMonthSection(
          year: entry.key.$1,
          month: entry.key.$2,
          cycles: entry.value,
          showTitle: _selectedMonth == null,
          showYear: entry.key.$1 != currentYear,
        ),
    ];
  }

  /// 초기화 → 전체보기로 되돌리고 피커를 닫는다.
  void _onFilterReset() {
    setState(() {
      _selectedYear = null;
      _selectedMonth = null;
      _displayYear = DateTime.now().year;
      _pickerVisible = false;
    });
  }

  /// 월 선택 → 필터 확정 후 피커를 닫는다.
  /// TODO: 선택된 년·월로 목록 필터링 연동.
  void _onMonthSelected(int month) {
    setState(() {
      _selectedYear = _displayYear;
      _selectedMonth = month;
      _pickerVisible = false;
    });
  }
}
