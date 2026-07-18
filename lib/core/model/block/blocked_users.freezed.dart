// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_users.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BlockedUsers {

 List<BlockedUser> get users;
/// Create a copy of BlockedUsers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockedUsersCopyWith<BlockedUsers> get copyWith => _$BlockedUsersCopyWithImpl<BlockedUsers>(this as BlockedUsers, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockedUsers&&const DeepCollectionEquality().equals(other.users, users));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(users));

@override
String toString() {
  return 'BlockedUsers(users: $users)';
}


}

/// @nodoc
abstract mixin class $BlockedUsersCopyWith<$Res>  {
  factory $BlockedUsersCopyWith(BlockedUsers value, $Res Function(BlockedUsers) _then) = _$BlockedUsersCopyWithImpl;
@useResult
$Res call({
 List<BlockedUser> users
});




}
/// @nodoc
class _$BlockedUsersCopyWithImpl<$Res>
    implements $BlockedUsersCopyWith<$Res> {
  _$BlockedUsersCopyWithImpl(this._self, this._then);

  final BlockedUsers _self;
  final $Res Function(BlockedUsers) _then;

/// Create a copy of BlockedUsers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,}) {
  return _then(_self.copyWith(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<BlockedUser>,
  ));
}

}


/// Adds pattern-matching-related methods to [BlockedUsers].
extension BlockedUsersPatterns on BlockedUsers {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlockedUsers value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlockedUsers() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlockedUsers value)  $default,){
final _that = this;
switch (_that) {
case _BlockedUsers():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlockedUsers value)?  $default,){
final _that = this;
switch (_that) {
case _BlockedUsers() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BlockedUser> users)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlockedUsers() when $default != null:
return $default(_that.users);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BlockedUser> users)  $default,) {final _that = this;
switch (_that) {
case _BlockedUsers():
return $default(_that.users);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BlockedUser> users)?  $default,) {final _that = this;
switch (_that) {
case _BlockedUsers() when $default != null:
return $default(_that.users);case _:
  return null;

}
}

}

/// @nodoc


class _BlockedUsers implements BlockedUsers {
  const _BlockedUsers({required final  List<BlockedUser> users}): _users = users;
  

 final  List<BlockedUser> _users;
@override List<BlockedUser> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}


/// Create a copy of BlockedUsers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedUsersCopyWith<_BlockedUsers> get copyWith => __$BlockedUsersCopyWithImpl<_BlockedUsers>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedUsers&&const DeepCollectionEquality().equals(other._users, _users));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_users));

@override
String toString() {
  return 'BlockedUsers(users: $users)';
}


}

/// @nodoc
abstract mixin class _$BlockedUsersCopyWith<$Res> implements $BlockedUsersCopyWith<$Res> {
  factory _$BlockedUsersCopyWith(_BlockedUsers value, $Res Function(_BlockedUsers) _then) = __$BlockedUsersCopyWithImpl;
@override @useResult
$Res call({
 List<BlockedUser> users
});




}
/// @nodoc
class __$BlockedUsersCopyWithImpl<$Res>
    implements _$BlockedUsersCopyWith<$Res> {
  __$BlockedUsersCopyWithImpl(this._self, this._then);

  final _BlockedUsers _self;
  final $Res Function(_BlockedUsers) _then;

/// Create a copy of BlockedUsers
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,}) {
  return _then(_BlockedUsers(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<BlockedUser>,
  ));
}


}

/// @nodoc
mixin _$BlockedUser {

 int get userId; String get name; DateTime get blockedAt;
/// Create a copy of BlockedUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockedUserCopyWith<BlockedUser> get copyWith => _$BlockedUserCopyWithImpl<BlockedUser>(this as BlockedUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockedUser&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.blockedAt, blockedAt) || other.blockedAt == blockedAt));
}


@override
int get hashCode => Object.hash(runtimeType,userId,name,blockedAt);

@override
String toString() {
  return 'BlockedUser(userId: $userId, name: $name, blockedAt: $blockedAt)';
}


}

/// @nodoc
abstract mixin class $BlockedUserCopyWith<$Res>  {
  factory $BlockedUserCopyWith(BlockedUser value, $Res Function(BlockedUser) _then) = _$BlockedUserCopyWithImpl;
@useResult
$Res call({
 int userId, String name, DateTime blockedAt
});




}
/// @nodoc
class _$BlockedUserCopyWithImpl<$Res>
    implements $BlockedUserCopyWith<$Res> {
  _$BlockedUserCopyWithImpl(this._self, this._then);

  final BlockedUser _self;
  final $Res Function(BlockedUser) _then;

/// Create a copy of BlockedUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? blockedAt = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,blockedAt: null == blockedAt ? _self.blockedAt : blockedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BlockedUser].
extension BlockedUserPatterns on BlockedUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlockedUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlockedUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlockedUser value)  $default,){
final _that = this;
switch (_that) {
case _BlockedUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlockedUser value)?  $default,){
final _that = this;
switch (_that) {
case _BlockedUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  String name,  DateTime blockedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlockedUser() when $default != null:
return $default(_that.userId,_that.name,_that.blockedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  String name,  DateTime blockedAt)  $default,) {final _that = this;
switch (_that) {
case _BlockedUser():
return $default(_that.userId,_that.name,_that.blockedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  String name,  DateTime blockedAt)?  $default,) {final _that = this;
switch (_that) {
case _BlockedUser() when $default != null:
return $default(_that.userId,_that.name,_that.blockedAt);case _:
  return null;

}
}

}

/// @nodoc


class _BlockedUser implements BlockedUser {
  const _BlockedUser({required this.userId, required this.name, required this.blockedAt});
  

@override final  int userId;
@override final  String name;
@override final  DateTime blockedAt;

/// Create a copy of BlockedUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedUserCopyWith<_BlockedUser> get copyWith => __$BlockedUserCopyWithImpl<_BlockedUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedUser&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.blockedAt, blockedAt) || other.blockedAt == blockedAt));
}


@override
int get hashCode => Object.hash(runtimeType,userId,name,blockedAt);

@override
String toString() {
  return 'BlockedUser(userId: $userId, name: $name, blockedAt: $blockedAt)';
}


}

/// @nodoc
abstract mixin class _$BlockedUserCopyWith<$Res> implements $BlockedUserCopyWith<$Res> {
  factory _$BlockedUserCopyWith(_BlockedUser value, $Res Function(_BlockedUser) _then) = __$BlockedUserCopyWithImpl;
@override @useResult
$Res call({
 int userId, String name, DateTime blockedAt
});




}
/// @nodoc
class __$BlockedUserCopyWithImpl<$Res>
    implements _$BlockedUserCopyWith<$Res> {
  __$BlockedUserCopyWithImpl(this._self, this._then);

  final _BlockedUser _self;
  final $Res Function(_BlockedUser) _then;

/// Create a copy of BlockedUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? blockedAt = null,}) {
  return _then(_BlockedUser(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,blockedAt: null == blockedAt ? _self.blockedAt : blockedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
