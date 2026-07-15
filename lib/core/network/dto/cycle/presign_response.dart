import 'package:freezed_annotation/freezed_annotation.dart';

part 'presign_response.freezed.dart';
part 'presign_response.g.dart';

@freezed
abstract class PresignResponse with _$PresignResponse {
  const factory PresignResponse({
    /// S3에 직접 PUT 업로드할 presigned URL. (서명·만료 쿼리 포함)
    required String uploadUrl,

    /// 업로드 완료 후 서버에 넘길 최종 접근 URL.
    required String imageUrl,

    /// presigned URL 만료까지 남은 시간(초).
    required int expiresIn,
  }) = _PresignResponse;

  factory PresignResponse.fromJson(Map<String, dynamic> json) =>
      _$PresignResponseFromJson(json);
}
