import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// 재인코딩 품질. 업로드 직전 한 번 더 압축(85)되므로 여기서는 눈에 띄는
/// 열화만 막을 정도로 충분히 높게 잡는다. (100 은 파일만 몇 배로 커진다)
const int _jpegQuality = 95;

/// [path] 이미지를 좌우 반전해 같은 경로에 덮어쓰고, 그 경로를 돌려준다.
///
/// 전면 카메라 프리뷰는 플랫폼이 거울상으로 보여 주지만 `takePicture()` 가
/// 남기는 파일은 반전되지 않은 원본이라, 확인 화면에서 좌우가 뒤집혀 보인다.
/// 촬영 직후 이 함수로 파일 자체를 프리뷰와 같은 좌우로 맞춘다.
///
/// 디코딩·인코딩은 [compute] 로 별도 isolate 에서 처리해 촬영 직후 UI 가
/// 멈추지 않게 한다. 실패하면 파일을 건드리지 않고 원본 경로를 그대로
/// 돌려준다. (사진을 잃는 것보다 좌우가 뒤집힌 채 남는 편이 낫다)
Future<String> mirrorImageFile(String path) async {
  try {
    final file = File(path);
    final mirrored = await compute(_mirrorBytes, await file.readAsBytes());
    if (mirrored == null) return path;

    await file.writeAsBytes(mirrored, flush: true);
    return path;
  } catch (_) {
    return path;
  }
}

/// isolate 에서 도는 실제 반전 작업. 디코딩에 실패하면 null.
Uint8List? _mirrorBytes(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;

  // 촬영본은 회전 정보를 EXIF 로만 갖고 있을 수 있다. 픽셀에 먼저 구워
  // 방향을 확정한 뒤 반전해야, EXIF 를 읽는 쪽과 읽지 않는 쪽에서 결과가
  // 갈리지 않는다. (bakeOrientation 은 굽고 나서 orientation 을 비운다)
  final baked = img.bakeOrientation(decoded);

  return img.encodeJpg(img.flipHorizontal(baked), quality: _jpegQuality);
}
