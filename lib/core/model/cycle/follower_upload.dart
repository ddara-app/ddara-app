import 'package:freezed_annotation/freezed_annotation.dart';

part 'follower_upload.freezed.dart';

@freezed
abstract class FollowerUpload with _$FollowerUpload {
  const factory FollowerUpload({required int cycleId}) = _FollowerUpload;
}
