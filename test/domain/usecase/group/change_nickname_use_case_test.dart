import 'package:ddara/domain/model/group/change_nickname.dart';
import 'package:ddara/domain/repository/group_repository.dart';
import 'package:ddara/domain/usecase/group/change_nickname_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository repository;
  late ChangeNicknameUseCase useCase;

  setUp(() {
    repository = MockGroupRepository();
    useCase = ChangeNicknameUseCase(repository);
  });

  test('groupId·nickName 을 그대로 Repository 에 위임한다', () async {
    const changed = ChangeNickName(nickname: '새닉네임');
    when(
      () => repository.changeNickName(1, '새닉네임'),
    ).thenAnswer((_) async => changed);

    final result = await useCase.call(1, '새닉네임');

    expect(result, changed);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.changeNickName(any(), any()),
    ).thenThrow(Exception('fail'));

    expect(
      () => useCase.call(1, '새닉네임'),
      throwsA(isA<Exception>()),
    );
  });
}
