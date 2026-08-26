import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gal/gal.dart';

/// 이미지를 기기 갤러리에 저장한 결과.
enum SaveImageResult { success, permissionDenied, failed }

/// 네트워크 이미지를 기기 갤러리(사진 앱)에 저장한다.
///
/// 저장 대상은 화면에 이미 그려진 사진이므로, 새로 내려받는 대신
/// [CachedNetworkImage] 와 같은 캐시([DefaultCacheManager])에서 파일을 꺼내 쓴다.
/// 캐시에 없을 때만 실제 다운로드가 일어난다.
class ImageSaver {
  const ImageSaver._();

  /// [url] 이미지를 갤러리에 저장한다. 실패 사유는 [SaveImageResult] 로 돌려주고,
  /// 사용자 문구는 호출부가 l10n 으로 매핑한다. ([SaveImageResultMessage])
  static Future<SaveImageResult> saveNetworkImage(String url) async {
    if (url.isEmpty) return SaveImageResult.failed;

    try {
      // 갤러리 접근 권한. (Android 10+ · iOS 14+ 는 추가 저장만 하므로 대개
      // 권한 없이 통과하고, 필요한 버전에서만 프롬프트가 뜬다)
      if (!await Gal.hasAccess()) {
        if (!await Gal.requestAccess()) {
          return SaveImageResult.permissionDenied;
        }
      }

      final file = await DefaultCacheManager().getSingleFile(url);
      await Gal.putImage(file.path);
      return SaveImageResult.success;
    } on GalException catch (e) {
      debugPrint('[ImageSaver] 저장 실패: ${e.type}');
      return e.type == GalExceptionType.accessDenied
          ? SaveImageResult.permissionDenied
          : SaveImageResult.failed;
    } catch (e) {
      // 캐시 조회·다운로드 실패 등.
      debugPrint('[ImageSaver] 저장 실패: $e');
      return SaveImageResult.failed;
    }
  }
}

extension SaveImageResultMessage on SaveImageResult {
  /// 결과를 사용자에게 보여줄 토스트 문구로 매핑한다.
  String message(AppLocalizations l10n) {
    return switch (this) {
      SaveImageResult.success => l10n.photoSaveSuccess,
      SaveImageResult.permissionDenied => l10n.photoSavePermissionDenied,
      SaveImageResult.failed => l10n.photoSaveFailed,
    };
  }

  /// 실패했는지 여부. (토스트 종류를 고르는 데 쓴다)
  bool get isFailure => this != SaveImageResult.success;
}
