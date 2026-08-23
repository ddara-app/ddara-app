import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_guide_response.freezed.dart';
part 'camera_guide_response.g.dart';

@freezed
abstract class CameraGuideResponse with _$CameraGuideResponse {
  const factory CameraGuideResponse({
    /// 이미 본 안내의 키 목록. 아무것도 안 봤으면 빈 배열.
    /// (MINI_VIEW · GHOST_VIEW)
    required List<String> seen,
  }) = _CameraGuideResponse;

  factory CameraGuideResponse.fromJson(Map<String, dynamic> json) =>
      _$CameraGuideResponseFromJson(json);
}
