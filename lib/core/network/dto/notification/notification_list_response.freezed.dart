// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationListResponse {

 List<NotificationItemResponse> get items;// 아직 읽지 않은 알림 개수. (배지 표시 등에 사용)
 int get unreadCount;
/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationListResponseCopyWith<NotificationListResponse> get copyWith => _$NotificationListResponseCopyWithImpl<NotificationListResponse>(this as NotificationListResponse, _$identity);

  /// Serializes this NotificationListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationListResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),unreadCount);

@override
String toString() {
  return 'NotificationListResponse(items: $items, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class $NotificationListResponseCopyWith<$Res>  {
  factory $NotificationListResponseCopyWith(NotificationListResponse value, $Res Function(NotificationListResponse) _then) = _$NotificationListResponseCopyWithImpl;
@useResult
$Res call({
 List<NotificationItemResponse> items, int unreadCount
});




}
/// @nodoc
class _$NotificationListResponseCopyWithImpl<$Res>
    implements $NotificationListResponseCopyWith<$Res> {
  _$NotificationListResponseCopyWithImpl(this._self, this._then);

  final NotificationListResponse _self;
  final $Res Function(NotificationListResponse) _then;

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? unreadCount = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationItemResponse>,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationListResponse].
extension NotificationListResponsePatterns on NotificationListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationListResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NotificationItemResponse> items,  int unreadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
return $default(_that.items,_that.unreadCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NotificationItemResponse> items,  int unreadCount)  $default,) {final _that = this;
switch (_that) {
case _NotificationListResponse():
return $default(_that.items,_that.unreadCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NotificationItemResponse> items,  int unreadCount)?  $default,) {final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
return $default(_that.items,_that.unreadCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationListResponse implements NotificationListResponse {
  const _NotificationListResponse({required final  List<NotificationItemResponse> items, this.unreadCount = 0}): _items = items;
  factory _NotificationListResponse.fromJson(Map<String, dynamic> json) => _$NotificationListResponseFromJson(json);

 final  List<NotificationItemResponse> _items;
@override List<NotificationItemResponse> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

// 아직 읽지 않은 알림 개수. (배지 표시 등에 사용)
@override@JsonKey() final  int unreadCount;

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationListResponseCopyWith<_NotificationListResponse> get copyWith => __$NotificationListResponseCopyWithImpl<_NotificationListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationListResponse&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),unreadCount);

@override
String toString() {
  return 'NotificationListResponse(items: $items, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class _$NotificationListResponseCopyWith<$Res> implements $NotificationListResponseCopyWith<$Res> {
  factory _$NotificationListResponseCopyWith(_NotificationListResponse value, $Res Function(_NotificationListResponse) _then) = __$NotificationListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<NotificationItemResponse> items, int unreadCount
});




}
/// @nodoc
class __$NotificationListResponseCopyWithImpl<$Res>
    implements _$NotificationListResponseCopyWith<$Res> {
  __$NotificationListResponseCopyWithImpl(this._self, this._then);

  final _NotificationListResponse _self;
  final $Res Function(_NotificationListResponse) _then;

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? unreadCount = null,}) {
  return _then(_NotificationListResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationItemResponse>,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$NotificationItemResponse {

 int get id;// 알림 종류. (예: 'MEMBER_JOIN', 'NEW_CYCLE')
 String get type;// 알림 종류별로 스키마가 다른 부가 정보. (해당 종류에 없는 필드는 null)
 NotificationPayloadResponse get payload;// 아직 읽지 않은 경우 null.
 DateTime? get readAt; DateTime get createdAt;
/// Create a copy of NotificationItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationItemResponseCopyWith<NotificationItemResponse> get copyWith => _$NotificationItemResponseCopyWithImpl<NotificationItemResponse>(this as NotificationItemResponse, _$identity);

  /// Serializes this NotificationItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,payload,readAt,createdAt);

@override
String toString() {
  return 'NotificationItemResponse(id: $id, type: $type, payload: $payload, readAt: $readAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $NotificationItemResponseCopyWith<$Res>  {
  factory $NotificationItemResponseCopyWith(NotificationItemResponse value, $Res Function(NotificationItemResponse) _then) = _$NotificationItemResponseCopyWithImpl;
@useResult
$Res call({
 int id, String type, NotificationPayloadResponse payload, DateTime? readAt, DateTime createdAt
});


$NotificationPayloadResponseCopyWith<$Res> get payload;

}
/// @nodoc
class _$NotificationItemResponseCopyWithImpl<$Res>
    implements $NotificationItemResponseCopyWith<$Res> {
  _$NotificationItemResponseCopyWithImpl(this._self, this._then);

  final NotificationItemResponse _self;
  final $Res Function(NotificationItemResponse) _then;

/// Create a copy of NotificationItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? payload = null,Object? readAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as NotificationPayloadResponse,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of NotificationItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationPayloadResponseCopyWith<$Res> get payload {
  
  return $NotificationPayloadResponseCopyWith<$Res>(_self.payload, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationItemResponse].
extension NotificationItemResponsePatterns on NotificationItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String type,  NotificationPayloadResponse payload,  DateTime? readAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationItemResponse() when $default != null:
return $default(_that.id,_that.type,_that.payload,_that.readAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String type,  NotificationPayloadResponse payload,  DateTime? readAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationItemResponse():
return $default(_that.id,_that.type,_that.payload,_that.readAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String type,  NotificationPayloadResponse payload,  DateTime? readAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationItemResponse() when $default != null:
return $default(_that.id,_that.type,_that.payload,_that.readAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationItemResponse implements NotificationItemResponse {
  const _NotificationItemResponse({required this.id, required this.type, required this.payload, required this.readAt, required this.createdAt});
  factory _NotificationItemResponse.fromJson(Map<String, dynamic> json) => _$NotificationItemResponseFromJson(json);

@override final  int id;
// 알림 종류. (예: 'MEMBER_JOIN', 'NEW_CYCLE')
@override final  String type;
// 알림 종류별로 스키마가 다른 부가 정보. (해당 종류에 없는 필드는 null)
@override final  NotificationPayloadResponse payload;
// 아직 읽지 않은 경우 null.
@override final  DateTime? readAt;
@override final  DateTime createdAt;

/// Create a copy of NotificationItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationItemResponseCopyWith<_NotificationItemResponse> get copyWith => __$NotificationItemResponseCopyWithImpl<_NotificationItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,payload,readAt,createdAt);

@override
String toString() {
  return 'NotificationItemResponse(id: $id, type: $type, payload: $payload, readAt: $readAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationItemResponseCopyWith<$Res> implements $NotificationItemResponseCopyWith<$Res> {
  factory _$NotificationItemResponseCopyWith(_NotificationItemResponse value, $Res Function(_NotificationItemResponse) _then) = __$NotificationItemResponseCopyWithImpl;
@override @useResult
$Res call({
 int id, String type, NotificationPayloadResponse payload, DateTime? readAt, DateTime createdAt
});


@override $NotificationPayloadResponseCopyWith<$Res> get payload;

}
/// @nodoc
class __$NotificationItemResponseCopyWithImpl<$Res>
    implements _$NotificationItemResponseCopyWith<$Res> {
  __$NotificationItemResponseCopyWithImpl(this._self, this._then);

  final _NotificationItemResponse _self;
  final $Res Function(_NotificationItemResponse) _then;

/// Create a copy of NotificationItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? payload = null,Object? readAt = freezed,Object? createdAt = null,}) {
  return _then(_NotificationItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as NotificationPayloadResponse,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of NotificationItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationPayloadResponseCopyWith<$Res> get payload {
  
  return $NotificationPayloadResponseCopyWith<$Res>(_self.payload, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}


/// @nodoc
mixin _$NotificationPayloadResponse {

// 관련 모임 id/이름.
 int? get groupId; String? get groupName;// 참여자 정보가 있는 알림(MEMBER_JOIN 등)에만 존재.
 String? get actorNickname;// 사이클 관련 알림(NEW_CYCLE·CYCLE_COMPLETED·DEADLINE·FRIEND_SHOT·COMMENT)에만 존재.
 int? get cycleId;// 대상 사진 id. (FRIEND_SHOT·COMMENT 에 존재)
 int? get shotId;// 사이클 마감 시각. (NEW_CYCLE·DEADLINE 에 존재)
 DateTime? get deadlineAt;// 서버가 계산한 마감까지 남은 단계. 60·30·5·1 중 하나. (DEADLINE 에 존재)
 int? get remainingMinutes;// 알림 썸네일 이미지 URL. 사진이 딸린 알림(NEW_CYCLE·CYCLE_COMPLETED 의
// 스타터 가이드샷, FRIEND_SHOT·COMMENT 의 인증샷)에만 값이 오고,
// 나머지는 null 이다. (검토 중·삭제된 사진도 null)
 String? get imageUrl;// 썸네일이 신고 접수로 검토 중인지 여부.
// (NEW_CYCLE·CYCLE_COMPLETED·FRIEND_SHOT·COMMENT 에 존재)
 bool? get imageUnderReview;// 썸네일이 잠긴 사진인지 여부. 잠겨도 imageUrl 은 그대로 온다.
// (FRIEND_SHOT·COMMENT 에 존재)
 bool? get locked;// 썸네일을 올린 스타터의 userId. (NEW_CYCLE·CYCLE_COMPLETED 에 존재)
 int? get starterUserId;
/// Create a copy of NotificationPayloadResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPayloadResponseCopyWith<NotificationPayloadResponse> get copyWith => _$NotificationPayloadResponseCopyWithImpl<NotificationPayloadResponse>(this as NotificationPayloadResponse, _$identity);

  /// Serializes this NotificationPayloadResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPayloadResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.actorNickname, actorNickname) || other.actorNickname == actorNickname)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.shotId, shotId) || other.shotId == shotId)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&(identical(other.remainingMinutes, remainingMinutes) || other.remainingMinutes == remainingMinutes)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageUnderReview, imageUnderReview) || other.imageUnderReview == imageUnderReview)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,groupName,actorNickname,cycleId,shotId,deadlineAt,remainingMinutes,imageUrl,imageUnderReview,locked,starterUserId);

@override
String toString() {
  return 'NotificationPayloadResponse(groupId: $groupId, groupName: $groupName, actorNickname: $actorNickname, cycleId: $cycleId, shotId: $shotId, deadlineAt: $deadlineAt, remainingMinutes: $remainingMinutes, imageUrl: $imageUrl, imageUnderReview: $imageUnderReview, locked: $locked, starterUserId: $starterUserId)';
}


}

/// @nodoc
abstract mixin class $NotificationPayloadResponseCopyWith<$Res>  {
  factory $NotificationPayloadResponseCopyWith(NotificationPayloadResponse value, $Res Function(NotificationPayloadResponse) _then) = _$NotificationPayloadResponseCopyWithImpl;
@useResult
$Res call({
 int? groupId, String? groupName, String? actorNickname, int? cycleId, int? shotId, DateTime? deadlineAt, int? remainingMinutes, String? imageUrl, bool? imageUnderReview, bool? locked, int? starterUserId
});




}
/// @nodoc
class _$NotificationPayloadResponseCopyWithImpl<$Res>
    implements $NotificationPayloadResponseCopyWith<$Res> {
  _$NotificationPayloadResponseCopyWithImpl(this._self, this._then);

  final NotificationPayloadResponse _self;
  final $Res Function(NotificationPayloadResponse) _then;

/// Create a copy of NotificationPayloadResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = freezed,Object? groupName = freezed,Object? actorNickname = freezed,Object? cycleId = freezed,Object? shotId = freezed,Object? deadlineAt = freezed,Object? remainingMinutes = freezed,Object? imageUrl = freezed,Object? imageUnderReview = freezed,Object? locked = freezed,Object? starterUserId = freezed,}) {
  return _then(_self.copyWith(
groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,actorNickname: freezed == actorNickname ? _self.actorNickname : actorNickname // ignore: cast_nullable_to_non_nullable
as String?,cycleId: freezed == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int?,shotId: freezed == shotId ? _self.shotId : shotId // ignore: cast_nullable_to_non_nullable
as int?,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remainingMinutes: freezed == remainingMinutes ? _self.remainingMinutes : remainingMinutes // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUnderReview: freezed == imageUnderReview ? _self.imageUnderReview : imageUnderReview // ignore: cast_nullable_to_non_nullable
as bool?,locked: freezed == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool?,starterUserId: freezed == starterUserId ? _self.starterUserId : starterUserId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPayloadResponse].
extension NotificationPayloadResponsePatterns on NotificationPayloadResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPayloadResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPayloadResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPayloadResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPayloadResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPayloadResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPayloadResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? groupId,  String? groupName,  String? actorNickname,  int? cycleId,  int? shotId,  DateTime? deadlineAt,  int? remainingMinutes,  String? imageUrl,  bool? imageUnderReview,  bool? locked,  int? starterUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPayloadResponse() when $default != null:
return $default(_that.groupId,_that.groupName,_that.actorNickname,_that.cycleId,_that.shotId,_that.deadlineAt,_that.remainingMinutes,_that.imageUrl,_that.imageUnderReview,_that.locked,_that.starterUserId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? groupId,  String? groupName,  String? actorNickname,  int? cycleId,  int? shotId,  DateTime? deadlineAt,  int? remainingMinutes,  String? imageUrl,  bool? imageUnderReview,  bool? locked,  int? starterUserId)  $default,) {final _that = this;
switch (_that) {
case _NotificationPayloadResponse():
return $default(_that.groupId,_that.groupName,_that.actorNickname,_that.cycleId,_that.shotId,_that.deadlineAt,_that.remainingMinutes,_that.imageUrl,_that.imageUnderReview,_that.locked,_that.starterUserId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? groupId,  String? groupName,  String? actorNickname,  int? cycleId,  int? shotId,  DateTime? deadlineAt,  int? remainingMinutes,  String? imageUrl,  bool? imageUnderReview,  bool? locked,  int? starterUserId)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPayloadResponse() when $default != null:
return $default(_that.groupId,_that.groupName,_that.actorNickname,_that.cycleId,_that.shotId,_that.deadlineAt,_that.remainingMinutes,_that.imageUrl,_that.imageUnderReview,_that.locked,_that.starterUserId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPayloadResponse implements NotificationPayloadResponse {
  const _NotificationPayloadResponse({required this.groupId, required this.groupName, required this.actorNickname, required this.cycleId, this.shotId, this.deadlineAt, this.remainingMinutes, required this.imageUrl, this.imageUnderReview, this.locked, this.starterUserId});
  factory _NotificationPayloadResponse.fromJson(Map<String, dynamic> json) => _$NotificationPayloadResponseFromJson(json);

// 관련 모임 id/이름.
@override final  int? groupId;
@override final  String? groupName;
// 참여자 정보가 있는 알림(MEMBER_JOIN 등)에만 존재.
@override final  String? actorNickname;
// 사이클 관련 알림(NEW_CYCLE·CYCLE_COMPLETED·DEADLINE·FRIEND_SHOT·COMMENT)에만 존재.
@override final  int? cycleId;
// 대상 사진 id. (FRIEND_SHOT·COMMENT 에 존재)
@override final  int? shotId;
// 사이클 마감 시각. (NEW_CYCLE·DEADLINE 에 존재)
@override final  DateTime? deadlineAt;
// 서버가 계산한 마감까지 남은 단계. 60·30·5·1 중 하나. (DEADLINE 에 존재)
@override final  int? remainingMinutes;
// 알림 썸네일 이미지 URL. 사진이 딸린 알림(NEW_CYCLE·CYCLE_COMPLETED 의
// 스타터 가이드샷, FRIEND_SHOT·COMMENT 의 인증샷)에만 값이 오고,
// 나머지는 null 이다. (검토 중·삭제된 사진도 null)
@override final  String? imageUrl;
// 썸네일이 신고 접수로 검토 중인지 여부.
// (NEW_CYCLE·CYCLE_COMPLETED·FRIEND_SHOT·COMMENT 에 존재)
@override final  bool? imageUnderReview;
// 썸네일이 잠긴 사진인지 여부. 잠겨도 imageUrl 은 그대로 온다.
// (FRIEND_SHOT·COMMENT 에 존재)
@override final  bool? locked;
// 썸네일을 올린 스타터의 userId. (NEW_CYCLE·CYCLE_COMPLETED 에 존재)
@override final  int? starterUserId;

/// Create a copy of NotificationPayloadResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPayloadResponseCopyWith<_NotificationPayloadResponse> get copyWith => __$NotificationPayloadResponseCopyWithImpl<_NotificationPayloadResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPayloadResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPayloadResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.actorNickname, actorNickname) || other.actorNickname == actorNickname)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.shotId, shotId) || other.shotId == shotId)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&(identical(other.remainingMinutes, remainingMinutes) || other.remainingMinutes == remainingMinutes)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageUnderReview, imageUnderReview) || other.imageUnderReview == imageUnderReview)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,groupName,actorNickname,cycleId,shotId,deadlineAt,remainingMinutes,imageUrl,imageUnderReview,locked,starterUserId);

@override
String toString() {
  return 'NotificationPayloadResponse(groupId: $groupId, groupName: $groupName, actorNickname: $actorNickname, cycleId: $cycleId, shotId: $shotId, deadlineAt: $deadlineAt, remainingMinutes: $remainingMinutes, imageUrl: $imageUrl, imageUnderReview: $imageUnderReview, locked: $locked, starterUserId: $starterUserId)';
}


}

/// @nodoc
abstract mixin class _$NotificationPayloadResponseCopyWith<$Res> implements $NotificationPayloadResponseCopyWith<$Res> {
  factory _$NotificationPayloadResponseCopyWith(_NotificationPayloadResponse value, $Res Function(_NotificationPayloadResponse) _then) = __$NotificationPayloadResponseCopyWithImpl;
@override @useResult
$Res call({
 int? groupId, String? groupName, String? actorNickname, int? cycleId, int? shotId, DateTime? deadlineAt, int? remainingMinutes, String? imageUrl, bool? imageUnderReview, bool? locked, int? starterUserId
});




}
/// @nodoc
class __$NotificationPayloadResponseCopyWithImpl<$Res>
    implements _$NotificationPayloadResponseCopyWith<$Res> {
  __$NotificationPayloadResponseCopyWithImpl(this._self, this._then);

  final _NotificationPayloadResponse _self;
  final $Res Function(_NotificationPayloadResponse) _then;

/// Create a copy of NotificationPayloadResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = freezed,Object? groupName = freezed,Object? actorNickname = freezed,Object? cycleId = freezed,Object? shotId = freezed,Object? deadlineAt = freezed,Object? remainingMinutes = freezed,Object? imageUrl = freezed,Object? imageUnderReview = freezed,Object? locked = freezed,Object? starterUserId = freezed,}) {
  return _then(_NotificationPayloadResponse(
groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,actorNickname: freezed == actorNickname ? _self.actorNickname : actorNickname // ignore: cast_nullable_to_non_nullable
as String?,cycleId: freezed == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int?,shotId: freezed == shotId ? _self.shotId : shotId // ignore: cast_nullable_to_non_nullable
as int?,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remainingMinutes: freezed == remainingMinutes ? _self.remainingMinutes : remainingMinutes // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUnderReview: freezed == imageUnderReview ? _self.imageUnderReview : imageUnderReview // ignore: cast_nullable_to_non_nullable
as bool?,locked: freezed == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool?,starterUserId: freezed == starterUserId ? _self.starterUserId : starterUserId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
