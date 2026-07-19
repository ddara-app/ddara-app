import 'package:ddara/core/exception/comment_error_code.dart';
import 'package:ddara/core/exception/comment_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/core/model/comment/comment.dart';
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
      final code = e.response?.data is Map
          ? CommentErrorCode.fromValue(e.response?.data['code'])
          : null;

      // 401(미인증)은 인터셉터에서 따로 처리하므로 여기서 다루지 않는다.
      switch (code) {
        case CommentErrorCode.invalidInput:
          // 400 — content 누락, 공백만 입력, 200자 초과
          throw InvalidCommentInputException();

        case CommentErrorCode.notGroupMember:
          // 403 — 해당 사진이 속한 모임의 멤버가 아님
          throw NotGroupMemberException();

        case CommentErrorCode.shotLocked:
          // 403 — 잠금 상태의 사진 (해당 회차에 인증샷 미업로드)
          throw ShotLockedException();

        case CommentErrorCode.shotNotFound:
          // 404 — 사진 없음
          throw ShotNotFoundException();

        case CommentErrorCode.shotUnderReview:
          // 409 — 검토중(신고된) 사진
          throw ShotUnderReviewException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<List<Comment>> getComments(int shotId) async {
    try {
      final response = await _commentDataSource.getComments(shotId);
      return response.toDomain();
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? CommentErrorCode.fromValue(e.response?.data['code'])
          : null;

      switch (code) {
        case CommentErrorCode.notGroupMember:
          // 403 — 해당 사진이 속한 모임의 멤버가 아님
          throw NotGroupMemberException();

        case CommentErrorCode.shotNotFound:
          // 404 — 사진 없음
          throw ShotNotFoundException();

        default:
          throw NetworkException();
      }
    }
  }
}
