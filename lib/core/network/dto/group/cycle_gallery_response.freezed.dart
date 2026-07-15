// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cycle_gallery_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CycleGalleryResponse {

 int get groupId; String get groupName; CycleGalleryCycleResponse get cycle;// 현재 사용자의 업로드 여부.
 bool get viewerUploaded; List<CycleGalleryMemberResponse> get members;
/// Create a copy of CycleGalleryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CycleGalleryResponseCopyWith<CycleGalleryResponse> get copyWith => _$CycleGalleryResponseCopyWithImpl<CycleGalleryResponse>(this as CycleGalleryResponse, _$identity);

  /// Serializes this CycleGalleryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CycleGalleryResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.cycle, cycle) || other.cycle == cycle)&&(identical(other.viewerUploaded, viewerUploaded) || other.viewerUploaded == viewerUploaded)&&const DeepCollectionEquality().equals(other.members, members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,groupName,cycle,viewerUploaded,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'CycleGalleryResponse(groupId: $groupId, groupName: $groupName, cycle: $cycle, viewerUploaded: $viewerUploaded, members: $members)';
}


}

/// @nodoc
abstract mixin class $CycleGalleryResponseCopyWith<$Res>  {
  factory $CycleGalleryResponseCopyWith(CycleGalleryResponse value, $Res Function(CycleGalleryResponse) _then) = _$CycleGalleryResponseCopyWithImpl;
@useResult
$Res call({
 int groupId, String groupName, CycleGalleryCycleResponse cycle, bool viewerUploaded, List<CycleGalleryMemberResponse> members
});


$CycleGalleryCycleResponseCopyWith<$Res> get cycle;

}
/// @nodoc
class _$CycleGalleryResponseCopyWithImpl<$Res>
    implements $CycleGalleryResponseCopyWith<$Res> {
  _$CycleGalleryResponseCopyWithImpl(this._self, this._then);

  final CycleGalleryResponse _self;
  final $Res Function(CycleGalleryResponse) _then;

/// Create a copy of CycleGalleryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? groupName = null,Object? cycle = null,Object? viewerUploaded = null,Object? members = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,cycle: null == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as CycleGalleryCycleResponse,viewerUploaded: null == viewerUploaded ? _self.viewerUploaded : viewerUploaded // ignore: cast_nullable_to_non_nullable
as bool,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<CycleGalleryMemberResponse>,
  ));
}
/// Create a copy of CycleGalleryResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CycleGalleryCycleResponseCopyWith<$Res> get cycle {
  
  return $CycleGalleryCycleResponseCopyWith<$Res>(_self.cycle, (value) {
    return _then(_self.copyWith(cycle: value));
  });
}
}


/// Adds pattern-matching-related methods to [CycleGalleryResponse].
extension CycleGalleryResponsePatterns on CycleGalleryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CycleGalleryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CycleGalleryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CycleGalleryResponse value)  $default,){
final _that = this;
switch (_that) {
case _CycleGalleryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CycleGalleryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CycleGalleryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int groupId,  String groupName,  CycleGalleryCycleResponse cycle,  bool viewerUploaded,  List<CycleGalleryMemberResponse> members)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CycleGalleryResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int groupId,  String groupName,  CycleGalleryCycleResponse cycle,  bool viewerUploaded,  List<CycleGalleryMemberResponse> members)  $default,) {final _that = this;
switch (_that) {
case _CycleGalleryResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int groupId,  String groupName,  CycleGalleryCycleResponse cycle,  bool viewerUploaded,  List<CycleGalleryMemberResponse> members)?  $default,) {final _that = this;
switch (_that) {
case _CycleGalleryResponse() when $default != null:
return $default(_that.groupId,_that.groupName,_that.cycle,_that.viewerUploaded,_that.members);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CycleGalleryResponse implements CycleGalleryResponse {
  const _CycleGalleryResponse({required this.groupId, required this.groupName, required this.cycle, required this.viewerUploaded, required final  List<CycleGalleryMemberResponse> members}): _members = members;
  factory _CycleGalleryResponse.fromJson(Map<String, dynamic> json) => _$CycleGalleryResponseFromJson(json);

@override final  int groupId;
@override final  String groupName;
@override final  CycleGalleryCycleResponse cycle;
// 현재 사용자의 업로드 여부.
@override final  bool viewerUploaded;
 final  List<CycleGalleryMemberResponse> _members;
@override List<CycleGalleryMemberResponse> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}


/// Create a copy of CycleGalleryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleGalleryResponseCopyWith<_CycleGalleryResponse> get copyWith => __$CycleGalleryResponseCopyWithImpl<_CycleGalleryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CycleGalleryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleGalleryResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.cycle, cycle) || other.cycle == cycle)&&(identical(other.viewerUploaded, viewerUploaded) || other.viewerUploaded == viewerUploaded)&&const DeepCollectionEquality().equals(other._members, _members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,groupName,cycle,viewerUploaded,const DeepCollectionEquality().hash(_members));

@override
String toString() {
  return 'CycleGalleryResponse(groupId: $groupId, groupName: $groupName, cycle: $cycle, viewerUploaded: $viewerUploaded, members: $members)';
}


}

/// @nodoc
abstract mixin class _$CycleGalleryResponseCopyWith<$Res> implements $CycleGalleryResponseCopyWith<$Res> {
  factory _$CycleGalleryResponseCopyWith(_CycleGalleryResponse value, $Res Function(_CycleGalleryResponse) _then) = __$CycleGalleryResponseCopyWithImpl;
@override @useResult
$Res call({
 int groupId, String groupName, CycleGalleryCycleResponse cycle, bool viewerUploaded, List<CycleGalleryMemberResponse> members
});


@override $CycleGalleryCycleResponseCopyWith<$Res> get cycle;

}
/// @nodoc
class __$CycleGalleryResponseCopyWithImpl<$Res>
    implements _$CycleGalleryResponseCopyWith<$Res> {
  __$CycleGalleryResponseCopyWithImpl(this._self, this._then);

  final _CycleGalleryResponse _self;
  final $Res Function(_CycleGalleryResponse) _then;

/// Create a copy of CycleGalleryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? groupName = null,Object? cycle = null,Object? viewerUploaded = null,Object? members = null,}) {
  return _then(_CycleGalleryResponse(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,cycle: null == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as CycleGalleryCycleResponse,viewerUploaded: null == viewerUploaded ? _self.viewerUploaded : viewerUploaded // ignore: cast_nullable_to_non_nullable
as bool,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<CycleGalleryMemberResponse>,
  ));
}

/// Create a copy of CycleGalleryResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CycleGalleryCycleResponseCopyWith<$Res> get cycle {
  
  return $CycleGalleryCycleResponseCopyWith<$Res>(_self.cycle, (value) {
    return _then(_self.copyWith(cycle: value));
  });
}
}


/// @nodoc
mixin _$CycleGalleryCycleResponse {

 int get cycleId; int get cycleNumber; String get topic; String get starterNickname;// 스타터가 올린 사진 URL. 없으면 null.
 String? get starterImageUrl; String get status; DateTime get deadlineAt;
/// Create a copy of CycleGalleryCycleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CycleGalleryCycleResponseCopyWith<CycleGalleryCycleResponse> get copyWith => _$CycleGalleryCycleResponseCopyWithImpl<CycleGalleryCycleResponse>(this as CycleGalleryCycleResponse, _$identity);

  /// Serializes this CycleGalleryCycleResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CycleGalleryCycleResponse&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.cycleNumber, cycleNumber) || other.cycleNumber == cycleNumber)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.starterNickname, starterNickname) || other.starterNickname == starterNickname)&&(identical(other.starterImageUrl, starterImageUrl) || other.starterImageUrl == starterImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,cycleNumber,topic,starterNickname,starterImageUrl,status,deadlineAt);

@override
String toString() {
  return 'CycleGalleryCycleResponse(cycleId: $cycleId, cycleNumber: $cycleNumber, topic: $topic, starterNickname: $starterNickname, starterImageUrl: $starterImageUrl, status: $status, deadlineAt: $deadlineAt)';
}


}

/// @nodoc
abstract mixin class $CycleGalleryCycleResponseCopyWith<$Res>  {
  factory $CycleGalleryCycleResponseCopyWith(CycleGalleryCycleResponse value, $Res Function(CycleGalleryCycleResponse) _then) = _$CycleGalleryCycleResponseCopyWithImpl;
@useResult
$Res call({
 int cycleId, int cycleNumber, String topic, String starterNickname, String? starterImageUrl, String status, DateTime deadlineAt
});




}
/// @nodoc
class _$CycleGalleryCycleResponseCopyWithImpl<$Res>
    implements $CycleGalleryCycleResponseCopyWith<$Res> {
  _$CycleGalleryCycleResponseCopyWithImpl(this._self, this._then);

  final CycleGalleryCycleResponse _self;
  final $Res Function(CycleGalleryCycleResponse) _then;

/// Create a copy of CycleGalleryCycleResponse
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


/// Adds pattern-matching-related methods to [CycleGalleryCycleResponse].
extension CycleGalleryCycleResponsePatterns on CycleGalleryCycleResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CycleGalleryCycleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CycleGalleryCycleResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CycleGalleryCycleResponse value)  $default,){
final _that = this;
switch (_that) {
case _CycleGalleryCycleResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CycleGalleryCycleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CycleGalleryCycleResponse() when $default != null:
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
case _CycleGalleryCycleResponse() when $default != null:
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
case _CycleGalleryCycleResponse():
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
case _CycleGalleryCycleResponse() when $default != null:
return $default(_that.cycleId,_that.cycleNumber,_that.topic,_that.starterNickname,_that.starterImageUrl,_that.status,_that.deadlineAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CycleGalleryCycleResponse implements CycleGalleryCycleResponse {
  const _CycleGalleryCycleResponse({required this.cycleId, required this.cycleNumber, required this.topic, required this.starterNickname, required this.starterImageUrl, required this.status, required this.deadlineAt});
  factory _CycleGalleryCycleResponse.fromJson(Map<String, dynamic> json) => _$CycleGalleryCycleResponseFromJson(json);

@override final  int cycleId;
@override final  int cycleNumber;
@override final  String topic;
@override final  String starterNickname;
// 스타터가 올린 사진 URL. 없으면 null.
@override final  String? starterImageUrl;
@override final  String status;
@override final  DateTime deadlineAt;

/// Create a copy of CycleGalleryCycleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleGalleryCycleResponseCopyWith<_CycleGalleryCycleResponse> get copyWith => __$CycleGalleryCycleResponseCopyWithImpl<_CycleGalleryCycleResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CycleGalleryCycleResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleGalleryCycleResponse&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.cycleNumber, cycleNumber) || other.cycleNumber == cycleNumber)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.starterNickname, starterNickname) || other.starterNickname == starterNickname)&&(identical(other.starterImageUrl, starterImageUrl) || other.starterImageUrl == starterImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,cycleNumber,topic,starterNickname,starterImageUrl,status,deadlineAt);

@override
String toString() {
  return 'CycleGalleryCycleResponse(cycleId: $cycleId, cycleNumber: $cycleNumber, topic: $topic, starterNickname: $starterNickname, starterImageUrl: $starterImageUrl, status: $status, deadlineAt: $deadlineAt)';
}


}

/// @nodoc
abstract mixin class _$CycleGalleryCycleResponseCopyWith<$Res> implements $CycleGalleryCycleResponseCopyWith<$Res> {
  factory _$CycleGalleryCycleResponseCopyWith(_CycleGalleryCycleResponse value, $Res Function(_CycleGalleryCycleResponse) _then) = __$CycleGalleryCycleResponseCopyWithImpl;
@override @useResult
$Res call({
 int cycleId, int cycleNumber, String topic, String starterNickname, String? starterImageUrl, String status, DateTime deadlineAt
});




}
/// @nodoc
class __$CycleGalleryCycleResponseCopyWithImpl<$Res>
    implements _$CycleGalleryCycleResponseCopyWith<$Res> {
  __$CycleGalleryCycleResponseCopyWithImpl(this._self, this._then);

  final _CycleGalleryCycleResponse _self;
  final $Res Function(_CycleGalleryCycleResponse) _then;

/// Create a copy of CycleGalleryCycleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,Object? cycleNumber = null,Object? topic = null,Object? starterNickname = null,Object? starterImageUrl = freezed,Object? status = null,Object? deadlineAt = null,}) {
  return _then(_CycleGalleryCycleResponse(
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
mixin _$CycleGalleryMemberResponse {

 int get userId; String get nickname;// 프로필 이미지 URL. 없으면 null.
 String? get profileImageUrl; bool get isStarter;// 사진 카드 상태. (open: 공개 / empty: 미업로드 / locked: 잠금)
 String get status;// 멤버가 따라찍은 사진 URL. 없으면 null.
 String? get imageUrl;// 업로드 시각. 미업로드면 null.
 DateTime? get uploadedAt;
/// Create a copy of CycleGalleryMemberResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CycleGalleryMemberResponseCopyWith<CycleGalleryMemberResponse> get copyWith => _$CycleGalleryMemberResponseCopyWithImpl<CycleGalleryMemberResponse>(this as CycleGalleryMemberResponse, _$identity);

  /// Serializes this CycleGalleryMemberResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CycleGalleryMemberResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.isStarter, isStarter) || other.isStarter == isStarter)&&(identical(other.status, status) || other.status == status)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,nickname,profileImageUrl,isStarter,status,imageUrl,uploadedAt);

@override
String toString() {
  return 'CycleGalleryMemberResponse(userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, isStarter: $isStarter, status: $status, imageUrl: $imageUrl, uploadedAt: $uploadedAt)';
}


}

/// @nodoc
abstract mixin class $CycleGalleryMemberResponseCopyWith<$Res>  {
  factory $CycleGalleryMemberResponseCopyWith(CycleGalleryMemberResponse value, $Res Function(CycleGalleryMemberResponse) _then) = _$CycleGalleryMemberResponseCopyWithImpl;
@useResult
$Res call({
 int userId, String nickname, String? profileImageUrl, bool isStarter, String status, String? imageUrl, DateTime? uploadedAt
});




}
/// @nodoc
class _$CycleGalleryMemberResponseCopyWithImpl<$Res>
    implements $CycleGalleryMemberResponseCopyWith<$Res> {
  _$CycleGalleryMemberResponseCopyWithImpl(this._self, this._then);

  final CycleGalleryMemberResponse _self;
  final $Res Function(CycleGalleryMemberResponse) _then;

/// Create a copy of CycleGalleryMemberResponse
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


/// Adds pattern-matching-related methods to [CycleGalleryMemberResponse].
extension CycleGalleryMemberResponsePatterns on CycleGalleryMemberResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CycleGalleryMemberResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CycleGalleryMemberResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CycleGalleryMemberResponse value)  $default,){
final _that = this;
switch (_that) {
case _CycleGalleryMemberResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CycleGalleryMemberResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CycleGalleryMemberResponse() when $default != null:
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
case _CycleGalleryMemberResponse() when $default != null:
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
case _CycleGalleryMemberResponse():
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
case _CycleGalleryMemberResponse() when $default != null:
return $default(_that.userId,_that.nickname,_that.profileImageUrl,_that.isStarter,_that.status,_that.imageUrl,_that.uploadedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CycleGalleryMemberResponse implements CycleGalleryMemberResponse {
  const _CycleGalleryMemberResponse({required this.userId, required this.nickname, required this.profileImageUrl, required this.isStarter, required this.status, required this.imageUrl, required this.uploadedAt});
  factory _CycleGalleryMemberResponse.fromJson(Map<String, dynamic> json) => _$CycleGalleryMemberResponseFromJson(json);

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

/// Create a copy of CycleGalleryMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleGalleryMemberResponseCopyWith<_CycleGalleryMemberResponse> get copyWith => __$CycleGalleryMemberResponseCopyWithImpl<_CycleGalleryMemberResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CycleGalleryMemberResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleGalleryMemberResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.isStarter, isStarter) || other.isStarter == isStarter)&&(identical(other.status, status) || other.status == status)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,nickname,profileImageUrl,isStarter,status,imageUrl,uploadedAt);

@override
String toString() {
  return 'CycleGalleryMemberResponse(userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, isStarter: $isStarter, status: $status, imageUrl: $imageUrl, uploadedAt: $uploadedAt)';
}


}

/// @nodoc
abstract mixin class _$CycleGalleryMemberResponseCopyWith<$Res> implements $CycleGalleryMemberResponseCopyWith<$Res> {
  factory _$CycleGalleryMemberResponseCopyWith(_CycleGalleryMemberResponse value, $Res Function(_CycleGalleryMemberResponse) _then) = __$CycleGalleryMemberResponseCopyWithImpl;
@override @useResult
$Res call({
 int userId, String nickname, String? profileImageUrl, bool isStarter, String status, String? imageUrl, DateTime? uploadedAt
});




}
/// @nodoc
class __$CycleGalleryMemberResponseCopyWithImpl<$Res>
    implements _$CycleGalleryMemberResponseCopyWith<$Res> {
  __$CycleGalleryMemberResponseCopyWithImpl(this._self, this._then);

  final _CycleGalleryMemberResponse _self;
  final $Res Function(_CycleGalleryMemberResponse) _then;

/// Create a copy of CycleGalleryMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? nickname = null,Object? profileImageUrl = freezed,Object? isStarter = null,Object? status = null,Object? imageUrl = freezed,Object? uploadedAt = freezed,}) {
  return _then(_CycleGalleryMemberResponse(
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
