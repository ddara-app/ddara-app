import 'package:ddara/core/model/cycle/follower_upload.dart';
import 'package:ddara/core/model/cycle/starter_upload.dart';
import 'package:ddara/core/network/dto/cycle/follower_upload_response.dart';
import 'package:ddara/core/network/dto/cycle/starter_upload_response.dart';

extension StarterUploadMapper on StarterUploadResponse {
  StarterUpload toDomain() {
    return StarterUpload(cycleId: cycleId);
  }
}

extension FollowerUploadMapper on FollowerUploadResponse {
  FollowerUpload toDomain() {
    return FollowerUpload(cycleId: cycleId);
  }
}
