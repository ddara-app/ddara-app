import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 앱 공통 확인 다이얼로그.
///
/// 가운데 [title] 아래에 취소/확인 두 버튼을 둔다. 확인=true, 취소(또는 바깥
/// 탭)=false 를 반환한다. 보통 [AppDialog.show] 로 띄우고 반환값으로 분기한다.
///
/// ```dart
/// final ok = await AppDialog.show(
///   context,
///   title: '로그아웃 할까요?',
///   confirmLabel: '로그아웃',
/// );
/// if (ok) await _logout();
/// ```
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.confirmLabel,
    this.message,
    this.cancelLabel,
    this.confirmColor,
    this.confirmLabelColor,
  });

  /// 가운데 정렬되는 제목.
  final String title;

  /// 제목 아래 본문(body) 설명. null 이면 제목만 보여준다.
  final String? message;

  /// 확인(주요 동작) 버튼 라벨.
  final String confirmLabel;

  /// 취소 버튼 라벨. null 이면 기본값('취소', l10n [AppLocalizations.commonCancel]).
  final String? cancelLabel;

  /// 확인 버튼 채움색 override. null 이면 기본 강조색.
  /// (예: 삭제·나가기 등 파괴적 동작은 [AppColors.statusDanger] 를 넘긴다)
  final Color? confirmColor;

  /// 확인 버튼 글자색 override. null 이면 기본값(textOnAccent).
  final Color? confirmLabelColor;

  /// 다이얼로그를 띄우고 결과를 받는다. 확인=true / 취소·바깥 탭=false.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String confirmLabel,
    String? message,
    String? cancelLabel,
    Color? confirmColor,
    Color? confirmLabelColor,
  }) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AppDialog(
        title: title,
        confirmLabel: confirmLabel,
        message: message,
        cancelLabel: cancelLabel,
        confirmColor: confirmColor,
        confirmLabelColor: confirmLabelColor,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 328),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.s7,
                    left: AppSpacing.s6,
                    right: AppSpacing.s6,
                    bottom: AppSpacing.s6,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: AppSpacing.s3,
                    children: [
                      AppText.headlineMedium(title, textAlign: TextAlign.center),
                      if (message != null)
                        AppText.body(message!, textAlign: TextAlign.center),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.s3,
                    left: AppSpacing.s5,
                    right: AppSpacing.s5,
                    bottom: AppSpacing.s6,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton.outline(
                          label:
                              cancelLabel ??
                              AppLocalizations.of(context).commonCancel,
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s2),
                      Expanded(
                        child: AppButton(
                          label: confirmLabel,
                          color: confirmColor,
                          foregroundColor: confirmLabelColor,
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
