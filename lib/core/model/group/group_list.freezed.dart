// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroupList {

 List<Group> get groups;
/// Create a copy of GroupList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupListCopyWith<GroupList> get copyWith => _$GroupListCopyWithImpl<GroupList>(this as GroupList, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupList&&const DeepCollectionEquality().equals(other.groups, groups));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'GroupList(groups: $groups)';
}


}

/// @nodoc
abstract mixin class $GroupListCopyWith<$Res>  {
  factory $GroupListCopyWith(GroupList value, $Res Function(GroupList) _then) = _$GroupListCopyWithImpl;
@useResult
$Res call({
 List<Group> groups
});




}
/// @nodoc
class _$GroupListCopyWithImpl<$Res>
    implements $GroupListCopyWith<$Res> {
  _$GroupListCopyWithImpl(this._self, this._then);

  final GroupList _self;
  final $Res Function(GroupList) _then;

/// Create a copy of GroupList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,}) {
  return _then(_self.copyWith(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupList].
extension GroupListPatterns on GroupList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupList value)  $default,){
final _that = this;
switch (_that) {
case _GroupList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupList value)?  $default,){
final _that = this;
switch (_that) {
case _GroupList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Group> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Group> groups)  $default,) {final _that = this;
switch (_that) {
case _GroupList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Group> groups)?  $default,) {final _that = this;
switch (_that) {
case _GroupList() when $default != null:
return $default(_that.groups);case _:
  return null;

}
}

}

/// @nodoc


class _GroupList implements GroupList {
  const _GroupList({required final  List<Group> groups}): _groups = groups;
  

 final  List<Group> _groups;
@override List<Group> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}


/// Create a copy of GroupList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupListCopyWith<_GroupList> get copyWith => __$GroupListCopyWithImpl<_GroupList>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupList&&const DeepCollectionEquality().equals(other._groups, _groups));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups));

@override
String toString() {
  return 'GroupList(groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$GroupListCopyWith<$Res> implements $GroupListCopyWith<$Res> {
  factory _$GroupListCopyWith(_GroupList value, $Res Function(_GroupList) _then) = __$GroupListCopyWithImpl;
@override @useResult
$Res call({
 List<Group> groups
});




}
/// @nodoc
class __$GroupListCopyWithImpl<$Res>
    implements _$GroupListCopyWith<$Res> {
  __$GroupListCopyWithImpl(this._self, this._then);

  final _GroupList _self;
  final $Res Function(_GroupList) _then;

/// Create a copy of GroupList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,}) {
  return _then(_GroupList(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,
  ));
}


}

/// @nodoc
mixin _$Group {

 int get groupId; String get name; String get ownerNickname; int get memberCount;// 모임 대표 썸네일(진행 사이클 스타터 샷). 아직 없으면 null.
 String? get thumbnailUrl;// 진행 중인 사이클이 없으면 null.
 CurrentCycle? get currentCycle;
/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupCopyWith<Group> get copyWith => _$GroupCopyWithImpl<Group>(this as Group, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Group&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.ownerNickname, ownerNickname) || other.ownerNickname == ownerNickname)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle));
}


@override
int get hashCode => Object.hash(runtimeType,groupId,name,ownerNickname,memberCount,thumbnailUrl,currentCycle);

@override
String toString() {
  return 'Group(groupId: $groupId, name: $name, ownerNickname: $ownerNickname, memberCount: $memberCount, thumbnailUrl: $thumbnailUrl, currentCycle: $currentCycle)';
}


}

/// @nodoc
abstract mixin class $GroupCopyWith<$Res>  {
  factory $GroupCopyWith(Group value, $Res Function(Group) _then) = _$GroupCopyWithImpl;
@useResult
$Res call({
 int groupId, String name, String ownerNickname, int memberCount, String? thumbnailUrl, CurrentCycle? currentCycle
});


$CurrentCycleCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class _$GroupCopyWithImpl<$Res>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._self, this._then);

  final Group _self;
  final $Res Function(Group) _then;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? name = null,Object? ownerNickname = null,Object? memberCount = null,Object? thumbnailUrl = freezed,Object? currentCycle = freezed,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ownerNickname: null == ownerNickname ? _self.ownerNickname : ownerNickname // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as CurrentCycle?,
  ));
}
/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentCycleCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $CurrentCycleCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}


/// Adds pattern-matching-related methods to [Group].
extension GroupPatterns on Group {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Group value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Group() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Group value)  $default,){
final _that = this;
switch (_that) {
case _Group():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Group value)?  $default,){
final _that = this;
switch (_that) {
case _Group() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int groupId,  String name,  String ownerNickname,  int memberCount,  String? thumbnailUrl,  CurrentCycle? currentCycle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Group() when $default != null:
return $default(_that.groupId,_that.name,_that.ownerNickname,_that.memberCount,_that.thumbnailUrl,_that.currentCycle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int groupId,  String name,  String ownerNickname,  int memberCount,  String? thumbnailUrl,  CurrentCycle? currentCycle)  $default,) {final _that = this;
switch (_that) {
case _Group():
return $default(_that.groupId,_that.name,_that.ownerNickname,_that.memberCount,_that.thumbnailUrl,_that.currentCycle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int groupId,  String name,  String ownerNickname,  int memberCount,  String? thumbnailUrl,  CurrentCycle? currentCycle)?  $default,) {final _that = this;
switch (_that) {
case _Group() when $default != null:
return $default(_that.groupId,_that.name,_that.ownerNickname,_that.memberCount,_that.thumbnailUrl,_that.currentCycle);case _:
  return null;

}
}

}

/// @nodoc


class _Group implements Group {
  const _Group({required this.groupId, required this.name, required this.ownerNickname, required this.memberCount, required this.thumbnailUrl, required this.currentCycle});
  

@override final  int groupId;
@override final  String name;
@override final  String ownerNickname;
@override final  int memberCount;
// 모임 대표 썸네일(진행 사이클 스타터 샷). 아직 없으면 null.
@override final  String? thumbnailUrl;
// 진행 중인 사이클이 없으면 null.
@override final  CurrentCycle? currentCycle;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupCopyWith<_Group> get copyWith => __$GroupCopyWithImpl<_Group>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Group&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.ownerNickname, ownerNickname) || other.ownerNickname == ownerNickname)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle));
}


@override
int get hashCode => Object.hash(runtimeType,groupId,name,ownerNickname,memberCount,thumbnailUrl,currentCycle);

@override
String toString() {
  return 'Group(groupId: $groupId, name: $name, ownerNickname: $ownerNickname, memberCount: $memberCount, thumbnailUrl: $thumbnailUrl, currentCycle: $currentCycle)';
}


}

/// @nodoc
abstract mixin class _$GroupCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$GroupCopyWith(_Group value, $Res Function(_Group) _then) = __$GroupCopyWithImpl;
@override @useResult
$Res call({
 int groupId, String name, String ownerNickname, int memberCount, String? thumbnailUrl, CurrentCycle? currentCycle
});


@override $CurrentCycleCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class __$GroupCopyWithImpl<$Res>
    implements _$GroupCopyWith<$Res> {
  __$GroupCopyWithImpl(this._self, this._then);

  final _Group _self;
  final $Res Function(_Group) _then;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? name = null,Object? ownerNickname = null,Object? memberCount = null,Object? thumbnailUrl = freezed,Object? currentCycle = freezed,}) {
  return _then(_Group(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ownerNickname: null == ownerNickname ? _self.ownerNickname : ownerNickname // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as CurrentCycle?,
  ));
}

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentCycleCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $CurrentCycleCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}

/// @nodoc
mixin _$CurrentCycle {

 int get cycleId; String get topic; DateTime get deadlineAt;
/// Create a copy of CurrentCycle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentCycleCopyWith<CurrentCycle> get copyWith => _$CurrentCycleCopyWithImpl<CurrentCycle>(this as CurrentCycle, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentCycle&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt));
}


@override
int get hashCode => Object.hash(runtimeType,cycleId,topic,deadlineAt);

@override
String toString() {
  return 'CurrentCycle(cycleId: $cycleId, topic: $topic, deadlineAt: $deadlineAt)';
}


}

/// @nodoc
abstract mixin class $CurrentCycleCopyWith<$Res>  {
  factory $CurrentCycleCopyWith(CurrentCycle value, $Res Function(CurrentCycle) _then) = _$CurrentCycleCopyWithImpl;
@useResult
$Res call({
 int cycleId, String topic, DateTime deadlineAt
});




}
/// @nodoc
class _$CurrentCycleCopyWithImpl<$Res>
    implements $CurrentCycleCopyWith<$Res> {
  _$CurrentCycleCopyWithImpl(this._self, this._then);

  final CurrentCycle _self;
  final $Res Function(CurrentCycle) _then;

/// Create a copy of CurrentCycle
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


/// Adds pattern-matching-related methods to [CurrentCycle].
extension CurrentCyclePatterns on CurrentCycle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentCycle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentCycle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentCycle value)  $default,){
final _that = this;
switch (_that) {
case _CurrentCycle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentCycle value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentCycle() when $default != null:
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
case _CurrentCycle() when $default != null:
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
case _CurrentCycle():
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
case _CurrentCycle() when $default != null:
return $default(_that.cycleId,_that.topic,_that.deadlineAt);case _:
  return null;

}
}

}

/// @nodoc


class _CurrentCycle implements CurrentCycle {
  const _CurrentCycle({required this.cycleId, required this.topic, required this.deadlineAt});
  

@override final  int cycleId;
@override final  String topic;
@override final  DateTime deadlineAt;

/// Create a copy of CurrentCycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentCycleCopyWith<_CurrentCycle> get copyWith => __$CurrentCycleCopyWithImpl<_CurrentCycle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentCycle&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt));
}


@override
int get hashCode => Object.hash(runtimeType,cycleId,topic,deadlineAt);

@override
String toString() {
  return 'CurrentCycle(cycleId: $cycleId, topic: $topic, deadlineAt: $deadlineAt)';
}


}

/// @nodoc
abstract mixin class _$CurrentCycleCopyWith<$Res> implements $CurrentCycleCopyWith<$Res> {
  factory _$CurrentCycleCopyWith(_CurrentCycle value, $Res Function(_CurrentCycle) _then) = __$CurrentCycleCopyWithImpl;
@override @useResult
$Res call({
 int cycleId, String topic, DateTime deadlineAt
});




}
/// @nodoc
class __$CurrentCycleCopyWithImpl<$Res>
    implements _$CurrentCycleCopyWith<$Res> {
  __$CurrentCycleCopyWithImpl(this._self, this._then);

  final _CurrentCycle _self;
  final $Res Function(_CurrentCycle) _then;

/// Create a copy of CurrentCycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,Object? topic = null,Object? deadlineAt = null,}) {
  return _then(_CurrentCycle(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: null == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
