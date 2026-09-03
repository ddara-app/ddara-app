import 'dart:io';

import 'package:ddara/core/design_system/theme/app_colors.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

/// 카메라 촬영/갤러리 선택으로 이미지 한 장을 가져오고, 원하는 영역만 잘라주는 서비스.
///
/// - 갤러리: OS 시스템 피커(Android Photo Picker / iOS PHPicker)를 사용하므로
///   별도 저장소 권한이 거의 필요 없다.
/// - 카메라: 카메라 권한이 필요하며, 미허용이면 OS 가 프롬프트를 띄운다.
///   (영구 거부 등으로 실패하면 예외를 삼키고 null 을 반환한다)
/// - 크롭: 네이티브 크롭 UI(Android uCrop / iOS TOCropViewController)로 원형 크롭.
///
/// 사용자가 취소하거나 실패하면 `null` 을 반환한다.
class ImagePickerService {
  ImagePickerService([ImagePicker? picker, ImageCropper? cropper])
    : _picker = picker ?? ImagePicker(),
      _cropper = cropper ?? ImageCropper();

  final ImagePicker _picker;
  final ImageCropper _cropper;

  /// 카메라로 촬영한 이미지를 반환한다. (취소·실패 시 null)
  Future<XFile?> pickFromCamera() => _pick(ImageSource.camera);

  /// 갤러리에서 선택한 이미지를 반환한다. (취소·실패 시 null)
  Future<XFile?> pickFromGallery() => _pick(ImageSource.gallery);

  Future<XFile?> _pick(ImageSource source) async {
    try {
      return await _picker.pickImage(source: source);
    } catch (e) {
      // 권한 영구 거부·플랫폼 오류 등은 삼키고 미선택으로 처리한다.
      debugPrint('[ImagePicker] 선택 실패: $e');
      return null;
    }
  }

  /// [sourcePath] 이미지를 원형(1:1 원)으로 잘라 반환한다. (원형 프로필 아바타용)
  ///
  /// 크롭 UI 에 원형 마스크를 씌워 원 안 영역만 이동/확대해 지정한다. 원형이라
  /// 코너가 투명해지므로 투명도를 보존하도록 PNG 로 출력한다.
  /// 취소·실패 시 null 을 반환한다. [title] 은 네이티브 크롭 UI 의 툴바
  /// 제목으로, 호출부에서 l10n 값을 넘긴다.
  ///
  /// 크롭 결과는 별도 파일로 생성되므로, 성공·취소와 무관하게 크롭을 마치면
  /// 피커가 만든 원본 사본([sourcePath])은 임시 파일이 쌓이지 않도록 삭제한다.
  Future<XFile?> cropToCircle(
    String sourcePath, {
    required String title,
  }) async {
    try {
      final CroppedFile? cropped = await _cropper.cropImage(
        sourcePath: sourcePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        // 원형 크롭은 코너가 투명 → 투명도 보존 위해 PNG.
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: title,
            // 앱 다크 테마에 맞춘 툴바/배경/강조 색.
            toolbarColor: AppColors.bgBase,
            toolbarWidgetColor: AppColors.textPrimary,
            backgroundColor: AppColors.bgBase,
            activeControlsWidgetColor: AppColors.accentDefault,
            statusBarLight: false,
            // 원형 마스크 + 정사각 비율 고정. (하단 컨트롤 숨겨 이동/확대만)
            cropStyle: CropStyle.circle,
            lockAspectRatio: true,
            hideBottomControls: true,
            // 원형 위에 겹치는 사각 격자 + 사각 프레임 제거. (원만 보이게)
            showCropGrid: false,
            cropFrameColor: AppColors.bgTransparent,
            initAspectRatio: CropAspectRatioPreset.square,
            aspectRatioPresets: const [CropAspectRatioPreset.square],
          ),
          IOSUiSettings(
            title: title,
            cropStyle: CropStyle.circle,
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
            aspectRatioPresets: const [CropAspectRatioPreset.square],
          ),
        ],
      );
      return cropped == null ? null : XFile(cropped.path);
    } catch (e) {
      debugPrint('[ImagePicker] 크롭 실패: $e');
      return null;
    } finally {
      try {
        await File(sourcePath).delete();
      } catch (_) {
        // 삭제 실패는 무시한다. (OS 가 임시 디렉토리를 주기적으로 정리)
      }
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
