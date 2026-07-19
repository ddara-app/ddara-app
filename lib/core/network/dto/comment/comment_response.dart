import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_response.freezed.dart';
part 'comment_response.g.dart';

/// `POST /api/shots/{shotId}/comments` 응답 DTO.
@freezed
abstract class CommentResponse with _$CommentResponse {
  const factory CommentResponse({
    required int commentId,
    required int userId,
    required String nickname,
    // 프로필 이미지 URL. 없으면 null.
    required String? profileImageUrl,
    required String content,
    required DateTime createdAt,
  }) = _CommentResponse;

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentResponseFromJson(json);
}
