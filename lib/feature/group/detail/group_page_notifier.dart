import 'package:ddara/core/exception/block_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/core/model/group/group_action_error.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/model/group/history_cycles.dart';
import 'package:ddara/core/model/report/group_report_reason.dart';
import 'package:ddara/core/model/report/user_report_reason.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/detail/util/group_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupPageNotifier extends AutoDisposeFamilyNotifier<GroupPageState, int> {
  /// 가장 마지막에 시작한 조회의 번호. 응답이 도착했을 때 이 값과 다르면
  /// 그 사이 새 조회가 시작된 것이므로 결과를 버린다.
  /// (당겨서 새로고침을 연달아 하거나 차단·닉네임 변경 후 재조회가 겹칠 때,
  ///  옛 응답이 최신 상태를 덮는 것을 막는다)
  int _requestId = 0;

  @override
  GroupPageState build(int groupId) {
    // GroupPage 가 넘긴 groupId 로 진입 시 자동 조회. (build 는 동기라 fire-and-forget)
    _load(groupId);

    return const GroupPageState(isLoading: true);
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
      // 기다리는 동안 더 새 조회가 시작됐으면 이 결과는 버린다.
      if (id != _requestId) return;
      state = state.copyWith(
        isLoading: false,
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

  /// 조회 실패를 상태에 반영한다. 이미 더 새 조회가 시작됐다면 무시한다 —
  /// 옛 요청의 실패로 최신 조회의 로딩·본문이 흐트러지지 않게 한다.
  void _failLoad(int id, GroupActionError error) {
    if (id != _requestId) return;
    state = state.copyWith(isLoading: false, error: error);
  }

  /// 당겨서 새로고침: 상세·히스토리를 다시 조회한다.
  ///
  /// 전체 화면 로딩(isLoading)으로 바꾸지 않는다 — 당김 인디케이터가 로딩
  /// 표시를 대신하고, 본문이 스피너로 교체되면 당김 제스처가 끊기기 때문.
  /// (연달아 당겨 조회가 겹쳐도 [_requestId] 가 옛 응답을 버린다)
  Future<void> refresh() async {
    if (state.isLoading) return;
    await _load(arg);
  }

  /// 에러를 소비한 뒤(토스트로 노출 후) 다시 비운다.
  /// 같은 에러가 이후 상태 변경 때 재노출되는 것을 막는다.
  void clearError() {
    if (state.error == null) return;
    state = state.copyWith(clearError: true);
  }

  /// 현재 모임에서 나간다. 성공하면 true, 실패하면 error 를 채우고 false 를 반환한다.
  /// 요청 시작~완료까지 isLoading 을 true 로 둬 화면에 로딩을 표시한다.
  /// (성공 시엔 홈으로 이동하므로 로딩을 내리지 않는다.)
  Future<bool> exitGroup() async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true);
    final exitGroupUseCase = ref.read(exitGroupUseCaseProvider);

    try {
      await exitGroupUseCase(arg);
      return true;
    } on NotGroupMemberException {
      return _fail(GroupActionError.notGroupMember, stopLoading: true);
    } on GroupNotFoundException {
      return _fail(GroupActionError.groupNotFound, stopLoading: true);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      return _fail(GroupActionError.exitFailed, stopLoading: true);
    }
  }

  /// 액션 실패를 상태에 반영하고 false 를 돌려준다.
  /// (로딩을 세운 액션은 [stopLoading] 으로 함께 내린다)
  bool _fail(GroupActionError error, {bool stopLoading = false}) {
    state = state.copyWith(
      isLoading: stopLoading ? false : null,
      error: error,
    );
    return false;
  }

  /// [userId] 멤버를 신고한다. 성공하면 true.
  /// (실패 사유는 error 로 내려 화면에서 토스트로 안내한다)
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
  /// (실패 사유는 error 로 내려 화면에서 토스트로 안내한다)
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

  /// [userId] 멤버를 차단한다. 성공하면 true, 실패하면 error 를 채우고 false 를 반환한다.
  /// 요청 시작~완료까지 isLoading 을 true 로 두고, 성공 시 차단이 반영된
  /// 목록을 받도록 상세를 다시 조회한다.
  Future<bool> blockMember(int userId) async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true);
    final blockUserUseCase = ref.read(blockUserUseCaseProvider);

    try {
      await blockUserUseCase(userId, groupId: arg);
      // 차단 결과를 반영하기 위해 상세를 다시 조회한다. (isLoading 은 _load 가 내린다)
      await _load(arg);
      return true;
    } on InvalidBlockInputException {
      return _fail(GroupActionError.blockSelf, stopLoading: true);
    } on BlockTargetNotFoundException {
      return _fail(GroupActionError.blockTargetNotFound, stopLoading: true);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      return _fail(GroupActionError.blockFailed, stopLoading: true);
    }
  }

  /// 모임 내 닉네임을 변경한다. 성공하면 true, 실패하면 error 를 채우고 false 를 반환한다.
  /// 요청 시작~완료까지 isLoading 을 true 로 두고, 성공 시 변경된 닉네임이
  /// 멤버 목록에 반영되도록 상세를 다시 조회한다.
  Future<bool> changeNickName(String nickName) async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true);
    final changeNicknameUseCase = ref.read(changeNicknameUseCaseProvider);

    try {
      await changeNicknameUseCase(arg, nickName);
      // 변경된 닉네임을 반영하기 위해 상세를 다시 조회한다. (isLoading 은 _load 가 내린다)
      await _load(arg);
      return true;
    } on InvalidNicknameException {
      return _fail(GroupActionError.nicknameInvalid, stopLoading: true);
    } on DuplicateGroupNicknameException {
      return _fail(GroupActionError.nicknameDuplicate, stopLoading: true);
    } on NotGroupMemberException {
      return _fail(GroupActionError.notGroupMember, stopLoading: true);
    } on GroupNotFoundException {
      return _fail(GroupActionError.groupNotFound, stopLoading: true);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      return _fail(GroupActionError.nicknameChangeFailed, stopLoading: true);
    }
  }
}
