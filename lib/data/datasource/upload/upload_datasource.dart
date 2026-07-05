import 'dart:io';
import 'dart:typed_data';

import 'package:ddara/core/network/dto/cycle/presign_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// 업로드 이미지 재인코딩 포맷. (호출부가 flutter_image_compress 에 의존하지 않도록 래핑)
///
/// - [jpeg]: 용량이 작아 사진 업로드 기본값. (투명도 없음)
/// - [png]: 투명도(알파)를 보존해야 할 때. (원형 크롭 등 — 무손실이라 용량 큼)
enum UploadImageFormat {
  jpeg(CompressFormat.jpeg, 'image/jpeg'),
  png(CompressFormat.png, 'image/png');

  const UploadImageFormat(this.compressFormat, this.contentType);

  final CompressFormat compressFormat;

  /// presign·S3 PUT 에 함께 넘길 Content-Type.
  final String contentType;
}

/// S3 presigned URL 발급 + S3 직접 업로드를 담당하는 공용 데이터소스.
///
/// 여러 기능(따라찍기 사진·프로필 이미지 등)에서 공통으로 쓴다. 업로드 대상별
/// 구분은 [presign] 의 `purpose` 로 한다. (예: 'shot', 'profile')
class UploadDataSource {
  UploadDataSource(this._dio);

  final Dio _dio;

  /// 이미지를 업로드 전 리사이징·압축한 바이트를 반환한다. (실패 시 원본 바이트)
  ///
  /// 긴 변을 [maxSize] 에 맞춰 축소하고 [format] 으로 재인코딩한다.
  /// PNG 는 무손실이라 [quality] 가 무시되며 투명도가 보존된다.
  Future<Uint8List> compress(
    String imagePath, {
    int maxSize = 1080,
    int quality = 85,
    UploadImageFormat format = UploadImageFormat.jpeg,
  }) async {
    final compressed = await FlutterImageCompress.compressWithFile(
      imagePath,
      minWidth: maxSize,
      minHeight: maxSize,
      quality: quality,
      format: format.compressFormat,
    );

    return compressed ?? await File(imagePath).readAsBytes();
  }

  /// S3 업로드용 presigned URL을 발급받는다.
  Future<PresignResponse> presign(String purpose, String contentType) async {
    final response = await _dio.post(
      '/api/uploads/presign',
      data: {'purpose': purpose, 'contentType': contentType},
    );

    return PresignResponse.fromJson(response.data);
  }

  /// presigned URL로 S3에 이미지 바이트를 직접 PUT 업로드한다.
  Future<void> uploadToS3(
    String uploadUrl,
    Uint8List bytes,
    String contentType,
  ) async {
    // 인증 인터셉터·baseUrl 없는 순수 Dio로 전송한다.
    // (Authorization 헤더가 붙으면 presigned 쿼리 서명과 충돌해 S3가 거부한다)
    final s3Dio = Dio();

    await s3Dio.put(
      uploadUrl,
      data: Stream.fromIterable([bytes]),
      options: Options(
        headers: {
          Headers.contentTypeHeader: contentType,
          Headers.contentLengthHeader: bytes.length,
        },
      ),
    );
  }
}
