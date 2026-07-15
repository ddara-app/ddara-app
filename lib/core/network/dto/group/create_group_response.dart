import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_group_response.freezed.dart';
part 'create_group_response.g.dart';

@freezed
abstract class CreateGroupResponse with _$CreateGroupResponse {
  const factory CreateGroupResponse({
    required int groupId,
    required String name,
    required String description,
    required String inviteCode,
    required DateTime createdAt,
  }) = _CreateGroupResponse;

  factory CreateGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateGroupResponseFromJson(json);
}
