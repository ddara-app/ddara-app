import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/component/button/app_text_button.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/app_dialog.dart';
import 'package:ddara/core/widget/invite_share_sheet.dart';
import 'package:ddara/feature/group/detail/provider/notifier_provider.dart';
import 'package:ddara/feature/group/detail/util/group_page_state.dart';
import 'package:ddara/feature/group/detail/widget/body/history_photos.dart';
import 'package:ddara/feature/group/detail/widget/body/members.dart';
import 'package:ddara/feature/group/detail/widget/edit_nickname_sheet.dart';
import 'package:ddara/feature/group/detail/widget/group_section.dart';
import 'package:ddara/feature/group/detail/widget/header/group_header.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widget/toast/toast.dart';

/// 모임 화면. 전달받은 [groupId] 로 상세를 조회해 그린다.
class GroupPage extends ConsumerWidget {
  const GroupPage({super.key, required this.groupId});

  /// 진입 시 전달받은 모임 식별자. (이 id 로 모임 상세를 조회)
  final int groupId;

  /// 초대 공유 카드에 넣을 모임 대표 이미지. (카카오가 접근 가능한 공개 https URL)
  // TODO: 모임 대표 이미지로 대체. (현재 응답에 없음 — 임시 placeholder)
  static const _shareImageUrl = 'https://placehold.co/800x400.png';

  /// 초대 시트를 자동으로 띄우는 인원 기준. (이 수 미만이면 띄운다)
  static const _inviteThreshold = 3;

  /// 따라찍기를 시작할 수 있는 최소 인원. (이 수 미만이면 시작 버튼 비활성화)
  static const _minMembersToStart = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // groupId 를 그대로 provider 에 넘기면 notifier.build(int groupId) 가 받아 로드한다.
    final state = ref.watch(groupPageNotifierProvider(groupId));

    ref.listen(groupPageNotifierProvider(groupId), (prev, next) {
      final errorMessage = next.errorMessage;

      if (errorMessage.isNotEmpty) {
        Toast.showToast(context, errorMessage, type: ToastType.error);
        // 토스트로 소비했으니 비워, 이후 상태 변경 때 같은 에러가 재노출되지 않게 한다.
        ref.read(groupPageNotifierProvider(groupId).notifier).clearError();
      }

      // 진입해 상세가 처음 로드됐을 때, 인원이 기준 미만이면 초대 시트를 띄운다.
      final detail = next.groupDetail;
      if (prev?.groupDetail == null &&
          detail != null &&
          detail.members.length < _inviteThreshold) {
        // 빌드/네비게이션 도중 모달을 띄우지 않도록 다음 프레임에 연다.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          InviteShareSheet.show(
            context,
            inviteCode: detail.inviteCode,
            imageUrl: _shareImageUrl,
            // 인원 부족으로 자동으로 띄운 경우라 머리말을 안내 문구로 바꾼다.
            memberShortage: true,
          );
        });
      }
    });

    // 진입 경로·스택과 무관하게 뒤로가기(AppBar·OS 모두)는 항상 홈으로 보낸다.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        context.go(RoutePath.home);
      },
      child: CupertinoPageScaffold(
        navigationBar: AppBar(
          title: state.groupDetail?.name ?? '',
          onBack: () => context.go(RoutePath.home),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () => _showMenu(context, ref),
            child: const Icon(
              CupertinoIcons.ellipsis_vertical,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        child: SafeArea(child: _body(context, state)),
      ),
    );
  }

  /// 우측 메뉴 버튼을 눌렀을 때 뜨는 모임 메뉴(액션 시트).
  void _showMenu(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(sheetContext).pop();
              _editNickname(context, ref);
            },
            child: AppText.title(l10n.groupMenuEditNickname),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(sheetContext).pop();
              _exitGroup(context, ref);
            },
            child: AppText.title(
              l10n.groupMenuExit,
              color: AppColors.statusDanger,
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(sheetContext).pop(),
          child: AppText.title(l10n.commonCancel),
        ),
      ),
    );
  }

  /// 닉네임 수정 바텀시트를 띄우고, 입력을 받으면 변경을 요청한다.
  /// (실패 시 notifier 가 errorMessage → 토스트로 처리, 성공 시 상세 재조회로 반영)
  Future<void> _editNickname(BuildContext context, WidgetRef ref) async {
    final groupName =
        ref.read(groupPageNotifierProvider(groupId)).groupDetail?.name ?? '';

    final nickName = await EditNicknameSheet.show(context, groupName: groupName);
    if (nickName == null || !context.mounted) return;

    await ref
        .read(groupPageNotifierProvider(groupId).notifier)
        .changeNickName(nickName);
  }

  /// 모임 나가기를 실행한다. 먼저 확인 다이얼로그를 띄우고, 확인 시에만 진행한다.
  /// 성공하면 홈의 목록을 새로 조회(invalidate)해 나간 모임이 사라지도록 반영한
  /// 뒤 홈으로 이동한다. (실패 시 notifier 가 에러 토스트 처리)
  Future<void> _exitGroup(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await AppDialog.show(
      context,
      title: l10n.groupExitConfirmTitle,
      confirmLabel: l10n.groupExitConfirmAction,
      confirmColor: AppColors.statusDanger,
      confirmLabelColor: AppColors.textPrimary,
    );
    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(groupPageNotifierProvider(groupId).notifier)
        .exitGroup();
    if (!success || !context.mounted) return;

    ref.invalidate(homeNotifierProvider);
    context.go(RoutePath.home);
  }

  Widget _body(BuildContext context, GroupPageState state) {
    final l10n = AppLocalizations.of(context);
    if (state.isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    final groupDetail = state.groupDetail;
    if (groupDetail == null) {
      return Center(
        child: AppText.body(
          state.errorMessage.isEmpty
              ? l10n.groupDetailLoadError
              : state.errorMessage,
        ),
      );
    }

    final cycles = state.historyCycles?.cycles ?? const [];

    return SingleChildScrollView(
      // 끝에서 더 당겨지는 바운스(overscroll)를 막고 가장자리에서 멈춘다.
      physics: const ClampingScrollPhysics(),
      // 상하 s6 여백만. (좌우 여백은 일단 헤더에만 적용)
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
      child: Column(
        // 상단부터 쌓되 가로는 중앙 정렬.
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s8,
        children: [
          // 좌우 여백은 일단 헤더에만 적용한다.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
            child: GroupHeader(
              // 진행 중인 사이클을 그대로 전달. null 이면 헤더가 빈 상태를 보여준다.
              progress: groupDetail.currentCycle,
              // 멤버가 최소 인원 미만이면 시작 버튼을 비활성화한다.
              canStart: groupDetail.members.length >= _minMembersToStart,
              navigateToStart: () =>
                  context.push(RoutePath.starter, extra: groupId),
              // 촬영 버튼은 진행 중 사이클이 있을 때만 노출되므로 cycleId 가 존재한다.
              onTakePhoto: () {
                final cycleId = groupDetail.currentCycle?.cycleId;
                if (cycleId == null) return;
                context.push(
                  RoutePath.follower,
                  extra: cycleId,
                );
              },
            ),
          ),
          GroupSection(
            title: AppText.headlineLarge(l10n.groupMembersTitle),
            body: Members(
              members: groupDetail.members
                  .map(
                    (member) => (
                      name: member.nickname,
                      imageUrl: member.profileImageUrl,
                    ),
                  )
                  .toList(),
              onAddMember: () => InviteShareSheet.show(
                context,
                inviteCode: groupDetail.inviteCode,
                imageUrl: _shareImageUrl,
              ),
              onReportMember: (member) => _reportMember(context, member.name),
            ),
          ),
          GroupSection(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText.headlineLarge(l10n.groupHistoryTitle),
                // 전체 보기 기능 구현 전까지 숨긴다. (레이아웃 유지 위해 자리는 남겨 둠)
                Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: AppTextButton(
                    label: l10n.groupHistoryMore,
                    onPressed: () {
                      // TODO: 지난 따라찍기 전체 보기 화면으로 이동.
                    },
                  ),
                ),
              ],
            ),
            // 히스토리가 있으면 사진 카드들을, 없으면 같은 높이의 빈 상태 안내를 보여준다.
            body: cycles.isEmpty
                ? SizedBox(
                    height: 225 + AppSpacing.s4 * 2,
                    child: Center(child: AppText.body(l10n.groupHistoryEmpty)),
                  )
                : HistoryPhotos(cycles: cycles),
          ),
        ],
      ),
    );
  }

  /// 닉네임 신고 수신 주소. (프로필 문의하기와 동일한 팀 메일)
  static const String _reportEmail = 'ddara.team3@gmail.com';

  /// 기본 메일 앱으로 닉네임 신고 메일 작성 화면을 띄운다. (제목·본문 미리 채움)
  Future<void> _reportMember(BuildContext context, String nickname) async {
    final l10n = AppLocalizations.of(context);

    // mailto 쿼리는 공백을 '+' 가 아닌 '%20' 으로 인코딩해야 메일 앱이 제대로 읽는다.
    final query =
        <String, String>{
              'subject': l10n.memberReportMailSubject,
              'body': l10n.memberReportMailBody(nickname),
            }.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&');

    final mailUri = Uri(scheme: 'mailto', path: _reportEmail, query: query);

    // 메일 앱이 없거나 실행에 실패하면 사용자에게 안내한다.
    final launched = await launchUrl(mailUri).catchError((_) => false);
    if (!launched && context.mounted) {
      Toast.showToast(
        context,
        l10n.memberReportMailFailed(_reportEmail),
        type: ToastType.error,
      );
    }
  }
}
