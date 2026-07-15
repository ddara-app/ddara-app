import 'package:ddara/core/permission/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

/// `permission_handler` 기반 [PermissionService] 구현체.
class PermissionHandlerService implements PermissionService {
  const PermissionHandlerService();

  /// [PermissionStatus] 를 [PermissionResult] 로 변환.
  /// [grantedWhenLimited] 가 true 면 limited 상태도 허용으로 본다. (사진)
  PermissionResult _toResult(
    PermissionStatus status, {
    bool grantedWhenLimited = false,
  }) {
    if (status.isGranted || (grantedWhenLimited && status.isLimited)) {
      return PermissionResult.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return PermissionResult.permanentlyDenied;
    }
    return PermissionResult.denied;
  }

  @override
  Future<bool> isCameraGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  @override
  Future<bool> isCameraPermanentlyDenied() async {
    final status = await Permission.camera.status;
    return status.isPermanentlyDenied || status.isRestricted;
  }

  @override
  Future<PermissionResult> requestCamera() async {
    final status = await Permission.camera.request();
    return _toResult(status);
  }

  @override
  Future<PermissionResult> cameraStatus() async {
    return _toResult(await Permission.camera.status);
  }

  @override
  Future<bool> isNotificationGranted() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  @override
  Future<PermissionResult> requestNotification() async {
    final status = await Permission.notification.request();
    return _toResult(status);
  }

  @override
  Future<PermissionResult> notificationStatus() async {
    return _toResult(await Permission.notification.status);
  }

  @override
  Future<bool> isPhotosGranted() async {
    final status = await Permission.photos.status;
    return status.isGranted || status.isLimited;
  }

  @override
  Future<PermissionResult> requestPhotos() async {
    final status = await Permission.photos.request();
    return _toResult(status, grantedWhenLimited: true);
  }

  @override
  Future<PermissionResult> photosStatus() async {
    return _toResult(await Permission.photos.status, grantedWhenLimited: true);
  }

  @override
  Future<bool> openSettings() => openAppSettings();
}
