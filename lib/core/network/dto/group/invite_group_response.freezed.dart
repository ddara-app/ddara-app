// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_group_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InviteGroupResponse {

 int get groupId; String get name; String get description; String get ownerNickname; int get memberCount; int get capacity; bool get isFull; List<String?> get memberAvatars; bool get alreadyJoined; DateTime get createdAt;
/// Create a copy of InviteGroupResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteGroupResponseCopyWith<InviteGroupResponse> get copyWith => _$InviteGroupResponseCopyWithImpl<InviteGroupResponse>(this as InviteGroupResponse, _$identity);

  /// Serializes this InviteGroupResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InviteGroupResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.ownerNickname, ownerNickname) || other.ownerNickname == ownerNickname)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.isFull, isFull) || other.isFull == isFull)&&const DeepCollectionEquality().equals(other.memberAvatars, memberAvatars)&&(identical(other.alreadyJoined, alreadyJoined) || other.alreadyJoined == alreadyJoined)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,name,description,ownerNickname,memberCount,capacity,isFull,const DeepCollectionEquality().hash(memberAvatars),alreadyJoined,createdAt);

@override
String toString() {
  return 'InviteGroupResponse(groupId: $groupId, name: $name, description: $description, ownerNickname: $ownerNickname, memberCount: $memberCount, capacity: $capacity, isFull: $isFull, memberAvatars: $memberAvatars, alreadyJoined: $alreadyJoined, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $InviteGroupResponseCopyWith<$Res>  {
  factory $InviteGroupResponseCopyWith(InviteGroupResponse value, $Res Function(InviteGroupResponse) _then) = _$InviteGroupResponseCopyWithImpl;
@useResult
$Res call({
 int groupId, String name, String description, String ownerNickname, int memberCount, int capacity, bool isFull, List<String?> memberAvatars, bool alreadyJoined, DateTime createdAt
});




}
/// @nodoc
class _$InviteGroupResponseCopyWithImpl<$Res>
    implements $InviteGroupResponseCopyWith<$Res> {
  _$InviteGroupResponseCopyWithImpl(this._self, this._then);

  final InviteGroupResponse _self;
  final $Res Function(InviteGroupResponse) _then;

/// Create a copy of InviteGroupResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? name = null,Object? description = null,Object? ownerNickname = null,Object? memberCount = null,Object? capacity = null,Object? isFull = null,Object? memberAvatars = null,Object? alreadyJoined = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,ownerNickname: null == ownerNickname ? _self.ownerNickname : ownerNickname // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,isFull: null == isFull ? _self.isFull : isFull // ignore: cast_nullable_to_non_nullable
as bool,memberAvatars: null == memberAvatars ? _self.memberAvatars : memberAvatars // ignore: cast_nullable_to_non_nullable
as List<String?>,alreadyJoined: null == alreadyJoined ? _self.alreadyJoined : alreadyJoined // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InviteGroupResponse].
extension InviteGroupResponsePatterns on InviteGroupResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InviteGroupResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InviteGroupResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InviteGroupResponse value)  $default,){
final _that = this;
switch (_that) {
case _InviteGroupResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InviteGroupResponse value)?  $default,){
final _that = this;
switch (_that) {
case _InviteGroupResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int groupId,  String name,  String description,  String ownerNickname,  int memberCount,  int capacity,  bool isFull,  List<String?> memberAvatars,  bool alreadyJoined,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InviteGroupResponse() when $default != null:
return $default(_that.groupId,_that.name,_that.description,_that.ownerNickname,_that.memberCount,_that.capacity,_that.isFull,_that.memberAvatars,_that.alreadyJoined,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int groupId,  String name,  String description,  String ownerNickname,  int memberCount,  int capacity,  bool isFull,  List<String?> memberAvatars,  bool alreadyJoined,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _InviteGroupResponse():
return $default(_that.groupId,_that.name,_that.description,_that.ownerNickname,_that.memberCount,_that.capacity,_that.isFull,_that.memberAvatars,_that.alreadyJoined,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int groupId,  String name,  String description,  String ownerNickname,  int memberCount,  int capacity,  bool isFull,  List<String?> memberAvatars,  bool alreadyJoined,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _InviteGroupResponse() when $default != null:
return $default(_that.groupId,_that.name,_that.description,_that.ownerNickname,_that.memberCount,_that.capacity,_that.isFull,_that.memberAvatars,_that.alreadyJoined,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InviteGroupResponse implements InviteGroupResponse {
  const _InviteGroupResponse({required this.groupId, required this.name, required this.description, required this.ownerNickname, required this.memberCount, required this.capacity, required this.isFull, required final  List<String?> memberAvatars, required this.alreadyJoined, required this.createdAt}): _memberAvatars = memberAvatars;
  factory _InviteGroupResponse.fromJson(Map<String, dynamic> json) => _$InviteGroupResponseFromJson(json);

@override final  int groupId;
@override final  String name;
@override final  String description;
@override final  String ownerNickname;
@override final  int memberCount;
@override final  int capacity;
@override final  bool isFull;
 final  List<String?> _memberAvatars;
@override List<String?> get memberAvatars {
  if (_memberAvatars is EqualUnmodifiableListView) return _memberAvatars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberAvatars);
}

@override final  bool alreadyJoined;
@override final  DateTime createdAt;

/// Create a copy of InviteGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteGroupResponseCopyWith<_InviteGroupResponse> get copyWith => __$InviteGroupResponseCopyWithImpl<_InviteGroupResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InviteGroupResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteGroupResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.ownerNickname, ownerNickname) || other.ownerNickname == ownerNickname)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.isFull, isFull) || other.isFull == isFull)&&const DeepCollectionEquality().equals(other._memberAvatars, _memberAvatars)&&(identical(other.alreadyJoined, alreadyJoined) || other.alreadyJoined == alreadyJoined)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,name,description,ownerNickname,memberCount,capacity,isFull,const DeepCollectionEquality().hash(_memberAvatars),alreadyJoined,createdAt);

@override
String toString() {
  return 'InviteGroupResponse(groupId: $groupId, name: $name, description: $description, ownerNickname: $ownerNickname, memberCount: $memberCount, capacity: $capacity, isFull: $isFull, memberAvatars: $memberAvatars, alreadyJoined: $alreadyJoined, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$InviteGroupResponseCopyWith<$Res> implements $InviteGroupResponseCopyWith<$Res> {
  factory _$InviteGroupResponseCopyWith(_InviteGroupResponse value, $Res Function(_InviteGroupResponse) _then) = __$InviteGroupResponseCopyWithImpl;
@override @useResult
$Res call({
 int groupId, String name, String description, String ownerNickname, int memberCount, int capacity, bool isFull, List<String?> memberAvatars, bool alreadyJoined, DateTime createdAt
});




}
/// @nodoc
class __$InviteGroupResponseCopyWithImpl<$Res>
    implements _$InviteGroupResponseCopyWith<$Res> {
  __$InviteGroupResponseCopyWithImpl(this._self, this._then);

  final _InviteGroupResponse _self;
  final $Res Function(_InviteGroupResponse) _then;

/// Create a copy of InviteGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? name = null,Object? description = null,Object? ownerNickname = null,Object? memberCount = null,Object? capacity = null,Object? isFull = null,Object? memberAvatars = null,Object? alreadyJoined = null,Object? createdAt = null,}) {
  return _then(_InviteGroupResponse(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,ownerNickname: null == ownerNickname ? _self.ownerNickname : ownerNickname // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,isFull: null == isFull ? _self.isFull : isFull // ignore: cast_nullable_to_non_nullable
as bool,memberAvatars: null == memberAvatars ? _self._memberAvatars : memberAvatars // ignore: cast_nullable_to_non_nullable
as List<String?>,alreadyJoined: null == alreadyJoined ? _self.alreadyJoined : alreadyJoined // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
