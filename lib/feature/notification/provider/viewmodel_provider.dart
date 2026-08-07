import 'package:ddara/feature/notification/notification_viewmodel.dart';
import 'package:ddara/feature/notification/util/notification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// autoDispose: 화면을 벗어나면 폐기되어 다음 진입 시 최신 알림을 다시 조회한다.
final notificationViewModelProvider =
    NotifierProvider.autoDispose<NotificationViewModel, NotificationState>(
      NotificationViewModel.new,
    );
