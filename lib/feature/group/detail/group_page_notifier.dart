import 'package:ddara/core/exception/block_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/model/group/history_cycles.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/detail/util/group_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupPageNotifier extends AutoDisposeFamilyNotifier<GroupPageState, int> {
  @override
  GroupPageState build(int groupId) {
    // GroupPage 가 넘긴 groupId 로 진입 시 자동 조회. (build 는 동기라 fire-and-forget)
    _load(groupId);

    return const GroupPageState(isLoading: true);
  }

  Future<void> _load(int groupId) async {
    final getGroupDetailUseCase = ref.read(getGroupDetailUseCaseProvider);
    final getHistoryCyclesUseCase = ref.read(getHistoryCyclesUseCaseProvider);

    try {
      // 모임 상세와 히스토리를 함께(병렬) 조회한다.
      final results = await Future.wait([
        getGroupDetailUseCase(groupId),
        getHistoryCyclesUseCase(groupId),
      ]);
      state = state.copyWith(
        isLoading: false,
        groupDetail: results[0] as GroupDetail,
        historyCycles: results[1] as HistoryCycles,
      );
    } on NotGroupMemberException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '해당 모임의 멤버가 아니에요.',
      );
    } on GroupNotFoundException {
      state = state.copyWith(isLoading: false, errorMessage: '존재하지 않는 모임이에요.');
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(
        isLoading: false,
        errorMessage: '모임 정보를 불러오지 못했어요.',
      );
    }
  }

  /// 당겨서 새로고침: 상세·히스토리를 다시 조회한다.
  ///
  /// 전체 화면 로딩(isLoading)으로 바꾸지 않는다 — 당김 인디케이터가 로딩
  /// 표시를 대신하고, 본문이 스피너로 교체되면 당김 제스처가 끊기기 때문.
  Future<void> refresh() async {
    if (state.isLoading) return;
    await _load(arg);
  }

  /// 에러 메시지를 소비한 뒤(토스트로 노출 후) 다시 비운다.
  /// 같은 에러가 이후 상태 변경 때 재노출되는 것을 막는다.
  void clearError() {
    if (state.errorMessage.isEmpty) return;
    state = state.copyWith(errorMessage: '');
  }

  /// 현재 모임에서 나간다. 성공하면 true, 실패하면 errorMessage 를 채우고 false 를 반환한다.
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
      state = state.copyWith(
        isLoading: false,
        errorMessage: '해당 모임의 멤버가 아니에요.',
      );
      return false;
    } on GroupNotFoundException {
      state = state.copyWith(isLoading: false, errorMessage: '존재하지 않는 모임이에요.');
      return false;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(isLoading: false, errorMessage: '모임에서 나가지 못했어요.');
      return false;
    }
  }

  /// [userId] 멤버를 차단한다. 성공하면 true, 실패하면 errorMessage 를 채우고 false 를 반환한다.
  /// 요청 시작~완료까지 isLoading 을 true 로 두고, 성공 시 차단이 반영된
  /// 목록을 받도록 상세를 다시 조회한다.
  Future<bool> blockMember(int userId) async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true);
    final blockUserUseCase = ref.read(blockUserUseCaseProvider);

    try {
      await blockUserUseCase(userId);
      // 차단 결과를 반영하기 위해 상세를 다시 조회한다. (isLoading 은 _load 가 내린다)
      await _load(arg);
      return true;
    } on InvalidBlockInputException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '자기 자신은 차단할 수 없어요.',
      );
      return false;
    } on BlockTargetNotFoundException {
      state = state.copyWith(isLoading: false, errorMessage: '존재하지 않는 사용자예요.');
      return false;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(isLoading: false, errorMessage: '차단하지 못했어요.');
      return false;
    }
  }

  /// 모임 내 닉네임을 변경한다. 성공하면 true, 실패하면 errorMessage 를 채우고 false 를 반환한다.
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
      state = state.copyWith(
        isLoading: false,
        errorMessage: '닉네임은 2~10자로 입력해주세요.',
      );
      return false;
    } on DuplicateGroupNicknameException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '이미 누가 쓰고 있어요. 다른 이름은 어때요?',
      );
      return false;
    } on NotGroupMemberException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '해당 모임의 멤버가 아니에요.',
      );
      return false;
    } on GroupNotFoundException {
      state = state.copyWith(isLoading: false, errorMessage: '존재하지 않는 모임이에요.');
      return false;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(isLoading: false, errorMessage: '닉네임을 변경하지 못했어요.');
      return false;
    }
  }
}
