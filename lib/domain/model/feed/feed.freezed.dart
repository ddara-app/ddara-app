// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Feed {

// 대시보드에 노출할 업데이트 개수.
 int get updateCount; List<FeedItem> get items;
/// Create a copy of Feed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedCopyWith<Feed> get copyWith => _$FeedCopyWithImpl<Feed>(this as Feed, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Feed&&(identical(other.updateCount, updateCount) || other.updateCount == updateCount)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,updateCount,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'Feed(updateCount: $updateCount, items: $items)';
}


}

/// @nodoc
abstract mixin class $FeedCopyWith<$Res>  {
  factory $FeedCopyWith(Feed value, $Res Function(Feed) _then) = _$FeedCopyWithImpl;
@useResult
$Res call({
 int updateCount, List<FeedItem> items
});




}
/// @nodoc
class _$FeedCopyWithImpl<$Res>
    implements $FeedCopyWith<$Res> {
  _$FeedCopyWithImpl(this._self, this._then);

  final Feed _self;
  final $Res Function(Feed) _then;

/// Create a copy of Feed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? updateCount = null,Object? items = null,}) {
  return _then(_self.copyWith(
updateCount: null == updateCount ? _self.updateCount : updateCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<FeedItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [Feed].
extension FeedPatterns on Feed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Feed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Feed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Feed value)  $default,){
final _that = this;
switch (_that) {
case _Feed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Feed value)?  $default,){
final _that = this;
switch (_that) {
case _Feed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int updateCount,  List<FeedItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Feed() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int updateCount,  List<FeedItem> items)  $default,) {final _that = this;
switch (_that) {
case _Feed():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int updateCount,  List<FeedItem> items)?  $default,) {final _that = this;
switch (_that) {
case _Feed() when $default != null:
return $default(_that.updateCount,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _Feed implements Feed {
  const _Feed({this.updateCount = 0, final  List<FeedItem> items = const <FeedItem>[]}): _items = items;
  

// 대시보드에 노출할 업데이트 개수.
@override@JsonKey() final  int updateCount;
 final  List<FeedItem> _items;
@override@JsonKey() List<FeedItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Feed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedCopyWith<_Feed> get copyWith => __$FeedCopyWithImpl<_Feed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Feed&&(identical(other.updateCount, updateCount) || other.updateCount == updateCount)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,updateCount,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'Feed(updateCount: $updateCount, items: $items)';
}


}

/// @nodoc
abstract mixin class _$FeedCopyWith<$Res> implements $FeedCopyWith<$Res> {
  factory _$FeedCopyWith(_Feed value, $Res Function(_Feed) _then) = __$FeedCopyWithImpl;
@override @useResult
$Res call({
 int updateCount, List<FeedItem> items
});




}
/// @nodoc
class __$FeedCopyWithImpl<$Res>
    implements _$FeedCopyWith<$Res> {
  __$FeedCopyWithImpl(this._self, this._then);

  final _Feed _self;
  final $Res Function(_Feed) _then;

/// Create a copy of Feed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? updateCount = null,Object? items = null,}) {
  return _then(_Feed(
updateCount: null == updateCount ? _self.updateCount : updateCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<FeedItem>,
  ));
}


}

/// @nodoc
mixin _$FeedItem {

 int get shotId;// 회차를 연 스타터의 사진인지 여부. (아니면 따라찍은 멤버의 사진)
 bool get isStarter;// 사진 URL. 신고 접수로 검토 중이면 null.
 String? get imageUrl;// 사진이 신고 접수로 검토 중인지 여부.
 bool get imageUnderReview;// 사진을 올린 사용자.
 int get userId; String get nickname;// 사진이 속한 모임.
 int get groupId; String get groupName;// 사진이 속한 회차와 그 주제.
 int get cycleId; String get topic;// 잠금 여부. 해당 회차에 내 인증샷을 올리지 않았으면 true.
 bool get locked; DateTime get uploadedAt;
/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedItemCopyWith<FeedItem> get copyWith => _$FeedItemCopyWithImpl<FeedItem>(this as FeedItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedItem&&(identical(other.shotId, shotId) || other.shotId == shotId)&&(identical(other.isStarter, isStarter) || other.isStarter == isStarter)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageUnderReview, imageUnderReview) || other.imageUnderReview == imageUnderReview)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt));
}


@override
int get hashCode => Object.hash(runtimeType,shotId,isStarter,imageUrl,imageUnderReview,userId,nickname,groupId,groupName,cycleId,topic,locked,uploadedAt);

@override
String toString() {
  return 'FeedItem(shotId: $shotId, isStarter: $isStarter, imageUrl: $imageUrl, imageUnderReview: $imageUnderReview, userId: $userId, nickname: $nickname, groupId: $groupId, groupName: $groupName, cycleId: $cycleId, topic: $topic, locked: $locked, uploadedAt: $uploadedAt)';
}


}

/// @nodoc
abstract mixin class $FeedItemCopyWith<$Res>  {
  factory $FeedItemCopyWith(FeedItem value, $Res Function(FeedItem) _then) = _$FeedItemCopyWithImpl;
@useResult
$Res call({
 int shotId, bool isStarter, String? imageUrl, bool imageUnderReview, int userId, String nickname, int groupId, String groupName, int cycleId, String topic, bool locked, DateTime uploadedAt
});




}
/// @nodoc
class _$FeedItemCopyWithImpl<$Res>
    implements $FeedItemCopyWith<$Res> {
  _$FeedItemCopyWithImpl(this._self, this._then);

  final FeedItem _self;
  final $Res Function(FeedItem) _then;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shotId = null,Object? isStarter = null,Object? imageUrl = freezed,Object? imageUnderReview = null,Object? userId = null,Object? nickname = null,Object? groupId = null,Object? groupName = null,Object? cycleId = null,Object? topic = null,Object? locked = null,Object? uploadedAt = null,}) {
  return _then(_self.copyWith(
shotId: null == shotId ? _self.shotId : shotId // ignore: cast_nullable_to_non_nullable
as int,isStarter: null == isStarter ? _self.isStarter : isStarter // ignore: cast_nullable_to_non_nullable
as bool,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUnderReview: null == imageUnderReview ? _self.imageUnderReview : imageUnderReview // ignore: cast_nullable_to_non_nullable
as bool,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedItem].
extension FeedItemPatterns on FeedItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedItem value)  $default,){
final _that = this;
switch (_that) {
case _FeedItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedItem value)?  $default,){
final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int shotId,  bool isStarter,  String? imageUrl,  bool imageUnderReview,  int userId,  String nickname,  int groupId,  String groupName,  int cycleId,  String topic,  bool locked,  DateTime uploadedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
return $default(_that.shotId,_that.isStarter,_that.imageUrl,_that.imageUnderReview,_that.userId,_that.nickname,_that.groupId,_that.groupName,_that.cycleId,_that.topic,_that.locked,_that.uploadedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int shotId,  bool isStarter,  String? imageUrl,  bool imageUnderReview,  int userId,  String nickname,  int groupId,  String groupName,  int cycleId,  String topic,  bool locked,  DateTime uploadedAt)  $default,) {final _that = this;
switch (_that) {
case _FeedItem():
return $default(_that.shotId,_that.isStarter,_that.imageUrl,_that.imageUnderReview,_that.userId,_that.nickname,_that.groupId,_that.groupName,_that.cycleId,_that.topic,_that.locked,_that.uploadedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int shotId,  bool isStarter,  String? imageUrl,  bool imageUnderReview,  int userId,  String nickname,  int groupId,  String groupName,  int cycleId,  String topic,  bool locked,  DateTime uploadedAt)?  $default,) {final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
return $default(_that.shotId,_that.isStarter,_that.imageUrl,_that.imageUnderReview,_that.userId,_that.nickname,_that.groupId,_that.groupName,_that.cycleId,_that.topic,_that.locked,_that.uploadedAt);case _:
  return null;

}
}

}

/// @nodoc


class _FeedItem implements FeedItem {
  const _FeedItem({required this.shotId, required this.isStarter, required this.imageUrl, this.imageUnderReview = false, required this.userId, required this.nickname, required this.groupId, required this.groupName, required this.cycleId, required this.topic, this.locked = false, required this.uploadedAt});
  

@override final  int shotId;
// 회차를 연 스타터의 사진인지 여부. (아니면 따라찍은 멤버의 사진)
@override final  bool isStarter;
// 사진 URL. 신고 접수로 검토 중이면 null.
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
@override final  DateTime uploadedAt;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedItemCopyWith<_FeedItem> get copyWith => __$FeedItemCopyWithImpl<_FeedItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedItem&&(identical(other.shotId, shotId) || other.shotId == shotId)&&(identical(other.isStarter, isStarter) || other.isStarter == isStarter)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageUnderReview, imageUnderReview) || other.imageUnderReview == imageUnderReview)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt));
}


@override
int get hashCode => Object.hash(runtimeType,shotId,isStarter,imageUrl,imageUnderReview,userId,nickname,groupId,groupName,cycleId,topic,locked,uploadedAt);

@override
String toString() {
  return 'FeedItem(shotId: $shotId, isStarter: $isStarter, imageUrl: $imageUrl, imageUnderReview: $imageUnderReview, userId: $userId, nickname: $nickname, groupId: $groupId, groupName: $groupName, cycleId: $cycleId, topic: $topic, locked: $locked, uploadedAt: $uploadedAt)';
}


}

/// @nodoc
abstract mixin class _$FeedItemCopyWith<$Res> implements $FeedItemCopyWith<$Res> {
  factory _$FeedItemCopyWith(_FeedItem value, $Res Function(_FeedItem) _then) = __$FeedItemCopyWithImpl;
@override @useResult
$Res call({
 int shotId, bool isStarter, String? imageUrl, bool imageUnderReview, int userId, String nickname, int groupId, String groupName, int cycleId, String topic, bool locked, DateTime uploadedAt
});




}
/// @nodoc
class __$FeedItemCopyWithImpl<$Res>
    implements _$FeedItemCopyWith<$Res> {
  __$FeedItemCopyWithImpl(this._self, this._then);

  final _FeedItem _self;
  final $Res Function(_FeedItem) _then;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shotId = null,Object? isStarter = null,Object? imageUrl = freezed,Object? imageUnderReview = null,Object? userId = null,Object? nickname = null,Object? groupId = null,Object? groupName = null,Object? cycleId = null,Object? topic = null,Object? locked = null,Object? uploadedAt = null,}) {
  return _then(_FeedItem(
shotId: null == shotId ? _self.shotId : shotId // ignore: cast_nullable_to_non_nullable
as int,isStarter: null == isStarter ? _self.isStarter : isStarter // ignore: cast_nullable_to_non_nullable
as bool,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUnderReview: null == imageUnderReview ? _self.imageUnderReview : imageUnderReview // ignore: cast_nullable_to_non_nullable
as bool,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
