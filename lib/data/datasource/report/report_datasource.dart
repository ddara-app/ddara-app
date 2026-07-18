import 'package:dio/dio.dart';

class ReportDataSource {
  ReportDataSource(this._dio);

  final Dio _dio;
  static final String _baseUrl = '/api/reports';

  /// 사진(SHOT)을 신고한다. (응답 본문 없음)
  Future<void> reportShot({
    required int shotId,
    required String reasonCode,
    String? reasonText,
  }) async {
    await _dio.post(
      _baseUrl,
      data: {
        'targetType': 'SHOT',
        'targetId': shotId,
        'reasonCode': reasonCode,
        'reasonText': reasonText,
      },
    );
  }
}
