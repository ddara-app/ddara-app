import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../permission_handler_service.dart';
import '../permission_service.dart';

final permissionServiceProvider = Provider<PermissionService>(
  (ref) => const PermissionHandlerService(),
);

final cameraNoticeAcknowledgedProvider = StateProvider<bool>((ref) => false);
