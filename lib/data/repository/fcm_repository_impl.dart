import 'package:ddara/data/datasource/fcm/fcm_datasource.dart';
import 'package:ddara/domain/repository/fcm_repository.dart';

class FcmRepositoryImpl implements FcmRepository {
  FcmRepositoryImpl(this._dataSource);

  final FcmDataSource _dataSource;

  @override
  Future<void> registerToken(String token) => _dataSource.registerToken(token);
}
