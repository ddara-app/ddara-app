import 'package:ddara/core/exception/block_error_code.dart';
import 'package:ddara/core/exception/block_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/data/datasource/block/block_datasource.dart';
import 'package:ddara/domain/repository/block_repository.dart';
import 'package:dio/dio.dart';

class BlockRepositoryImpl implements BlockRepository {
  final BlockDataSource _blockDataSource;

  BlockRepositoryImpl(this._blockDataSource);

  @override
  Future<void> blockUser(int userId) async {
    try {
      await _blockDataSource.blockUser(userId);
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? BlockErrorCode.fromValue(e.response?.data['code'])
          : null;

      // 401(UNAUTHORIZED)은 인터셉터에서 따로 처리하므로 여기서 다루지 않는다.
      switch (code) {
        case BlockErrorCode.invalidInput:
          // 400 — userId 누락 또는 자기 자신 차단
          throw InvalidBlockInputException();

        case BlockErrorCode.userNotFound:
          // 404 — 차단 대상 유저 없음
          throw BlockTargetNotFoundException();

        default:
          throw NetworkException();
      }
    }
  }
}
