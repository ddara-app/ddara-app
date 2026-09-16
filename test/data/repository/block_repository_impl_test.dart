import 'package:ddara/core/exception/block_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/network/dto/block/block_list_response.dart';
import 'package:ddara/data/datasource/block/block_datasource.dart';
import 'package:ddara/data/repository/block_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBlockDataSource extends Mock implements BlockDataSource {}

DioException _dioError({String? code}) {
  final req = RequestOptions(path: '/api/blocks');
  return DioException(
    requestOptions: req,
    response: Response(
      requestOptions: req,
      statusCode: 400,
      data: code == null ? null : {'code': code},
    ),
  );
}

void main() {
  late MockBlockDataSource dataSource;
  late BlockRepositoryImpl repository;

  setUp(() {
    dataSource = MockBlockDataSource();
    repository = BlockRepositoryImpl(dataSource);
  });

  group('blockUser', () {
    test('userId·groupId 를 그대로 DataSource 에 위임한다', () async {
      when(
        () => dataSource.blockUser(1, groupId: 2),
      ).thenAnswer((_) async {});

      await repository.blockUser(1, groupId: 2);

      verify(() => dataSource.blockUser(1, groupId: 2)).called(1);
    });

    test('USER_NOT_FOUND 코드는 BlockTargetNotFoundException 으로 변환한다', () async {
      when(
        () => dataSource.blockUser(any(), groupId: any(named: 'groupId')),
      ).thenThrow(_dioError(code: 'USER_NOT_FOUND'));

      expect(
        () => repository.blockUser(1, groupId: 2),
        throwsA(isA<BlockTargetNotFoundException>()),
      );
    });

    test('매칭되지 않는 code 는 NetworkException 으로 변환한다', () async {
      when(
        () => dataSource.blockUser(any(), groupId: any(named: 'groupId')),
      ).thenThrow(_dioError());

      expect(
        () => repository.blockUser(1, groupId: 2),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('getBlockedUsers', () {
    test('응답을 도메인 모델로 변환한다', () async {
      when(() => dataSource.getBlocks()).thenAnswer(
        (_) async => const BlockListResponse(blocks: []),
      );

      final result = await repository.getBlockedUsers();

      expect(result.users, isEmpty);
    });

    test('DioException 은 NetworkException 으로 변환한다', () async {
      when(() => dataSource.getBlocks()).thenThrow(_dioError());

      expect(
        () => repository.getBlockedUsers(),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('unblockUser', () {
    test('userId 를 그대로 DataSource 에 위임한다', () async {
      when(() => dataSource.unblockUser(1)).thenAnswer((_) async {});

      await repository.unblockUser(1);

      verify(() => dataSource.unblockUser(1)).called(1);
    });

    test('DioException 은 NetworkException 으로 변환한다', () async {
      when(() => dataSource.unblockUser(any())).thenThrow(_dioError());

      expect(
        () => repository.unblockUser(1),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
