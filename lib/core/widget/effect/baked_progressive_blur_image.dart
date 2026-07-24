import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

/// ProgressiveBlurImage 와 같은 점진 블러를 "베이크" 방식으로 내는 버전.
///
/// 매 프레임 블러를 다시 계산하는 대신, 원본이 디코딩되면 오프스크린
/// 캔버스에서 단계별 블러 레이어를 한 번만 합성해 알파 오버레이([ui.Image])로
/// 굽고 LRU 캐시에 둔다. 이후엔 선명한 원본 위에 그 텍스처 한 장만 얹으므로
/// 스크롤 중 블러 계산이 전혀 실행되지 않는다.
/// (배경 원리: docs/tech_notes/progressive_blur_cost.md)
///
/// 오버레이의 상단(선명 구간)은 어차피 완전 투명이라 굽지 않는다. 블러가
/// 실제로 보이는 하단 스트립만 물리 해상도 그대로 구워 하단에 정렬해 얹으므로,
/// 표시 시 확대가 없어(1:1) 픽셀이 드러나지 않으면서 메모리 부담도 적다.
/// 오버레이가 준비되기 전에는 [builder] 의 선명한 원본만 보인다.
/// (베이크는 디코딩 직후 1회뿐이라 짧다)
class BakedProgressiveBlurImage extends StatefulWidget {
  const BakedProgressiveBlurImage({
    super.key,
    required this.imageUrl,
    required this.builder,
    this.sigma = 12,
    this.sharpUntil = 0.55,
    this.steps = 3,
  });

  /// 블러를 구울 원본 이미지 URL. [builder] 가 그리는 이미지와 같아야 하며,
  /// 같은 URL 은 이미지 캐시를 공유하므로 중복 요청되지 않는다.
  final String imageUrl;

  /// 선명 레이어로 그릴 위젯 빌더. (자리표시·에러 처리 포함)
  final WidgetBuilder builder;

  /// 하단에서 도달하는 최대 블러 세기. (논리 픽셀 기준)
  final double sigma;

  /// 위에서부터 이 비율까지는 선명하게 두고, 이후 하단까지 서서히 블러로 전환. (0~1)
  final double sharpUntil;

  /// 블러 세기 단계 수. 베이크 시 1회만 계산하므로 늘려도 런타임 비용은 없다.
  final int steps;

  /// 베이크 해상도 배율. (물리 픽셀 대비)
  ///
  /// 1.0 = 물리 해상도 그대로(표시 시 확대 없음). 블러가 보이는 하단
  /// 스트립만 굽기 때문에 전체를 절반 해상도로 굽던 것과 메모리가 비슷하다.
  /// 논리 픽셀 기준으로 잡으면 고밀도 화면(dpr 2~3)에서 확대되어 픽셀이
  /// 드러나므로 반드시 물리 픽셀 기준을 유지할 것.
  static const double _bakeScale = 1.0;

  @override
  State<BakedProgressiveBlurImage> createState() =>
      _BakedProgressiveBlurImageState();
}

class _BakedProgressiveBlurImageState extends State<BakedProgressiveBlurImage> {
  ImageStream? _stream;
  late final ImageStreamListener _listener = ImageStreamListener(
    _onImage,
    // 원본 로드 실패 시 블러 없이 builder(에러 위젯)만 보인다.
    onError: (Object _, StackTrace? _) {},
  );

  /// 디코딩된 원본. 오버레이 베이크의 입력.
  ImageInfo? _source;

  /// 베이크된 블러 오버레이와 그 캐시 키.
  ui.Image? _overlay;
  String? _overlayKey;

  /// 오버레이(하단 스트립)가 표시 영역에서 차지하는 높이 비율. (0~1)
  double _overlayHeightFactor = 1;

  /// 진행 중인 베이크의 캐시 키. (중복 베이크 방지)
  String? _bakingKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(BakedProgressiveBlurImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _source?.dispose();
      _source = null;
      _overlay?.dispose();
      _overlay = null;
      _overlayKey = null;
      _overlayHeightFactor = 1;
      _bakingKey = null;
      _resolveImage();
    }
  }

  @override
  void dispose() {
    _stream?.removeListener(_listener);
    _source?.dispose();
    _overlay?.dispose();
    super.dispose();
  }

  void _resolveImage() {
    final stream = CachedNetworkImageProvider(
      widget.imageUrl,
    ).resolve(createLocalImageConfiguration(context));
    if (stream.key == _stream?.key) return;
    _stream?.removeListener(_listener);
    _stream = stream..addListener(_listener);
  }

  void _onImage(ImageInfo info, bool _) {
    if (!mounted) {
      info.dispose();
      return;
    }
    _source?.dispose();
    setState(() => _source = info);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final source = _source;
        if (source != null) {
          _ensureBaked(
            source.image,
            constraints,
            MediaQuery.devicePixelRatioOf(context),
          );
        }
        final overlay = _overlay;
        return Stack(
          fit: StackFit.expand,
          children: [
            // 맨 아래: 선명한 원본. (전체 해상도)
            widget.builder(context),
            // 그 위: 베이크된 점진 블러 오버레이(하단 스트립, 위쪽은 투명).
            // 물리 해상도 1:1 이라 리샘플링이 사실상 없으므로 bilinear 로 충분.
            if (overlay != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: _overlayHeightFactor,
                  child: RawImage(
                    image: overlay,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.low,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// 현재 원본·표시 크기에 맞는 오버레이가 없으면 베이크를 시작한다.
  void _ensureBaked(
    ui.Image source,
    BoxConstraints constraints,
    double devicePixelRatio,
  ) {
    // 표시 크기를 모르면(무한 제약) 원본의 논리 크기로 대체한다.
    final boxWidth = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : source.width / devicePixelRatio;
    final boxHeight = constraints.maxHeight.isFinite
        ? constraints.maxHeight
        : source.height / devicePixelRatio;
    // 스트립 시작점: 전환 시작(sharpUntil)보다 sigma 만큼 위. 마스크 알파가
    // 0이라 보이지 않는 여유 구간까지 포함해 구워야, 알파가 생기는 지점의
    // 블러가 스트립 위쪽의 실제 내용을 샘플링할 수 있다.
    final stripTop = math.max(
      0.0,
      widget.sharpUntil - widget.sigma / boxHeight,
    );
    final (width, height) = _overlaySizeOf(
      source,
      boxWidth,
      boxHeight,
      stripTop,
      devicePixelRatio,
    );
    // 오버레이는 표시 영역에 1:1 로 얹히므로 "베이크 픽셀당 논리 픽셀 수"
    // 만큼 sigma 를 줄여야 화면에서 같은 세기가 된다. (원본이 작아 축소해
    // 구운 경우에도 이 비율에 자동 반영된다)
    final sigmaScale = width / boxWidth;
    final key =
        '${widget.imageUrl}#${width}x$height'
        '#s${widget.sigma}#u${widget.sharpUntil}#n${widget.steps}';
    if (key == _overlayKey || key == _bakingKey) return;
    _bakingKey = key;
    final future = _BakedBlurOverlayCache.instance.obtain(key, () {
      // 베이크가 끝날 때까지 원본이 처분되지 않도록 클론을 쥐고 시작한다.
      final src = source.clone();
      return _bake(
        src,
        width,
        height,
        sigmaScale,
        stripTop,
      ).whenComplete(src.dispose);
    });
    unawaited(
      future.then(
        (image) {
          if (!mounted || _bakingKey != key) {
            image.dispose();
            return;
          }
          _overlay?.dispose();
          setState(() {
            _overlay = image;
            _overlayKey = key;
            _overlayHeightFactor = 1 - stripTop;
            _bakingKey = null;
          });
        },
        onError: (Object _, StackTrace _) {
          if (_bakingKey == key) _bakingKey = null;
        },
      ),
    );
  }

  /// 오버레이(하단 스트립) 베이크 크기: 표시 폭 × 스트립 높이의 물리 해상도.
  ///
  /// 반드시 원본이 아닌 "표시 영역" 기준이어야 한다. 원본 비율로 구우면
  /// cover 크롭 때 그라데이션 하단(블러가 가장 센 구간)이 잘려 나가,
  /// 화면에는 전환 중간까지만 보여 블러가 약해 보인다. 마스크는 라이브
  /// 버전처럼 카드 높이 기준으로 걸려야 한다.
  (int, int) _overlaySizeOf(
    ui.Image source,
    double boxWidth,
    double boxHeight,
    double stripTop,
    double devicePixelRatio,
  ) {
    final bakeScale = BakedProgressiveBlurImage._bakeScale * devicePixelRatio;
    final width = boxWidth * bakeScale;
    final height = boxHeight * (1 - stripTop) * bakeScale;
    // 원본(cover 크롭 후)에 남는 픽셀보다 크게 굽지 않는다.
    final boxAspect = boxWidth / boxHeight;
    final srcAspect = source.width / source.height;
    final cropWidth = srcAspect > boxAspect
        ? source.height * boxAspect
        : source.width.toDouble();
    final shrink = math.min(1.0, cropWidth / width);
    return (
      math.max(1, (width * shrink).round()),
      math.max(1, (height * shrink).round()),
    );
  }

  /// ProgressiveBlurImage 가 매 프레임 하던 합성을 오프스크린에서 1회 수행한다.
  /// 단계별 블러 레이어를 세로 그라데이션 마스크로 겹쳐, 표시 영역 하단
  /// [stripTop]~1.0 구간에 해당하는 알파 오버레이 스트립을 만든다.
  Future<ui.Image> _bake(
    ui.Image source,
    int width,
    int height,
    double sigmaScale,
    double stripTop,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final bounds = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
    final stripHeightFactor = 1 - stripTop;
    // 표시 영역(전체 박스) 비율에 맞춰 원본을 중앙 cover 크롭한 뒤,
    // 그중 하단 스트립 구간만 취한다.
    // (선명 레이어 CachedNetworkImage 의 BoxFit.cover 와 같은 크롭)
    final boxAspect = width * stripHeightFactor / height;
    final srcAspect = source.width / source.height;
    final Rect cropRect;
    if (srcAspect > boxAspect) {
      final cropWidth = source.height * boxAspect;
      cropRect = Rect.fromLTWH(
        (source.width - cropWidth) / 2,
        0,
        cropWidth,
        source.height.toDouble(),
      );
    } else {
      final cropHeight = source.width / boxAspect;
      cropRect = Rect.fromLTWH(
        0,
        (source.height - cropHeight) / 2,
        source.width.toDouble(),
        cropHeight,
      );
    }
    final srcRect = Rect.fromLTWH(
      cropRect.left,
      cropRect.top + cropRect.height * stripTop,
      cropRect.width,
      cropRect.height * stripHeightFactor,
    );
    final bandWidth = (1 - widget.sharpUntil) / widget.steps;
    for (var step = 1; step <= widget.steps; step++) {
      // ease-in(제곱) 진행: 첫 단계는 약하게 시작해 마지막 단계에 sigma 도달.
      final progress = step / widget.steps;
      // 저해상도 캔버스이므로 sigma 도 같은 비율로 줄여 같은 세기를 낸다.
      final layerSigma = widget.sigma * progress * progress * sigmaScale;
      // 마스크 위치(전체 박스 기준)를 스트립 좌표계로 변환한다.
      final fadeStart =
          (widget.sharpUntil + (step - 1) * bandWidth - stripTop) /
          stripHeightFactor;
      final fadeEnd =
          (widget.sharpUntil + step * bandWidth - stripTop) / stripHeightFactor;
      canvas.saveLayer(bounds, Paint());
      canvas.drawImageRect(
        source,
        srcRect,
        bounds,
        Paint()
          // 원본을 크게 축소해 그리므로 mipmap(medium)으로 계단 현상을 막는다.
          // (약한 sigma 단계에선 축소 앨리어싱이 블러에 가려지지 않는다)
          ..filterQuality = FilterQuality.medium
          ..imageFilter = ui.ImageFilter.blur(
            sigmaX: layerSigma,
            sigmaY: layerSigma,
            // 가장자리에서 알파가 빠져 아래가 비치지 않도록 clamp.
            tileMode: ui.TileMode.clamp,
          ),
      );
      // 자기 구간에서 페이드 인하는 세로 마스크. (ShaderMask dstIn 과 동일)
      canvas.drawRect(
        bounds,
        Paint()
          ..blendMode = BlendMode.dstIn
          ..shader = ui.Gradient.linear(
            bounds.topCenter,
            bounds.bottomCenter,
            const [
              Color(0x00000000),
              Color(0x00000000),
              Color(0xFF000000),
              Color(0xFF000000),
            ],
            [0.0, fadeStart, fadeEnd, 1.0],
          ),
      );
      canvas.restore();
    }
    final picture = recorder.endRecording();
    try {
      return await picture.toImage(width, height);
    } finally {
      picture.dispose();
    }
  }
}

/// 베이크된 블러 오버레이의 LRU 캐시. (키: URL + 크기 + 블러 파라미터)
///
/// 캐시가 원본 핸들을 소유하고 사용처엔 [ui.Image.clone] 을 넘긴다. 클론이
/// 살아 있는 동안 픽셀 버퍼가 유지되므로, 화면에 보이는 중에 축출돼도 안전하다.
class _BakedBlurOverlayCache {
  _BakedBlurOverlayCache._();

  static final _BakedBlurOverlayCache instance = _BakedBlurOverlayCache._();

  /// 최대 보관 장수. 하단 스트립만 물리 해상도로 굽기 때문에 홈 카드(dpr 3)
  /// 기준 장당 700~800KB — 상한을 채워도 총 ~20MB 수준이다.
  static const int _maxEntries = 24;

  /// 삽입 순서가 곧 LRU 순서. (접근 시 제거 후 재삽입)
  final _entries = <String, Future<ui.Image>>{};

  Future<ui.Image> obtain(String key, Future<ui.Image> Function() bake) {
    final existing = _entries.remove(key);
    if (existing != null) {
      _entries[key] = existing;
      return existing.then((image) => image.clone());
    }
    final created = bake();
    _entries[key] = created;
    // 실패한 베이크는 캐시에 남기지 않는다. (다음 요청에서 재시도)
    unawaited(
      created.then(
        (_) {},
        onError: (Object _, StackTrace _) {
          if (identical(_entries[key], created)) _entries.remove(key);
        },
      ),
    );
    if (_entries.length > _maxEntries) {
      final evicted = _entries.remove(_entries.keys.first)!;
      // 방금 나간 클론 요청(마이크로태스크)이 끝난 뒤 처분되도록 한 틱 늦춘다.
      unawaited(
        evicted.then(
          (image) => Future(image.dispose),
          onError: (Object _, StackTrace _) {},
        ),
      );
    }
    return created.then((image) => image.clone());
  }
}