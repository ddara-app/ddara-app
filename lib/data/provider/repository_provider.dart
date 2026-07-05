import 'package:ddara/core/auth/provider/auth_provider.dart';
import 'package:ddara/domain/repository/cycle_repository.dart';
import 'package:ddara/domain/repository/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/group_repository.dart';
import '../repository/auth_repository_impl.dart';
import '../repository/cycle_repository_impl.dart';
import '../repository/group_repository_impl.dart';
import '../repository/profile_repository_impl.dart';
import 'datasource_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authRemoteDataSourceProvider),
    ref.read(kakaoAuthProvider),
    ref.read(googleAuthProvider),
    ref.read(appleAuthProvider),
  );
});

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepositoryImpl(ref.read(groupDataSourceProvider));
});

final cycleRepositoryProvider = Provider<CycleRepository>((ref) {
  return CycleRepositoryImpl(
    ref.read(cycleDataSourceProvider),
    ref.read(uploadDataSourceProvider),
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    ref.read(profileDataSourceProvider),
    ref.read(uploadDataSourceProvider),
  );
});
