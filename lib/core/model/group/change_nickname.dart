import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_nickname.freezed.dart';

@freezed
abstract class ChangeNickName with _$ChangeNickName {
  const factory ChangeNickName({required String nickname}) = _ChangeNickName;
}
