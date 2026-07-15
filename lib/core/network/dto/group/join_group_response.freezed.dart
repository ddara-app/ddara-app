// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_group_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JoinGroupResponse {

 int get groupId; String get name;
/// Create a copy of JoinGroupResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinGroupResponseCopyWith<JoinGroupResponse> get copyWith => _$JoinGroupResponseCopyWithImpl<JoinGroupResponse>(this as JoinGroupResponse, _$identity);

  /// Serializes this JoinGroupResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinGroupResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,name);

@override
String toString() {
  return 'JoinGroupResponse(groupId: $groupId, name: $name)';
}


}

/// @nodoc
abstract mixin class $JoinGroupResponseCopyWith<$Res>  {
  factory $JoinGroupResponseCopyWith(JoinGroupResponse value, $Res Function(JoinGroupResponse) _then) = _$JoinGroupResponseCopyWithImpl;
@useResult
$Res call({
 int groupId, String name
});




}
/// @nodoc
class _$JoinGroupResponseCopyWithImpl<$Res>
    implements $JoinGroupResponseCopyWith<$Res> {
  _$JoinGroupResponseCopyWithImpl(this._self, this._then);

  final JoinGroupResponse _self;
  final $Res Function(JoinGroupResponse) _then;

/// Create a copy of JoinGroupResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? name = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [JoinGroupResponse].
extension JoinGroupResponsePatterns on JoinGroupResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JoinGroupResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JoinGroupResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JoinGroupResponse value)  $default,){
final _that = this;
switch (_that) {
case _JoinGroupResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JoinGroupResponse value)?  $default,){
final _that = this;
switch (_that) {
case _JoinGroupResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int groupId,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JoinGroupResponse() when $default != null:
return $default(_that.groupId,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int groupId,  String name)  $default,) {final _that = this;
switch (_that) {
case _JoinGroupResponse():
return $default(_that.groupId,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int groupId,  String name)?  $default,) {final _that = this;
switch (_that) {
case _JoinGroupResponse() when $default != null:
return $default(_that.groupId,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JoinGroupResponse implements JoinGroupResponse {
  const _JoinGroupResponse({required this.groupId, required this.name});
  factory _JoinGroupResponse.fromJson(Map<String, dynamic> json) => _$JoinGroupResponseFromJson(json);

@override final  int groupId;
@override final  String name;

/// Create a copy of JoinGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JoinGroupResponseCopyWith<_JoinGroupResponse> get copyWith => __$JoinGroupResponseCopyWithImpl<_JoinGroupResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JoinGroupResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinGroupResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,name);

@override
String toString() {
  return 'JoinGroupResponse(groupId: $groupId, name: $name)';
}


}

/// @nodoc
abstract mixin class _$JoinGroupResponseCopyWith<$Res> implements $JoinGroupResponseCopyWith<$Res> {
  factory _$JoinGroupResponseCopyWith(_JoinGroupResponse value, $Res Function(_JoinGroupResponse) _then) = __$JoinGroupResponseCopyWithImpl;
@override @useResult
$Res call({
 int groupId, String name
});




}
/// @nodoc
class __$JoinGroupResponseCopyWithImpl<$Res>
    implements _$JoinGroupResponseCopyWith<$Res> {
  __$JoinGroupResponseCopyWithImpl(this._self, this._then);

  final _JoinGroupResponse _self;
  final $Res Function(_JoinGroupResponse) _then;

/// Create a copy of JoinGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? name = null,}) {
  return _then(_JoinGroupResponse(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
