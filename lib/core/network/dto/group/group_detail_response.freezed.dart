// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_detail_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupDetailResponse {

 int get groupId; String get name; String get description; String get inviteCode; int get ownerUserId; int get memberCount; List<GroupMemberResponse> get members;// 진행 중인 사이클이 없으면 null.
 GroupCycleResponse? get currentCycle;// 현재 사용자가 새 사이클을 시작할 수 있는지 여부.
 bool get canStartCycle; DateTime get createdAt;
/// Create a copy of GroupDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupDetailResponseCopyWith<GroupDetailResponse> get copyWith => _$GroupDetailResponseCopyWithImpl<GroupDetailResponse>(this as GroupDetailResponse, _$identity);

  /// Serializes this GroupDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupDetailResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle)&&(identical(other.canStartCycle, canStartCycle) || other.canStartCycle == canStartCycle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,name,description,inviteCode,ownerUserId,memberCount,const DeepCollectionEquality().hash(members),currentCycle,canStartCycle,createdAt);

@override
String toString() {
  return 'GroupDetailResponse(groupId: $groupId, name: $name, description: $description, inviteCode: $inviteCode, ownerUserId: $ownerUserId, memberCount: $memberCount, members: $members, currentCycle: $currentCycle, canStartCycle: $canStartCycle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $GroupDetailResponseCopyWith<$Res>  {
  factory $GroupDetailResponseCopyWith(GroupDetailResponse value, $Res Function(GroupDetailResponse) _then) = _$GroupDetailResponseCopyWithImpl;
@useResult
$Res call({
 int groupId, String name, String description, String inviteCode, int ownerUserId, int memberCount, List<GroupMemberResponse> members, GroupCycleResponse? currentCycle, bool canStartCycle, DateTime createdAt
});


$GroupCycleResponseCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class _$GroupDetailResponseCopyWithImpl<$Res>
    implements $GroupDetailResponseCopyWith<$Res> {
  _$GroupDetailResponseCopyWithImpl(this._self, this._then);

  final GroupDetailResponse _self;
  final $Res Function(GroupDetailResponse) _then;

/// Create a copy of GroupDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? name = null,Object? description = null,Object? inviteCode = null,Object? ownerUserId = null,Object? memberCount = null,Object? members = null,Object? currentCycle = freezed,Object? canStartCycle = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as int,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<GroupMemberResponse>,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as GroupCycleResponse?,canStartCycle: null == canStartCycle ? _self.canStartCycle : canStartCycle // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of GroupDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCycleResponseCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $GroupCycleResponseCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}


/// Adds pattern-matching-related methods to [GroupDetailResponse].
extension GroupDetailResponsePatterns on GroupDetailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupDetailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupDetailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupDetailResponse value)  $default,){
final _that = this;
switch (_that) {
case _GroupDetailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupDetailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GroupDetailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int groupId,  String name,  String description,  String inviteCode,  int ownerUserId,  int memberCount,  List<GroupMemberResponse> members,  GroupCycleResponse? currentCycle,  bool canStartCycle,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupDetailResponse() when $default != null:
return $default(_that.groupId,_that.name,_that.description,_that.inviteCode,_that.ownerUserId,_that.memberCount,_that.members,_that.currentCycle,_that.canStartCycle,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int groupId,  String name,  String description,  String inviteCode,  int ownerUserId,  int memberCount,  List<GroupMemberResponse> members,  GroupCycleResponse? currentCycle,  bool canStartCycle,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _GroupDetailResponse():
return $default(_that.groupId,_that.name,_that.description,_that.inviteCode,_that.ownerUserId,_that.memberCount,_that.members,_that.currentCycle,_that.canStartCycle,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int groupId,  String name,  String description,  String inviteCode,  int ownerUserId,  int memberCount,  List<GroupMemberResponse> members,  GroupCycleResponse? currentCycle,  bool canStartCycle,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _GroupDetailResponse() when $default != null:
return $default(_that.groupId,_that.name,_that.description,_that.inviteCode,_that.ownerUserId,_that.memberCount,_that.members,_that.currentCycle,_that.canStartCycle,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupDetailResponse implements GroupDetailResponse {
  const _GroupDetailResponse({required this.groupId, required this.name, required this.description, required this.inviteCode, required this.ownerUserId, required this.memberCount, required final  List<GroupMemberResponse> members, required this.currentCycle, required this.canStartCycle, required this.createdAt}): _members = members;
  factory _GroupDetailResponse.fromJson(Map<String, dynamic> json) => _$GroupDetailResponseFromJson(json);

@override final  int groupId;
@override final  String name;
@override final  String description;
@override final  String inviteCode;
@override final  int ownerUserId;
@override final  int memberCount;
 final  List<GroupMemberResponse> _members;
@override List<GroupMemberResponse> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

// 진행 중인 사이클이 없으면 null.
@override final  GroupCycleResponse? currentCycle;
// 현재 사용자가 새 사이클을 시작할 수 있는지 여부.
@override final  bool canStartCycle;
@override final  DateTime createdAt;

/// Create a copy of GroupDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupDetailResponseCopyWith<_GroupDetailResponse> get copyWith => __$GroupDetailResponseCopyWithImpl<_GroupDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupDetailResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle)&&(identical(other.canStartCycle, canStartCycle) || other.canStartCycle == canStartCycle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,name,description,inviteCode,ownerUserId,memberCount,const DeepCollectionEquality().hash(_members),currentCycle,canStartCycle,createdAt);

@override
String toString() {
  return 'GroupDetailResponse(groupId: $groupId, name: $name, description: $description, inviteCode: $inviteCode, ownerUserId: $ownerUserId, memberCount: $memberCount, members: $members, currentCycle: $currentCycle, canStartCycle: $canStartCycle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$GroupDetailResponseCopyWith<$Res> implements $GroupDetailResponseCopyWith<$Res> {
  factory _$GroupDetailResponseCopyWith(_GroupDetailResponse value, $Res Function(_GroupDetailResponse) _then) = __$GroupDetailResponseCopyWithImpl;
@override @useResult
$Res call({
 int groupId, String name, String description, String inviteCode, int ownerUserId, int memberCount, List<GroupMemberResponse> members, GroupCycleResponse? currentCycle, bool canStartCycle, DateTime createdAt
});


@override $GroupCycleResponseCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class __$GroupDetailResponseCopyWithImpl<$Res>
    implements _$GroupDetailResponseCopyWith<$Res> {
  __$GroupDetailResponseCopyWithImpl(this._self, this._then);

  final _GroupDetailResponse _self;
  final $Res Function(_GroupDetailResponse) _then;

/// Create a copy of GroupDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? name = null,Object? description = null,Object? inviteCode = null,Object? ownerUserId = null,Object? memberCount = null,Object? members = null,Object? currentCycle = freezed,Object? canStartCycle = null,Object? createdAt = null,}) {
  return _then(_GroupDetailResponse(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as int,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<GroupMemberResponse>,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as GroupCycleResponse?,canStartCycle: null == canStartCycle ? _self.canStartCycle : canStartCycle // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of GroupDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCycleResponseCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $GroupCycleResponseCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}


/// @nodoc
mixin _$GroupMemberResponse {

 int get userId; String get nickname; String? get profileImageUrl; String get role;
/// Create a copy of GroupMemberResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupMemberResponseCopyWith<GroupMemberResponse> get copyWith => _$GroupMemberResponseCopyWithImpl<GroupMemberResponse>(this as GroupMemberResponse, _$identity);

  /// Serializes this GroupMemberResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupMemberResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,nickname,profileImageUrl,role);

@override
String toString() {
  return 'GroupMemberResponse(userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, role: $role)';
}


}

/// @nodoc
abstract mixin class $GroupMemberResponseCopyWith<$Res>  {
  factory $GroupMemberResponseCopyWith(GroupMemberResponse value, $Res Function(GroupMemberResponse) _then) = _$GroupMemberResponseCopyWithImpl;
@useResult
$Res call({
 int userId, String nickname, String? profileImageUrl, String role
});




}
/// @nodoc
class _$GroupMemberResponseCopyWithImpl<$Res>
    implements $GroupMemberResponseCopyWith<$Res> {
  _$GroupMemberResponseCopyWithImpl(this._self, this._then);

  final GroupMemberResponse _self;
  final $Res Function(GroupMemberResponse) _then;

/// Create a copy of GroupMemberResponse
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


/// Adds pattern-matching-related methods to [GroupMemberResponse].
extension GroupMemberResponsePatterns on GroupMemberResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupMemberResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupMemberResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupMemberResponse value)  $default,){
final _that = this;
switch (_that) {
case _GroupMemberResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupMemberResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GroupMemberResponse() when $default != null:
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
case _GroupMemberResponse() when $default != null:
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
case _GroupMemberResponse():
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
case _GroupMemberResponse() when $default != null:
return $default(_that.userId,_that.nickname,_that.profileImageUrl,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupMemberResponse implements GroupMemberResponse {
  const _GroupMemberResponse({required this.userId, required this.nickname, required this.profileImageUrl, required this.role});
  factory _GroupMemberResponse.fromJson(Map<String, dynamic> json) => _$GroupMemberResponseFromJson(json);

@override final  int userId;
@override final  String nickname;
@override final  String? profileImageUrl;
@override final  String role;

/// Create a copy of GroupMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupMemberResponseCopyWith<_GroupMemberResponse> get copyWith => __$GroupMemberResponseCopyWithImpl<_GroupMemberResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupMemberResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupMemberResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,nickname,profileImageUrl,role);

@override
String toString() {
  return 'GroupMemberResponse(userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, role: $role)';
}


}

/// @nodoc
abstract mixin class _$GroupMemberResponseCopyWith<$Res> implements $GroupMemberResponseCopyWith<$Res> {
  factory _$GroupMemberResponseCopyWith(_GroupMemberResponse value, $Res Function(_GroupMemberResponse) _then) = __$GroupMemberResponseCopyWithImpl;
@override @useResult
$Res call({
 int userId, String nickname, String? profileImageUrl, String role
});




}
/// @nodoc
class __$GroupMemberResponseCopyWithImpl<$Res>
    implements _$GroupMemberResponseCopyWith<$Res> {
  __$GroupMemberResponseCopyWithImpl(this._self, this._then);

  final _GroupMemberResponse _self;
  final $Res Function(_GroupMemberResponse) _then;

/// Create a copy of GroupMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? nickname = null,Object? profileImageUrl = freezed,Object? role = null,}) {
  return _then(_GroupMemberResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GroupCycleResponse {

 int get cycleId; int get cycleNumber; String get topic; int get starterUserId; String get starterNickname; String? get starterImageUrl; String get status; DateTime get startedAt; DateTime get deadlineAt;
/// Create a copy of GroupCycleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupCycleResponseCopyWith<GroupCycleResponse> get copyWith => _$GroupCycleResponseCopyWithImpl<GroupCycleResponse>(this as GroupCycleResponse, _$identity);

  /// Serializes this GroupCycleResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupCycleResponse&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.cycleNumber, cycleNumber) || other.cycleNumber == cycleNumber)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId)&&(identical(other.starterNickname, starterNickname) || other.starterNickname == starterNickname)&&(identical(other.starterImageUrl, starterImageUrl) || other.starterImageUrl == starterImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,cycleNumber,topic,starterUserId,starterNickname,starterImageUrl,status,startedAt,deadlineAt);

@override
String toString() {
  return 'GroupCycleResponse(cycleId: $cycleId, cycleNumber: $cycleNumber, topic: $topic, starterUserId: $starterUserId, starterNickname: $starterNickname, starterImageUrl: $starterImageUrl, status: $status, startedAt: $startedAt, deadlineAt: $deadlineAt)';
}


}

/// @nodoc
abstract mixin class $GroupCycleResponseCopyWith<$Res>  {
  factory $GroupCycleResponseCopyWith(GroupCycleResponse value, $Res Function(GroupCycleResponse) _then) = _$GroupCycleResponseCopyWithImpl;
@useResult
$Res call({
 int cycleId, int cycleNumber, String topic, int starterUserId, String starterNickname, String? starterImageUrl, String status, DateTime startedAt, DateTime deadlineAt
});




}
/// @nodoc
class _$GroupCycleResponseCopyWithImpl<$Res>
    implements $GroupCycleResponseCopyWith<$Res> {
  _$GroupCycleResponseCopyWithImpl(this._self, this._then);

  final GroupCycleResponse _self;
  final $Res Function(GroupCycleResponse) _then;

/// Create a copy of GroupCycleResponse
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


/// Adds pattern-matching-related methods to [GroupCycleResponse].
extension GroupCycleResponsePatterns on GroupCycleResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupCycleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupCycleResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupCycleResponse value)  $default,){
final _that = this;
switch (_that) {
case _GroupCycleResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupCycleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GroupCycleResponse() when $default != null:
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
case _GroupCycleResponse() when $default != null:
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
case _GroupCycleResponse():
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
case _GroupCycleResponse() when $default != null:
return $default(_that.cycleId,_that.cycleNumber,_that.topic,_that.starterUserId,_that.starterNickname,_that.starterImageUrl,_that.status,_that.startedAt,_that.deadlineAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupCycleResponse implements GroupCycleResponse {
  const _GroupCycleResponse({required this.cycleId, required this.cycleNumber, required this.topic, required this.starterUserId, required this.starterNickname, required this.starterImageUrl, required this.status, required this.startedAt, required this.deadlineAt});
  factory _GroupCycleResponse.fromJson(Map<String, dynamic> json) => _$GroupCycleResponseFromJson(json);

@override final  int cycleId;
@override final  int cycleNumber;
@override final  String topic;
@override final  int starterUserId;
@override final  String starterNickname;
@override final  String? starterImageUrl;
@override final  String status;
@override final  DateTime startedAt;
@override final  DateTime deadlineAt;

/// Create a copy of GroupCycleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupCycleResponseCopyWith<_GroupCycleResponse> get copyWith => __$GroupCycleResponseCopyWithImpl<_GroupCycleResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupCycleResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupCycleResponse&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.cycleNumber, cycleNumber) || other.cycleNumber == cycleNumber)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId)&&(identical(other.starterNickname, starterNickname) || other.starterNickname == starterNickname)&&(identical(other.starterImageUrl, starterImageUrl) || other.starterImageUrl == starterImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,cycleNumber,topic,starterUserId,starterNickname,starterImageUrl,status,startedAt,deadlineAt);

@override
String toString() {
  return 'GroupCycleResponse(cycleId: $cycleId, cycleNumber: $cycleNumber, topic: $topic, starterUserId: $starterUserId, starterNickname: $starterNickname, starterImageUrl: $starterImageUrl, status: $status, startedAt: $startedAt, deadlineAt: $deadlineAt)';
}


}

/// @nodoc
abstract mixin class _$GroupCycleResponseCopyWith<$Res> implements $GroupCycleResponseCopyWith<$Res> {
  factory _$GroupCycleResponseCopyWith(_GroupCycleResponse value, $Res Function(_GroupCycleResponse) _then) = __$GroupCycleResponseCopyWithImpl;
@override @useResult
$Res call({
 int cycleId, int cycleNumber, String topic, int starterUserId, String starterNickname, String? starterImageUrl, String status, DateTime startedAt, DateTime deadlineAt
});




}
/// @nodoc
class __$GroupCycleResponseCopyWithImpl<$Res>
    implements _$GroupCycleResponseCopyWith<$Res> {
  __$GroupCycleResponseCopyWithImpl(this._self, this._then);

  final _GroupCycleResponse _self;
  final $Res Function(_GroupCycleResponse) _then;

/// Create a copy of GroupCycleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,Object? cycleNumber = null,Object? topic = null,Object? starterUserId = null,Object? starterNickname = null,Object? starterImageUrl = freezed,Object? status = null,Object? startedAt = null,Object? deadlineAt = null,}) {
  return _then(_GroupCycleResponse(
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
