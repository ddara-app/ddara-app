import 'package:flutter/cupertino.dart';

/// 아이콘 소스 정의. 폰트 아이콘(IconData)과 SVG 에셋을 하나의 타입으로 다룬다.
/// 렌더링은 design_system/component/icon 의 AppIcon 위젯이 담당한다.
sealed class AppIconData {
  const AppIconData();

  /// 폰트 아이콘. (CupertinoIcons 등 IconData 기반)
  const factory AppIconData.font(IconData icon) = FontIconData;

  /// SVG 에셋 아이콘. [name] 은 `assets/images/<name>.svg` 의 파일명.
  const factory AppIconData.svg(String name) = SvgIconData;
}

final class FontIconData extends AppIconData {
  const FontIconData(this.icon);

  final IconData icon;
}

final class SvgIconData extends AppIconData {
  const SvgIconData(this.name);

  final String name;

  String get assetPath => 'assets/images/$name.svg';
}

/// 앱에서 쓰는 아이콘의 단일 진실 공급원.
///
/// 화면 코드는 CupertinoIcons·에셋 경로를 직접 쓰지 않고 이 목록을 통해서만
/// 아이콘을 참조한다. 아이콘 교체(폰트 ↔ SVG 포함)는 여기 한 줄 수정으로 끝난다.
abstract final class AppIcons {
  const AppIcons._();

  // chevron·내비게이션
  /// AppBar 뒤로가기. (커스텀 chevron — Material rounded 아이콘과 비교 테스트 중)
  static const back = AppIconData.svg('ic_chevron_left');
  static const chevronForward = AppIconData.svg('ic_chevron_right');
  static const chevronUp = AppIconData.svg('ic_chevron_up');
  static const chevronDown = AppIconData.svg('ic_chevron_down');
  static const chevronLeft = AppIconData.svg('ic_chevron_left');
  static const chevronRight = AppIconData.svg('ic_chevron_right');

  // 동작
  static const close = AppIconData.font(CupertinoIcons.xmark);
  static const add = AppIconData.font(CupertinoIcons.add);
  static const checkmark = AppIconData.font(CupertinoIcons.checkmark);
  /// 댓글 등록(전송) 버튼.
  static const arrowUp = AppIconData.font(CupertinoIcons.arrow_up);
  static const copy = AppIconData.font(CupertinoIcons.doc_on_clipboard);
  static const more = AppIconData.font(CupertinoIcons.ellipsis);
  static const moreVertical = AppIconData.font(CupertinoIcons.ellipsis_vertical);
  /// 따라찍기 순서 반전.
  static const reverse = AppIconData.svg('ic_reverse');

  // 촬영
  static const camera = AppIconData.font(CupertinoIcons.camera);
  /// 목록·시트용 카메라. (커스텀 SVG — 카메라 화면 안내는 [camera] 폰트 아이콘)
  static const cameraDefault = AppIconData.svg('ic_camera');
  static const flashOn = AppIconData.font(CupertinoIcons.bolt_fill);
  static const flashOff = AppIconData.font(CupertinoIcons.bolt_slash_fill);
  /// 사진 없음 placeholder. (반투명 — 카드·빈 썸네일용)
  static const gallery = AppIconData.svg('ic_image');
  /// 목록·시트용 갤러리. (커스텀 SVG — 사진 placeholder 는 [gallery])
  static const galleryDefault = AppIconData.svg('ic_image_default');

  // 상태·개체
  /// 알림 종. (홈 상단 알림 버튼 · 권한 안내 목록 공용)
  static const bell = AppIconData.svg('ic_bell');
  static const lock = AppIconData.svg('ic_lock');
  static const people = AppIconData.svg('ic_people');
  static const comment = AppIconData.svg('ic_comment');
  static const personCropCircle = AppIconData.font(
    CupertinoIcons.person_crop_circle,
  );
  /// 프로필 아바타 placeholder.
  static const personCircleFill = AppIconData.svg('ic_person_circle_fill');

  // 브랜드 (원본 색 유지 — AppIcon 에 color 를 주지 말 것)
  static const kakao = AppIconData.svg('ic_kakao');
  static const google = AppIconData.svg('ic_google');
  static const apple = AppIconData.svg('ic_apple_logo_');
}
