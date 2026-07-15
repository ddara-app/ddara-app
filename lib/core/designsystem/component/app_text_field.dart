import 'package:ddara/core/designsystem/theme/app_colors.dart';
import 'package:ddara/core/designsystem/theme/app_typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../foundation/app_radius.dart';
import '../foundation/app_spacing.dart';

/// 공통 입력 필드. (박스형 · 선택적 라벨 · 선택적 에러)
///
/// - [label] 이 있으면 입력 박스 위에 라벨을 표시한다. (없으면 박스만)
/// - [errorText] 가 있으면 테두리를 [AppColors.statusDanger] 로 바꾸고
///   박스 아래에 에러 문구를 표시한다.
/// - [highlightWhenFilled] 가 true 면 값이 입력됐을 때 테두리를
///   [AppColors.borderSelected] 로 강조한다. (기본 off · 에러보다 우선순위 낮음)
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.label,
    this.errorText,
    this.highlightWhenFilled = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
  });

  final TextEditingController controller;
  final String placeholder;

  /// 입력 박스 위에 표시할 라벨. null 이면 라벨 없이 박스만 렌더링한다.
  final String? label;

  /// 입력 박스 아래에 표시할 에러 문구. null 이면 에러 상태가 아니다.
  final String? errorText;

  /// 값이 입력됐을 때 테두리를 강조할지 여부.
  final bool highlightWhenFilled;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // 박스 어디를 눌러도 포커스가 잡히도록 직접 관리하는 포커스 노드.
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 강조 모드일 때만 값 변화에 따라 rebuild 가 필요하다.
    if (widget.highlightWhenFilled) {
      widget.controller.addListener(_onChanged);
    }
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    // 컨트롤러는 호출 측이 소유 → 여기서는 리스너만 해제.
    if (widget.highlightWhenFilled) {
      widget.controller.removeListener(_onChanged);
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hintStyle = AppTypography.body.copyWith(
      color: AppColors.textTertiary,
    );

    final hasError = widget.errorText != null;
    final highlighted =
        widget.highlightWhenFilled && widget.controller.text.isNotEmpty;

    // 테두리 색 우선순위: 에러 > 입력값 강조 > 기본.
    final Color borderColor;
    if (hasError) {
      borderColor = AppColors.statusDanger;
    } else if (highlighted) {
      borderColor = AppColors.borderSelected;
    } else {
      borderColor = AppColors.borderDefault;
    }

    final field = GestureDetector(
      // 패딩 등 박스 빈 영역을 눌러도 입력에 포커스가 잡히도록.
      behavior: HitTestBehavior.opaque,
      onTap: _focusNode.requestFocus,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: AppColors.bgSurface,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: borderColor),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
        child: CupertinoTextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          padding: EdgeInsets.zero,
          decoration: null,
          placeholder: widget.placeholder,
          placeholderStyle: hintStyle,
          style: hintStyle.copyWith(color: AppColors.textPrimary),
          cursorColor: AppColors.accentDefault,
        ),
      ),
    );

    final children = <Widget>[
      if (widget.label != null)
        Text(
          widget.label!,
          style: AppTypography.label.copyWith(color: AppColors.textSecondary),
        ),
      field,
      if (hasError)
        Text(
          widget.errorText!,
          style: AppTypography.caption.copyWith(color: AppColors.statusDanger),
        ),
    ];

    // 에러 유무에 따라 루트 위젯 타입이 바뀌면(Column↔단일 박스) 그 위치의
    // CupertinoTextField 엘리먼트가 재생성돼 포커스가 풀리고 키보드가 내려간다.
    // 라벨·에러가 없어도 항상 같은 Column 구조를 유지해 포커스를 보존한다.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s2,
      children: children,
    );
  }
}
