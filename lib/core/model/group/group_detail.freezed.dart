// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroupDetail {

 int get groupId; String get name; String get inviteCode; List<GroupMember> get members;// 진행 중인 사이클이 없으면 null.
 GroupCycle? get currentCycle; DateTime get createdAt;
/// Create a copy of GroupDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupDetailCopyWith<GroupDetail> get copyWith => _$GroupDetailCopyWithImpl<GroupDetail>(this as GroupDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupDetail&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,groupId,name,inviteCode,const DeepCollectionEquality().hash(members),currentCycle,createdAt);

@override
String toString() {
  return 'GroupDetail(groupId: $groupId, name: $name, inviteCode: $inviteCode, members: $members, currentCycle: $currentCycle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $GroupDetailCopyWith<$Res>  {
  factory $GroupDetailCopyWith(GroupDetail value, $Res Function(GroupDetail) _then) = _$GroupDetailCopyWithImpl;
@useResult
$Res call({
 int groupId, String name, String inviteCode, List<GroupMember> members, GroupCycle? currentCycle, DateTime createdAt
});


$GroupCycleCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class _$GroupDetailCopyWithImpl<$Res>
    implements $GroupDetailCopyWith<$Res> {
  _$GroupDetailCopyWithImpl(this._self, this._then);

  final GroupDetail _self;
  final $Res Function(GroupDetail) _then;

/// Create a copy of GroupDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? name = null,Object? inviteCode = null,Object? members = null,Object? currentCycle = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<GroupMember>,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as GroupCycle?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of GroupDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCycleCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $GroupCycleCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}


/// Adds pattern-matching-related methods to [GroupDetail].
extension GroupDetailPatterns on GroupDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupDetail value)  $default,){
final _that = this;
switch (_that) {
case _GroupDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupDetail value)?  $default,){
final _that = this;
switch (_that) {
case _GroupDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int groupId,  String name,  String inviteCode,  List<GroupMember> members,  GroupCycle? currentCycle,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupDetail() when $default != null:
return $default(_that.groupId,_that.name,_that.inviteCode,_that.members,_that.currentCycle,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int groupId,  String name,  String inviteCode,  List<GroupMember> members,  GroupCycle? currentCycle,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _GroupDetail():
return $default(_that.groupId,_that.name,_that.inviteCode,_that.members,_that.currentCycle,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int groupId,  String name,  String inviteCode,  List<GroupMember> members,  GroupCycle? currentCycle,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _GroupDetail() when $default != null:
return $default(_that.groupId,_that.name,_that.inviteCode,_that.members,_that.currentCycle,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _GroupDetail implements GroupDetail {
  const _GroupDetail({required this.groupId, required this.name, required this.inviteCode, required final  List<GroupMember> members, required this.currentCycle, required this.createdAt}): _members = members;
  

@override final  int groupId;
@override final  String name;
@override final  String inviteCode;
 final  List<GroupMember> _members;
@override List<GroupMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

// 진행 중인 사이클이 없으면 null.
@override final  GroupCycle? currentCycle;
@override final  DateTime createdAt;

/// Create a copy of GroupDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupDetailCopyWith<_GroupDetail> get copyWith => __$GroupDetailCopyWithImpl<_GroupDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupDetail&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,groupId,name,inviteCode,const DeepCollectionEquality().hash(_members),currentCycle,createdAt);

@override
String toString() {
  return 'GroupDetail(groupId: $groupId, name: $name, inviteCode: $inviteCode, members: $members, currentCycle: $currentCycle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$GroupDetailCopyWith<$Res> implements $GroupDetailCopyWith<$Res> {
  factory _$GroupDetailCopyWith(_GroupDetail value, $Res Function(_GroupDetail) _then) = __$GroupDetailCopyWithImpl;
@override @useResult
$Res call({
 int groupId, String name, String inviteCode, List<GroupMember> members, GroupCycle? currentCycle, DateTime createdAt
});


@override $GroupCycleCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class __$GroupDetailCopyWithImpl<$Res>
    implements _$GroupDetailCopyWith<$Res> {
  __$GroupDetailCopyWithImpl(this._self, this._then);

  final _GroupDetail _self;
  final $Res Function(_GroupDetail) _then;

/// Create a copy of GroupDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? name = null,Object? inviteCode = null,Object? members = null,Object? currentCycle = freezed,Object? createdAt = null,}) {
  return _then(_GroupDetail(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<GroupMember>,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as GroupCycle?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of GroupDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCycleCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $GroupCycleCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}

/// @nodoc
mixin _$GroupMember {

 int get userId; String get nickname; String? get profileImageUrl; String get role;
/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupMemberCopyWith<GroupMember> get copyWith => _$GroupMemberCopyWithImpl<GroupMember>(this as GroupMember, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,userId,nickname,profileImageUrl,role);

@override
String toString() {
  return 'GroupMember(userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, role: $role)';
}


}

/// @nodoc
abstract mixin class $GroupMemberCopyWith<$Res>  {
  factory $GroupMemberCopyWith(GroupMember value, $Res Function(GroupMember) _then) = _$GroupMemberCopyWithImpl;
@useResult
$Res call({
 int userId, String nickname, String? profileImageUrl, String role
});




}
/// @nodoc
class _$GroupMemberCopyWithImpl<$Res>
    implements $GroupMemberCopyWith<$Res> {
  _$GroupMemberCopyWithImpl(this._self, this._then);

  final GroupMember _self;
  final $Res Function(GroupMember) _then;

/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? nickname = null,Object? profileImageUrl = freezed,Object? role = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupMember].
extension GroupMemberPatterns on GroupMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupMember value)  $default,){
final _that = this;
switch (_that) {
case _GroupMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupMember value)?  $default,){
final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  String nickname,  String? profileImageUrl,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
return $default(_that.userId,_that.nickname,_that.profileImageUrl,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  String nickname,  String? profileImageUrl,  String role)  $default,) {final _that = this;
switch (_that) {
case _GroupMember():
return $default(_that.userId,_that.nickname,_that.profileImageUrl,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  String nickname,  String? profileImageUrl,  String role)?  $default,) {final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
return $default(_that.userId,_that.nickname,_that.profileImageUrl,_that.role);case _:
  return null;

}
}

}

/// @nodoc


class _GroupMember implements GroupMember {
  const _GroupMember({required this.userId, required this.nickname, required this.profileImageUrl, required this.role});
  

@override final  int userId;
@override final  String nickname;
@override final  String? profileImageUrl;
@override final  String role;

/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupMemberCopyWith<_GroupMember> get copyWith => __$GroupMemberCopyWithImpl<_GroupMember>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,userId,nickname,profileImageUrl,role);

@override
String toString() {
  return 'GroupMember(userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, role: $role)';
}


}

/// @nodoc
abstract mixin class _$GroupMemberCopyWith<$Res> implements $GroupMemberCopyWith<$Res> {
  factory _$GroupMemberCopyWith(_GroupMember value, $Res Function(_GroupMember) _then) = __$GroupMemberCopyWithImpl;
@override @useResult
$Res call({
 int userId, String nickname, String? profileImageUrl, String role
});




}
/// @nodoc
class __$GroupMemberCopyWithImpl<$Res>
    implements _$GroupMemberCopyWith<$Res> {
  __$GroupMemberCopyWithImpl(this._self, this._then);

  final _GroupMember _self;
  final $Res Function(_GroupMember) _then;

/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? nickname = null,Object? profileImageUrl = freezed,Object? role = null,}) {
  return _then(_GroupMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$GroupCycle {

 int get cycleId; int get cycleNumber; String get topic; int get starterUserId; String get starterNickname; String? get starterImageUrl; String get status; DateTime get startedAt; DateTime get deadlineAt;
/// Create a copy of GroupCycle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupCycleCopyWith<GroupCycle> get copyWith => _$GroupCycleCopyWithImpl<GroupCycle>(this as GroupCycle, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupCycle&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.cycleNumber, cycleNumber) || other.cycleNumber == cycleNumber)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId)&&(identical(other.starterNickname, starterNickname) || other.starterNickname == starterNickname)&&(identical(other.starterImageUrl, starterImageUrl) || other.starterImageUrl == starterImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt));
}


@override
int get hashCode => Object.hash(runtimeType,cycleId,cycleNumber,topic,starterUserId,starterNickname,starterImageUrl,status,startedAt,deadlineAt);

@override
String toString() {
  return 'GroupCycle(cycleId: $cycleId, cycleNumber: $cycleNumber, topic: $topic, starterUserId: $starterUserId, starterNickname: $starterNickname, starterImageUrl: $starterImageUrl, status: $status, startedAt: $startedAt, deadlineAt: $deadlineAt)';
}


}

/// @nodoc
abstract mixin class $GroupCycleCopyWith<$Res>  {
  factory $GroupCycleCopyWith(GroupCycle value, $Res Function(GroupCycle) _then) = _$GroupCycleCopyWithImpl;
@useResult
$Res call({
 int cycleId, int cycleNumber, String topic, int starterUserId, String starterNickname, String? starterImageUrl, String status, DateTime startedAt, DateTime deadlineAt
});




}
/// @nodoc
class _$GroupCycleCopyWithImpl<$Res>
    implements $GroupCycleCopyWith<$Res> {
  _$GroupCycleCopyWithImpl(this._self, this._then);

  final GroupCycle _self;
  final $Res Function(GroupCycle) _then;

/// Create a copy of GroupCycle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cycleId = null,Object? cycleNumber = null,Object? topic = null,Object? starterUserId = null,Object? starterNickname = null,Object? starterImageUrl = freezed,Object? status = null,Object? startedAt = null,Object? deadlineAt = null,}) {
  return _then(_self.copyWith(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,cycleNumber: null == cycleNumber ? _self.cycleNumber : cycleNumber // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,starterUserId: null == starterUserId ? _self.starterUserId : starterUserId // ignore: cast_nullable_to_non_nullable
as int,starterNickname: null == starterNickname ? _self.starterNickname : starterNickname // ignore: cast_nullable_to_non_nullable
as String,starterImageUrl: freezed == starterImageUrl ? _self.starterImageUrl : starterImageUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deadlineAt: null == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupCycle].
extension GroupCyclePatterns on GroupCycle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupCycle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupCycle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupCycle value)  $default,){
final _that = this;
switch (_that) {
case _GroupCycle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupCycle value)?  $default,){
final _that = this;
switch (_that) {
case _GroupCycle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int cycleId,  int cycleNumber,  String topic,  int starterUserId,  String starterNickname,  String? starterImageUrl,  String status,  DateTime startedAt,  DateTime deadlineAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupCycle() when $default != null:
return $default(_that.cycleId,_that.cycleNumber,_that.topic,_that.starterUserId,_that.starterNickname,_that.starterImageUrl,_that.status,_that.startedAt,_that.deadlineAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int cycleId,  int cycleNumber,  String topic,  int starterUserId,  String starterNickname,  String? starterImageUrl,  String status,  DateTime startedAt,  DateTime deadlineAt)  $default,) {final _that = this;
switch (_that) {
case _GroupCycle():
return $default(_that.cycleId,_that.cycleNumber,_that.topic,_that.starterUserId,_that.starterNickname,_that.starterImageUrl,_that.status,_that.startedAt,_that.deadlineAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int cycleId,  int cycleNumber,  String topic,  int starterUserId,  String starterNickname,  String? starterImageUrl,  String status,  DateTime startedAt,  DateTime deadlineAt)?  $default,) {final _that = this;
switch (_that) {
case _GroupCycle() when $default != null:
return $default(_that.cycleId,_that.cycleNumber,_that.topic,_that.starterUserId,_that.starterNickname,_that.starterImageUrl,_that.status,_that.startedAt,_that.deadlineAt);case _:
  return null;

}
}

}

/// @nodoc


class _GroupCycle implements GroupCycle {
  const _GroupCycle({required this.cycleId, required this.cycleNumber, required this.topic, required this.starterUserId, required this.starterNickname, required this.starterImageUrl, required this.status, required this.startedAt, required this.deadlineAt});
  

@override final  int cycleId;
@override final  int cycleNumber;
@override final  String topic;
@override final  int starterUserId;
@override final  String starterNickname;
@override final  String? starterImageUrl;
@override final  String status;
@override final  DateTime startedAt;
@override final  DateTime deadlineAt;

/// Create a copy of GroupCycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupCycleCopyWith<_GroupCycle> get copyWith => __$GroupCycleCopyWithImpl<_GroupCycle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupCycle&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.cycleNumber, cycleNumber) || other.cycleNumber == cycleNumber)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId)&&(identical(other.starterNickname, starterNickname) || other.starterNickname == starterNickname)&&(identical(other.starterImageUrl, starterImageUrl) || other.starterImageUrl == starterImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt));
}


@override
int get hashCode => Object.hash(runtimeType,cycleId,cycleNumber,topic,starterUserId,starterNickname,starterImageUrl,status,startedAt,deadlineAt);

@override
String toString() {
  return 'GroupCycle(cycleId: $cycleId, cycleNumber: $cycleNumber, topic: $topic, starterUserId: $starterUserId, starterNickname: $starterNickname, starterImageUrl: $starterImageUrl, status: $status, startedAt: $startedAt, deadlineAt: $deadlineAt)';
}


}

/// @nodoc
abstract mixin class _$GroupCycleCopyWith<$Res> implements $GroupCycleCopyWith<$Res> {
  factory _$GroupCycleCopyWith(_GroupCycle value, $Res Function(_GroupCycle) _then) = __$GroupCycleCopyWithImpl;
@override @useResult
$Res call({
 int cycleId, int cycleNumber, String topic, int starterUserId, String starterNickname, String? starterImageUrl, String status, DateTime startedAt, DateTime deadlineAt
});




}
/// @nodoc
class __$GroupCycleCopyWithImpl<$Res>
    implements _$GroupCycleCopyWith<$Res> {
  __$GroupCycleCopyWithImpl(this._self, this._then);

  final _GroupCycle _self;
  final $Res Function(_GroupCycle) _then;

/// Create a copy of GroupCycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,Object? cycleNumber = null,Object? topic = null,Object? starterUserId = null,Object? starterNickname = null,Object? starterImageUrl = freezed,Object? status = null,Object? startedAt = null,Object? deadlineAt = null,}) {
  return _then(_GroupCycle(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,cycleNumber: null == cycleNumber ? _self.cycleNumber : cycleNumber // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,starterUserId: null == starterUserId ? _self.starterUserId : starterUserId // ignore: cast_nullable_to_non_nullable
as int,starterNickname: null == starterNickname ? _self.starterNickname : starterNickname // ignore: cast_nullable_to_non_nullable
as String,starterImageUrl: freezed == starterImageUrl ? _self.starterImageUrl : starterImageUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deadlineAt: null == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
