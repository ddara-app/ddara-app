import 'package:ddara/core/exception/comment_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/domain/model/comment/comment.dart';
import 'package:ddara/data/datasource/comment/comment_datasource.dart';
import 'package:ddara/domain/repository/comment_repository.dart';
import 'package:dio/dio.dart';

import 'mapper/comment_mapper.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentDataSource _commentDataSource;

  CommentRepositoryImpl(this._commentDataSource);

  @override
  Future<Comment> createComment({
    required int shotId,
    required String content,
  }) async {
    try {
      final response = await _commentDataSource.createComment(
        shotId: shotId,
        content: content,
      );
      return response.toDomain();
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<List<Comment>> getComments(int shotId) async {
    try {
      final response = await _commentDataSource.getComments(shotId);
      return response.toDomain();
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<void> markCommentsRead(int shotId) async {
    try {
      await _commentDataSource.markCommentsRead(shotId);
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<void> deleteComment(int commentId) async {
    try {
      await _commentDataSource.deleteComment(commentId);
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<String> editComment({
    required int commentId,
    required String content,
  }) async {
    try {
      final response = await _commentDataSource.editComment(
        commentId: commentId,
        content: content,
      );
      return response.content;
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  /// 서버 오류 응답을 도메인 예외로 옮긴다.
  /// (매칭되는 code 가 없으면 네트워크 오류로 본다)
  Exception _toException(DioException e) {
    final code = e.response?.data is Map ? e.response?.data['code'] : null;
    return CommentException.fromCode(code) ?? NetworkException();
  }
}
