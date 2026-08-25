import 'package:ddara/core/exception/block_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/domain/model/block/blocked_users.dart';
import 'package:ddara/data/datasource/block/block_datasource.dart';
import 'package:ddara/domain/repository/block_repository.dart';
import 'package:dio/dio.dart';

import 'mapper/block_mapper.dart';

class BlockRepositoryImpl implements BlockRepository {
  final BlockDataSource _blockDataSource;

  BlockRepositoryImpl(this._blockDataSource);

  @override
  Future<void> blockUser(int userId, {required int groupId}) async {
    try {
      await _blockDataSource.blockUser(userId, groupId: groupId);
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<BlockedUsers> getBlockedUsers() async {
    try {
      final response = await _blockDataSource.getBlocks();
      return response.toDomain();
    } on DioException {
      throw NetworkException();
    }
  }

  @override
  Future<void> unblockUser(int userId) async {
    try {
      await _blockDataSource.unblockUser(userId);
    } on DioException {
      // 별도 에러 코드가 없는 API 라 네트워크 오류로 통일한다.
      throw NetworkException();
    }
  }

  /// 서버 오류 응답을 도메인 예외로 옮긴다.
  /// (매칭되는 code 가 없으면 네트워크 오류로 본다)
  Exception _toException(DioException e) {
    final code = e.response?.data is Map ? e.response?.data['code'] : null;
    return BlockException.fromCode(code) ?? NetworkException();
  }
}
