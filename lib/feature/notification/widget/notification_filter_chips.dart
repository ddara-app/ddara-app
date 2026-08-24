import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/feature/notification/util/notification_filter.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 알림 목록 위에 놓이는 필터 칩 줄.
///
/// 선택 상태는 갖지 않고 [selected] 를 그대로 그린다. 탭('전체'/'안 읽음')을
/// 오가도 이 줄은 그대로 남아야 해서, 상태를 화면이 들고 있어야 한다.
class NotificationFilterChips extends StatelessWidget {
  const NotificationFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final NotificationFilter selected;

  final ValueChanged<NotificationFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s3,
      children: [
        for (final filter in NotificationFilter.values)
          _Chip(
            label: filter.label(l10n),
            selected: filter == selected,
            onPressed: () => onChanged(filter),
          ),
      ],
    );
  }
}

/// 필터 칩 하나.
///
/// 선택되면 흰 알약에서 글자를 도려내, 그 자리로 페이지 배경이 비친다.
/// ([BlendMode.srcOut] 은 자식이 그려지지 않은 곳에만 색을 칠하는 합성이라,
/// 자식(글자)은 색이 아니라 마스크로만 쓰인다)
class _Chip extends StatefulWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  State<_Chip> createState() => _ChipState();
}

class _ChipState extends State<_Chip> {
  /// 손가락을 올려둔 동안 true. (누름 표시)
  bool _pressed = false;

  /// 칩 안쪽 여백. 선택 여부와 무관하게 같아야 크기가 흔들리지 않는다.
  static const _padding = EdgeInsets.symmetric(
    horizontal: AppSpacing.s5,
    vertical: AppSpacing.s3,
  );

  /// 누르는 동안 배경을 어둡게 섞는 비율.
  static const double _pressedDim = 0.3;

  /// 지금 그릴 배경색. 누르는 동안만 한 단계 어둡다.
  ///
  /// CupertinoButton 처럼 위젯 전체를 흐리게 하면, 글자를 도려낸 선택 칩이
  /// 통째로 사라졌다 돌아오는 것처럼 보인다. 그래서 투명도가 아니라 채우기
  /// 색만 바꾼다.
  Color get _fill {
    // 흰 배경을 뜻하는 의미 토큰이 없어 primitive 를 직접 쓴다.
    final base = widget.selected
        ? AppColorPrimitives.white
        : AppColors.bgSurfaceAlt;
    if (!_pressed) return base;
    return Color.lerp(base, AppColorPrimitives.black, _pressedDim)!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: widget.selected ? _selectedChip() : _unselectedChip(),
    );
  }

  /// 흰 알약 + 도려낸 글자.
  ///
  /// [BlendMode.srcOut] 은 자식이 그려지지 않은 곳에만 색을 칠하는 합성이라,
  /// 자식(글자)은 색이 아니라 마스크로만 쓰인다. 글자 자리로 페이지 배경이 비친다.
  Widget _selectedChip() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(_fill, BlendMode.srcOut),
        child: Padding(padding: _padding, child: AppText.label(widget.label)),
      ),
    );
  }

  Widget _unselectedChip() {
    return Container(
      padding: _padding,
      decoration: ShapeDecoration(
        color: _fill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      child: AppText.label(widget.label, color: AppColors.textSecondary),
    );
  }
}
