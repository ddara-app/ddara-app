import 'package:ddara/core/analytics/mixpanel_manager.dart';
import 'package:ddara/core/design_system/component/button/app_text_button.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/invite/kakao_share_service.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/widget/bottom_sheet/draggable_sheet.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// 모임 초대 공유 BottomSheet.
///
/// 여러 화면에서 재사용할 수 있도록 [show] 정적 메서드로 띄운다.
///
/// ```dart
/// InviteShareSheet.show(context, inviteCode: 'A82TSJXk2', imageUrl: '<https-url>');
/// ```
class InviteShareSheet extends StatelessWidget {
  const InviteShareSheet({
    super.key,
    required this.inviteCode,
    required this.imageUrl,
    this.memberShortage = false,
  });

  /// 공유/복사에 사용할 초대코드 (백엔드 발급 문자열).
  final String inviteCode;

  /// 공유 카드에 넣을 모임 대표 이미지 (공개 https URL).
  final String imageUrl;

  /// 인원 부족으로 자동으로 띄운 경우. true 면 머리말을 "아직 멤버가 부족해요"
  /// 안내로 바꾼다. (기본: 일반 초대 머리말)
  final bool memberShortage;

  /// 초대 공유 시트를 표시한다. (Cupertino 모달 팝업)
  static Future<void> show(
    BuildContext context, {
    required String inviteCode,
    required String imageUrl,
    bool memberShortage = false,
  }) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => InviteShareSheet(
        inviteCode: inviteCode,
        imageUrl: imageUrl,
        memberShortage: memberShortage,
      ),
    );
  }

  Future<void> _onKakaoShare(BuildContext context) async {
    MixpanelManager.instance.track('invite_kakao_share_clicked');
    final navigator = Navigator.of(context);
    try {
      await KakaoShareService().shareInvite(inviteCode, imageUrl: imageUrl);
      navigator.pop();
    } catch (_) {
      // 공유 실패(미설치 폴백 실패 등) → 시트는 유지하고 안내.
      if (!context.mounted) return;
      _showShareError(context);
    }
  }

  void _showShareError(BuildContext context) {
    Toast.showToast(
      context,
      AppLocalizations.of(context).inviteShareFailed,
      type: ToastType.error,
    );
  }

  void _onCopyCode(BuildContext context) {
    MixpanelManager.instance.track('invite_code_copy_clicked');
    Clipboard.setData(ClipboardData(text: inviteCode));
    // 시트가 닫혀도 토스트는 루트 오버레이에 남으므로 pop 전에 띄운다.
    Toast.showToast(context, AppLocalizations.of(context).inviteCodeCopied);
    Navigator.of(context).pop();
  }

  void _onMore(BuildContext context) {
    Navigator.of(context).pop();
    // TODO: share_plus 로 OS 기본 공유 시트.
  }

  void _onLater(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s5,
              AppSpacing.s3,
              AppSpacing.s5,
              AppSpacing.s7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: AppSpacing.s3,
              children: [
                // 드래그 핸들
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.s4),
                  decoration: const ShapeDecoration(
                    color: AppColors.borderStrong,
                    shape: StadiumBorder(),
                  ),
                ),
                if (memberShortage)
                  TitleDescription(
                    title: l10n.inviteMemberShortageTitle,
                    description: l10n.inviteMemberShortageDescription,
                    centered: true,
                  )
                else
                  AppText.headlineMedium(
                    l10n.inviteShareTitle,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: AppSpacing.s2),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CircleAction(
                        icon: const AppIcon(AppIcons.kakao, size: 24),
                        backgroundColor: AppColorPrimitives.kakaoYellow,
                        label: l10n.inviteShareKakao,
                        onTap: () => _onKakaoShare(context),
                      ),
                      _CircleAction(
                        icon: const AppIcon(
                          AppIcons.copy,
                          size: 24,
                          color: AppColors.textPrimary,
                        ),
                        label: l10n.inviteShareCopyCode,
                        onTap: () => _onCopyCode(context),
                      ),
                      _CircleAction(
                        icon: const AppIcon(
                          AppIcons.more,
                          size: 24,
                          color: AppColors.textPrimary,
                        ),
                        label: l10n.inviteShareMore,
                        onTap: () => _onMore(context),
                      ),
                    ],
                  ),
                ),
                AppTextButton.body(
                  label: l10n.inviteShareLater,
                  onPressed: () => _onLater(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 동그란 배경 + 아이콘 버튼과 그 아래 caption 라벨. (시트 액션용)
class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor = AppColors.bgSurfaceAlt,
  });

  /// 원 안에 들어갈 아이콘 위젯 (Icon 또는 SvgPicture 등).
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s2,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          onPressed: onTap,
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: icon,
          ),
        ),
        AppText.caption(label),
      ],
    );
  }
}
