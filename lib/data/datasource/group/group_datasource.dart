import 'package:ddara/core/network/dto/group/change_nickname_response.dart';
import 'package:ddara/core/network/dto/group/create_group_response.dart';
import 'package:ddara/core/network/dto/group/group_detail_response.dart';
import 'package:ddara/core/network/dto/group/group_list_response.dart';
import 'package:ddara/core/network/dto/group/history_cycles_response.dart';
import 'package:ddara/core/network/dto/group/invite_group_response.dart';
import 'package:ddara/core/network/dto/group/join_group_response.dart';
import 'package:dio/dio.dart';

class GroupDataSource {
  GroupDataSource(this._dio);

  final Dio _dio;
  static final String _baseUrl = '/api/groups';

  Future<CreateGroupResponse> createGroup(
    String groupName,
    String description,
    String nickName,
  ) async {
    final response = await _dio.post(
      _baseUrl,
      data: {
        'name': groupName,
        'description': description,
        'nickname': nickName,
      },
    );

    return CreateGroupResponse.fromJson(response.data);
  }

  Future<GroupListResponse> getGroupList() async {
    final response = await _dio.get(_baseUrl);

    return GroupListResponse.fromJson(response.data);
  }

  Future<GroupDetailResponse> getGroupDetail(int groupId) async {
    final response = await _dio.get('$_baseUrl/$groupId');

    return GroupDetailResponse.fromJson(response.data);
  }

  Future<InviteGroupResponse> getInviteGroup(String inviteCode) async {
    final response = await _dio.get('$_baseUrl/preview?inviteCode=$inviteCode');

    return InviteGroupResponse.fromJson(response.data);
  }

  Future<JoinGroupResponse> joinGroup(
    String inviteCode,
    String nickName,
  ) async {
    final response = await _dio.post(
      '$_baseUrl/join',
      data: {'inviteCode': inviteCode, 'nickname': nickName},
    );

    return JoinGroupResponse.fromJson(response.data);
  }

  Future<void> exitGroup(int groupId) async {
    await _dio.delete('$_baseUrl/$groupId/members/me');
  }

  Future<HistoryCyclesResponse> getHistoryCycles(int groupId) async {
    final response = await _dio.get('$_baseUrl/$groupId/cycles?status=done');

    return HistoryCyclesResponse.fromJson(response.data);
  }

  Future<ChangeNickNameResponse> changeNickName(int groupId, String nickName) async {
    final response = await _dio.patch('$_baseUrl/$groupId/members/me/nickname', data: {'nickname': nickName});
    return ChangeNickNameResponse.fromJson(response.data);
  }
}
