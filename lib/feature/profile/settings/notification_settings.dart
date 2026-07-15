import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/component/surface/app_surface.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/core/permission/provider/permission_provider.dart';
import 'package:ddara/feature/profile/provider/notifier_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 알림 설정 화면.
class NotificationSettings extends ConsumerStatefulWidget {
  const NotificationSettings({super.key});

  @override
  ConsumerState<NotificationSettings> createState() =>
      _NotificationSettingsState();
}

class _NotificationSettingsState extends ConsumerState<NotificationSettings>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // 설정 화면에서 권한을 바꾸고 돌아오는 경우까지 반영하기 위해 옵저버 등록.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // OS 설정에서 권한을 변경하고 앱으로 복귀하면 토글을 최신 상태로 맞춘다.
    if (state == AppLifecycleState.resumed) {
      ref.read(notificationSettingsNotifierProvider.notifier).syncPermission();
    }
  }

  /// '알림 허용' 토글 변경. 권한 요청까지 Notifier 가 담당하고,
  /// 영구 거부인 경우에만 설정 이동 안내를 띄운다.
  Future<void> _onAllowChanged(bool value) async {
    final result = await ref
        .read(notificationSettingsNotifierProvider.notifier)
        .changeAllow(value);
    if (!mounted) return;

    // 영구 거부면 프롬프트가 더 뜨지 않으므로 설정으로 안내한다.
    if (result == PermissionResult.permanentlyDenied) {
      _showOpenSettingsDialog();
    }
  }

  /// 알림 권한이 영구 거부됐을 때, 설정 이동을 안내하는 다이얼로그.
  void _showOpenSettingsDialog() {
    final l10n = AppLocalizations.of(context);
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(l10n.notificationPermissionDialogTitle),
        content: Text(l10n.notificationPermissionDialogBody),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonCancel),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(permissionServiceProvider).openSettings();
            },
            child: Text(l10n.notificationOpenSettings),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(notificationSettingsNotifierProvider);
    final notifier = ref.read(notificationSettingsNotifierProvider.notifier);

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.notificationSettingsTitle,
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          // 콘텐츠가 화면에 들어가면 스크롤 없음, 큰 글자 설정 등에서는
          // 스크롤로 전환되도록 뷰포트 높이를 최소 높이로 강제한다.
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.only(
                  top: AppSpacing.s3,
                  left: AppSpacing.s4,
                  right: AppSpacing.s4,
                  // 하단 Safe Area 까지 배경을 잇되, 마지막 항목이 홈
                  // 인디케이터와 겹치지 않도록 인셋만큼 더 띄운다.
                  bottom: AppSpacing.s6 + MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.s5,
                  children: [
                    _SettingCard(
                      children: [
                        _ToggleRow(
                          label: l10n.notificationAllow,
                          value: state.notificationEnabled,
                          onChanged: _onAllowChanged,
                        ),
                      ],
                    ),
                    // 알림을 끄면 세부 설정 섹션을 숨긴다.
                    if (state.notificationEnabled) ...[
                      _SettingCard(
                        children: [
                          AppText.caption(l10n.notificationSectionActivity),
                          _ToggleRow(
                            label: l10n.notificationFollowShot,
                            caption: l10n.notificationFollowShotCaption,
                            value: state.followShot,
                            onChanged: notifier.changeFollowShot,
                          ),
                          _ToggleRow(
                            label: l10n.notificationDeadlineVote,
                            caption: l10n.notificationDeadlineVoteCaption,
                            value: state.deadlineVote,
                            onChanged: notifier.changeDeadlineVote,
                          ),
                        ],
                      ),
                      _SettingCard(
                        children: [
                          AppText.caption(l10n.notificationSectionEtc),
                          _ToggleRow(
                            label: l10n.notificationMemberJoin,
                            caption: l10n.notificationMemberJoinCaption,
                            value: state.memberJoin,
                            onChanged: notifier.changeMemberJoin,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 알림 설정 항목을 담는 카드.
///
/// bg-surface 배경의 둥근 카드 안에 [children] 을 세로로 쌓고, 항목 사이에는
/// [AppSpacing.s4] 간격을 둔다. (카드 자체가 좌우 [AppSpacing.s5]·상하
/// [AppSpacing.s3] 패딩을 갖는다.)
class _SettingCard extends StatelessWidget {
  const _SettingCard({required this.children});

  /// 카드 내부에 세로로 쌓을 항목들.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s5,
        vertical: AppSpacing.s3,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s4,
        children: children,
      ),
    );
  }
}

/// [_SettingCard] 안에 들어가는 "라벨 + 토글" 행.
///
/// [caption] 이 없으면 라벨을 headlineMedium 으로 보여주는 상위 토글(예: '알림
/// 허용')이고, [caption] 이 있으면 body(textPrimary) 라벨 아래에 caption 설명을
/// 덧붙인 개별 항목 토글이다.
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.caption,
  });

  /// 항목 이름. (예: '알림 허용')
  final String label;

  /// 라벨 아래 보조 설명. null 이면 라벨만 보여준다.
  final String? caption;

  /// 토글 켜짐 여부.
  final bool value;

  /// 토글이 바뀔 때 실행할 콜백.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final caption = this.caption;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: caption == null
              ? AppText.headlineMedium(label)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s1,
                  children: [
                    AppText.body(label, color: AppColors.textPrimary),
                    AppText.caption(caption),
                  ],
                ),
        ),
        const SizedBox(width: AppSpacing.s3),
        CupertinoSwitch(
          value: value,
          activeTrackColor: AppColors.accentDefault,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
