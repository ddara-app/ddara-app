import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/network/dto/group/change_nickname_response.dart';
import 'package:ddara/core/network/dto/group/create_group_response.dart';
import 'package:ddara/core/network/dto/group/group_list_response.dart';
import 'package:ddara/core/network/dto/group/history_cycles_response.dart';
import 'package:ddara/core/network/dto/group/join_group_response.dart';
import 'package:ddara/data/datasource/group/group_datasource.dart';
import 'package:ddara/data/repository/group_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupDataSource extends Mock implements GroupDataSource {}

DioException _dioError({String? code, int? statusCode}) {
  final req = RequestOptions(path: '/api/groups');
  return DioException(
    requestOptions: req,
    response: Response(
      requestOptions: req,
      statusCode: statusCode ?? 400,
      data: code == null ? null : {'code': code},
    ),
  );
}

void main() {
  late MockGroupDataSource dataSource;
  late GroupRepositoryImpl repository;

  setUp(() {
    dataSource = MockGroupDataSource();
    repository = GroupRepositoryImpl(dataSource);
  });

  group('createGroup', () {
    test('409 는 GroupLimitExceededException 으로 변환한다', () async {
      when(
        () => dataSource.createGroup(any(), any(), any()),
      ).thenThrow(_dioError(statusCode: 409));

      expect(
        () => repository.createGroup('name', 'desc', 'nick'),
        throwsA(isA<GroupLimitExceededException>()),
      );
    });

    test('성공하면 응답을 도메인 모델로 변환한다', () async {
      when(() => dataSource.createGroup('name', 'desc', 'nick')).thenAnswer(
        (_) async => CreateGroupResponse(
          groupId: 1,
          name: 'name',
          description: 'desc',
          inviteCode: 'ABC123',
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      final result = await repository.createGroup('name', 'desc', 'nick');

      expect(result.groupId, 1);
    });
  });

  group('getGroupList', () {
    test('성공하면 응답을 도메인 모델로 변환한다', () async {
      when(() => dataSource.getGroupList()).thenAnswer(
        (_) async => const GroupListResponse(groups: []),
      );

      final result = await repository.getGroupList();

      expect(result.groups, isEmpty);
    });

    test('DioException 은 NetworkException 으로 변환한다', () async {
      when(() => dataSource.getGroupList()).thenThrow(_dioError());

      expect(() => repository.getGroupList(), throwsA(isA<NetworkException>()));
    });
  });

  group('getGroupDetail', () {
    test('403 이면 NotGroupMemberException 으로 변환한다', () async {
      when(() => dataSource.getGroupDetail(any())).thenThrow(_dioError(statusCode: 403));

      expect(
        () => repository.getGroupDetail(1),
        throwsA(isA<NotGroupMemberException>()),
      );
    });

    test('404 이면 GroupNotFoundException 으로 변환한다', () async {
      when(() => dataSource.getGroupDetail(any())).thenThrow(_dioError(statusCode: 404));

      expect(
        () => repository.getGroupDetail(1),
        throwsA(isA<GroupNotFoundException>()),
      );
    });
  });

  group('getInviteGroup', () {
    test('유효하지 않은 초대 코드는 InvalidInviteCodeException 으로 변환한다', () async {
      when(
        () => dataSource.getInviteGroup(any()),
      ).thenThrow(_dioError(code: 'INVALID_INVITE_CODE'));

      expect(
        () => repository.getInviteGroup('ABC123'),
        throwsA(isA<InvalidInviteCodeException>()),
      );
    });

    test('매칭되지 않는 code 는 NetworkException 으로 변환한다', () async {
      when(() => dataSource.getInviteGroup(any())).thenThrow(_dioError());

      expect(
        () => repository.getInviteGroup('ABC123'),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('joinGroup', () {
    test('GROUP_FULL 코드는 GroupFullException 으로 변환한다', () async {
      when(
        () => dataSource.joinGroup(any(), any()),
      ).thenThrow(_dioError(code: 'GROUP_FULL'));

      expect(
        () => repository.joinGroup('ABC123', 'nick'),
        throwsA(isA<GroupFullException>()),
      );
    });

    test('DUPLICATE_GROUP_NICKNAME 코드는 DuplicateGroupNicknameException 으로 변환한다', () async {
      when(
        () => dataSource.joinGroup(any(), any()),
      ).thenThrow(_dioError(code: 'DUPLICATE_GROUP_NICKNAME'));

      expect(
        () => repository.joinGroup('ABC123', 'nick'),
        throwsA(isA<DuplicateGroupNicknameException>()),
      );
    });

    test('성공하면 응답을 도메인 모델로 변환한다', () async {
      when(() => dataSource.joinGroup('ABC123', 'nick')).thenAnswer(
        (_) async => const JoinGroupResponse(groupId: 1, name: 'group'),
      );

      final result = await repository.joinGroup('ABC123', 'nick');

      expect(result.groupId, 1);
    });
  });

  group('exitGroup', () {
    test('GROUP_NOT_FOUND 코드는 GroupNotFoundException 으로 변환한다', () async {
      when(
        () => dataSource.exitGroup(any()),
      ).thenThrow(_dioError(code: 'GROUP_NOT_FOUND'));

      expect(() => repository.exitGroup(1), throwsA(isA<GroupNotFoundException>()));
    });
  });

  group('markNextStarterSeen', () {
    test('NOT_GROUP_MEMBER 코드는 NotGroupMemberException 으로 변환한다', () async {
      when(
        () => dataSource.markNextStarterSeen(any()),
      ).thenThrow(_dioError(code: 'NOT_GROUP_MEMBER'));

      expect(
        () => repository.markNextStarterSeen(1),
        throwsA(isA<NotGroupMemberException>()),
      );
    });
  });

  group('getHistoryCycles / getHistoryList', () {
    test('getHistoryCycles 는 프리뷰용(toGroupHistory) 으로 변환한다', () async {
      when(
        () => dataSource.getHistoryCycles(1, year: null, month: null),
      ).thenAnswer((_) async => const HistoryCyclesResponse(cycles: []));

      final result = await repository.getHistoryCycles(1);

      expect(result.cycles, isEmpty);
    });

    test('getHistoryList 는 year·month 를 그대로 전달하고 통계 포함으로 변환한다', () async {
      when(
        () => dataSource.getHistoryCycles(1, year: 2026, month: 1),
      ).thenAnswer(
        (_) async => const HistoryCyclesResponse(
          stats: HistoryStatsResponse(myCount: 1, totalCount: 2),
          cycles: [],
        ),
      );

      final result = await repository.getHistoryList(1, year: 2026, month: 1);

      expect(result.stats.myCount, 1);
    });

    test('GROUP_NOT_FOUND 코드는 GroupNotFoundException 으로 변환한다 (공통 매핑)', () async {
      when(
        () => dataSource.getHistoryCycles(any(), year: any(named: 'year'), month: any(named: 'month')),
      ).thenThrow(_dioError(code: 'GROUP_NOT_FOUND'));

      expect(
        () => repository.getHistoryCycles(1),
        throwsA(isA<GroupNotFoundException>()),
      );
    });
  });

  group('changeNickName', () {
    test('INVALID_INPUT 코드는 InvalidNicknameException 으로 변환한다', () async {
      when(
        () => dataSource.changeNickName(any(), any()),
      ).thenThrow(_dioError(code: 'INVALID_INPUT'));

      expect(
        () => repository.changeNickName(1, '닉'),
        throwsA(isA<InvalidNicknameException>()),
      );
    });

    test('성공하면 응답을 도메인 모델로 변환한다', () async {
      when(() => dataSource.changeNickName(1, '새닉네임')).thenAnswer(
        (_) async => const ChangeNickNameResponse(groupId: 1, nickname: '새닉네임'),
      );

      final result = await repository.changeNickName(1, '새닉네임');

      expect(result.nickname, '새닉네임');
    });
  });
}
