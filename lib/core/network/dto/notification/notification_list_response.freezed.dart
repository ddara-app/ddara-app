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

 List<NotificationItemResponse> get items;
/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationListResponseCopyWith<NotificationListResponse> get copyWith => _$NotificationListResponseCopyWithImpl<NotificationListResponse>(this as NotificationListResponse, _$identity);

  /// Serializes this NotificationListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationListResponse&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'NotificationListResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class $NotificationListResponseCopyWith<$Res>  {
  factory $NotificationListResponseCopyWith(NotificationListResponse value, $Res Function(NotificationListResponse) _then) = _$NotificationListResponseCopyWithImpl;
@useResult
$Res call({
 List<NotificationItemResponse> items
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
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationItemResponse>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NotificationItemResponse> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NotificationItemResponse> items)  $default,) {final _that = this;
switch (_that) {
case _NotificationListResponse():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NotificationItemResponse> items)?  $default,) {final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationListResponse implements NotificationListResponse {
  const _NotificationListResponse({required final  List<NotificationItemResponse> items}): _items = items;
  factory _NotificationListResponse.fromJson(Map<String, dynamic> json) => _$NotificationListResponseFromJson(json);

 final  List<NotificationItemResponse> _items;
@override List<NotificationItemResponse> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationListResponse&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'NotificationListResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class _$NotificationListResponseCopyWith<$Res> implements $NotificationListResponseCopyWith<$Res> {
  factory _$NotificationListResponseCopyWith(_NotificationListResponse value, $Res Function(_NotificationListResponse) _then) = __$NotificationListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<NotificationItemResponse> items
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
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_NotificationListResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationItemResponse>,
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
 String? get actorNickname;// 사이클 관련 알림(NEW_CYCLE·CYCLE_COMPLETED·DEADLINE 등)에만 존재.
 int? get cycleId;// 알림 썸네일 이미지 URL.
 String? get imageUrl;
/// Create a copy of NotificationPayloadResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPayloadResponseCopyWith<NotificationPayloadResponse> get copyWith => _$NotificationPayloadResponseCopyWithImpl<NotificationPayloadResponse>(this as NotificationPayloadResponse, _$identity);

  /// Serializes this NotificationPayloadResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPayloadResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.actorNickname, actorNickname) || other.actorNickname == actorNickname)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,groupName,actorNickname,cycleId,imageUrl);

@override
String toString() {
  return 'NotificationPayloadResponse(groupId: $groupId, groupName: $groupName, actorNickname: $actorNickname, cycleId: $cycleId, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $NotificationPayloadResponseCopyWith<$Res>  {
  factory $NotificationPayloadResponseCopyWith(NotificationPayloadResponse value, $Res Function(NotificationPayloadResponse) _then) = _$NotificationPayloadResponseCopyWithImpl;
@useResult
$Res call({
 int? groupId, String? groupName, String? actorNickname, int? cycleId, String? imageUrl
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
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = freezed,Object? groupName = freezed,Object? actorNickname = freezed,Object? cycleId = freezed,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,actorNickname: freezed == actorNickname ? _self.actorNickname : actorNickname // ignore: cast_nullable_to_non_nullable
as String?,cycleId: freezed == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? groupId,  String? groupName,  String? actorNickname,  int? cycleId,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPayloadResponse() when $default != null:
return $default(_that.groupId,_that.groupName,_that.actorNickname,_that.cycleId,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? groupId,  String? groupName,  String? actorNickname,  int? cycleId,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _NotificationPayloadResponse():
return $default(_that.groupId,_that.groupName,_that.actorNickname,_that.cycleId,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? groupId,  String? groupName,  String? actorNickname,  int? cycleId,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPayloadResponse() when $default != null:
return $default(_that.groupId,_that.groupName,_that.actorNickname,_that.cycleId,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPayloadResponse implements NotificationPayloadResponse {
  const _NotificationPayloadResponse({required this.groupId, required this.groupName, required this.actorNickname, required this.cycleId, required this.imageUrl});
  factory _NotificationPayloadResponse.fromJson(Map<String, dynamic> json) => _$NotificationPayloadResponseFromJson(json);

// 관련 모임 id/이름.
@override final  int? groupId;
@override final  String? groupName;
// 참여자 정보가 있는 알림(MEMBER_JOIN 등)에만 존재.
@override final  String? actorNickname;
// 사이클 관련 알림(NEW_CYCLE·CYCLE_COMPLETED·DEADLINE 등)에만 존재.
@override final  int? cycleId;
// 알림 썸네일 이미지 URL.
@override final  String? imageUrl;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPayloadResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.actorNickname, actorNickname) || other.actorNickname == actorNickname)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,groupName,actorNickname,cycleId,imageUrl);

@override
String toString() {
  return 'NotificationPayloadResponse(groupId: $groupId, groupName: $groupName, actorNickname: $actorNickname, cycleId: $cycleId, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$NotificationPayloadResponseCopyWith<$Res> implements $NotificationPayloadResponseCopyWith<$Res> {
  factory _$NotificationPayloadResponseCopyWith(_NotificationPayloadResponse value, $Res Function(_NotificationPayloadResponse) _then) = __$NotificationPayloadResponseCopyWithImpl;
@override @useResult
$Res call({
 int? groupId, String? groupName, String? actorNickname, int? cycleId, String? imageUrl
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
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = freezed,Object? groupName = freezed,Object? actorNickname = freezed,Object? cycleId = freezed,Object? imageUrl = freezed,}) {
  return _then(_NotificationPayloadResponse(
groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,actorNickname: freezed == actorNickname ? _self.actorNickname : actorNickname // ignore: cast_nullable_to_non_nullable
as String?,cycleId: freezed == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
