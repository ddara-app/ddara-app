import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_group.freezed.dart';

@freezed
abstract class CreateGroup with _$CreateGroup {
  const factory CreateGroup({required int groupId}) = _CreateGroup;
}
