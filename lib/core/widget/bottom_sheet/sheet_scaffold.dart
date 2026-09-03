import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/bottom_sheet/draggable_sheet.dart';
import 'package:flutter/cupertino.dart';

/// 바텀시트 공통 뼈대.
///
/// bg-surface 배경의 상단만 둥근 컨테이너에 드래그 핸들(40×4)을 얹고,
/// [DraggableSheet] 로 감싸 아래로 드래그해 닫기를 지원한다. 시트마다
/// 외형·조작감이 갈라지지 않도록 바텀시트 본문은 이 위젯 위에 올린다.
///
/// [contentPadding] 은 핸들 아래 본문에만 적용된다.
/// (top 값이 핸들과 본문 사이 간격이 된다)
class SheetScaffold extends StatelessWidget {
  const SheetScaffold({
    super.key,
    required this.child,
    this.contentPadding = const EdgeInsets.fromLTRB(
      AppSpacing.s5,
      AppSpacing.s4,
      AppSpacing.s5,
      AppSpacing.s6,
    ),
  });

  /// 핸들 아래에 그릴 시트 본문.
  final Widget child;

  /// 본문 패딩. (핸들·SafeArea 는 포함하지 않는다)
  final EdgeInsetsGeometry contentPadding;

  /// 드래그 핸들 크기. 시트를 직접 조립하는 화면도 이 값을 써서 핸들 모양이
  /// 시트끼리 어긋나지 않게 한다.
  static const Size handleSize = Size(40, 4);

  @override
  Widget build(BuildContext context) {
    // 아래로 드래그해도 닫히도록 감싼다. (드래그 핸들 UI 와 동작을 일치)
    return DraggableSheet(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 드래그 핸들
              Center(
                child: Container(
                  width: handleSize.width,
                  height: handleSize.height,
                  margin: const EdgeInsets.only(top: AppSpacing.s4),
                  decoration: const ShapeDecoration(
                    color: AppColors.borderStrong,
                    shape: StadiumBorder(),
                  ),
                ),
              ),
              // 키보드 등장 등으로 세로 공간이 부족하면 본문만 줄어들게 한다.
              Flexible(
                child: Padding(padding: contentPadding, child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
