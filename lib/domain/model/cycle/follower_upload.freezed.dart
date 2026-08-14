// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follower_upload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FollowerUpload {

 int get cycleId;
/// Create a copy of FollowerUpload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowerUploadCopyWith<FollowerUpload> get copyWith => _$FollowerUploadCopyWithImpl<FollowerUpload>(this as FollowerUpload, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowerUpload&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId));
}


@override
int get hashCode => Object.hash(runtimeType,cycleId);

@override
String toString() {
  return 'FollowerUpload(cycleId: $cycleId)';
}


}

/// @nodoc
abstract mixin class $FollowerUploadCopyWith<$Res>  {
  factory $FollowerUploadCopyWith(FollowerUpload value, $Res Function(FollowerUpload) _then) = _$FollowerUploadCopyWithImpl;
@useResult
$Res call({
 int cycleId
});




}
/// @nodoc
class _$FollowerUploadCopyWithImpl<$Res>
    implements $FollowerUploadCopyWith<$Res> {
  _$FollowerUploadCopyWithImpl(this._self, this._then);

  final FollowerUpload _self;
  final $Res Function(FollowerUpload) _then;

/// Create a copy of FollowerUpload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cycleId = null,}) {
  return _then(_self.copyWith(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FollowerUpload].
extension FollowerUploadPatterns on FollowerUpload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowerUpload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowerUpload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowerUpload value)  $default,){
final _that = this;
switch (_that) {
case _FollowerUpload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowerUpload value)?  $default,){
final _that = this;
switch (_that) {
case _FollowerUpload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int cycleId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowerUpload() when $default != null:
return $default(_that.cycleId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int cycleId)  $default,) {final _that = this;
switch (_that) {
case _FollowerUpload():
return $default(_that.cycleId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int cycleId)?  $default,) {final _that = this;
switch (_that) {
case _FollowerUpload() when $default != null:
return $default(_that.cycleId);case _:
  return null;

}
}

}

/// @nodoc


class _FollowerUpload implements FollowerUpload {
  const _FollowerUpload({required this.cycleId});
  

@override final  int cycleId;

/// Create a copy of FollowerUpload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowerUploadCopyWith<_FollowerUpload> get copyWith => __$FollowerUploadCopyWithImpl<_FollowerUpload>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowerUpload&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId));
}


@override
int get hashCode => Object.hash(runtimeType,cycleId);

@override
String toString() {
  return 'FollowerUpload(cycleId: $cycleId)';
}


}

/// @nodoc
abstract mixin class _$FollowerUploadCopyWith<$Res> implements $FollowerUploadCopyWith<$Res> {
  factory _$FollowerUploadCopyWith(_FollowerUpload value, $Res Function(_FollowerUpload) _then) = __$FollowerUploadCopyWithImpl;
@override @useResult
$Res call({
 int cycleId
});




}
/// @nodoc
class __$FollowerUploadCopyWithImpl<$Res>
    implements _$FollowerUploadCopyWith<$Res> {
  __$FollowerUploadCopyWithImpl(this._self, this._then);

  final _FollowerUpload _self;
  final $Res Function(_FollowerUpload) _then;

/// Create a copy of FollowerUpload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,}) {
  return _then(_FollowerUpload(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
