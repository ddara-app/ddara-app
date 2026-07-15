// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follower_upload_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FollowerUploadResponse {

 int get shotId; int get cycleId; int get userId;// 사진 종류. (팔로워 사진은 'member')
 String get type; String get imageUrl; DateTime get uploadedAt;
/// Create a copy of FollowerUploadResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowerUploadResponseCopyWith<FollowerUploadResponse> get copyWith => _$FollowerUploadResponseCopyWithImpl<FollowerUploadResponse>(this as FollowerUploadResponse, _$identity);

  /// Serializes this FollowerUploadResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowerUploadResponse&&(identical(other.shotId, shotId) || other.shotId == shotId)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shotId,cycleId,userId,type,imageUrl,uploadedAt);

@override
String toString() {
  return 'FollowerUploadResponse(shotId: $shotId, cycleId: $cycleId, userId: $userId, type: $type, imageUrl: $imageUrl, uploadedAt: $uploadedAt)';
}


}

/// @nodoc
abstract mixin class $FollowerUploadResponseCopyWith<$Res>  {
  factory $FollowerUploadResponseCopyWith(FollowerUploadResponse value, $Res Function(FollowerUploadResponse) _then) = _$FollowerUploadResponseCopyWithImpl;
@useResult
$Res call({
 int shotId, int cycleId, int userId, String type, String imageUrl, DateTime uploadedAt
});




}
/// @nodoc
class _$FollowerUploadResponseCopyWithImpl<$Res>
    implements $FollowerUploadResponseCopyWith<$Res> {
  _$FollowerUploadResponseCopyWithImpl(this._self, this._then);

  final FollowerUploadResponse _self;
  final $Res Function(FollowerUploadResponse) _then;

/// Create a copy of FollowerUploadResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shotId = null,Object? cycleId = null,Object? userId = null,Object? type = null,Object? imageUrl = null,Object? uploadedAt = null,}) {
  return _then(_self.copyWith(
shotId: null == shotId ? _self.shotId : shotId // ignore: cast_nullable_to_non_nullable
as int,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FollowerUploadResponse].
extension FollowerUploadResponsePatterns on FollowerUploadResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowerUploadResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowerUploadResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowerUploadResponse value)  $default,){
final _that = this;
switch (_that) {
case _FollowerUploadResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowerUploadResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FollowerUploadResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int shotId,  int cycleId,  int userId,  String type,  String imageUrl,  DateTime uploadedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowerUploadResponse() when $default != null:
return $default(_that.shotId,_that.cycleId,_that.userId,_that.type,_that.imageUrl,_that.uploadedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int shotId,  int cycleId,  int userId,  String type,  String imageUrl,  DateTime uploadedAt)  $default,) {final _that = this;
switch (_that) {
case _FollowerUploadResponse():
return $default(_that.shotId,_that.cycleId,_that.userId,_that.type,_that.imageUrl,_that.uploadedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int shotId,  int cycleId,  int userId,  String type,  String imageUrl,  DateTime uploadedAt)?  $default,) {final _that = this;
switch (_that) {
case _FollowerUploadResponse() when $default != null:
return $default(_that.shotId,_that.cycleId,_that.userId,_that.type,_that.imageUrl,_that.uploadedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FollowerUploadResponse implements FollowerUploadResponse {
  const _FollowerUploadResponse({required this.shotId, required this.cycleId, required this.userId, required this.type, required this.imageUrl, required this.uploadedAt});
  factory _FollowerUploadResponse.fromJson(Map<String, dynamic> json) => _$FollowerUploadResponseFromJson(json);

@override final  int shotId;
@override final  int cycleId;
@override final  int userId;
// 사진 종류. (팔로워 사진은 'member')
@override final  String type;
@override final  String imageUrl;
@override final  DateTime uploadedAt;

/// Create a copy of FollowerUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowerUploadResponseCopyWith<_FollowerUploadResponse> get copyWith => __$FollowerUploadResponseCopyWithImpl<_FollowerUploadResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FollowerUploadResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowerUploadResponse&&(identical(other.shotId, shotId) || other.shotId == shotId)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shotId,cycleId,userId,type,imageUrl,uploadedAt);

@override
String toString() {
  return 'FollowerUploadResponse(shotId: $shotId, cycleId: $cycleId, userId: $userId, type: $type, imageUrl: $imageUrl, uploadedAt: $uploadedAt)';
}


}

/// @nodoc
abstract mixin class _$FollowerUploadResponseCopyWith<$Res> implements $FollowerUploadResponseCopyWith<$Res> {
  factory _$FollowerUploadResponseCopyWith(_FollowerUploadResponse value, $Res Function(_FollowerUploadResponse) _then) = __$FollowerUploadResponseCopyWithImpl;
@override @useResult
$Res call({
 int shotId, int cycleId, int userId, String type, String imageUrl, DateTime uploadedAt
});




}
/// @nodoc
class __$FollowerUploadResponseCopyWithImpl<$Res>
    implements _$FollowerUploadResponseCopyWith<$Res> {
  __$FollowerUploadResponseCopyWithImpl(this._self, this._then);

  final _FollowerUploadResponse _self;
  final $Res Function(_FollowerUploadResponse) _then;

/// Create a copy of FollowerUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shotId = null,Object? cycleId = null,Object? userId = null,Object? type = null,Object? imageUrl = null,Object? uploadedAt = null,}) {
  return _then(_FollowerUploadResponse(
shotId: null == shotId ? _self.shotId : shotId // ignore: cast_nullable_to_non_nullable
as int,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
