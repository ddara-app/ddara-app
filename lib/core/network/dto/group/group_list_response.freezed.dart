// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupListResponse {

 List<GroupResponse> get groups;
/// Create a copy of GroupListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupListResponseCopyWith<GroupListResponse> get copyWith => _$GroupListResponseCopyWithImpl<GroupListResponse>(this as GroupListResponse, _$identity);

  /// Serializes this GroupListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupListResponse&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'GroupListResponse(groups: $groups)';
}


}

/// @nodoc
abstract mixin class $GroupListResponseCopyWith<$Res>  {
  factory $GroupListResponseCopyWith(GroupListResponse value, $Res Function(GroupListResponse) _then) = _$GroupListResponseCopyWithImpl;
@useResult
$Res call({
 List<GroupResponse> groups
});




}
/// @nodoc
class _$GroupListResponseCopyWithImpl<$Res>
    implements $GroupListResponseCopyWith<$Res> {
  _$GroupListResponseCopyWithImpl(this._self, this._then);

  final GroupListResponse _self;
  final $Res Function(GroupListResponse) _then;

/// Create a copy of GroupListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,}) {
  return _then(_self.copyWith(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<GroupResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupListResponse].
extension GroupListResponsePatterns on GroupListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupListResponse value)  $default,){
final _that = this;
switch (_that) {
case _GroupListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GroupListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GroupResponse> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupListResponse() when $default != null:
return $default(_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GroupResponse> groups)  $default,) {final _that = this;
switch (_that) {
case _GroupListResponse():
return $default(_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GroupResponse> groups)?  $default,) {final _that = this;
switch (_that) {
case _GroupListResponse() when $default != null:
return $default(_that.groups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupListResponse implements GroupListResponse {
  const _GroupListResponse({required final  List<GroupResponse> groups}): _groups = groups;
  factory _GroupListResponse.fromJson(Map<String, dynamic> json) => _$GroupListResponseFromJson(json);

 final  List<GroupResponse> _groups;
@override List<GroupResponse> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}


/// Create a copy of GroupListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupListResponseCopyWith<_GroupListResponse> get copyWith => __$GroupListResponseCopyWithImpl<_GroupListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupListResponse&&const DeepCollectionEquality().equals(other._groups, _groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups));

@override
String toString() {
  return 'GroupListResponse(groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$GroupListResponseCopyWith<$Res> implements $GroupListResponseCopyWith<$Res> {
  factory _$GroupListResponseCopyWith(_GroupListResponse value, $Res Function(_GroupListResponse) _then) = __$GroupListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<GroupResponse> groups
});




}
/// @nodoc
class __$GroupListResponseCopyWithImpl<$Res>
    implements _$GroupListResponseCopyWith<$Res> {
  __$GroupListResponseCopyWithImpl(this._self, this._then);

  final _GroupListResponse _self;
  final $Res Function(_GroupListResponse) _then;

/// Create a copy of GroupListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,}) {
  return _then(_GroupListResponse(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<GroupResponse>,
  ));
}


}


/// @nodoc
mixin _$GroupResponse {

 int get groupId; String get name; String get ownerNickname; int get memberCount;// 모임 대표 썸네일(진행 사이클 스타터 샷). 아직 없으면 null.
 String? get thumbnailUrl;// 진행 중인 사이클이 없으면 null.
 CurrentCycleResponse? get currentCycle; DateTime get createdAt;
/// Create a copy of GroupResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupResponseCopyWith<GroupResponse> get copyWith => _$GroupResponseCopyWithImpl<GroupResponse>(this as GroupResponse, _$identity);

  /// Serializes this GroupResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.ownerNickname, ownerNickname) || other.ownerNickname == ownerNickname)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,name,ownerNickname,memberCount,thumbnailUrl,currentCycle,createdAt);

@override
String toString() {
  return 'GroupResponse(groupId: $groupId, name: $name, ownerNickname: $ownerNickname, memberCount: $memberCount, thumbnailUrl: $thumbnailUrl, currentCycle: $currentCycle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $GroupResponseCopyWith<$Res>  {
  factory $GroupResponseCopyWith(GroupResponse value, $Res Function(GroupResponse) _then) = _$GroupResponseCopyWithImpl;
@useResult
$Res call({
 int groupId, String name, String ownerNickname, int memberCount, String? thumbnailUrl, CurrentCycleResponse? currentCycle, DateTime createdAt
});


$CurrentCycleResponseCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class _$GroupResponseCopyWithImpl<$Res>
    implements $GroupResponseCopyWith<$Res> {
  _$GroupResponseCopyWithImpl(this._self, this._then);

  final GroupResponse _self;
  final $Res Function(GroupResponse) _then;

/// Create a copy of GroupResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? name = null,Object? ownerNickname = null,Object? memberCount = null,Object? thumbnailUrl = freezed,Object? currentCycle = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ownerNickname: null == ownerNickname ? _self.ownerNickname : ownerNickname // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as CurrentCycleResponse?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of GroupResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentCycleResponseCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $CurrentCycleResponseCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}


/// Adds pattern-matching-related methods to [GroupResponse].
extension GroupResponsePatterns on GroupResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupResponse value)  $default,){
final _that = this;
switch (_that) {
case _GroupResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GroupResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int groupId,  String name,  String ownerNickname,  int memberCount,  String? thumbnailUrl,  CurrentCycleResponse? currentCycle,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupResponse() when $default != null:
return $default(_that.groupId,_that.name,_that.ownerNickname,_that.memberCount,_that.thumbnailUrl,_that.currentCycle,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int groupId,  String name,  String ownerNickname,  int memberCount,  String? thumbnailUrl,  CurrentCycleResponse? currentCycle,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _GroupResponse():
return $default(_that.groupId,_that.name,_that.ownerNickname,_that.memberCount,_that.thumbnailUrl,_that.currentCycle,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int groupId,  String name,  String ownerNickname,  int memberCount,  String? thumbnailUrl,  CurrentCycleResponse? currentCycle,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _GroupResponse() when $default != null:
return $default(_that.groupId,_that.name,_that.ownerNickname,_that.memberCount,_that.thumbnailUrl,_that.currentCycle,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupResponse implements GroupResponse {
  const _GroupResponse({required this.groupId, required this.name, required this.ownerNickname, required this.memberCount, required this.thumbnailUrl, required this.currentCycle, required this.createdAt});
  factory _GroupResponse.fromJson(Map<String, dynamic> json) => _$GroupResponseFromJson(json);

@override final  int groupId;
@override final  String name;
@override final  String ownerNickname;
@override final  int memberCount;
// 모임 대표 썸네일(진행 사이클 스타터 샷). 아직 없으면 null.
@override final  String? thumbnailUrl;
// 진행 중인 사이클이 없으면 null.
@override final  CurrentCycleResponse? currentCycle;
@override final  DateTime createdAt;

/// Create a copy of GroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupResponseCopyWith<_GroupResponse> get copyWith => __$GroupResponseCopyWithImpl<_GroupResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.ownerNickname, ownerNickname) || other.ownerNickname == ownerNickname)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,name,ownerNickname,memberCount,thumbnailUrl,currentCycle,createdAt);

@override
String toString() {
  return 'GroupResponse(groupId: $groupId, name: $name, ownerNickname: $ownerNickname, memberCount: $memberCount, thumbnailUrl: $thumbnailUrl, currentCycle: $currentCycle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$GroupResponseCopyWith<$Res> implements $GroupResponseCopyWith<$Res> {
  factory _$GroupResponseCopyWith(_GroupResponse value, $Res Function(_GroupResponse) _then) = __$GroupResponseCopyWithImpl;
@override @useResult
$Res call({
 int groupId, String name, String ownerNickname, int memberCount, String? thumbnailUrl, CurrentCycleResponse? currentCycle, DateTime createdAt
});


@override $CurrentCycleResponseCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class __$GroupResponseCopyWithImpl<$Res>
    implements _$GroupResponseCopyWith<$Res> {
  __$GroupResponseCopyWithImpl(this._self, this._then);

  final _GroupResponse _self;
  final $Res Function(_GroupResponse) _then;

/// Create a copy of GroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? name = null,Object? ownerNickname = null,Object? memberCount = null,Object? thumbnailUrl = freezed,Object? currentCycle = freezed,Object? createdAt = null,}) {
  return _then(_GroupResponse(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ownerNickname: null == ownerNickname ? _self.ownerNickname : ownerNickname // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as CurrentCycleResponse?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of GroupResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentCycleResponseCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $CurrentCycleResponseCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}


/// @nodoc
mixin _$CurrentCycleResponse {

 int get cycleId; String get topic; DateTime get deadlineAt;
/// Create a copy of CurrentCycleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentCycleResponseCopyWith<CurrentCycleResponse> get copyWith => _$CurrentCycleResponseCopyWithImpl<CurrentCycleResponse>(this as CurrentCycleResponse, _$identity);

  /// Serializes this CurrentCycleResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentCycleResponse&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,topic,deadlineAt);

@override
String toString() {
  return 'CurrentCycleResponse(cycleId: $cycleId, topic: $topic, deadlineAt: $deadlineAt)';
}


}

/// @nodoc
abstract mixin class $CurrentCycleResponseCopyWith<$Res>  {
  factory $CurrentCycleResponseCopyWith(CurrentCycleResponse value, $Res Function(CurrentCycleResponse) _then) = _$CurrentCycleResponseCopyWithImpl;
@useResult
$Res call({
 int cycleId, String topic, DateTime deadlineAt
});




}
/// @nodoc
class _$CurrentCycleResponseCopyWithImpl<$Res>
    implements $CurrentCycleResponseCopyWith<$Res> {
  _$CurrentCycleResponseCopyWithImpl(this._self, this._then);

  final CurrentCycleResponse _self;
  final $Res Function(CurrentCycleResponse) _then;

/// Create a copy of CurrentCycleResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cycleId = null,Object? topic = null,Object? deadlineAt = null,}) {
  return _then(_self.copyWith(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: null == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentCycleResponse].
extension CurrentCycleResponsePatterns on CurrentCycleResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentCycleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentCycleResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentCycleResponse value)  $default,){
final _that = this;
switch (_that) {
case _CurrentCycleResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentCycleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentCycleResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int cycleId,  String topic,  DateTime deadlineAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentCycleResponse() when $default != null:
return $default(_that.cycleId,_that.topic,_that.deadlineAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int cycleId,  String topic,  DateTime deadlineAt)  $default,) {final _that = this;
switch (_that) {
case _CurrentCycleResponse():
return $default(_that.cycleId,_that.topic,_that.deadlineAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int cycleId,  String topic,  DateTime deadlineAt)?  $default,) {final _that = this;
switch (_that) {
case _CurrentCycleResponse() when $default != null:
return $default(_that.cycleId,_that.topic,_that.deadlineAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentCycleResponse implements CurrentCycleResponse {
  const _CurrentCycleResponse({required this.cycleId, required this.topic, required this.deadlineAt});
  factory _CurrentCycleResponse.fromJson(Map<String, dynamic> json) => _$CurrentCycleResponseFromJson(json);

@override final  int cycleId;
@override final  String topic;
@override final  DateTime deadlineAt;

/// Create a copy of CurrentCycleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentCycleResponseCopyWith<_CurrentCycleResponse> get copyWith => __$CurrentCycleResponseCopyWithImpl<_CurrentCycleResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentCycleResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentCycleResponse&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,topic,deadlineAt);

@override
String toString() {
  return 'CurrentCycleResponse(cycleId: $cycleId, topic: $topic, deadlineAt: $deadlineAt)';
}


}

/// @nodoc
abstract mixin class _$CurrentCycleResponseCopyWith<$Res> implements $CurrentCycleResponseCopyWith<$Res> {
  factory _$CurrentCycleResponseCopyWith(_CurrentCycleResponse value, $Res Function(_CurrentCycleResponse) _then) = __$CurrentCycleResponseCopyWithImpl;
@override @useResult
$Res call({
 int cycleId, String topic, DateTime deadlineAt
});




}
/// @nodoc
class __$CurrentCycleResponseCopyWithImpl<$Res>
    implements _$CurrentCycleResponseCopyWith<$Res> {
  __$CurrentCycleResponseCopyWithImpl(this._self, this._then);

  final _CurrentCycleResponse _self;
  final $Res Function(_CurrentCycleResponse) _then;

/// Create a copy of CurrentCycleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,Object? topic = null,Object? deadlineAt = null,}) {
  return _then(_CurrentCycleResponse(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: null == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
