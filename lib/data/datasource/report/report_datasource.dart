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

  /// 유저(USER)를 신고한다. (응답 본문 없음)
  ///
  /// 유저 신고는 대상이 속한 모임 안에서만 접수되므로 [groupId] 가 필수다.
  Future<void> reportUser({
    required int userId,
    required int groupId,
    required String reasonCode,
    String? reasonText,
  }) async {
    await _dio.post(
      _baseUrl,
      data: {
        'targetType': 'USER',
        'targetId': userId,
        'groupId': groupId,
        'reasonCode': reasonCode,
        'reasonText': reasonText,
      },
    );
  }
}
