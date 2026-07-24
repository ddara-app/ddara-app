import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 알약 형태의 댓글 입력 필드. (댓글 시트 하단)
///
/// 입력값이 있을 때만 우측에 전송 버튼이 나타나며, 버튼이 없을 때도 같은 높이를
/// 예약해 입력창 높이가 변하지 않는다.
///
/// 잠긴(블러+자물쇠) 사진은 서버가 댓글 작성을 막으므로 입력을 비활성화하고,
/// 안내 문구 + tail 자물쇠 아이콘을 보여준다.
class CommentInputField extends StatelessWidget {
  const CommentInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
    this.locked = false,
  });

  /// 전송 버튼(알약) 높이. 아이콘 24 + 상하 패딩(s1)×2.
  /// 입력창 높이를 이 값 기준으로 잡아, 아이콘이 생겨도 높이가 변하지 않게 한다.
  static const double _sendButtonHeight = 24 + AppSpacing.s1 * 2;

  /// 입력값 컨트롤러. (전송 버튼 표시 여부도 이 값으로 판단한다)
  final TextEditingController controller;

  /// 입력 박스 어디를 눌러도 포커스가 잡히도록 시트가 직접 관리하는 포커스 노드.
  final FocusNode focusNode;

  /// 전송 콜백. (키보드 전송 키 · tail 버튼 공용)
  final void Function(String text) onSubmit;

  /// 잠긴 사진 여부. true 면 입력을 비활성화한다.
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final placeholderStyle = AppTypography.body.copyWith(
      color: AppColors.textDisabled,
    );
    return GestureDetector(
      // 패딩 등 박스 빈 영역을 눌러도 입력에 포커스가 잡히도록.
      // (잠긴 사진은 포커스를 주지 않는다)
      behavior: HitTestBehavior.opaque,
      onTap: locked ? null : focusNode.requestFocus,
      child: Container(
        width: double.infinity,
        // 우측은 전송 버튼(알약)이 자리하도록 좁게 둔다. (피그마 기준)
        padding: const EdgeInsets.only(
          top: AppSpacing.s2,
          left: AppSpacing.s5,
          right: AppSpacing.s2,
          bottom: AppSpacing.s2,
        ),
        decoration: ShapeDecoration(
          // 잠금(비활성)일 때만 pill 내부를 surface 로 채운다. 입력 가능할 때는
          // 투명(뒤의 base 배경이 비침).
          color: locked ? AppColors.bgSurface : null,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.5, color: AppColors.borderDefault),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: CupertinoTextField(
                controller: controller,
                focusNode: focusNode,
                padding: EdgeInsets.zero,
                // decoration 을 null 로 두면 CupertinoTextField 가 disabled 일 때
                // 프레임워크 기본 배경(_kDisabledBackground, 다크에서 #050505)을
                // 칠한다. 투명 decoration 을 넘겨 그 fallback 을 막는다.
                decoration: const BoxDecoration(),
                // 잠긴 사진은 입력을 막고 안내 문구를 플레이스홀더로 보여준다.
                enabled: !locked,
                placeholder: locked
                    ? l10n.photoViewerCommentLockedHint
                    : l10n.photoViewerCommentHint,
                placeholderStyle: placeholderStyle,
                // 잠긴 사진은 입력이 비활성이므로 글자도 흐린(disabled) 색으로.
                style: placeholderStyle.copyWith(
                  color: locked ? AppColors.textDisabled : AppColors.textPrimary,
                ),
                cursorColor: AppColors.accentDefault,
                // 서버 400(200자 초과)을 막기 위해 입력 단계에서 제한한다.
                maxLength: 200,
                textInputAction: TextInputAction.send,
                onSubmitted: onSubmit,
              ),
            ),
            if (locked) const _LockTail() else _SendButton(
              controller: controller,
              onSubmit: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

/// 잠긴 사진의 tail 자리에 고정으로 놓이는 자물쇠 아이콘.
/// 전송 버튼과 같은 높이를 예약해 입력창 높이를 동일하게 맞춘다.
class _LockTail extends StatelessWidget {
  const _LockTail();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: AppSpacing.s2, right: AppSpacing.s2),
      child: SizedBox(
        height: CommentInputField._sendButtonHeight,
        child: Center(
          child: AppIcon(AppIcons.lock, size: 20, color: AppColors.textDisabled),
        ),
      ),
    );
  }
}

/// 입력값이 있을 때만 나타나는 tail(전송) 버튼.
/// (강조색 알약 버튼 + 화살표 아이콘 — 피그마 기준)
class _SendButton extends StatelessWidget {
  const _SendButton({required this.controller, required this.onSubmit});

  final TextEditingController controller;
  final void Function(String text) onSubmit;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        if (value.text.trim().isEmpty) {
          // 버튼이 없어도 높이를 유지해 입력창 높이가 변하지 않게 한다.
          return const SizedBox(height: CommentInputField._sendButtonHeight);
        }
        return GestureDetector(
          onTap: () => onSubmit(controller.text),
          child: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.s3),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s3,
                vertical: AppSpacing.s1,
              ),
              decoration: ShapeDecoration(
                color: AppColors.accentDefault,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              child: const AppIcon(
                AppIcons.arrowUp,
                size: 24,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}
