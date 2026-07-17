import 'package:freezed_annotation/freezed_annotation.dart';

part 'block_list_response.freezed.dart';
part 'block_list_response.g.dart';

@freezed
abstract class BlockListResponse with _$BlockListResponse {
  const factory BlockListResponse({
    required List<BlockedUserResponse> blocks,
  }) = _BlockListResponse;

  factory BlockListResponse.fromJson(Map<String, dynamic> json) =>
      _$BlockListResponseFromJson(json);
}

@freezed
abstract class BlockedUserResponse with _$BlockedUserResponse {
  const factory BlockedUserResponse({
    required int userId,
    required String name,
    required DateTime blockedAt,
  }) = _BlockedUserResponse;

  factory BlockedUserResponse.fromJson(Map<String, dynamic> json) =>
      _$BlockedUserResponseFromJson(json);
}
