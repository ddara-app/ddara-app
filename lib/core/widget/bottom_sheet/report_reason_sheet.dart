import 'package:ddara/core/design_system/component/text_field/app_text_field.dart';
import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/design_system/component/checkbox/app_checkbox.dart';
import 'package:ddara/core/widget/bottom_sheet/draggable_sheet.dart';
import 'package:flutter/cupertino.dart';

/// 드래그 핸들 크기.
const Size _handleSize = Size(40, 4);

/// 신고 사유 한 개.
class ReportReasonOption {
  const ReportReasonOption({required this.label, this.requiresDetail = false});

  /// 화면에 보여줄 사유 라벨.
  final String label;

  /// 선택 시 상세 입력이 필수인지. ('기타'류 사유)
  final bool requiresDetail;
}

/// 신고 사유 시트가 반환하는 값. (선택한 사유의 인덱스 + 상세 입력)
typedef ReportReasonSheetResult = ({int index, String detail});

/// 신고 사유를 고르는 공통 바텀시트.
///
/// 사유 목록([reasons])만 바꿔 사진·댓글 등 어디서든 재사용한다. 사유 하나를
/// 선택하고([ReportReasonOption.requiresDetail] 이면 상세 입력란이 함께 열린다)
/// [submitLabel] 버튼으로 확정하면 [ReportReasonSheetResult] 를 반환한다.
/// 취소(바깥 탭·아래로 드래그)면 null 을 반환한다.
class ReportReasonSheet extends StatefulWidget {
  const ReportReasonSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.submitLabel,
    required this.detailPlaceholder,
    required this.reasons,
  });

  final String title;
  final String subtitle;
  final String submitLabel;
  final String detailPlaceholder;
  final List<ReportReasonOption> reasons;

  /// 바텀시트를 띄우고 확정한 값을 받는다. 취소·바깥 탭이면 null.
  static Future<ReportReasonSheetResult?> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String submitLabel,
    required String detailPlaceholder,
    required List<ReportReasonOption> reasons,
  }) {
    return showCupertinoModalPopup<ReportReasonSheetResult>(
      context: context,
      builder: (_) => ReportReasonSheet(
        title: title,
        subtitle: subtitle,
        submitLabel: submitLabel,
        detailPlaceholder: detailPlaceholder,
        reasons: reasons,
      ),
    );
  }

  @override
  State<ReportReasonSheet> createState() => _ReportReasonSheetState();
}

class _ReportReasonSheetState extends State<ReportReasonSheet> {
  final TextEditingController _detailController = TextEditingController();

  /// 선택한 사유의 인덱스. 선택 전엔 null. (하나만 선택할 수 있다)
  int? _selectedIndex;

  ReportReasonOption? get _selected =>
      _selectedIndex == null ? null : widget.reasons[_selectedIndex!];

  /// 신고할 수 있는 상태인지. (사유 선택 필수, 상세 필수 사유는 상세 입력도 필수)
  bool get _canSubmit {
    final selected = _selected;
    if (selected == null) return false;
    if (selected.requiresDetail) {
      return _detailController.text.trim().isNotEmpty;
    }
    return true;
  }

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  void _submit() {
    final index = _selectedIndex;
    final selected = _selected;
    if (index == null || selected == null) return;
    // 상세 입력은 필수 사유에만 노출되므로 그 외 사유에서는 비운다.
    final detail = selected.requiresDetail
        ? _detailController.text.trim()
        : '';
    Navigator.of(context).pop((index: index, detail: detail));
  }

  @override
  Widget build(BuildContext context) {
    // 아래로 드래그해도 닫히도록 감싼다. (취소와 동일하게 null 반환)
    return DraggableSheet(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        padding: EdgeInsets.only(
          top: AppSpacing.s3,
          // 키보드가 올라오면 그만큼 콘텐츠를 위로 밀어 올린다.
          bottom: AppSpacing.s5 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: _handleSize.width,
                  height: _handleSize.height,
                  decoration: ShapeDecoration(
                    color: AppColors.textTertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_handleSize.height / 2),
                    ),
                  ),
                ),
              ),
              // 키보드가 올라오는 등 세로 공간이 부족하면 본문만 스크롤된다.
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 제목 + 안내.
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppSpacing.s5,
                          left: AppSpacing.s4,
                          right: AppSpacing.s4,
                          bottom: AppSpacing.s3,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.headlineLarge(widget.title),
                            AppText.body(widget.subtitle),
                          ],
                        ),
                      ),
                      // 신고 사유 선택 목록. (단일 선택)
                      for (var i = 0; i < widget.reasons.length; i++)
                        _ReasonRow(
                          label: widget.reasons[i].label,
                          selected: _selectedIndex == i,
                          onSelect: () => setState(() => _selectedIndex = i),
                        ),
                      // 상세 내용 입력. (상세 필수 사유를 선택했을 때만 노출)
                      if (_selected?.requiresDetail ?? false)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.s4,
                            right: AppSpacing.s4,
                            bottom: AppSpacing.s5,
                          ),
                          child: AppTextField(
                            controller: _detailController,
                            placeholder: widget.detailPlaceholder,
                            // 입력에 따라 신고 버튼 활성 상태를 갱신한다.
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppSpacing.s2,
                          left: AppSpacing.s4,
                          right: AppSpacing.s4,
                        ),
                        // 사유 미선택(상세 필수는 상세 미입력 포함) 시 비활성화한다.
                        child: AppButton(
                          label: widget.submitLabel,
                          onPressed: _canSubmit ? _submit : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 신고 사유 한 줄. (체크박스 + 라벨 — 행 전체가 탭 대상)
class _ReasonRow extends StatelessWidget {
  const _ReasonRow({
    required this.label,
    required this.selected,
    required this.onSelect,
  });

  final String label;
  final bool selected;

  /// 행(또는 체크박스)을 탭해 이 사유를 선택했을 때.
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelect,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: Row(
          spacing: AppSpacing.s3,
          children: [
            AppCheckbox(value: selected, onChanged: (_) => onSelect()),
            AppText.label(label, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }
}
