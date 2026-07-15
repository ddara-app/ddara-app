// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'presign_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PresignResponse {

/// S3에 직접 PUT 업로드할 presigned URL. (서명·만료 쿼리 포함)
 String get uploadUrl;/// 업로드 완료 후 서버에 넘길 최종 접근 URL.
 String get imageUrl;/// presigned URL 만료까지 남은 시간(초).
 int get expiresIn;
/// Create a copy of PresignResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresignResponseCopyWith<PresignResponse> get copyWith => _$PresignResponseCopyWithImpl<PresignResponse>(this as PresignResponse, _$identity);

  /// Serializes this PresignResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresignResponse&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uploadUrl,imageUrl,expiresIn);

@override
String toString() {
  return 'PresignResponse(uploadUrl: $uploadUrl, imageUrl: $imageUrl, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class $PresignResponseCopyWith<$Res>  {
  factory $PresignResponseCopyWith(PresignResponse value, $Res Function(PresignResponse) _then) = _$PresignResponseCopyWithImpl;
@useResult
$Res call({
 String uploadUrl, String imageUrl, int expiresIn
});




}
/// @nodoc
class _$PresignResponseCopyWithImpl<$Res>
    implements $PresignResponseCopyWith<$Res> {
  _$PresignResponseCopyWithImpl(this._self, this._then);

  final PresignResponse _self;
  final $Res Function(PresignResponse) _then;

/// Create a copy of PresignResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uploadUrl = null,Object? imageUrl = null,Object? expiresIn = null,}) {
  return _then(_self.copyWith(
uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PresignResponse].
extension PresignResponsePatterns on PresignResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresignResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresignResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresignResponse value)  $default,){
final _that = this;
switch (_that) {
case _PresignResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresignResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PresignResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uploadUrl,  String imageUrl,  int expiresIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresignResponse() when $default != null:
return $default(_that.uploadUrl,_that.imageUrl,_that.expiresIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uploadUrl,  String imageUrl,  int expiresIn)  $default,) {final _that = this;
switch (_that) {
case _PresignResponse():
return $default(_that.uploadUrl,_that.imageUrl,_that.expiresIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uploadUrl,  String imageUrl,  int expiresIn)?  $default,) {final _that = this;
switch (_that) {
case _PresignResponse() when $default != null:
return $default(_that.uploadUrl,_that.imageUrl,_that.expiresIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PresignResponse implements PresignResponse {
  const _PresignResponse({required this.uploadUrl, required this.imageUrl, required this.expiresIn});
  factory _PresignResponse.fromJson(Map<String, dynamic> json) => _$PresignResponseFromJson(json);

/// S3에 직접 PUT 업로드할 presigned URL. (서명·만료 쿼리 포함)
@override final  String uploadUrl;
/// 업로드 완료 후 서버에 넘길 최종 접근 URL.
@override final  String imageUrl;
/// presigned URL 만료까지 남은 시간(초).
@override final  int expiresIn;

/// Create a copy of PresignResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresignResponseCopyWith<_PresignResponse> get copyWith => __$PresignResponseCopyWithImpl<_PresignResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PresignResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresignResponse&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uploadUrl,imageUrl,expiresIn);

@override
String toString() {
  return 'PresignResponse(uploadUrl: $uploadUrl, imageUrl: $imageUrl, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class _$PresignResponseCopyWith<$Res> implements $PresignResponseCopyWith<$Res> {
  factory _$PresignResponseCopyWith(_PresignResponse value, $Res Function(_PresignResponse) _then) = __$PresignResponseCopyWithImpl;
@override @useResult
$Res call({
 String uploadUrl, String imageUrl, int expiresIn
});




}
/// @nodoc
class __$PresignResponseCopyWithImpl<$Res>
    implements _$PresignResponseCopyWith<$Res> {
  __$PresignResponseCopyWithImpl(this._self, this._then);

  final _PresignResponse _self;
  final $Res Function(_PresignResponse) _then;

/// Create a copy of PresignResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uploadUrl = null,Object? imageUrl = null,Object? expiresIn = null,}) {
  return _then(_PresignResponse(
uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
