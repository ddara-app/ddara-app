// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'camera_guide_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CameraGuideResponse {

/// 이미 본 안내의 키 목록. 아무것도 안 봤으면 빈 배열.
/// (MINI_VIEW · GHOST_VIEW)
 List<String> get seen;
/// Create a copy of CameraGuideResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CameraGuideResponseCopyWith<CameraGuideResponse> get copyWith => _$CameraGuideResponseCopyWithImpl<CameraGuideResponse>(this as CameraGuideResponse, _$identity);

  /// Serializes this CameraGuideResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CameraGuideResponse&&const DeepCollectionEquality().equals(other.seen, seen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(seen));

@override
String toString() {
  return 'CameraGuideResponse(seen: $seen)';
}


}

/// @nodoc
abstract mixin class $CameraGuideResponseCopyWith<$Res>  {
  factory $CameraGuideResponseCopyWith(CameraGuideResponse value, $Res Function(CameraGuideResponse) _then) = _$CameraGuideResponseCopyWithImpl;
@useResult
$Res call({
 List<String> seen
});




}
/// @nodoc
class _$CameraGuideResponseCopyWithImpl<$Res>
    implements $CameraGuideResponseCopyWith<$Res> {
  _$CameraGuideResponseCopyWithImpl(this._self, this._then);

  final CameraGuideResponse _self;
  final $Res Function(CameraGuideResponse) _then;

/// Create a copy of CameraGuideResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seen = null,}) {
  return _then(_self.copyWith(
seen: null == seen ? _self.seen : seen // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CameraGuideResponse].
extension CameraGuideResponsePatterns on CameraGuideResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CameraGuideResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CameraGuideResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CameraGuideResponse value)  $default,){
final _that = this;
switch (_that) {
case _CameraGuideResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CameraGuideResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CameraGuideResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> seen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CameraGuideResponse() when $default != null:
return $default(_that.seen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> seen)  $default,) {final _that = this;
switch (_that) {
case _CameraGuideResponse():
return $default(_that.seen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> seen)?  $default,) {final _that = this;
switch (_that) {
case _CameraGuideResponse() when $default != null:
return $default(_that.seen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CameraGuideResponse implements CameraGuideResponse {
  const _CameraGuideResponse({required final  List<String> seen}): _seen = seen;
  factory _CameraGuideResponse.fromJson(Map<String, dynamic> json) => _$CameraGuideResponseFromJson(json);

/// 이미 본 안내의 키 목록. 아무것도 안 봤으면 빈 배열.
/// (MINI_VIEW · GHOST_VIEW)
 final  List<String> _seen;
/// 이미 본 안내의 키 목록. 아무것도 안 봤으면 빈 배열.
/// (MINI_VIEW · GHOST_VIEW)
@override List<String> get seen {
  if (_seen is EqualUnmodifiableListView) return _seen;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seen);
}


/// Create a copy of CameraGuideResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CameraGuideResponseCopyWith<_CameraGuideResponse> get copyWith => __$CameraGuideResponseCopyWithImpl<_CameraGuideResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CameraGuideResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CameraGuideResponse&&const DeepCollectionEquality().equals(other._seen, _seen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_seen));

@override
String toString() {
  return 'CameraGuideResponse(seen: $seen)';
}


}

/// @nodoc
abstract mixin class _$CameraGuideResponseCopyWith<$Res> implements $CameraGuideResponseCopyWith<$Res> {
  factory _$CameraGuideResponseCopyWith(_CameraGuideResponse value, $Res Function(_CameraGuideResponse) _then) = __$CameraGuideResponseCopyWithImpl;
@override @useResult
$Res call({
 List<String> seen
});




}
/// @nodoc
class __$CameraGuideResponseCopyWithImpl<$Res>
    implements _$CameraGuideResponseCopyWith<$Res> {
  __$CameraGuideResponseCopyWithImpl(this._self, this._then);

  final _CameraGuideResponse _self;
  final $Res Function(_CameraGuideResponse) _then;

/// Create a copy of CameraGuideResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seen = null,}) {
  return _then(_CameraGuideResponse(
seen: null == seen ? _self._seen : seen // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
