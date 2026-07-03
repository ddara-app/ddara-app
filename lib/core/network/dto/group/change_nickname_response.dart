import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_nickname_response.freezed.dart';
part 'change_nickname_response.g.dart';

@freezed
abstract class ChangeNickNameResponse with _$ChangeNickNameResponse {
  const factory ChangeNickNameResponse({
    required int groupId,
    required String nickname,
  }) = _ChangeNickNameResponse;

  factory ChangeNickNameResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangeNickNameResponseFromJson(json);
}
