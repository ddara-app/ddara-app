import 'package:ddara/core/local/provider/local_provider.dart';
import 'package:ddara/data/datasource/block/block_datasource.dart';
import 'package:ddara/data/datasource/cycle/cycle_datasource.dart';
import 'package:ddara/data/datasource/fcm/fcm_datasource.dart';
import 'package:ddara/data/datasource/notification/notification_datasource.dart';
import 'package:ddara/data/datasource/profile/profile_datasource.dart';
import 'package:ddara/data/datasource/upload/upload_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/dio_provider.dart';
import '../datasource/auth/auth_datasource.dart';
import '../datasource/group/group_datasource.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    ref.read(dioProvider),
    ref.read(secureStorageProvider),
  );
});

final groupDataSourceProvider = Provider<GroupDataSource>((ref) {
  return GroupDataSource(ref.read(dioProvider));
});

final profileDataSourceProvider = Provider<ProfileDataSource>((ref) {
  return ProfileDataSource(ref.read(dioProvider));
});

final cycleDataSourceProvider = Provider<CycleDataSource>((ref) {
  return CycleDataSource(ref.read(dioProvider));
});

final uploadDataSourceProvider = Provider<UploadDataSource>((ref) {
  return UploadDataSource(ref.read(dioProvider));
});

final fcmDataSourceProvider = Provider<FcmDataSource>((ref) {
  return FcmDataSource(ref.read(dioProvider));
});

final notificationDataSourceProvider = Provider<NotificationDataSource>((ref) {
  return NotificationDataSource(ref.read(dioProvider));
});

final blockDataSourceProvider = Provider<BlockDataSource>((ref) {
  return BlockDataSource(ref.read(dioProvider));
});
