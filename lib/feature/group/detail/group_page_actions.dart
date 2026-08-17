import 'package:ddara/core/analytics/app_analytics.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/bottom_sheet/invite_share_sheet.dart';
import 'package:ddara/core/widget/bottom_sheet/report_sheets.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/domain/model/group/group_detail.dart';
import 'package:ddara/feature/group/detail/group_page_viewmodel.dart';
import 'package:ddara/feature/group/detail/provider/viewmodel_provider.dart';
import 'package:ddara/feature/group/detail/util/group_page_state.dart';
import 'package:ddara/feature/group/detail/widget/edit_nickname_sheet.dart';
import 'package:ddara/feature/group/random_starter/random_starter_page.dart';
import 'package:ddara/feature/home/provider/viewmodel_provider.dart';
import 'package:ddara/feature/profile/provider/viewmodel_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 초대 공유 카드에 넣을 모임 대표 이미지. (카카오가 접근 가능한 공개 https URL)
// TODO: 모임 대표 이미지로 대체. (현재 응답에 없음 — 임시 placeholder)
const String groupShareImageUrl = 'https://placehold.co/800x400.png';

/// 초대 시트를 자동으로 띄우는 인원 기준. (이 수 미만이면 띄운다)
const int _inviteThreshold = 2;

/// 모임 화면의 이동과 액션 배선 묶음.
///
/// 각 액션은 "시트·다이얼로그 띄우기 → ViewModel 호출 → 토스트·이동" 이라는
/// 같은 모양이라, 화면 조립 코드 사이에 흩어 두지 않고 여기에 모은다.
/// 화면은 [GroupPageActions] 를 만들어 콜백으로 넘기기만 한다.
///
/// ```dart
/// final actions = GroupPageActions(context: context, ref: ref, groupId: groupId);
/// MembersSection(..., actions: actions);
/// ```
class GroupPageActions {
  const GroupPageActions({
    required this.context,
    required this.ref,
    required this.groupId,
  });

  /// 액션을 띄운 화면의 context. (l10n·토스트·이동·mounted 확인에 사용)
  final BuildContext context;

  final WidgetRef ref;

  /// 대상 모임 식별자.
  final int groupId;

  AppLocalizations get _l10n => AppLocalizations.of(context);

  GroupPageViewModel get _viewModel =>
      ref.read(groupPageViewModelProvider(groupId).notifier);

  // ── 이동 ──────────────────────────────────────────────────────────

  /// AppBar 뒤로가기: 스택이 있으면 이전 화면으로 pop 하고, 없으면(딥링크
  /// 진입 등) 홈으로 보낸다. (홈 무효화는 PopScope 의 pop 콜백에서 처리)
  void back() {
    if (context.canPop()) {
      context.pop();
    } else {
      goHome();
    }
  }

  /// 홈으로 돌아간다. 나가기 직전 홈 목록을 무효화해, 복귀 시 최신 상태로
  /// 재조회되도록 한다. (스타터 시작 사진 등 이 화면에서 생긴 변경을 홈 카드에 반영)
  void goHome() {
    ref.invalidate(homeViewModelProvider);
    context.go(RoutePath.home);
  }

  /// 하위 화면(스타터·갤러리)으로 이동했다가 돌아오면 모임 상세를 무효화해
  /// 재조회한다. (하위 화면에서 생긴 변경을 복귀 시 반영 — 홈 복귀 갱신과 동일 패턴)
  Future<void> pushThenRefresh(String path, {Object? extra}) async {
    await context.push(path, extra: extra);
    ref.invalidate(groupPageViewModelProvider(groupId));
  }

  /// 이 모임의 [cycleId] 회차 갤러리로 이동한다. (복귀 시 상세 갱신)
  Future<void> pushGallery(int cycleId) => pushThenRefresh(
    RoutePath.cycleGallery(groupId: groupId, cycleId: cycleId),
  );

  /// 따라찍기 시작(스타터 촬영) 화면으로 이동한다. (복귀 시 상세 갱신)
  Future<void> pushStarter() =>
      pushThenRefresh(RoutePath.starter, extra: groupId);

  /// 지난 따라찍기 전체 목록으로 이동한다. (복귀 시 상세 갱신)
  Future<void> pushHistoryList() {
    AppAnalytics.track(
      'group_history_more_clicked',
      properties: {'group_id': groupId},
    );
    return pushThenRefresh(RoutePath.historyList, extra: groupId);
  }

  /// 초대 공유 시트를 띄운다.
  /// [memberShortage] 는 인원 부족으로 자동으로 띄운 경우 — 머리말이 안내 문구로 바뀐다.
  void showInviteSheet(String inviteCode, {bool memberShortage = false}) {
    InviteShareSheet.show(
      context,
      inviteCode: inviteCode,
      imageUrl: groupShareImageUrl,
      memberShortage: memberShortage,
    );
  }

  // ── 진입 처리 ─────────────────────────────────────────────────────

  /// 상세가 처음 로드된 직후의 진입 처리.
  /// 랜덤 스타터 공개가 필요하면 그 화면으로 보내고, 아니면 인원이 기준 미만일 때
  /// 초대 시트를 띄운다. (빌드·네비게이션 도중 화면을 띄우지 않도록 다음 프레임에 연다)
  Future<void> onDetailLoaded(GroupDetail detail) async {
    final revealStarter = await _shouldRevealStarter(detail);
    if (!context.mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      // 이 화면 위에 이미 다른 화면이 올라와 있으면(딥링크로 갤러리에 바로
      // 들어와 이 화면이 스택 아래에 깔린 경우 등) 자동으로 열리는 화면을
      // 띄우지 않는다. 사용자가 보고 있는 화면을 덮어 버리기 때문이다.
      if (ModalRoute.of(context)?.isCurrent == false) return;

      // 슬롯머신(랜덤 스타터 공개)으로 이동한다. (상세를 재조회하지 않고 push
      //  한다 — 재조회하면 nextStarter 가 남아 다시 이동하는 루프가 된다)
      final nextStarter = detail.nextStarter;
      if (revealStarter && nextStarter != null) {
        context
            .push(
              RoutePath.randomStarter,
              extra: RandomStarterArgs(
                groupId: groupId,
                starterUserId: nextStarter.userId,
                members: detail.members,
              ),
            )
            // 공개를 보고 돌아오면 친구들 목록의 스타터 배지가 바로 뜨도록
            // 확인 표시만 로컬 상태에 남긴다. (재조회는 하지 않는다)
            .then((_) => _viewModel.markNextStarterSeen());
        return;
      }

      // 인원이 기준 미만이면 초대 시트를 띄운다.
      if (detail.members.length < _inviteThreshold) {
        showInviteSheet(detail.inviteCode, memberShortage: true);
      }
    });
  }

  /// 진입 시 랜덤 스타터 공개 화면을 띄워야 하는지 판단한다.
  /// - 아직 공개를 보지 않았으면(seen=false) 따라찍기가 이미 시작됐더라도 보여준다.
  ///   (당첨 사실 자체를 아직 못 본 상태라 한 번은 알려야 한다)
  /// - 이미 봤으면(seen=true) 당첨된 본인에게만, 그것도 **아직 아무도 시작하지
  ///   않았을 때**(currentCycle 없음) 진입할 때마다 다시 보여준다. 누군가
  ///   시작해 사이클이 열렸다면 공개를 다시 볼 이유가 없다.
  /// - 그 외(이미 본 다른 멤버)에는 띄우지 않는다.
  Future<bool> _shouldRevealStarter(GroupDetail detail) async {
    final nextStarter = detail.nextStarter;
    if (nextStarter == null) return false;
    if (!nextStarter.seen) return true;

    // 공개를 이미 본 뒤라면, 따라찍기가 시작된 시점부터는 재노출하지 않는다.
    if (detail.currentCycle != null) return false;

    // 내 프로필을 못 얻으면 당첨자 본인인지 알 수 없으므로 재노출하지 않는다.
    // (스타터는 헤더의 시작 버튼으로도 따라찍기를 시작할 수 있다)
    try {
      final myUserId = (await ref.read(currentProfileProvider.future)).id;
      return myUserId == nextStarter.userId;
    } catch (_) {
      return false;
    }
  }

  // ── 모임 메뉴 ─────────────────────────────────────────────────────

  /// 우측 메뉴 버튼을 눌렀을 때 뜨는 모임 메뉴(액션 시트).
  void showMenu() {
    final l10n = _l10n;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(sheetContext).pop();
              openTourTest();
            },
            child: AppText.title(l10n.groupMenuTourTest),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(sheetContext).pop();
              editNickname();
            },
            child: AppText.title(l10n.groupMenuEditNickname),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(sheetContext).pop();
              reportGroup();
            },
            child: AppText.title(l10n.groupMenuReport),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(sheetContext).pop();
              exitGroup();
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

  /// 가이드 투어 확인용 진입. (개발 중 동작 확인 목적)
  ///
  /// 진행 중인 회차가 없어도 열 수 있도록 가이드 사진은 번들 더미를 쓰고,
  /// 사이클 id 는 업로드하지 않을 전제로 0 을 넘긴다. 투어는 완료 플래그와
  /// 무관하게 매번 처음부터 뜬다.
  void openTourTest() => context.push(
    RoutePath.followerCamera,
    extra: (
      cycleId: 0,
      guideImageUrl: 'assets/images/photo_image.png',
      forceTour: true,
    ),
  );

  /// 모임 신고 사유 시트를 띄우고, 확정하면 신고를 접수한다.
  /// 성공 시 완료 토스트를 띄운다. (신고해도 모임은 그대로 노출 — 관리자 검토
  /// 후 처리, 실패 시 ViewModel 이 error → 토스트로 처리)
  Future<void> reportGroup() async {
    final result = await GroupReportSheet.show(context);
    if (result == null || !context.mounted) return;

    final success = await _viewModel.reportGroup(
      reason: result.reason,
      reasonText: result.detail.isEmpty ? null : result.detail,
    );
    if (!success || !context.mounted) return;

    Toast.showToast(context, _l10n.reportSubmitted);
  }

  /// 닉네임 수정 바텀시트를 띄우고, 입력을 받으면 변경을 요청한다.
  /// (실패 시 ViewModel 이 error → 토스트로 처리, 성공 시 상세 재조회로 반영)
  Future<void> editNickname() async {
    // 메뉴는 상세가 뜬 뒤에만 열리므로 여기선 항상 Loaded 다.
    final state = ref.read(groupPageViewModelProvider(groupId));
    if (state is! GroupPageLoaded) return;
    final detail = state.groupDetail;

    final nickName = await EditNicknameSheet.show(
      context,
      groupName: detail.name,
      // 멤버가 이미 쓰는 닉네임은 시트에서 중복 에러로 미리 막는다.
      takenNicknames: detail.members.map((m) => m.nickname).toSet(),
    );
    if (nickName == null || !context.mounted) return;

    final success = await _viewModel.changeNickName(nickName);
    if (success) {
      AppAnalytics.track(
        'group_nickname_changed',
        properties: {'group_id': groupId},
      );
    }
  }

  /// 모임 나가기를 실행한다. 먼저 확인 다이얼로그를 띄우고, 확인 시에만 진행한다.
  /// 성공하면 홈의 목록을 새로 조회(invalidate)해 나간 모임이 사라지도록 반영한
  /// 뒤 홈으로 이동한다. (실패 시 ViewModel 이 에러 토스트 처리)
  Future<void> exitGroup() async {
    final l10n = _l10n;
    final confirmed = await AppDialog.show(
      context,
      title: l10n.groupExitConfirmTitle,
      confirmLabel: l10n.groupExitConfirmAction,
      confirmColor: AppColors.statusDanger,
      confirmLabelColor: AppColors.textPrimary,
    );
    if (!confirmed || !context.mounted) return;

    final success = await _viewModel.exitGroup();
    if (!success || !context.mounted) return;

    AppAnalytics.track(
      'group_exit_succeeded',
      properties: {'group_id': groupId},
    );
    goHome();
  }

  // ── 멤버 액션 ─────────────────────────────────────────────────────

  /// 유저 신고 사유 시트를 띄우고, 확정하면 신고를 접수한다.
  /// 성공하면 완료 토스트를 띄운다.
  /// (실패 시 ViewModel 이 error → 토스트로 처리)
  Future<void> reportMember(int userId) async {
    final result = await UserReportSheet.show(context);
    if (result == null || !context.mounted) return;

    final success = await _viewModel.reportMember(
      userId: userId,
      reason: result.reason,
      reasonText: result.detail.isEmpty ? null : result.detail,
    );
    if (!success || !context.mounted) return;

    Toast.showToast(context, _l10n.reportSubmitted);
  }

  /// 멤버를 차단한다. 먼저 확인 다이얼로그를 띄우고, 확인 시에만 진행한다.
  /// 성공하면 차단이 반영된 상세를 다시 조회하고 완료 토스트를 띄운다.
  /// (실패 시 ViewModel 이 error → 토스트로 처리)
  Future<void> blockMember(int userId, String name) async {
    final l10n = _l10n;
    final confirmed = await AppDialog.show(
      context,
      title: l10n.memberBlockConfirmTitle(name),
      message: l10n.memberBlockConfirmMessage,
      confirmLabel: l10n.memberBlockConfirmAction,
      confirmColor: AppColors.statusDanger,
      confirmLabelColor: AppColors.textPrimary,
    );
    if (!confirmed || !context.mounted) return;

    final success = await _viewModel.blockMember(userId);
    if (!success || !context.mounted) return;

    Toast.showToast(context, l10n.memberBlockedToast(name));
  }
}
