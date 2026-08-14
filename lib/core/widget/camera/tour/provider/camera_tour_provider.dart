import 'package:ddara/core/widget/camera/tour/camera_tour_seen.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_steps.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 가이드 투어 노출 여부. (true 면 그 종류를 이미 본 상태)
final cameraTourSeenProvider =
    NotifierProvider.family<CameraTourSeenViewModel, bool, CameraTourKind>(
      CameraTourSeenViewModel.new,
    );
