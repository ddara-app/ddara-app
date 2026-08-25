import 'package:ddara/core/auth/provider/auth_provider.dart';
import 'package:ddara/domain/repository/block_repository.dart';
import 'package:ddara/domain/repository/cycle_repository.dart';
import 'package:ddara/domain/repository/fcm_repository.dart';
import 'package:ddara/domain/repository/feed_repository.dart';
import 'package:ddara/domain/repository/notification_repository.dart';
import 'package:ddara/domain/repository/profile_repository.dart';
import 'package:ddara/domain/repository/report_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/group_repository.dart';
import '../repository/auth_repository_impl.dart';
import '../repository/block_repository_impl.dart';
import '../repository/cycle_repository_impl.dart';
import '../repository/fcm_repository_impl.dart';
import '../repository/feed_repository_impl.dart';
import '../repository/group_repository_impl.dart';
import '../repository/notification_repository_impl.dart';
import '../repository/profile_repository_impl.dart';
import '../repository/report_repository_impl.dart';
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

final fcmRepositoryProvider = Provider<FcmRepository>((ref) {
  return FcmRepositoryImpl(ref.read(fcmDataSourceProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.read(notificationDataSourceProvider));
});

final blockRepositoryProvider = Provider<BlockRepository>((ref) {
  return BlockRepositoryImpl(ref.read(blockDataSourceProvider));
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(ref.read(reportDataSourceProvider));
});

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepositoryImpl(ref.read(feedDataSourceProvider));
});
