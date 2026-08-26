import 'package:freezed_annotation/freezed_annotation.dart';

part 'starter_upload.freezed.dart';

@freezed
abstract class StarterUpload with _$StarterUpload {
  const factory StarterUpload({required int cycleId}) = _StarterUpload;
}
