import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_list.freezed.dart';

@freezed
abstract class GroupList with _$GroupList {
  const factory GroupList({required List<Group> groups}) = _GroupList;
}

@freezed
abstract class Group with _$Group {
  const factory Group({
    required int groupId,
    required String name,
    required String ownerNickname,
    required int memberCount,
    // 모임 대표 썸네일(진행 사이클 스타터 샷). 아직 없으면 null.
    required String? thumbnailUrl,
    // 진행 중인 사이클이 없으면 null.
    required CurrentCycle? currentCycle,
  }) = _Group;
}

@freezed
abstract class CurrentCycle with _$CurrentCycle {
  const factory CurrentCycle({
    required int cycleId,
    required String topic,
    required DateTime deadlineAt,
  }) = _CurrentCycle;
}
