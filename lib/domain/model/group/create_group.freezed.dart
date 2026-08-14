// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateGroup {

 int get groupId;
/// Create a copy of CreateGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateGroupCopyWith<CreateGroup> get copyWith => _$CreateGroupCopyWithImpl<CreateGroup>(this as CreateGroup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateGroup&&(identical(other.groupId, groupId) || other.groupId == groupId));
}


@override
int get hashCode => Object.hash(runtimeType,groupId);

@override
String toString() {
  return 'CreateGroup(groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class $CreateGroupCopyWith<$Res>  {
  factory $CreateGroupCopyWith(CreateGroup value, $Res Function(CreateGroup) _then) = _$CreateGroupCopyWithImpl;
@useResult
$Res call({
 int groupId
});




}
/// @nodoc
class _$CreateGroupCopyWithImpl<$Res>
    implements $CreateGroupCopyWith<$Res> {
  _$CreateGroupCopyWithImpl(this._self, this._then);

  final CreateGroup _self;
  final $Res Function(CreateGroup) _then;

/// Create a copy of CreateGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateGroup].
extension CreateGroupPatterns on CreateGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateGroup value)  $default,){
final _that = this;
switch (_that) {
case _CreateGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateGroup value)?  $default,){
final _that = this;
switch (_that) {
case _CreateGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int groupId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateGroup() when $default != null:
return $default(_that.groupId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int groupId)  $default,) {final _that = this;
switch (_that) {
case _CreateGroup():
return $default(_that.groupId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int groupId)?  $default,) {final _that = this;
switch (_that) {
case _CreateGroup() when $default != null:
return $default(_that.groupId);case _:
  return null;

}
}

}

/// @nodoc


class _CreateGroup implements CreateGroup {
  const _CreateGroup({required this.groupId});
  

@override final  int groupId;

/// Create a copy of CreateGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateGroupCopyWith<_CreateGroup> get copyWith => __$CreateGroupCopyWithImpl<_CreateGroup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateGroup&&(identical(other.groupId, groupId) || other.groupId == groupId));
}


@override
int get hashCode => Object.hash(runtimeType,groupId);

@override
String toString() {
  return 'CreateGroup(groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class _$CreateGroupCopyWith<$Res> implements $CreateGroupCopyWith<$Res> {
  factory _$CreateGroupCopyWith(_CreateGroup value, $Res Function(_CreateGroup) _then) = __$CreateGroupCopyWithImpl;
@override @useResult
$Res call({
 int groupId
});




}
/// @nodoc
class __$CreateGroupCopyWithImpl<$Res>
    implements _$CreateGroupCopyWith<$Res> {
  __$CreateGroupCopyWithImpl(this._self, this._then);

  final _CreateGroup _self;
  final $Res Function(_CreateGroup) _then;

/// Create a copy of CreateGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,}) {
  return _then(_CreateGroup(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
