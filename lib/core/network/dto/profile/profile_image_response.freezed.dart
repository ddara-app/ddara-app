// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_image_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileImageResponse {

// 업로드 후 서버가 반환하는 새 프로필 이미지 URL.
 String get profileImageUrl;
/// Create a copy of ProfileImageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileImageResponseCopyWith<ProfileImageResponse> get copyWith => _$ProfileImageResponseCopyWithImpl<ProfileImageResponse>(this as ProfileImageResponse, _$identity);

  /// Serializes this ProfileImageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileImageResponse&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profileImageUrl);

@override
String toString() {
  return 'ProfileImageResponse(profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class $ProfileImageResponseCopyWith<$Res>  {
  factory $ProfileImageResponseCopyWith(ProfileImageResponse value, $Res Function(ProfileImageResponse) _then) = _$ProfileImageResponseCopyWithImpl;
@useResult
$Res call({
 String profileImageUrl
});




}
/// @nodoc
class _$ProfileImageResponseCopyWithImpl<$Res>
    implements $ProfileImageResponseCopyWith<$Res> {
  _$ProfileImageResponseCopyWithImpl(this._self, this._then);

  final ProfileImageResponse _self;
  final $Res Function(ProfileImageResponse) _then;

/// Create a copy of ProfileImageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profileImageUrl = null,}) {
  return _then(_self.copyWith(
profileImageUrl: null == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileImageResponse].
extension ProfileImageResponsePatterns on ProfileImageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileImageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileImageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileImageResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProfileImageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileImageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileImageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String profileImageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileImageResponse() when $default != null:
return $default(_that.profileImageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String profileImageUrl)  $default,) {final _that = this;
switch (_that) {
case _ProfileImageResponse():
return $default(_that.profileImageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String profileImageUrl)?  $default,) {final _that = this;
switch (_that) {
case _ProfileImageResponse() when $default != null:
return $default(_that.profileImageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileImageResponse implements ProfileImageResponse {
  const _ProfileImageResponse({required this.profileImageUrl});
  factory _ProfileImageResponse.fromJson(Map<String, dynamic> json) => _$ProfileImageResponseFromJson(json);

// 업로드 후 서버가 반환하는 새 프로필 이미지 URL.
@override final  String profileImageUrl;

/// Create a copy of ProfileImageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileImageResponseCopyWith<_ProfileImageResponse> get copyWith => __$ProfileImageResponseCopyWithImpl<_ProfileImageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileImageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileImageResponse&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profileImageUrl);

@override
String toString() {
  return 'ProfileImageResponse(profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class _$ProfileImageResponseCopyWith<$Res> implements $ProfileImageResponseCopyWith<$Res> {
  factory _$ProfileImageResponseCopyWith(_ProfileImageResponse value, $Res Function(_ProfileImageResponse) _then) = __$ProfileImageResponseCopyWithImpl;
@override @useResult
$Res call({
 String profileImageUrl
});




}
/// @nodoc
class __$ProfileImageResponseCopyWithImpl<$Res>
    implements _$ProfileImageResponseCopyWith<$Res> {
  __$ProfileImageResponseCopyWithImpl(this._self, this._then);

  final _ProfileImageResponse _self;
  final $Res Function(_ProfileImageResponse) _then;

/// Create a copy of ProfileImageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profileImageUrl = null,}) {
  return _then(_ProfileImageResponse(
profileImageUrl: null == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
