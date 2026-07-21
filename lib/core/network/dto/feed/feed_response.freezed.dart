// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedResponse {

// 대시보드에 노출할 업데이트 개수.
 int get updateCount; List<FeedItemResponse> get items;
/// Create a copy of FeedResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedResponseCopyWith<FeedResponse> get copyWith => _$FeedResponseCopyWithImpl<FeedResponse>(this as FeedResponse, _$identity);

  /// Serializes this FeedResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedResponse&&(identical(other.updateCount, updateCount) || other.updateCount == updateCount)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updateCount,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'FeedResponse(updateCount: $updateCount, items: $items)';
}


}

/// @nodoc
abstract mixin class $FeedResponseCopyWith<$Res>  {
  factory $FeedResponseCopyWith(FeedResponse value, $Res Function(FeedResponse) _then) = _$FeedResponseCopyWithImpl;
@useResult
$Res call({
 int updateCount, List<FeedItemResponse> items
});




}
/// @nodoc
class _$FeedResponseCopyWithImpl<$Res>
    implements $FeedResponseCopyWith<$Res> {
  _$FeedResponseCopyWithImpl(this._self, this._then);

  final FeedResponse _self;
  final $Res Function(FeedResponse) _then;

/// Create a copy of FeedResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? updateCount = null,Object? items = null,}) {
  return _then(_self.copyWith(
updateCount: null == updateCount ? _self.updateCount : updateCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<FeedItemResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedResponse].
extension FeedResponsePatterns on FeedResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedResponse value)  $default,){
final _that = this;
switch (_that) {
case _FeedResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FeedResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int updateCount,  List<FeedItemResponse> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedResponse() when $default != null:
return $default(_that.updateCount,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int updateCount,  List<FeedItemResponse> items)  $default,) {final _that = this;
switch (_that) {
case _FeedResponse():
return $default(_that.updateCount,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int updateCount,  List<FeedItemResponse> items)?  $default,) {final _that = this;
switch (_that) {
case _FeedResponse() when $default != null:
return $default(_that.updateCount,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedResponse implements FeedResponse {
  const _FeedResponse({this.updateCount = 0, final  List<FeedItemResponse> items = const <FeedItemResponse>[]}): _items = items;
  factory _FeedResponse.fromJson(Map<String, dynamic> json) => _$FeedResponseFromJson(json);

// 대시보드에 노출할 업데이트 개수.
@override@JsonKey() final  int updateCount;
 final  List<FeedItemResponse> _items;
@override@JsonKey() List<FeedItemResponse> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of FeedResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedResponseCopyWith<_FeedResponse> get copyWith => __$FeedResponseCopyWithImpl<_FeedResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedResponse&&(identical(other.updateCount, updateCount) || other.updateCount == updateCount)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updateCount,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'FeedResponse(updateCount: $updateCount, items: $items)';
}


}

/// @nodoc
abstract mixin class _$FeedResponseCopyWith<$Res> implements $FeedResponseCopyWith<$Res> {
  factory _$FeedResponseCopyWith(_FeedResponse value, $Res Function(_FeedResponse) _then) = __$FeedResponseCopyWithImpl;
@override @useResult
$Res call({
 int updateCount, List<FeedItemResponse> items
});




}
/// @nodoc
class __$FeedResponseCopyWithImpl<$Res>
    implements _$FeedResponseCopyWith<$Res> {
  __$FeedResponseCopyWithImpl(this._self, this._then);

  final _FeedResponse _self;
  final $Res Function(_FeedResponse) _then;

/// Create a copy of FeedResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? updateCount = null,Object? items = null,}) {
  return _then(_FeedResponse(
updateCount: null == updateCount ? _self.updateCount : updateCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<FeedItemResponse>,
  ));
}


}


/// @nodoc
mixin _$FeedItemResponse {

 int get shotId;// 사진 종류. 'starter'(회차를 연 사진) 또는 'member'(따라찍은 사진).
 String get type;// 사진 URL. 신고 접수로 검토 중이면 null 로 올 수 있다.
 String? get imageUrl;// 사진이 신고 접수로 검토 중인지 여부.
 bool get imageUnderReview;// 사진을 올린 사용자.
 int get userId; String get nickname;// 사진이 속한 모임.
 int get groupId; String get groupName;// 사진이 속한 회차와 그 주제.
 int get cycleId; String get topic;// 잠금 여부. 해당 회차에 내 인증샷을 올리지 않았으면 true.
 bool get locked; int get commentCount;// 최신 댓글 미리보기. 없으면 빈 목록.
 List<FeedCommentResponse> get latestComments; DateTime get uploadedAt;
/// Create a copy of FeedItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedItemResponseCopyWith<FeedItemResponse> get copyWith => _$FeedItemResponseCopyWithImpl<FeedItemResponse>(this as FeedItemResponse, _$identity);

  /// Serializes this FeedItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedItemResponse&&(identical(other.shotId, shotId) || other.shotId == shotId)&&(identical(other.type, type) || other.type == type)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageUnderReview, imageUnderReview) || other.imageUnderReview == imageUnderReview)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&const DeepCollectionEquality().equals(other.latestComments, latestComments)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shotId,type,imageUrl,imageUnderReview,userId,nickname,groupId,groupName,cycleId,topic,locked,commentCount,const DeepCollectionEquality().hash(latestComments),uploadedAt);

@override
String toString() {
  return 'FeedItemResponse(shotId: $shotId, type: $type, imageUrl: $imageUrl, imageUnderReview: $imageUnderReview, userId: $userId, nickname: $nickname, groupId: $groupId, groupName: $groupName, cycleId: $cycleId, topic: $topic, locked: $locked, commentCount: $commentCount, latestComments: $latestComments, uploadedAt: $uploadedAt)';
}


}

/// @nodoc
abstract mixin class $FeedItemResponseCopyWith<$Res>  {
  factory $FeedItemResponseCopyWith(FeedItemResponse value, $Res Function(FeedItemResponse) _then) = _$FeedItemResponseCopyWithImpl;
@useResult
$Res call({
 int shotId, String type, String? imageUrl, bool imageUnderReview, int userId, String nickname, int groupId, String groupName, int cycleId, String topic, bool locked, int commentCount, List<FeedCommentResponse> latestComments, DateTime uploadedAt
});




}
/// @nodoc
class _$FeedItemResponseCopyWithImpl<$Res>
    implements $FeedItemResponseCopyWith<$Res> {
  _$FeedItemResponseCopyWithImpl(this._self, this._then);

  final FeedItemResponse _self;
  final $Res Function(FeedItemResponse) _then;

/// Create a copy of FeedItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shotId = null,Object? type = null,Object? imageUrl = freezed,Object? imageUnderReview = null,Object? userId = null,Object? nickname = null,Object? groupId = null,Object? groupName = null,Object? cycleId = null,Object? topic = null,Object? locked = null,Object? commentCount = null,Object? latestComments = null,Object? uploadedAt = null,}) {
  return _then(_self.copyWith(
shotId: null == shotId ? _self.shotId : shotId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUnderReview: null == imageUnderReview ? _self.imageUnderReview : imageUnderReview // ignore: cast_nullable_to_non_nullable
as bool,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,latestComments: null == latestComments ? _self.latestComments : latestComments // ignore: cast_nullable_to_non_nullable
as List<FeedCommentResponse>,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedItemResponse].
extension FeedItemResponsePatterns on FeedItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _FeedItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FeedItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int shotId,  String type,  String? imageUrl,  bool imageUnderReview,  int userId,  String nickname,  int groupId,  String groupName,  int cycleId,  String topic,  bool locked,  int commentCount,  List<FeedCommentResponse> latestComments,  DateTime uploadedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedItemResponse() when $default != null:
return $default(_that.shotId,_that.type,_that.imageUrl,_that.imageUnderReview,_that.userId,_that.nickname,_that.groupId,_that.groupName,_that.cycleId,_that.topic,_that.locked,_that.commentCount,_that.latestComments,_that.uploadedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int shotId,  String type,  String? imageUrl,  bool imageUnderReview,  int userId,  String nickname,  int groupId,  String groupName,  int cycleId,  String topic,  bool locked,  int commentCount,  List<FeedCommentResponse> latestComments,  DateTime uploadedAt)  $default,) {final _that = this;
switch (_that) {
case _FeedItemResponse():
return $default(_that.shotId,_that.type,_that.imageUrl,_that.imageUnderReview,_that.userId,_that.nickname,_that.groupId,_that.groupName,_that.cycleId,_that.topic,_that.locked,_that.commentCount,_that.latestComments,_that.uploadedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int shotId,  String type,  String? imageUrl,  bool imageUnderReview,  int userId,  String nickname,  int groupId,  String groupName,  int cycleId,  String topic,  bool locked,  int commentCount,  List<FeedCommentResponse> latestComments,  DateTime uploadedAt)?  $default,) {final _that = this;
switch (_that) {
case _FeedItemResponse() when $default != null:
return $default(_that.shotId,_that.type,_that.imageUrl,_that.imageUnderReview,_that.userId,_that.nickname,_that.groupId,_that.groupName,_that.cycleId,_that.topic,_that.locked,_that.commentCount,_that.latestComments,_that.uploadedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedItemResponse implements FeedItemResponse {
  const _FeedItemResponse({required this.shotId, required this.type, required this.imageUrl, this.imageUnderReview = false, required this.userId, required this.nickname, required this.groupId, required this.groupName, required this.cycleId, required this.topic, this.locked = false, this.commentCount = 0, final  List<FeedCommentResponse> latestComments = const <FeedCommentResponse>[], required this.uploadedAt}): _latestComments = latestComments;
  factory _FeedItemResponse.fromJson(Map<String, dynamic> json) => _$FeedItemResponseFromJson(json);

@override final  int shotId;
// 사진 종류. 'starter'(회차를 연 사진) 또는 'member'(따라찍은 사진).
@override final  String type;
// 사진 URL. 신고 접수로 검토 중이면 null 로 올 수 있다.
@override final  String? imageUrl;
// 사진이 신고 접수로 검토 중인지 여부.
@override@JsonKey() final  bool imageUnderReview;
// 사진을 올린 사용자.
@override final  int userId;
@override final  String nickname;
// 사진이 속한 모임.
@override final  int groupId;
@override final  String groupName;
// 사진이 속한 회차와 그 주제.
@override final  int cycleId;
@override final  String topic;
// 잠금 여부. 해당 회차에 내 인증샷을 올리지 않았으면 true.
@override@JsonKey() final  bool locked;
@override@JsonKey() final  int commentCount;
// 최신 댓글 미리보기. 없으면 빈 목록.
 final  List<FeedCommentResponse> _latestComments;
// 최신 댓글 미리보기. 없으면 빈 목록.
@override@JsonKey() List<FeedCommentResponse> get latestComments {
  if (_latestComments is EqualUnmodifiableListView) return _latestComments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_latestComments);
}

@override final  DateTime uploadedAt;

/// Create a copy of FeedItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedItemResponseCopyWith<_FeedItemResponse> get copyWith => __$FeedItemResponseCopyWithImpl<_FeedItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedItemResponse&&(identical(other.shotId, shotId) || other.shotId == shotId)&&(identical(other.type, type) || other.type == type)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageUnderReview, imageUnderReview) || other.imageUnderReview == imageUnderReview)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&const DeepCollectionEquality().equals(other._latestComments, _latestComments)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shotId,type,imageUrl,imageUnderReview,userId,nickname,groupId,groupName,cycleId,topic,locked,commentCount,const DeepCollectionEquality().hash(_latestComments),uploadedAt);

@override
String toString() {
  return 'FeedItemResponse(shotId: $shotId, type: $type, imageUrl: $imageUrl, imageUnderReview: $imageUnderReview, userId: $userId, nickname: $nickname, groupId: $groupId, groupName: $groupName, cycleId: $cycleId, topic: $topic, locked: $locked, commentCount: $commentCount, latestComments: $latestComments, uploadedAt: $uploadedAt)';
}


}

/// @nodoc
abstract mixin class _$FeedItemResponseCopyWith<$Res> implements $FeedItemResponseCopyWith<$Res> {
  factory _$FeedItemResponseCopyWith(_FeedItemResponse value, $Res Function(_FeedItemResponse) _then) = __$FeedItemResponseCopyWithImpl;
@override @useResult
$Res call({
 int shotId, String type, String? imageUrl, bool imageUnderReview, int userId, String nickname, int groupId, String groupName, int cycleId, String topic, bool locked, int commentCount, List<FeedCommentResponse> latestComments, DateTime uploadedAt
});




}
/// @nodoc
class __$FeedItemResponseCopyWithImpl<$Res>
    implements _$FeedItemResponseCopyWith<$Res> {
  __$FeedItemResponseCopyWithImpl(this._self, this._then);

  final _FeedItemResponse _self;
  final $Res Function(_FeedItemResponse) _then;

/// Create a copy of FeedItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shotId = null,Object? type = null,Object? imageUrl = freezed,Object? imageUnderReview = null,Object? userId = null,Object? nickname = null,Object? groupId = null,Object? groupName = null,Object? cycleId = null,Object? topic = null,Object? locked = null,Object? commentCount = null,Object? latestComments = null,Object? uploadedAt = null,}) {
  return _then(_FeedItemResponse(
shotId: null == shotId ? _self.shotId : shotId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUnderReview: null == imageUnderReview ? _self.imageUnderReview : imageUnderReview // ignore: cast_nullable_to_non_nullable
as bool,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,latestComments: null == latestComments ? _self._latestComments : latestComments // ignore: cast_nullable_to_non_nullable
as List<FeedCommentResponse>,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$FeedCommentResponse {

 int get userId; String get nickname;// 작성자 프로필 이미지 URL. 미등록이면 null.
 String? get profileImageUrl;// 댓글 내용. 검토 중이면 null.
 String? get content; bool get underReview;// 내가 신고한 댓글인지 여부.
 bool get reportedByMe;
/// Create a copy of FeedCommentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedCommentResponseCopyWith<FeedCommentResponse> get copyWith => _$FeedCommentResponseCopyWithImpl<FeedCommentResponse>(this as FeedCommentResponse, _$identity);

  /// Serializes this FeedCommentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedCommentResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.content, content) || other.content == content)&&(identical(other.underReview, underReview) || other.underReview == underReview)&&(identical(other.reportedByMe, reportedByMe) || other.reportedByMe == reportedByMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,nickname,profileImageUrl,content,underReview,reportedByMe);

@override
String toString() {
  return 'FeedCommentResponse(userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, content: $content, underReview: $underReview, reportedByMe: $reportedByMe)';
}


}

/// @nodoc
abstract mixin class $FeedCommentResponseCopyWith<$Res>  {
  factory $FeedCommentResponseCopyWith(FeedCommentResponse value, $Res Function(FeedCommentResponse) _then) = _$FeedCommentResponseCopyWithImpl;
@useResult
$Res call({
 int userId, String nickname, String? profileImageUrl, String? content, bool underReview, bool reportedByMe
});




}
/// @nodoc
class _$FeedCommentResponseCopyWithImpl<$Res>
    implements $FeedCommentResponseCopyWith<$Res> {
  _$FeedCommentResponseCopyWithImpl(this._self, this._then);

  final FeedCommentResponse _self;
  final $Res Function(FeedCommentResponse) _then;

/// Create a copy of FeedCommentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? nickname = null,Object? profileImageUrl = freezed,Object? content = freezed,Object? underReview = null,Object? reportedByMe = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,underReview: null == underReview ? _self.underReview : underReview // ignore: cast_nullable_to_non_nullable
as bool,reportedByMe: null == reportedByMe ? _self.reportedByMe : reportedByMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedCommentResponse].
extension FeedCommentResponsePatterns on FeedCommentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedCommentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedCommentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedCommentResponse value)  $default,){
final _that = this;
switch (_that) {
case _FeedCommentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedCommentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FeedCommentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  String nickname,  String? profileImageUrl,  String? content,  bool underReview,  bool reportedByMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedCommentResponse() when $default != null:
return $default(_that.userId,_that.nickname,_that.profileImageUrl,_that.content,_that.underReview,_that.reportedByMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  String nickname,  String? profileImageUrl,  String? content,  bool underReview,  bool reportedByMe)  $default,) {final _that = this;
switch (_that) {
case _FeedCommentResponse():
return $default(_that.userId,_that.nickname,_that.profileImageUrl,_that.content,_that.underReview,_that.reportedByMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  String nickname,  String? profileImageUrl,  String? content,  bool underReview,  bool reportedByMe)?  $default,) {final _that = this;
switch (_that) {
case _FeedCommentResponse() when $default != null:
return $default(_that.userId,_that.nickname,_that.profileImageUrl,_that.content,_that.underReview,_that.reportedByMe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedCommentResponse implements FeedCommentResponse {
  const _FeedCommentResponse({required this.userId, required this.nickname, this.profileImageUrl, required this.content, this.underReview = false, this.reportedByMe = false});
  factory _FeedCommentResponse.fromJson(Map<String, dynamic> json) => _$FeedCommentResponseFromJson(json);

@override final  int userId;
@override final  String nickname;
// 작성자 프로필 이미지 URL. 미등록이면 null.
@override final  String? profileImageUrl;
// 댓글 내용. 검토 중이면 null.
@override final  String? content;
@override@JsonKey() final  bool underReview;
// 내가 신고한 댓글인지 여부.
@override@JsonKey() final  bool reportedByMe;

/// Create a copy of FeedCommentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedCommentResponseCopyWith<_FeedCommentResponse> get copyWith => __$FeedCommentResponseCopyWithImpl<_FeedCommentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedCommentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedCommentResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.content, content) || other.content == content)&&(identical(other.underReview, underReview) || other.underReview == underReview)&&(identical(other.reportedByMe, reportedByMe) || other.reportedByMe == reportedByMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,nickname,profileImageUrl,content,underReview,reportedByMe);

@override
String toString() {
  return 'FeedCommentResponse(userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, content: $content, underReview: $underReview, reportedByMe: $reportedByMe)';
}


}

/// @nodoc
abstract mixin class _$FeedCommentResponseCopyWith<$Res> implements $FeedCommentResponseCopyWith<$Res> {
  factory _$FeedCommentResponseCopyWith(_FeedCommentResponse value, $Res Function(_FeedCommentResponse) _then) = __$FeedCommentResponseCopyWithImpl;
@override @useResult
$Res call({
 int userId, String nickname, String? profileImageUrl, String? content, bool underReview, bool reportedByMe
});




}
/// @nodoc
class __$FeedCommentResponseCopyWithImpl<$Res>
    implements _$FeedCommentResponseCopyWith<$Res> {
  __$FeedCommentResponseCopyWithImpl(this._self, this._then);

  final _FeedCommentResponse _self;
  final $Res Function(_FeedCommentResponse) _then;

/// Create a copy of FeedCommentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? nickname = null,Object? profileImageUrl = freezed,Object? content = freezed,Object? underReview = null,Object? reportedByMe = null,}) {
  return _then(_FeedCommentResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,underReview: null == underReview ? _self.underReview : underReview // ignore: cast_nullable_to_non_nullable
as bool,reportedByMe: null == reportedByMe ? _self.reportedByMe : reportedByMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
