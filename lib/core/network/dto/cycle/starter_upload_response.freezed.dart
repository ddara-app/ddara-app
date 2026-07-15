// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'starter_upload_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StarterUploadResponse {

 int get cycleId; int get groupId; int get cycleNumber; String get topic; int get starterUserId; String get status; DateTime get startedAt; DateTime get deadlineAt; StarterShotResponse get starterShot;
/// Create a copy of StarterUploadResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StarterUploadResponseCopyWith<StarterUploadResponse> get copyWith => _$StarterUploadResponseCopyWithImpl<StarterUploadResponse>(this as StarterUploadResponse, _$identity);

  /// Serializes this StarterUploadResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StarterUploadResponse&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.cycleNumber, cycleNumber) || other.cycleNumber == cycleNumber)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&(identical(other.starterShot, starterShot) || other.starterShot == starterShot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,groupId,cycleNumber,topic,starterUserId,status,startedAt,deadlineAt,starterShot);

@override
String toString() {
  return 'StarterUploadResponse(cycleId: $cycleId, groupId: $groupId, cycleNumber: $cycleNumber, topic: $topic, starterUserId: $starterUserId, status: $status, startedAt: $startedAt, deadlineAt: $deadlineAt, starterShot: $starterShot)';
}


}

/// @nodoc
abstract mixin class $StarterUploadResponseCopyWith<$Res>  {
  factory $StarterUploadResponseCopyWith(StarterUploadResponse value, $Res Function(StarterUploadResponse) _then) = _$StarterUploadResponseCopyWithImpl;
@useResult
$Res call({
 int cycleId, int groupId, int cycleNumber, String topic, int starterUserId, String status, DateTime startedAt, DateTime deadlineAt, StarterShotResponse starterShot
});


$StarterShotResponseCopyWith<$Res> get starterShot;

}
/// @nodoc
class _$StarterUploadResponseCopyWithImpl<$Res>
    implements $StarterUploadResponseCopyWith<$Res> {
  _$StarterUploadResponseCopyWithImpl(this._self, this._then);

  final StarterUploadResponse _self;
  final $Res Function(StarterUploadResponse) _then;

/// Create a copy of StarterUploadResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cycleId = null,Object? groupId = null,Object? cycleNumber = null,Object? topic = null,Object? starterUserId = null,Object? status = null,Object? startedAt = null,Object? deadlineAt = null,Object? starterShot = null,}) {
  return _then(_self.copyWith(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,cycleNumber: null == cycleNumber ? _self.cycleNumber : cycleNumber // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,starterUserId: null == starterUserId ? _self.starterUserId : starterUserId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deadlineAt: null == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime,starterShot: null == starterShot ? _self.starterShot : starterShot // ignore: cast_nullable_to_non_nullable
as StarterShotResponse,
  ));
}
/// Create a copy of StarterUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StarterShotResponseCopyWith<$Res> get starterShot {
  
  return $StarterShotResponseCopyWith<$Res>(_self.starterShot, (value) {
    return _then(_self.copyWith(starterShot: value));
  });
}
}


/// Adds pattern-matching-related methods to [StarterUploadResponse].
extension StarterUploadResponsePatterns on StarterUploadResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StarterUploadResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StarterUploadResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StarterUploadResponse value)  $default,){
final _that = this;
switch (_that) {
case _StarterUploadResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StarterUploadResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StarterUploadResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int cycleId,  int groupId,  int cycleNumber,  String topic,  int starterUserId,  String status,  DateTime startedAt,  DateTime deadlineAt,  StarterShotResponse starterShot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StarterUploadResponse() when $default != null:
return $default(_that.cycleId,_that.groupId,_that.cycleNumber,_that.topic,_that.starterUserId,_that.status,_that.startedAt,_that.deadlineAt,_that.starterShot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int cycleId,  int groupId,  int cycleNumber,  String topic,  int starterUserId,  String status,  DateTime startedAt,  DateTime deadlineAt,  StarterShotResponse starterShot)  $default,) {final _that = this;
switch (_that) {
case _StarterUploadResponse():
return $default(_that.cycleId,_that.groupId,_that.cycleNumber,_that.topic,_that.starterUserId,_that.status,_that.startedAt,_that.deadlineAt,_that.starterShot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int cycleId,  int groupId,  int cycleNumber,  String topic,  int starterUserId,  String status,  DateTime startedAt,  DateTime deadlineAt,  StarterShotResponse starterShot)?  $default,) {final _that = this;
switch (_that) {
case _StarterUploadResponse() when $default != null:
return $default(_that.cycleId,_that.groupId,_that.cycleNumber,_that.topic,_that.starterUserId,_that.status,_that.startedAt,_that.deadlineAt,_that.starterShot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StarterUploadResponse implements StarterUploadResponse {
  const _StarterUploadResponse({required this.cycleId, required this.groupId, required this.cycleNumber, required this.topic, required this.starterUserId, required this.status, required this.startedAt, required this.deadlineAt, required this.starterShot});
  factory _StarterUploadResponse.fromJson(Map<String, dynamic> json) => _$StarterUploadResponseFromJson(json);

@override final  int cycleId;
@override final  int groupId;
@override final  int cycleNumber;
@override final  String topic;
@override final  int starterUserId;
@override final  String status;
@override final  DateTime startedAt;
@override final  DateTime deadlineAt;
@override final  StarterShotResponse starterShot;

/// Create a copy of StarterUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StarterUploadResponseCopyWith<_StarterUploadResponse> get copyWith => __$StarterUploadResponseCopyWithImpl<_StarterUploadResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StarterUploadResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StarterUploadResponse&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.cycleNumber, cycleNumber) || other.cycleNumber == cycleNumber)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&(identical(other.starterShot, starterShot) || other.starterShot == starterShot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,groupId,cycleNumber,topic,starterUserId,status,startedAt,deadlineAt,starterShot);

@override
String toString() {
  return 'StarterUploadResponse(cycleId: $cycleId, groupId: $groupId, cycleNumber: $cycleNumber, topic: $topic, starterUserId: $starterUserId, status: $status, startedAt: $startedAt, deadlineAt: $deadlineAt, starterShot: $starterShot)';
}


}

/// @nodoc
abstract mixin class _$StarterUploadResponseCopyWith<$Res> implements $StarterUploadResponseCopyWith<$Res> {
  factory _$StarterUploadResponseCopyWith(_StarterUploadResponse value, $Res Function(_StarterUploadResponse) _then) = __$StarterUploadResponseCopyWithImpl;
@override @useResult
$Res call({
 int cycleId, int groupId, int cycleNumber, String topic, int starterUserId, String status, DateTime startedAt, DateTime deadlineAt, StarterShotResponse starterShot
});


@override $StarterShotResponseCopyWith<$Res> get starterShot;

}
/// @nodoc
class __$StarterUploadResponseCopyWithImpl<$Res>
    implements _$StarterUploadResponseCopyWith<$Res> {
  __$StarterUploadResponseCopyWithImpl(this._self, this._then);

  final _StarterUploadResponse _self;
  final $Res Function(_StarterUploadResponse) _then;

/// Create a copy of StarterUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,Object? groupId = null,Object? cycleNumber = null,Object? topic = null,Object? starterUserId = null,Object? status = null,Object? startedAt = null,Object? deadlineAt = null,Object? starterShot = null,}) {
  return _then(_StarterUploadResponse(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,cycleNumber: null == cycleNumber ? _self.cycleNumber : cycleNumber // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,starterUserId: null == starterUserId ? _self.starterUserId : starterUserId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deadlineAt: null == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime,starterShot: null == starterShot ? _self.starterShot : starterShot // ignore: cast_nullable_to_non_nullable
as StarterShotResponse,
  ));
}

/// Create a copy of StarterUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StarterShotResponseCopyWith<$Res> get starterShot {
  
  return $StarterShotResponseCopyWith<$Res>(_self.starterShot, (value) {
    return _then(_self.copyWith(starterShot: value));
  });
}
}


/// @nodoc
mixin _$StarterShotResponse {

 int get shotId; String get imageUrl; String get type;
/// Create a copy of StarterShotResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StarterShotResponseCopyWith<StarterShotResponse> get copyWith => _$StarterShotResponseCopyWithImpl<StarterShotResponse>(this as StarterShotResponse, _$identity);

  /// Serializes this StarterShotResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StarterShotResponse&&(identical(other.shotId, shotId) || other.shotId == shotId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shotId,imageUrl,type);

@override
String toString() {
  return 'StarterShotResponse(shotId: $shotId, imageUrl: $imageUrl, type: $type)';
}


}

/// @nodoc
abstract mixin class $StarterShotResponseCopyWith<$Res>  {
  factory $StarterShotResponseCopyWith(StarterShotResponse value, $Res Function(StarterShotResponse) _then) = _$StarterShotResponseCopyWithImpl;
@useResult
$Res call({
 int shotId, String imageUrl, String type
});




}
/// @nodoc
class _$StarterShotResponseCopyWithImpl<$Res>
    implements $StarterShotResponseCopyWith<$Res> {
  _$StarterShotResponseCopyWithImpl(this._self, this._then);

  final StarterShotResponse _self;
  final $Res Function(StarterShotResponse) _then;

/// Create a copy of StarterShotResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shotId = null,Object? imageUrl = null,Object? type = null,}) {
  return _then(_self.copyWith(
shotId: null == shotId ? _self.shotId : shotId // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StarterShotResponse].
extension StarterShotResponsePatterns on StarterShotResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StarterShotResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StarterShotResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StarterShotResponse value)  $default,){
final _that = this;
switch (_that) {
case _StarterShotResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StarterShotResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StarterShotResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int shotId,  String imageUrl,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StarterShotResponse() when $default != null:
return $default(_that.shotId,_that.imageUrl,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int shotId,  String imageUrl,  String type)  $default,) {final _that = this;
switch (_that) {
case _StarterShotResponse():
return $default(_that.shotId,_that.imageUrl,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int shotId,  String imageUrl,  String type)?  $default,) {final _that = this;
switch (_that) {
case _StarterShotResponse() when $default != null:
return $default(_that.shotId,_that.imageUrl,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StarterShotResponse implements StarterShotResponse {
  const _StarterShotResponse({required this.shotId, required this.imageUrl, required this.type});
  factory _StarterShotResponse.fromJson(Map<String, dynamic> json) => _$StarterShotResponseFromJson(json);

@override final  int shotId;
@override final  String imageUrl;
@override final  String type;

/// Create a copy of StarterShotResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StarterShotResponseCopyWith<_StarterShotResponse> get copyWith => __$StarterShotResponseCopyWithImpl<_StarterShotResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StarterShotResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StarterShotResponse&&(identical(other.shotId, shotId) || other.shotId == shotId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shotId,imageUrl,type);

@override
String toString() {
  return 'StarterShotResponse(shotId: $shotId, imageUrl: $imageUrl, type: $type)';
}


}

/// @nodoc
abstract mixin class _$StarterShotResponseCopyWith<$Res> implements $StarterShotResponseCopyWith<$Res> {
  factory _$StarterShotResponseCopyWith(_StarterShotResponse value, $Res Function(_StarterShotResponse) _then) = __$StarterShotResponseCopyWithImpl;
@override @useResult
$Res call({
 int shotId, String imageUrl, String type
});




}
/// @nodoc
class __$StarterShotResponseCopyWithImpl<$Res>
    implements _$StarterShotResponseCopyWith<$Res> {
  __$StarterShotResponseCopyWithImpl(this._self, this._then);

  final _StarterShotResponse _self;
  final $Res Function(_StarterShotResponse) _then;

/// Create a copy of StarterShotResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shotId = null,Object? imageUrl = null,Object? type = null,}) {
  return _then(_StarterShotResponse(
shotId: null == shotId ? _self.shotId : shotId // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
