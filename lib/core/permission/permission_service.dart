enum PermissionResult { granted, denied, permanentlyDenied }

abstract interface class PermissionService {
  Future<bool> isCameraGranted();

  /// 카메라 권한이 영구 거부(또는 restricted) 상태인지.
  /// true 면 `requestCamera()` 를 호출해도 OS 권한 프롬프트가 더 이상 뜨지 않는다.
  Future<bool> isCameraPermanentlyDenied();

  Future<PermissionResult> requestCamera();

  /// 프롬프트 없이 현재 카메라 권한 상태만 읽는다.
  /// (요청 다이얼로그가 뒤로가기로 닫혀 요청 결과를 못 받았을 때 복구용)
  Future<PermissionResult> cameraStatus();

  Future<bool> isNotificationGranted();

  Future<PermissionResult> requestNotification();

  /// 프롬프트 없이 현재 알림 권한 상태만 읽는다.
  Future<PermissionResult> notificationStatus();

  Future<bool> isPhotosGranted();

  Future<PermissionResult> requestPhotos();

  /// 프롬프트 없이 현재 저장공간(사진) 권한 상태만 읽는다.
  Future<PermissionResult> photosStatus();

  Future<bool> openSettings();
}
