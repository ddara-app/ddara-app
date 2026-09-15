import 'package:ddara/core/exception/comment_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/network/dto/comment/comment_response.dart';
import 'package:ddara/data/datasource/comment/comment_datasource.dart';
import 'package:ddara/data/repository/comment_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommentDataSource extends Mock implements CommentDataSource {}

DioException _dioError({String? code}) {
  final req = RequestOptions(path: '/api/comments');
  return DioException(
    requestOptions: req,
    response: Response(
      requestOptions: req,
      statusCode: 400,
      data: code == null ? null : {'code': code},
    ),
  );
}

CommentResponse _commentResponse() {
  return CommentResponse(
    commentId: 1,
    userId: 1,
    nickname: 'nick',
    profileImageUrl: null,
    content: 'hi',
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  late MockCommentDataSource dataSource;
  late CommentRepositoryImpl repository;

  setUp(() {
    dataSource = MockCommentDataSource();
    repository = CommentRepositoryImpl(dataSource);
  });

  group('createComment', () {
    test('응답을 도메인 모델로 변환한다', () async {
      when(
        () => dataSource.createComment(shotId: 1, content: 'hi'),
      ).thenAnswer((_) async => _commentResponse());

      final result = await repository.createComment(shotId: 1, content: 'hi');

      expect(result.commentId, 1);
    });

    test('SHOT_LOCKED 코드는 ShotLockedException 으로 변환한다', () async {
      when(
        () => dataSource.createComment(
          shotId: any(named: 'shotId'),
          content: any(named: 'content'),
        ),
      ).thenThrow(_dioError(code: 'SHOT_LOCKED'));

      expect(
        () => repository.createComment(shotId: 1, content: 'hi'),
        throwsA(isA<ShotLockedException>()),
      );
    });
  });

  group('getComments', () {
    test('매칭되지 않는 code 는 NetworkException 으로 변환한다', () async {
      when(() => dataSource.getComments(any())).thenThrow(_dioError());

      expect(
        () => repository.getComments(1),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('markCommentsRead', () {
    test('shotId 를 그대로 DataSource 에 위임한다', () async {
      when(() => dataSource.markCommentsRead(1)).thenAnswer((_) async {});

      await repository.markCommentsRead(1);

      verify(() => dataSource.markCommentsRead(1)).called(1);
    });
  });

  group('deleteComment', () {
    test('COMMENT_FORBIDDEN 코드는 CommentForbiddenException 으로 변환한다', () async {
      when(() => dataSource.deleteComment(any())).thenThrow(_dioError(code: 'COMMENT_FORBIDDEN'));

      expect(
        () => repository.deleteComment(1),
        throwsA(isA<CommentForbiddenException>()),
      );
    });
  });

  group('editComment', () {
    test('수정된 content 를 반환한다', () async {
      when(
        () => dataSource.editComment(commentId: 1, content: 'edited'),
      ).thenAnswer(
        (_) async => CommentUpdateResponse(
          commentId: 1,
          content: 'edited',
          updatedAt: DateTime(2026, 1, 1),
        ),
      );

      final result = await repository.editComment(commentId: 1, content: 'edited');

      expect(result, 'edited');
    });

    test('COMMENT_NOT_FOUND 코드는 CommentNotFoundException 으로 변환한다', () async {
      when(
        () => dataSource.editComment(
          commentId: any(named: 'commentId'),
          content: any(named: 'content'),
        ),
      ).thenThrow(_dioError(code: 'COMMENT_NOT_FOUND'));

      expect(
        () => repository.editComment(commentId: 1, content: 'edited'),
        throwsA(isA<CommentNotFoundException>()),
      );
    });
  });
}
