import 'package:ddara/core/designsystem/component/app_text_field.dart';
import 'package:ddara/core/designsystem/component/button/app_button.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/widget/app_checkbox.dart';
import 'package:ddara/core/widget/draggable_sheet.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 드래그 핸들 크기.
const Size _handleSize = Size(40, 4);

/// 시트가 반환하는 신고 내용.
/// (선택한 사유 + 상세 입력 — 상세는 '기타' 사유일 때만 채워진다)
typedef ReportSheetResult<T extends Object> = ({T reason, String detail});

/// 신고 사유를 선택하는 공통 바텀시트.
///
/// 사유 하나를 선택하고([etcReason] 은 상세 내용 입력란이 함께 열린다)
/// '신고하기'로 확정하면 [ReportSheetResult] 를 [Navigator.pop] 으로 반환한다.
/// 취소(바깥 탭·아래로 드래그)면 null 을 반환한다.
///
/// 사유 목록은 신고 대상(사진·유저 등)마다 다르므로 [T] 로 받는다.
class ReportReasonSheet<T extends Object> extends StatefulWidget {
  const ReportReasonSheet({
    super.key,
    required this.reasons,
    required this.labelOf,
    required this.etcReason,
  });

  /// 나열할 신고 사유들. (위에서부터 순서대로)
  final List<T> reasons;

  /// 사유의 표시 라벨.
  final String Function(T reason) labelOf;

  /// 상세 내용 입력이 필수인 '기타' 사유.
  final T etcReason;

  /// 바텀시트를 띄우고 확정한 신고 내용을 받는다. 취소·바깥 탭이면 null.
  static Future<ReportSheetResult<T>?> show<T extends Object>(
    BuildContext context, {
    required List<T> reasons,
    required String Function(T reason) labelOf,
    required T etcReason,
  }) {
    return showCupertinoModalPopup<ReportSheetResult<T>>(
      context: context,
      builder: (_) => ReportReasonSheet<T>(
        reasons: reasons,
        labelOf: labelOf,
        etcReason: etcReason,
      ),
    );
  }

  @override
  State<ReportReasonSheet<T>> createState() => _ReportReasonSheetState<T>();
}

class _ReportReasonSheetState<T extends Object>
    extends State<ReportReasonSheet<T>> {
  final TextEditingController _detailController = TextEditingController();

  /// 선택한 신고 사유. 선택 전엔 null. (하나만 선택할 수 있다)
  T? _reason;

  /// 신고할 수 있는 상태인지. (사유 선택 필수, '기타'는 상세 내용도 필수)
  bool get _canSubmit {
    final reason = _reason;
    if (reason == null) return false;
    if (reason == widget.etcReason) {
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
    final reason = _reason;
    if (reason == null) return;
    // 상세 입력은 '기타' 사유에만 노출되므로 그 외 사유에서는 비운다.
    final detail = reason == widget.etcReason
        ? _detailController.text.trim()
        : '';
    Navigator.of(context).pop((reason: reason, detail: detail));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // 아래로 드래그해도 닫히도록 감싼다. (취소와 동일하게 null 반환)
    return DraggableSheet(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
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
                      borderRadius: BorderRadius.circular(
                        _handleSize.height / 2,
                      ),
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
                            AppText.headlineLarge(l10n.reportSheetTitle),
                            AppText.body(l10n.reportSheetSubtitle),
                          ],
                        ),
                      ),
                      // 신고 사유 선택 목록. (단일 선택)
                      for (final reason in widget.reasons)
                        _ReasonRow(
                          label: widget.labelOf(reason),
                          selected: _reason == reason,
                          onSelect: () => setState(() => _reason = reason),
                        ),
                      // 상세 내용 입력. ('기타' 사유를 선택했을 때만 노출)
                      if (_reason == widget.etcReason)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.s4,
                            right: AppSpacing.s4,
                            bottom: AppSpacing.s5,
                          ),
                          child: AppTextField(
                            controller: _detailController,
                            placeholder: l10n.reportDetailPlaceholder,
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
                        // 사유 미선택('기타'는 상세 미입력 포함) 시 비활성화한다.
                        child: AppButton(
                          label: l10n.report,
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