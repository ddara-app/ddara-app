/// 스티커 세트. 값의 [name] 이 그대로 에셋 폴더명이 된다.
/// (`assets/images/sticker/<set>/`)
enum StickerSet { doodle, pastel, collage }

/// 스티커 한 장. [fileName] 은 확장자를 뺀 파일명.
final class StickerData {
  const StickerData(this.set, this.fileName);

  final StickerSet set;
  final String fileName;

  String get assetPath => 'assets/images/sticker/${set.name}/$fileName.png';
}

/// 앱에서 쓰는 스티커의 단일 진실 공급원.
///
/// 화면 코드는 에셋 경로를 직접 쓰지 않고 이 목록을 통해서만 스티커를
/// 참조한다. 스티커 추가·교체는 여기 한 줄 수정으로 끝난다.
///
/// 아이콘은 [AppIcons] 로 분리되어 있다. 스티커는 원본 색을 그대로 쓰는
/// 장식 요소라 색을 덧입히지 말 것.
abstract final class AppStickers {
  const AppStickers._();

  /// 손그림 두들. (기본 세트)
  static const doodle = <StickerData>[
    StickerData(StickerSet.doodle, '01_heart'),
    StickerData(StickerSet.doodle, '02_sparkles'),
    StickerData(StickerSet.doodle, '03_crown'),
    StickerData(StickerSet.doodle, '04_curved_arrow'),
    StickerData(StickerSet.doodle, '05_smiley'),
    StickerData(StickerSet.doodle, '06_daisy'),
    StickerData(StickerSet.doodle, '07_lightning'),
    StickerData(StickerSet.doodle, '08_speech_bubble'),
    StickerData(StickerSet.doodle, '09_squiggle'),
    StickerData(StickerSet.doodle, '10_circle_highlight'),
    StickerData(StickerSet.doodle, '11_double_underline'),
    StickerData(StickerSet.doodle, '12_doodle_star'),
    StickerData(StickerSet.doodle, '13_emphasis_rays'),
    StickerData(StickerSet.doodle, '14_rough_frame'),
    StickerData(StickerSet.doodle, '15_check'),
  ];

  /// 파스텔 톤.
  static const pastel = <StickerData>[
    StickerData(StickerSet.pastel, '01_scribble_heart'),
    StickerData(StickerSet.pastel, '02_wonky_smiley'),
    StickerData(StickerSet.pastel, '03_shooting_star'),
    StickerData(StickerSet.pastel, '04_bow'),
    StickerData(StickerSet.pastel, '05_flame'),
    StickerData(StickerSet.pastel, '06_spiral'),
    StickerData(StickerSet.pastel, '07_rainbow'),
    StickerData(StickerSet.pastel, '08_flower_cluster'),
    StickerData(StickerSet.pastel, '09_confetti'),
    StickerData(StickerSet.pastel, '10_looping_arrow'),
  ];

  /// 콜라주·진(zine) 스타일.
  static const collage = <StickerData>[
    StickerData(StickerSet.collage, '01_halftone_heart'),
    StickerData(StickerSet.collage, '02_checker_star'),
    StickerData(StickerSet.collage, '03_cutout_eye'),
    StickerData(StickerSet.collage, '04_ink_cherries'),
    StickerData(StickerSet.collage, '05_zine_dice'),
    StickerData(StickerSet.collage, '06_chain_heart'),
    StickerData(StickerSet.collage, '07_safety_pin'),
    StickerData(StickerSet.collage, '08_comic_burst'),
    StickerData(StickerSet.collage, '09_tape_x'),
    StickerData(StickerSet.collage, '10_torn_photo_frame'),
  ];

  /// 세트별 목록. (스티커 피커의 탭·섹션 순서)
  static const bySet = <StickerSet, List<StickerData>>{
    StickerSet.doodle: doodle,
    StickerSet.pastel: pastel,
    StickerSet.collage: collage,
  };
}
