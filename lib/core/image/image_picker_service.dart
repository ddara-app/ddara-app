import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

/// 카메라 촬영/갤러리 선택으로 이미지 한 장을 가져오는 서비스.
///
/// - 갤러리: OS 시스템 피커(Android Photo Picker / iOS PHPicker)를 사용하므로
///   별도 저장소 권한이 거의 필요 없다.
/// - 카메라: 카메라 권한이 필요하며, 미허용이면 OS 가 프롬프트를 띄운다.
///   (영구 거부 등으로 실패하면 예외를 삼키고 null 을 반환한다)
///
/// 사용자가 취소하거나 실패하면 `null` 을 반환한다.
class ImagePickerService {
  ImagePickerService([ImagePicker? picker]) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// 카메라로 촬영한 이미지를 반환한다. (취소·실패 시 null)
  Future<XFile?> pickFromCamera() => _pick(ImageSource.camera);

  /// 갤러리에서 선택한 이미지를 반환한다. (취소·실패 시 null)
  Future<XFile?> pickFromGallery() => _pick(ImageSource.gallery);

  Future<XFile?> _pick(ImageSource source) async {
    try {
      return await _picker.pickImage(source: source);
    } catch (_) {
      // 권한 영구 거부·플랫폼 오류 등은 삼키고 미선택으로 처리한다.
      return null;
    }
  }
}

final imagePickerServiceProvider = Provider<ImagePickerService>((ref) {
  _ensureAndroidPhotoPicker();
  return ImagePickerService();
});

/// Android 에서 레거시 `ACTION_GET_CONTENT`(구형 갤러리 — 스크롤 등 UX 문제) 대신
/// 최신 Android Photo Picker(시스템 표준 갤러리)를 사용하도록 전환한다.
///
/// 전역 플랫폼 구현에 한 번 설정하면 이후 모든 image_picker 호출에 적용된다.
/// (Android 가 아니면 [ImagePickerAndroid] 가 아니므로 아무 일도 하지 않는다)
void _ensureAndroidPhotoPicker() {
  final ImagePickerPlatform impl = ImagePickerPlatform.instance;
  if (impl is ImagePickerAndroid) {
    impl.useAndroidPhotoPicker = true;
  }
}
