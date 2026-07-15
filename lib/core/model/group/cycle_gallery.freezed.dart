// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cycle_gallery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CycleGallery {

 int get groupId; String get groupName; CycleGalleryCycle get cycle;// 현재 사용자의 업로드 여부.
 bool get viewerUploaded; List<CycleGalleryMember> get members;
/// Create a copy of CycleGallery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CycleGalleryCopyWith<CycleGallery> get copyWith => _$CycleGalleryCopyWithImpl<CycleGallery>(this as CycleGallery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CycleGallery&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.cycle, cycle) || other.cycle == cycle)&&(identical(other.viewerUploaded, viewerUploaded) || other.viewerUploaded == viewerUploaded)&&const DeepCollectionEquality().equals(other.members, members));
}


@override
int get hashCode => Object.hash(runtimeType,groupId,groupName,cycle,viewerUploaded,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'CycleGallery(groupId: $groupId, groupName: $groupName, cycle: $cycle, viewerUploaded: $viewerUploaded, members: $members)';
}


}

/// @nodoc
abstract mixin class $CycleGalleryCopyWith<$Res>  {
  factory $CycleGalleryCopyWith(CycleGallery value, $Res Function(CycleGallery) _then) = _$CycleGalleryCopyWithImpl;
@useResult
$Res call({
 int groupId, String groupName, CycleGalleryCycle cycle, bool viewerUploaded, List<CycleGalleryMember> members
});


$CycleGalleryCycleCopyWith<$Res> get cycle;

}
/// @nodoc
class _$CycleGalleryCopyWithImpl<$Res>
    implements $CycleGalleryCopyWith<$Res> {
  _$CycleGalleryCopyWithImpl(this._self, this._then);

  final CycleGallery _self;
  final $Res Function(CycleGallery) _then;

/// Create a copy of CycleGallery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? groupName = null,Object? cycle = null,Object? viewerUploaded = null,Object? members = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,cycle: null == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as CycleGalleryCycle,viewerUploaded: null == viewerUploaded ? _self.viewerUploaded : viewerUploaded // ignore: cast_nullable_to_non_nullable
as bool,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<CycleGalleryMember>,
  ));
}
/// Create a copy of CycleGallery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CycleGalleryCycleCopyWith<$Res> get cycle {
  
  return $CycleGalleryCycleCopyWith<$Res>(_self.cycle, (value) {
    return _then(_self.copyWith(cycle: value));
  });
}
}


/// Adds pattern-matching-related methods to [CycleGallery].
extension CycleGalleryPatterns on CycleGallery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CycleGallery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CycleGallery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CycleGallery value)  $default,){
final _that = this;
switch (_that) {
case _CycleGallery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CycleGallery value)?  $default,){
final _that = this;
switch (_that) {
case _CycleGallery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int groupId,  String groupName,  CycleGalleryCycle cycle,  bool viewerUploaded,  List<CycleGalleryMember> members)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CycleGallery() when $default != null:
return $default(_that.groupId,_that.groupName,_that.cycle,_that.viewerUploaded,_that.members);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int groupId,  String groupName,  CycleGalleryCycle cycle,  bool viewerUploaded,  List<CycleGalleryMember> members)  $default,) {final _that = this;
switch (_that) {
case _CycleGallery():
return $default(_that.groupId,_that.groupName,_that.cycle,_that.viewerUploaded,_that.members);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int groupId,  String groupName,  CycleGalleryCycle cycle,  bool viewerUploaded,  List<CycleGalleryMember> members)?  $default,) {final _that = this;
switch (_that) {
case _CycleGallery() when $default != null:
return $default(_that.groupId,_that.groupName,_that.cycle,_that.viewerUploaded,_that.members);case _:
  return null;

}
}

}

/// @nodoc


class _CycleGallery implements CycleGallery {
  const _CycleGallery({required this.groupId, required this.groupName, required this.cycle, required this.viewerUploaded, required final  List<CycleGalleryMember> members}): _members = members;
  

@override final  int groupId;
@override final  String groupName;
@override final  CycleGalleryCycle cycle;
// 현재 사용자의 업로드 여부.
@override final  bool viewerUploaded;
 final  List<CycleGalleryMember> _members;
@override List<CycleGalleryMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}


/// Create a copy of CycleGallery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleGalleryCopyWith<_CycleGallery> get copyWith => __$CycleGalleryCopyWithImpl<_CycleGallery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleGallery&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.cycle, cycle) || other.cycle == cycle)&&(identical(other.viewerUploaded, viewerUploaded) || other.viewerUploaded == viewerUploaded)&&const DeepCollectionEquality().equals(other._members, _members));
}


@override
int get hashCode => Object.hash(runtimeType,groupId,groupName,cycle,viewerUploaded,const DeepCollectionEquality().hash(_members));

@override
String toString() {
  return 'CycleGallery(groupId: $groupId, groupName: $groupName, cycle: $cycle, viewerUploaded: $viewerUploaded, members: $members)';
}


}

/// @nodoc
abstract mixin class _$CycleGalleryCopyWith<$Res> implements $CycleGalleryCopyWith<$Res> {
  factory _$CycleGalleryCopyWith(_CycleGallery value, $Res Function(_CycleGallery) _then) = __$CycleGalleryCopyWithImpl;
@override @useResult
$Res call({
 int groupId, String groupName, CycleGalleryCycle cycle, bool viewerUploaded, List<CycleGalleryMember> members
});


@override $CycleGalleryCycleCopyWith<$Res> get cycle;

}
/// @nodoc
class __$CycleGalleryCopyWithImpl<$Res>
    implements _$CycleGalleryCopyWith<$Res> {
  __$CycleGalleryCopyWithImpl(this._self, this._then);

  final _CycleGallery _self;
  final $Res Function(_CycleGallery) _then;

/// Create a copy of CycleGallery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? groupName = null,Object? cycle = null,Object? viewerUploaded = null,Object? members = null,}) {
  return _then(_CycleGallery(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,cycle: null == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as CycleGalleryCycle,viewerUploaded: null == viewerUploaded ? _self.viewerUploaded : viewerUploaded // ignore: cast_nullable_to_non_nullable
as bool,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<CycleGalleryMember>,
  ));
}

/// Create a copy of CycleGallery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CycleGalleryCycleCopyWith<$Res> get cycle {
  
  return $CycleGalleryCycleCopyWith<$Res>(_self.cycle, (value) {
    return _then(_self.copyWith(cycle: value));
  });
}
}

/// @nodoc
mixin _$CycleGalleryCycle {

 int get cycleId; int get cycleNumber; String get topic; String get starterNickname;// 스타터가 올린 사진 URL. 없으면 null.
 String? get starterImageUrl; String get status; DateTime get deadlineAt;
/// Create a copy of CycleGalleryCycle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CycleGalleryCycleCopyWith<CycleGalleryCycle> get copyWith => _$CycleGalleryCycleCopyWithImpl<CycleGalleryCycle>(this as CycleGalleryCycle, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CycleGalleryCycle&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.cycleNumber, cycleNumber) || other.cycleNumber == cycleNumber)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.starterNickname, starterNickname) || other.starterNickname == starterNickname)&&(identical(other.starterImageUrl, starterImageUrl) || other.starterImageUrl == starterImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt));
}


@override
int get hashCode => Object.hash(runtimeType,cycleId,cycleNumber,topic,starterNickname,starterImageUrl,status,deadlineAt);

@override
String toString() {
  return 'CycleGalleryCycle(cycleId: $cycleId, cycleNumber: $cycleNumber, topic: $topic, starterNickname: $starterNickname, starterImageUrl: $starterImageUrl, status: $status, deadlineAt: $deadlineAt)';
}


}

/// @nodoc
abstract mixin class $CycleGalleryCycleCopyWith<$Res>  {
  factory $CycleGalleryCycleCopyWith(CycleGalleryCycle value, $Res Function(CycleGalleryCycle) _then) = _$CycleGalleryCycleCopyWithImpl;
@useResult
$Res call({
 int cycleId, int cycleNumber, String topic, String starterNickname, String? starterImageUrl, String status, DateTime deadlineAt
});




}
/// @nodoc
class _$CycleGalleryCycleCopyWithImpl<$Res>
    implements $CycleGalleryCycleCopyWith<$Res> {
  _$CycleGalleryCycleCopyWithImpl(this._self, this._then);

  final CycleGalleryCycle _self;
  final $Res Function(CycleGalleryCycle) _then;

/// Create a copy of CycleGalleryCycle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cycleId = null,Object? cycleNumber = null,Object? topic = null,Object? starterNickname = null,Object? starterImageUrl = freezed,Object? status = null,Object? deadlineAt = null,}) {
  return _then(_self.copyWith(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,cycleNumber: null == cycleNumber ? _self.cycleNumber : cycleNumber // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,starterNickname: null == starterNickname ? _self.starterNickname : starterNickname // ignore: cast_nullable_to_non_nullable
as String,starterImageUrl: freezed == starterImageUrl ? _self.starterImageUrl : starterImageUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: null == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CycleGalleryCycle].
extension CycleGalleryCyclePatterns on CycleGalleryCycle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CycleGalleryCycle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CycleGalleryCycle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CycleGalleryCycle value)  $default,){
final _that = this;
switch (_that) {
case _CycleGalleryCycle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CycleGalleryCycle value)?  $default,){
final _that = this;
switch (_that) {
case _CycleGalleryCycle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int cycleId,  int cycleNumber,  String topic,  String starterNickname,  String? starterImageUrl,  String status,  DateTime deadlineAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CycleGalleryCycle() when $default != null:
return $default(_that.cycleId,_that.cycleNumber,_that.topic,_that.starterNickname,_that.starterImageUrl,_that.status,_that.deadlineAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int cycleId,  int cycleNumber,  String topic,  String starterNickname,  String? starterImageUrl,  String status,  DateTime deadlineAt)  $default,) {final _that = this;
switch (_that) {
case _CycleGalleryCycle():
return $default(_that.cycleId,_that.cycleNumber,_that.topic,_that.starterNickname,_that.starterImageUrl,_that.status,_that.deadlineAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int cycleId,  int cycleNumber,  String topic,  String starterNickname,  String? starterImageUrl,  String status,  DateTime deadlineAt)?  $default,) {final _that = this;
switch (_that) {
case _CycleGalleryCycle() when $default != null:
return $default(_that.cycleId,_that.cycleNumber,_that.topic,_that.starterNickname,_that.starterImageUrl,_that.status,_that.deadlineAt);case _:
  return null;

}
}

}

/// @nodoc


class _CycleGalleryCycle implements CycleGalleryCycle {
  const _CycleGalleryCycle({required this.cycleId, required this.cycleNumber, required this.topic, required this.starterNickname, required this.starterImageUrl, required this.status, required this.deadlineAt});
  

@override final  int cycleId;
@override final  int cycleNumber;
@override final  String topic;
@override final  String starterNickname;
// 스타터가 올린 사진 URL. 없으면 null.
@override final  String? starterImageUrl;
@override final  String status;
@override final  DateTime deadlineAt;

/// Create a copy of CycleGalleryCycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleGalleryCycleCopyWith<_CycleGalleryCycle> get copyWith => __$CycleGalleryCycleCopyWithImpl<_CycleGalleryCycle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleGalleryCycle&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.cycleNumber, cycleNumber) || other.cycleNumber == cycleNumber)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.starterNickname, starterNickname) || other.starterNickname == starterNickname)&&(identical(other.starterImageUrl, starterImageUrl) || other.starterImageUrl == starterImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt));
}


@override
int get hashCode => Object.hash(runtimeType,cycleId,cycleNumber,topic,starterNickname,starterImageUrl,status,deadlineAt);

@override
String toString() {
  return 'CycleGalleryCycle(cycleId: $cycleId, cycleNumber: $cycleNumber, topic: $topic, starterNickname: $starterNickname, starterImageUrl: $starterImageUrl, status: $status, deadlineAt: $deadlineAt)';
}


}

/// @nodoc
abstract mixin class _$CycleGalleryCycleCopyWith<$Res> implements $CycleGalleryCycleCopyWith<$Res> {
  factory _$CycleGalleryCycleCopyWith(_CycleGalleryCycle value, $Res Function(_CycleGalleryCycle) _then) = __$CycleGalleryCycleCopyWithImpl;
@override @useResult
$Res call({
 int cycleId, int cycleNumber, String topic, String starterNickname, String? starterImageUrl, String status, DateTime deadlineAt
});




}
/// @nodoc
class __$CycleGalleryCycleCopyWithImpl<$Res>
    implements _$CycleGalleryCycleCopyWith<$Res> {
  __$CycleGalleryCycleCopyWithImpl(this._self, this._then);

  final _CycleGalleryCycle _self;
  final $Res Function(_CycleGalleryCycle) _then;

/// Create a copy of CycleGalleryCycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,Object? cycleNumber = null,Object? topic = null,Object? starterNickname = null,Object? starterImageUrl = freezed,Object? status = null,Object? deadlineAt = null,}) {
  return _then(_CycleGalleryCycle(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,cycleNumber: null == cycleNumber ? _self.cycleNumber : cycleNumber // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,starterNickname: null == starterNickname ? _self.starterNickname : starterNickname // ignore: cast_nullable_to_non_nullable
as String,starterImageUrl: freezed == starterImageUrl ? _self.starterImageUrl : starterImageUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: null == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$CycleGalleryMember {

 int get userId; String get nickname;// 프로필 이미지 URL. 없으면 null.
 String? get profileImageUrl; bool get isStarter;// 사진 카드 상태. (open: 공개 / empty: 미업로드 / locked: 잠금)
 String get status;// 멤버가 따라찍은 사진 URL. 없으면 null.
 String? get imageUrl;// 업로드 시각. 미업로드면 null.
 DateTime? get uploadedAt;
/// Create a copy of CycleGalleryMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CycleGalleryMemberCopyWith<CycleGalleryMember> get copyWith => _$CycleGalleryMemberCopyWithImpl<CycleGalleryMember>(this as CycleGalleryMember, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CycleGalleryMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.isStarter, isStarter) || other.isStarter == isStarter)&&(identical(other.status, status) || other.status == status)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt));
}


@override
int get hashCode => Object.hash(runtimeType,userId,nickname,profileImageUrl,isStarter,status,imageUrl,uploadedAt);

@override
String toString() {
  return 'CycleGalleryMember(userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, isStarter: $isStarter, status: $status, imageUrl: $imageUrl, uploadedAt: $uploadedAt)';
}


}

/// @nodoc
abstract mixin class $CycleGalleryMemberCopyWith<$Res>  {
  factory $CycleGalleryMemberCopyWith(CycleGalleryMember value, $Res Function(CycleGalleryMember) _then) = _$CycleGalleryMemberCopyWithImpl;
@useResult
$Res call({
 int userId, String nickname, String? profileImageUrl, bool isStarter, String status, String? imageUrl, DateTime? uploadedAt
});




}
/// @nodoc
class _$CycleGalleryMemberCopyWithImpl<$Res>
    implements $CycleGalleryMemberCopyWith<$Res> {
  _$CycleGalleryMemberCopyWithImpl(this._self, this._then);

  final CycleGalleryMember _self;
  final $Res Function(CycleGalleryMember) _then;

/// Create a copy of CycleGalleryMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? nickname = null,Object? profileImageUrl = freezed,Object? isStarter = null,Object? status = null,Object? imageUrl = freezed,Object? uploadedAt = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,isStarter: null == isStarter ? _self.isStarter : isStarter // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,uploadedAt: freezed == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CycleGalleryMember].
extension CycleGalleryMemberPatterns on CycleGalleryMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CycleGalleryMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CycleGalleryMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CycleGalleryMember value)  $default,){
final _that = this;
switch (_that) {
case _CycleGalleryMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CycleGalleryMember value)?  $default,){
final _that = this;
switch (_that) {
case _CycleGalleryMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  String nickname,  String? profileImageUrl,  bool isStarter,  String status,  String? imageUrl,  DateTime? uploadedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CycleGalleryMember() when $default != null:
return $default(_that.userId,_that.nickname,_that.profileImageUrl,_that.isStarter,_that.status,_that.imageUrl,_that.uploadedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  String nickname,  String? profileImageUrl,  bool isStarter,  String status,  String? imageUrl,  DateTime? uploadedAt)  $default,) {final _that = this;
switch (_that) {
case _CycleGalleryMember():
return $default(_that.userId,_that.nickname,_that.profileImageUrl,_that.isStarter,_that.status,_that.imageUrl,_that.uploadedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  String nickname,  String? profileImageUrl,  bool isStarter,  String status,  String? imageUrl,  DateTime? uploadedAt)?  $default,) {final _that = this;
switch (_that) {
case _CycleGalleryMember() when $default != null:
return $default(_that.userId,_that.nickname,_that.profileImageUrl,_that.isStarter,_that.status,_that.imageUrl,_that.uploadedAt);case _:
  return null;

}
}

}

/// @nodoc


class _CycleGalleryMember implements CycleGalleryMember {
  const _CycleGalleryMember({required this.userId, required this.nickname, required this.profileImageUrl, required this.isStarter, required this.status, required this.imageUrl, required this.uploadedAt});
  

@override final  int userId;
@override final  String nickname;
// 프로필 이미지 URL. 없으면 null.
@override final  String? profileImageUrl;
@override final  bool isStarter;
// 사진 카드 상태. (open: 공개 / empty: 미업로드 / locked: 잠금)
@override final  String status;
// 멤버가 따라찍은 사진 URL. 없으면 null.
@override final  String? imageUrl;
// 업로드 시각. 미업로드면 null.
@override final  DateTime? uploadedAt;

/// Create a copy of CycleGalleryMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleGalleryMemberCopyWith<_CycleGalleryMember> get copyWith => __$CycleGalleryMemberCopyWithImpl<_CycleGalleryMember>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleGalleryMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.isStarter, isStarter) || other.isStarter == isStarter)&&(identical(other.status, status) || other.status == status)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt));
}


@override
int get hashCode => Object.hash(runtimeType,userId,nickname,profileImageUrl,isStarter,status,imageUrl,uploadedAt);

@override
String toString() {
  return 'CycleGalleryMember(userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, isStarter: $isStarter, status: $status, imageUrl: $imageUrl, uploadedAt: $uploadedAt)';
}


}

/// @nodoc
abstract mixin class _$CycleGalleryMemberCopyWith<$Res> implements $CycleGalleryMemberCopyWith<$Res> {
  factory _$CycleGalleryMemberCopyWith(_CycleGalleryMember value, $Res Function(_CycleGalleryMember) _then) = __$CycleGalleryMemberCopyWithImpl;
@override @useResult
$Res call({
 int userId, String nickname, String? profileImageUrl, bool isStarter, String status, String? imageUrl, DateTime? uploadedAt
});




}
/// @nodoc
class __$CycleGalleryMemberCopyWithImpl<$Res>
    implements _$CycleGalleryMemberCopyWith<$Res> {
  __$CycleGalleryMemberCopyWithImpl(this._self, this._then);

  final _CycleGalleryMember _self;
  final $Res Function(_CycleGalleryMember) _then;

/// Create a copy of CycleGalleryMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? nickname = null,Object? profileImageUrl = freezed,Object? isStarter = null,Object? status = null,Object? imageUrl = freezed,Object? uploadedAt = freezed,}) {
  return _then(_CycleGalleryMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,isStarter: null == isStarter ? _self.isStarter : isStarter // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,uploadedAt: freezed == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
