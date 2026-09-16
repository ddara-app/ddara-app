import 'package:ddara/domain/repository/profile_repository.dart';
import 'package:ddara/domain/usecase/profile/reset_profile_image_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late ResetProfileImageUseCase useCase;

  setUp(() {
    repository = MockProfileRepository();
    useCase = ResetProfileImageUseCase(repository);
  });

  test('Repository 의 초기화 호출을 그대로 위임한다', () async {
    when(() => repository.resetProfileImage()).thenAnswer((_) async {});

    await useCase.call();

    verify(() => repository.resetProfileImage()).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.resetProfileImage()).thenThrow(Exception('fail'));

    expect(() => useCase.call(), throwsA(isA<Exception>()));
  });
}
