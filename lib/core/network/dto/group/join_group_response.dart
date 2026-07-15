import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_group_response.freezed.dart';
part 'join_group_response.g.dart';

@freezed
abstract class JoinGroupResponse with _$JoinGroupResponse {
  const factory JoinGroupResponse({
    required int groupId,
    required String name,
  }) = _JoinGroupResponse;

  factory JoinGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$JoinGroupResponseFromJson(json);
}
