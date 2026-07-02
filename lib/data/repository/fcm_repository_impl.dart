import 'package:ddara/core/network/dto/fcm/fcm_token_request.dart';
import 'package:ddara/data/datasource/fcm/fcm_datasource.dart';
import 'package:ddara/domain/repository/fcm_repository.dart';

class FcmRepositoryImpl implements FcmRepository {
  FcmRepositoryImpl(this._dataSource);

  final FcmDataSource _dataSource;

  @override
  Future<void> registerToken({
    required String token,
    required String platform,
  }) async {
    await _dataSource.registerToken(
      FcmTokenRequest(token: token, platform: platform),
    );
  }

  @override
  Future<void> deleteToken(String token) async {
    await _dataSource.deleteToken(token);
  }
}
