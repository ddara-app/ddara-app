import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_group.freezed.dart';

@freezed
abstract class JoinGroup with _$JoinGroup {
  const factory JoinGroup({required int groupId}) = _JoinGroup;
}
