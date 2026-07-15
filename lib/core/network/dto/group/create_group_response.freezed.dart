// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_group_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateGroupResponse {

 int get groupId; String get name; String get description; String get inviteCode; DateTime get createdAt;
/// Create a copy of CreateGroupResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateGroupResponseCopyWith<CreateGroupResponse> get copyWith => _$CreateGroupResponseCopyWithImpl<CreateGroupResponse>(this as CreateGroupResponse, _$identity);

  /// Serializes this CreateGroupResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateGroupResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,name,description,inviteCode,createdAt);

@override
String toString() {
  return 'CreateGroupResponse(groupId: $groupId, name: $name, description: $description, inviteCode: $inviteCode, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CreateGroupResponseCopyWith<$Res>  {
  factory $CreateGroupResponseCopyWith(CreateGroupResponse value, $Res Function(CreateGroupResponse) _then) = _$CreateGroupResponseCopyWithImpl;
@useResult
$Res call({
 int groupId, String name, String description, String inviteCode, DateTime createdAt
});




}
/// @nodoc
class _$CreateGroupResponseCopyWithImpl<$Res>
    implements $CreateGroupResponseCopyWith<$Res> {
  _$CreateGroupResponseCopyWithImpl(this._self, this._then);

  final CreateGroupResponse _self;
  final $Res Function(CreateGroupResponse) _then;

/// Create a copy of CreateGroupResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? name = null,Object? description = null,Object? inviteCode = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateGroupResponse].
extension CreateGroupResponsePatterns on CreateGroupResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateGroupResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateGroupResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateGroupResponse value)  $default,){
final _that = this;
switch (_that) {
case _CreateGroupResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateGroupResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CreateGroupResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int groupId,  String name,  String description,  String inviteCode,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateGroupResponse() when $default != null:
return $default(_that.groupId,_that.name,_that.description,_that.inviteCode,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int groupId,  String name,  String description,  String inviteCode,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CreateGroupResponse():
return $default(_that.groupId,_that.name,_that.description,_that.inviteCode,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int groupId,  String name,  String description,  String inviteCode,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CreateGroupResponse() when $default != null:
return $default(_that.groupId,_that.name,_that.description,_that.inviteCode,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateGroupResponse implements CreateGroupResponse {
  const _CreateGroupResponse({required this.groupId, required this.name, required this.description, required this.inviteCode, required this.createdAt});
  factory _CreateGroupResponse.fromJson(Map<String, dynamic> json) => _$CreateGroupResponseFromJson(json);

@override final  int groupId;
@override final  String name;
@override final  String description;
@override final  String inviteCode;
@override final  DateTime createdAt;

/// Create a copy of CreateGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateGroupResponseCopyWith<_CreateGroupResponse> get copyWith => __$CreateGroupResponseCopyWithImpl<_CreateGroupResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateGroupResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateGroupResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,name,description,inviteCode,createdAt);

@override
String toString() {
  return 'CreateGroupResponse(groupId: $groupId, name: $name, description: $description, inviteCode: $inviteCode, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CreateGroupResponseCopyWith<$Res> implements $CreateGroupResponseCopyWith<$Res> {
  factory _$CreateGroupResponseCopyWith(_CreateGroupResponse value, $Res Function(_CreateGroupResponse) _then) = __$CreateGroupResponseCopyWithImpl;
@override @useResult
$Res call({
 int groupId, String name, String description, String inviteCode, DateTime createdAt
});




}
/// @nodoc
class __$CreateGroupResponseCopyWithImpl<$Res>
    implements _$CreateGroupResponseCopyWith<$Res> {
  __$CreateGroupResponseCopyWithImpl(this._self, this._then);

  final _CreateGroupResponse _self;
  final $Res Function(_CreateGroupResponse) _then;

/// Create a copy of CreateGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? name = null,Object? description = null,Object? inviteCode = null,Object? createdAt = null,}) {
  return _then(_CreateGroupResponse(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
