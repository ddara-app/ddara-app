import 'package:ddara/core/exception/group_change_nickname_error_code.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/group_exit_error_code.dart';
import 'package:ddara/core/exception/group_history_error_code.dart';
import 'package:ddara/core/exception/group_join_error_code.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/model/group/change_nickname.dart';
import 'package:ddara/core/model/group/create_group.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/model/group/group_list.dart';
import 'package:ddara/core/model/group/history_cycles.dart';
import 'package:ddara/core/model/group/invite_group.dart';
import 'package:ddara/core/model/group/join_group.dart';
import 'package:ddara/data/datasource/group/group_datasource.dart';
import 'package:ddara/domain/repository/group_repository.dart';
import 'package:dio/dio.dart';

import 'mapper/group_mapper.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupDataSource _groupDataSource;

  GroupRepositoryImpl(this._groupDataSource);

  @override
  Future<CreateGroup> createGroup(
    String groupName,
    String description,
    String nickName,
  ) async {
    try {
      final response = await _groupDataSource.createGroup(
        groupName,
        description,
        nickName,
      );
      return response.toDomain();
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          // name 누락 또는 길이 초과
          throw InvalidGroupNameException();

        case 401:
          // 토큰 없음·만료 (인터셉터 복구도 실패한 경우)
          throw UnauthorizedException();

        case 409:
          // 모임 최대 개수(20개) 초과
          throw GroupLimitExceededException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<GroupList> getGroupList() async {
    try {
      final response = await _groupDataSource.getGroupList();
      return response.toDomain();
    } on DioException {
      throw NetworkException();
    }
  }

  @override
  Future<GroupDetail> getGroupDetail(int groupId) async {
    try {
      final response = await _groupDataSource.getGroupDetail(groupId);
      return response.toDomain();
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 403:
          // 해당 모임의 멤버가 아님
          throw NotGroupMemberException();

        case 404:
          // 모임 없음
          throw GroupNotFoundException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<InviteGroup> getInviteGroup(String inviteCode) async {
    try {
      final response = await _groupDataSource.getInviteGroup(inviteCode);
      return response.toDomain();
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? GroupJoinErrorCode.fromValue(e.response?.data['code'])
          : null;

      switch (code) {
        case GroupJoinErrorCode.invalidInviteCode:
          // 404 — 유효하지 않은 초대 코드
          throw InvalidInviteCodeException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<JoinGroup> joinGroup(String inviteCode, String nickName) async {
    try {
      final response = await _groupDataSource.joinGroup(inviteCode, nickName);
      return response.toDomain();
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? GroupJoinErrorCode.fromValue(e.response?.data['code'])
          : null;

      // 401(UNAUTHORIZED)은 인터셉터에서 따로 처리하므로 여기서 다루지 않는다.
      switch (code) {
        case GroupJoinErrorCode.invalidInput:
          // 400 — inviteCode/nickname 누락 또는 nickname 2~10자 위반
          throw InvalidJoinInputException();

        case GroupJoinErrorCode.invalidInviteCode:
          // 404 — 유효하지 않은 초대 코드
          throw InvalidInviteCodeException();

        case GroupJoinErrorCode.alreadyJoinedGroup:
          // 409 — 이미 참여 중인 모임
          throw AlreadyJoinedGroupException();

        case GroupJoinErrorCode.groupFull:
          // 409 — 모임 정원(8명) 가득 참
          throw GroupFullException();

        case GroupJoinErrorCode.groupLimitExceeded:
          // 409 — 모임 최대 개수(20개) 초과
          throw GroupLimitExceededException();

        case GroupJoinErrorCode.duplicateGroupNickname:
          // 409 — 모임 내 닉네임 중복
          throw DuplicateGroupNicknameException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<void> exitGroup(int groupId) async {
    try {
      await _groupDataSource.exitGroup(groupId);
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? GroupExitErrorCode.fromValue(e.response?.data['code'])
          : null;

      switch (code) {
        case GroupExitErrorCode.notGroupMember:
          // 403 — 해당 모임의 멤버가 아님
          throw NotGroupMemberException();

        case GroupExitErrorCode.groupNotFound:
          // 404 — 모임을 찾을 수 없음
          throw GroupNotFoundException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<HistoryCycles> getHistoryCycles(int groupId) async {
    try {
      final response = await _groupDataSource.getHistoryCycles(groupId);
      return response.toDomain();
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? GroupHistoryErrorCode.fromValue(e.response?.data['code'])
          : null;

      switch (code) {
        case GroupHistoryErrorCode.notGroupMember:
          // 403 — 해당 모임의 멤버가 아님
          throw NotGroupMemberException();

        case GroupHistoryErrorCode.groupNotFound:
          // 404 — 모임을 찾을 수 없음
          throw GroupNotFoundException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<ChangeNickName> changeNickName(int groupId, String nickName) async {
    try {
      final response = await _groupDataSource.changeNickName(groupId, nickName);
      return response.toDomain();
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? GroupChangeNickNameErrorCode.fromValue(e.response?.data['code'])
          : null;

      // 401(UNAUTHORIZED)은 인터셉터에서 따로 처리하므로 여기서 다루지 않는다.
      switch (code) {
        case GroupChangeNickNameErrorCode.invalidInput:
          // 400 — nickname 누락 또는 2~10자 위반
          throw InvalidNicknameException();

        case GroupChangeNickNameErrorCode.notGroupMember:
          // 403 — 해당 모임의 멤버가 아님
          throw NotGroupMemberException();

        case GroupChangeNickNameErrorCode.groupNotFound:
          // 404 — 모임을 찾을 수 없음
          throw GroupNotFoundException();

        case GroupChangeNickNameErrorCode.duplicateGroupNickname:
          // 409 — 모임 내 닉네임 중복
          throw DuplicateGroupNicknameException();

        default:
          throw NetworkException();
      }
    }
  }
}
