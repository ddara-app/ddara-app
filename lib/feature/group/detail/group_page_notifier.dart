import 'package:ddara/core/exception/block_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/core/model/group/group_action_error.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/model/group/history_cycles.dart';
import 'package:ddara/core/model/report/group_report_reason.dart';
import 'package:ddara/core/model/report/user_report_reason.dart';
import 'package:ddara/core/util/auto_dispose_guard.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/detail/util/group_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupPageNotifier extends AutoDisposeFamilyNotifier<GroupPageState, int>
    with AutoDisposeGuard<GroupPageState> {
  /// 가장 마지막에 시작한 조회의 번호. 응답이 도착했을 때 이 값과 다르면
  /// 그 사이 새 조회가 시작된 것이므로 결과를 버린다.
  /// (당겨서 새로고침을 연달아 하거나 차단·닉네임 변경 후 재조회가 겹칠 때,
  ///  옛 응답이 최신 상태를 덮는 것을 막는다)
  int _requestId = 0;

  @override
  GroupPageState build(int groupId) {
    watchDispose();
    // GroupPage 가 넘긴 groupId 로 진입 시 자동 조회. (build 는 동기라 fire-and-forget)
    _load(groupId);

    return const GroupPageLoading();
  }

  Future<void> _load(int groupId) async {
    final id = ++_requestId;
    final getGroupDetailUseCase = ref.read(getGroupDetailUseCaseProvider);
    final getHistoryCyclesUseCase = ref.read(getHistoryCyclesUseCaseProvider);

    try {
      // 모임 상세와 히스토리, 차단 목록을 함께(병렬) 조회한다.
      final results = await Future.wait([
        getGroupDetailUseCase(groupId),
        getHistoryCyclesUseCase(groupId),
        ref.read(getBlockedUserIdsUseCaseProvider)(),
      ]);
      // 화면을 벗어났거나(폐기) 더 새 조회가 시작됐으면 이 결과는 버린다.
      if (isDisposed || id != _requestId) return;
      state = GroupPageLoaded(
        groupDetail: results[0] as GroupDetail,
        historyCycles: results[1] as HistoryCycles,
        blockedUserIds: results[2] as Set<int>,
      );
    } on NotGroupMemberException {
      _failLoad(id, GroupActionError.notGroupMember);
    } on GroupNotFoundException {
      _failLoad(id, GroupActionError.groupNotFound);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      _failLoad(id, GroupActionError.groupLoadFailed);
    }
  }

  /// 조회 실패를 상태에 반영한다. 폐기됐거나 이미 더 새 조회가 시작됐다면
  /// 무시한다 — 옛 요청의 실패로 최신 조회의 본문이 흐트러지지 않게 한다.
  ///
  /// 이미 본문이 떠 있으면(당겨서 새로고침·차단 후 재조회) 보던 화면을 유지한
  /// 채 토스트로만 알리고, 최초 조회였다면 본문을 에러 화면으로 바꾼다.
  void _failLoad(int id, GroupActionError error) {
    if (isDisposed || id != _requestId) return;
    final current = state;
    state = current is GroupPageLoaded
        ? current.copyWith(isBusy: false, actionError: error)
        : GroupPageLoadError(error);
  }

  /// 당겨서 새로고침: 상세·히스토리를 다시 조회한다.
  ///
  /// 로딩 상태로 바꾸지 않는다 — 당김 인디케이터가 로딩 표시를 대신하고,
  /// 본문이 스피너로 교체되면 당김 제스처가 끊기기 때문.
  /// (연달아 당겨 조회가 겹쳐도 [_requestId] 가 옛 응답을 버린다)
  Future<void> refresh() async {
    final current = state;
    if (current is GroupPageLoaded && current.isBusy) return;
    await _load(arg);
  }

  /// 액션 에러를 소비한 뒤(토스트로 노출 후) 다시 비운다.
  /// 같은 에러가 이후 상태 변경 때 재노출되는 것을 막는다.
  void clearActionError() {
    final current = state;
    if (current is! GroupPageLoaded || current.actionError == null) return;
    state = current.copyWith(clearActionError: true);
  }

  /// 로딩을 세우는 액션(나가기·차단·닉네임 변경)의 진입 가드.
  /// 본문이 없거나 이미 처리 중이면 false 를 돌려 중복 실행을 막는다.
  bool _startAction() {
    final current = state;
    if (current is! GroupPageLoaded || current.isBusy) return false;
    state = current.copyWith(isBusy: true);

    return true;
  }

  /// 액션 실패를 상태에 반영하고 false 를 돌려준다.
  /// (로딩을 세운 액션은 [stopBusy] 로 함께 내린다)
  ///
  /// 본문이 없는 상태(로딩·조회 실패)에서는 액션 자체가 열리지 않으므로
  /// 반영할 곳이 없다 — 실패만 알리고 상태는 두 번 건드리지 않는다.
  bool _fail(GroupActionError error, {bool stopBusy = false}) {
    // 화면을 벗어난 뒤 도착한 실패는 반영하지 않는다.
    if (isDisposed) return false;
    final current = state;
    if (current is GroupPageLoaded) {
      state = current.copyWith(
        isBusy: stopBusy ? false : null,
        actionError: error,
      );
    }

    return false;
  }

  /// 현재 모임에서 나간다. 성공하면 true, 실패하면 actionError 를 채우고 false 를
  /// 반환한다. 요청 시작~완료까지 isBusy 를 true 로 둬 화면에 로딩을 표시한다.
  /// (성공 시엔 홈으로 이동하므로 로딩을 내리지 않는다.)
  Future<bool> exitGroup() async {
    if (!_startAction()) return false;
    final exitGroupUseCase = ref.read(exitGroupUseCaseProvider);

    try {
      await exitGroupUseCase(arg);
      return true;
    } on NotGroupMemberException {
      return _fail(GroupActionError.notGroupMember, stopBusy: true);
    } on GroupNotFoundException {
      return _fail(GroupActionError.groupNotFound, stopBusy: true);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      return _fail(GroupActionError.exitFailed, stopBusy: true);
    }
  }

  /// [userId] 멤버를 신고한다. 성공하면 true.
  /// (실패 사유는 actionError 로 내려 화면에서 토스트로 안내한다)
  ///
  /// 신고해도 화면에 바뀌는 값이 없으므로 로딩 표시·상세 재조회 없이
  /// 접수만 하고 결과 토스트로 끝낸다.
  Future<bool> reportMember({
    required int userId,
    required UserReportReason reason,
    String? reasonText,
  }) async {
    final reportUserUseCase = ref.read(reportUserUseCaseProvider);

    try {
      await reportUserUseCase(
        userId: userId,
        groupId: arg,
        reason: reason,
        reasonText: reasonText,
      );
      return true;
    } on InvalidReportInputException {
      return _fail(GroupActionError.reportInvalidInput);
    } on ReportUserNotFoundException {
      return _fail(GroupActionError.reportUserNotFound);
    } on NotGroupMemberException {
      return _fail(GroupActionError.notGroupMember);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      return _fail(GroupActionError.reportFailed);
    }
  }

  /// 이 모임을 신고한다. 성공하면 true.
  /// (실패 사유는 actionError 로 내려 화면에서 토스트로 안내한다)
  ///
  /// 신고해도 화면에 바뀌는 값이 없으므로 로딩 표시·상세 재조회 없이
  /// 접수만 하고 결과 토스트로 끝낸다.
  Future<bool> reportGroup({
    required GroupReportReason reason,
    String? reasonText,
  }) async {
    final reportGroupUseCase = ref.read(reportGroupUseCaseProvider);

    try {
      await reportGroupUseCase(
        groupId: arg,
        reason: reason,
        reasonText: reasonText,
      );
      return true;
    } on InvalidReportInputException {
      return _fail(GroupActionError.reportInvalidInput);
    } on NotGroupMemberException {
      return _fail(GroupActionError.notGroupMember);
    } on GroupNotFoundException {
      return _fail(GroupActionError.groupNotFound);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      return _fail(GroupActionError.reportFailed);
    }
  }

  /// [userId] 멤버를 차단한다. 성공하면 true, 실패하면 actionError 를 채우고
  /// false 를 반환한다. 요청 시작~완료까지 isBusy 를 true 로 두고, 성공 시
  /// 차단이 반영된 목록을 받도록 상세를 다시 조회한다.
  Future<bool> blockMember(int userId) async {
    if (!_startAction()) return false;
    final blockUserUseCase = ref.read(blockUserUseCaseProvider);

    try {
      await blockUserUseCase(userId, groupId: arg);
      // 차단 결과를 반영하기 위해 상세를 다시 조회한다. (isBusy 는 _load 가 내린다)
      await _load(arg);
      return true;
    } on InvalidBlockInputException {
      return _fail(GroupActionError.blockSelf, stopBusy: true);
    } on BlockTargetNotFoundException {
      return _fail(GroupActionError.blockTargetNotFound, stopBusy: true);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      return _fail(GroupActionError.blockFailed, stopBusy: true);
    }
  }

  /// 모임 내 닉네임을 변경한다. 성공하면 true, 실패하면 actionError 를 채우고
  /// false 를 반환한다. 요청 시작~완료까지 isBusy 를 true 로 두고, 성공 시
  /// 변경된 닉네임이 멤버 목록에 반영되도록 상세를 다시 조회한다.
  Future<bool> changeNickName(String nickName) async {
    if (!_startAction()) return false;
    final changeNicknameUseCase = ref.read(changeNicknameUseCaseProvider);

    try {
      await changeNicknameUseCase(arg, nickName);
      // 변경된 닉네임을 반영하기 위해 상세를 다시 조회한다. (isBusy 는 _load 가 내린다)
      await _load(arg);
      return true;
    } on InvalidNicknameException {
      return _fail(GroupActionError.nicknameInvalid, stopBusy: true);
    } on DuplicateGroupNicknameException {
      return _fail(GroupActionError.nicknameDuplicate, stopBusy: true);
    } on NotGroupMemberException {
      return _fail(GroupActionError.notGroupMember, stopBusy: true);
    } on GroupNotFoundException {
      return _fail(GroupActionError.groupNotFound, stopBusy: true);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      return _fail(GroupActionError.nicknameChangeFailed, stopBusy: true);
    }
  }
}
