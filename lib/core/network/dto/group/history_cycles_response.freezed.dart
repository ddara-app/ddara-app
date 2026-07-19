// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_cycles_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryCyclesResponse {

// 지난 따라찍기 통계. (더보기 화면 전용, 모임 페이지 프리뷰는 사용 안 함)
// 서버 미제공 시 null.
 HistoryStatsResponse? get stats; List<HistoryCycleResponse> get cycles;
/// Create a copy of HistoryCyclesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryCyclesResponseCopyWith<HistoryCyclesResponse> get copyWith => _$HistoryCyclesResponseCopyWithImpl<HistoryCyclesResponse>(this as HistoryCyclesResponse, _$identity);

  /// Serializes this HistoryCyclesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryCyclesResponse&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other.cycles, cycles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stats,const DeepCollectionEquality().hash(cycles));

@override
String toString() {
  return 'HistoryCyclesResponse(stats: $stats, cycles: $cycles)';
}


}

/// @nodoc
abstract mixin class $HistoryCyclesResponseCopyWith<$Res>  {
  factory $HistoryCyclesResponseCopyWith(HistoryCyclesResponse value, $Res Function(HistoryCyclesResponse) _then) = _$HistoryCyclesResponseCopyWithImpl;
@useResult
$Res call({
 HistoryStatsResponse? stats, List<HistoryCycleResponse> cycles
});


$HistoryStatsResponseCopyWith<$Res>? get stats;

}
/// @nodoc
class _$HistoryCyclesResponseCopyWithImpl<$Res>
    implements $HistoryCyclesResponseCopyWith<$Res> {
  _$HistoryCyclesResponseCopyWithImpl(this._self, this._then);

  final HistoryCyclesResponse _self;
  final $Res Function(HistoryCyclesResponse) _then;

/// Create a copy of HistoryCyclesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stats = freezed,Object? cycles = null,}) {
  return _then(_self.copyWith(
stats: freezed == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as HistoryStatsResponse?,cycles: null == cycles ? _self.cycles : cycles // ignore: cast_nullable_to_non_nullable
as List<HistoryCycleResponse>,
  ));
}
/// Create a copy of HistoryCyclesResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HistoryStatsResponseCopyWith<$Res>? get stats {
    if (_self.stats == null) {
    return null;
  }

  return $HistoryStatsResponseCopyWith<$Res>(_self.stats!, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [HistoryCyclesResponse].
extension HistoryCyclesResponsePatterns on HistoryCyclesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryCyclesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryCyclesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryCyclesResponse value)  $default,){
final _that = this;
switch (_that) {
case _HistoryCyclesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryCyclesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryCyclesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HistoryStatsResponse? stats,  List<HistoryCycleResponse> cycles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryCyclesResponse() when $default != null:
return $default(_that.stats,_that.cycles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HistoryStatsResponse? stats,  List<HistoryCycleResponse> cycles)  $default,) {final _that = this;
switch (_that) {
case _HistoryCyclesResponse():
return $default(_that.stats,_that.cycles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HistoryStatsResponse? stats,  List<HistoryCycleResponse> cycles)?  $default,) {final _that = this;
switch (_that) {
case _HistoryCyclesResponse() when $default != null:
return $default(_that.stats,_that.cycles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryCyclesResponse implements HistoryCyclesResponse {
  const _HistoryCyclesResponse({this.stats, required final  List<HistoryCycleResponse> cycles}): _cycles = cycles;
  factory _HistoryCyclesResponse.fromJson(Map<String, dynamic> json) => _$HistoryCyclesResponseFromJson(json);

// 지난 따라찍기 통계. (더보기 화면 전용, 모임 페이지 프리뷰는 사용 안 함)
// 서버 미제공 시 null.
@override final  HistoryStatsResponse? stats;
 final  List<HistoryCycleResponse> _cycles;
@override List<HistoryCycleResponse> get cycles {
  if (_cycles is EqualUnmodifiableListView) return _cycles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cycles);
}


/// Create a copy of HistoryCyclesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryCyclesResponseCopyWith<_HistoryCyclesResponse> get copyWith => __$HistoryCyclesResponseCopyWithImpl<_HistoryCyclesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryCyclesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryCyclesResponse&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other._cycles, _cycles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stats,const DeepCollectionEquality().hash(_cycles));

@override
String toString() {
  return 'HistoryCyclesResponse(stats: $stats, cycles: $cycles)';
}


}

/// @nodoc
abstract mixin class _$HistoryCyclesResponseCopyWith<$Res> implements $HistoryCyclesResponseCopyWith<$Res> {
  factory _$HistoryCyclesResponseCopyWith(_HistoryCyclesResponse value, $Res Function(_HistoryCyclesResponse) _then) = __$HistoryCyclesResponseCopyWithImpl;
@override @useResult
$Res call({
 HistoryStatsResponse? stats, List<HistoryCycleResponse> cycles
});


@override $HistoryStatsResponseCopyWith<$Res>? get stats;

}
/// @nodoc
class __$HistoryCyclesResponseCopyWithImpl<$Res>
    implements _$HistoryCyclesResponseCopyWith<$Res> {
  __$HistoryCyclesResponseCopyWithImpl(this._self, this._then);

  final _HistoryCyclesResponse _self;
  final $Res Function(_HistoryCyclesResponse) _then;

/// Create a copy of HistoryCyclesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stats = freezed,Object? cycles = null,}) {
  return _then(_HistoryCyclesResponse(
stats: freezed == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as HistoryStatsResponse?,cycles: null == cycles ? _self._cycles : cycles // ignore: cast_nullable_to_non_nullable
as List<HistoryCycleResponse>,
  ));
}

/// Create a copy of HistoryCyclesResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HistoryStatsResponseCopyWith<$Res>? get stats {
    if (_self.stats == null) {
    return null;
  }

  return $HistoryStatsResponseCopyWith<$Res>(_self.stats!, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// @nodoc
mixin _$HistoryStatsResponse {

// 내가 참여한 따라찍기 수.
 int get myCount;// 모임의 전체 따라찍기 수.
 int get totalCount;
/// Create a copy of HistoryStatsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryStatsResponseCopyWith<HistoryStatsResponse> get copyWith => _$HistoryStatsResponseCopyWithImpl<HistoryStatsResponse>(this as HistoryStatsResponse, _$identity);

  /// Serializes this HistoryStatsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryStatsResponse&&(identical(other.myCount, myCount) || other.myCount == myCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,myCount,totalCount);

@override
String toString() {
  return 'HistoryStatsResponse(myCount: $myCount, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class $HistoryStatsResponseCopyWith<$Res>  {
  factory $HistoryStatsResponseCopyWith(HistoryStatsResponse value, $Res Function(HistoryStatsResponse) _then) = _$HistoryStatsResponseCopyWithImpl;
@useResult
$Res call({
 int myCount, int totalCount
});




}
/// @nodoc
class _$HistoryStatsResponseCopyWithImpl<$Res>
    implements $HistoryStatsResponseCopyWith<$Res> {
  _$HistoryStatsResponseCopyWithImpl(this._self, this._then);

  final HistoryStatsResponse _self;
  final $Res Function(HistoryStatsResponse) _then;

/// Create a copy of HistoryStatsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? myCount = null,Object? totalCount = null,}) {
  return _then(_self.copyWith(
myCount: null == myCount ? _self.myCount : myCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryStatsResponse].
extension HistoryStatsResponsePatterns on HistoryStatsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryStatsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryStatsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryStatsResponse value)  $default,){
final _that = this;
switch (_that) {
case _HistoryStatsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryStatsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryStatsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int myCount,  int totalCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryStatsResponse() when $default != null:
return $default(_that.myCount,_that.totalCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int myCount,  int totalCount)  $default,) {final _that = this;
switch (_that) {
case _HistoryStatsResponse():
return $default(_that.myCount,_that.totalCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int myCount,  int totalCount)?  $default,) {final _that = this;
switch (_that) {
case _HistoryStatsResponse() when $default != null:
return $default(_that.myCount,_that.totalCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryStatsResponse implements HistoryStatsResponse {
  const _HistoryStatsResponse({required this.myCount, required this.totalCount});
  factory _HistoryStatsResponse.fromJson(Map<String, dynamic> json) => _$HistoryStatsResponseFromJson(json);

// 내가 참여한 따라찍기 수.
@override final  int myCount;
// 모임의 전체 따라찍기 수.
@override final  int totalCount;

/// Create a copy of HistoryStatsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryStatsResponseCopyWith<_HistoryStatsResponse> get copyWith => __$HistoryStatsResponseCopyWithImpl<_HistoryStatsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryStatsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryStatsResponse&&(identical(other.myCount, myCount) || other.myCount == myCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,myCount,totalCount);

@override
String toString() {
  return 'HistoryStatsResponse(myCount: $myCount, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class _$HistoryStatsResponseCopyWith<$Res> implements $HistoryStatsResponseCopyWith<$Res> {
  factory _$HistoryStatsResponseCopyWith(_HistoryStatsResponse value, $Res Function(_HistoryStatsResponse) _then) = __$HistoryStatsResponseCopyWithImpl;
@override @useResult
$Res call({
 int myCount, int totalCount
});




}
/// @nodoc
class __$HistoryStatsResponseCopyWithImpl<$Res>
    implements _$HistoryStatsResponseCopyWith<$Res> {
  __$HistoryStatsResponseCopyWithImpl(this._self, this._then);

  final _HistoryStatsResponse _self;
  final $Res Function(_HistoryStatsResponse) _then;

/// Create a copy of HistoryStatsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? myCount = null,Object? totalCount = null,}) {
  return _then(_HistoryStatsResponse(
myCount: null == myCount ? _self.myCount : myCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HistoryCycleResponse {

 int get cycleId; String get topic;// 대표 썸네일. 없으면 null.
 String? get thumbnailUrl;// 썸네일이 신고 접수로 검토 중인지 여부.
 bool get thumbnailUnderReview;// 썸네일(스타터 샷)을 올린 스타터의 userId.
 int get starterUserId; int get participantCount;// 참가자 목록. (더보기 화면의 참가자 아바타 전용) 서버 미제공 시 빈 목록.
 List<HistoryParticipantResponse> get participants; DateTime get date;
/// Create a copy of HistoryCycleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryCycleResponseCopyWith<HistoryCycleResponse> get copyWith => _$HistoryCycleResponseCopyWithImpl<HistoryCycleResponse>(this as HistoryCycleResponse, _$identity);

  /// Serializes this HistoryCycleResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryCycleResponse&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.thumbnailUnderReview, thumbnailUnderReview) || other.thumbnailUnderReview == thumbnailUnderReview)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,topic,thumbnailUrl,thumbnailUnderReview,starterUserId,participantCount,const DeepCollectionEquality().hash(participants),date);

@override
String toString() {
  return 'HistoryCycleResponse(cycleId: $cycleId, topic: $topic, thumbnailUrl: $thumbnailUrl, thumbnailUnderReview: $thumbnailUnderReview, starterUserId: $starterUserId, participantCount: $participantCount, participants: $participants, date: $date)';
}


}

/// @nodoc
abstract mixin class $HistoryCycleResponseCopyWith<$Res>  {
  factory $HistoryCycleResponseCopyWith(HistoryCycleResponse value, $Res Function(HistoryCycleResponse) _then) = _$HistoryCycleResponseCopyWithImpl;
@useResult
$Res call({
 int cycleId, String topic, String? thumbnailUrl, bool thumbnailUnderReview, int starterUserId, int participantCount, List<HistoryParticipantResponse> participants, DateTime date
});




}
/// @nodoc
class _$HistoryCycleResponseCopyWithImpl<$Res>
    implements $HistoryCycleResponseCopyWith<$Res> {
  _$HistoryCycleResponseCopyWithImpl(this._self, this._then);

  final HistoryCycleResponse _self;
  final $Res Function(HistoryCycleResponse) _then;

/// Create a copy of HistoryCycleResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cycleId = null,Object? topic = null,Object? thumbnailUrl = freezed,Object? thumbnailUnderReview = null,Object? starterUserId = null,Object? participantCount = null,Object? participants = null,Object? date = null,}) {
  return _then(_self.copyWith(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUnderReview: null == thumbnailUnderReview ? _self.thumbnailUnderReview : thumbnailUnderReview // ignore: cast_nullable_to_non_nullable
as bool,starterUserId: null == starterUserId ? _self.starterUserId : starterUserId // ignore: cast_nullable_to_non_nullable
as int,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<HistoryParticipantResponse>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryCycleResponse].
extension HistoryCycleResponsePatterns on HistoryCycleResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryCycleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryCycleResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryCycleResponse value)  $default,){
final _that = this;
switch (_that) {
case _HistoryCycleResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryCycleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryCycleResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int cycleId,  String topic,  String? thumbnailUrl,  bool thumbnailUnderReview,  int starterUserId,  int participantCount,  List<HistoryParticipantResponse> participants,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryCycleResponse() when $default != null:
return $default(_that.cycleId,_that.topic,_that.thumbnailUrl,_that.thumbnailUnderReview,_that.starterUserId,_that.participantCount,_that.participants,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int cycleId,  String topic,  String? thumbnailUrl,  bool thumbnailUnderReview,  int starterUserId,  int participantCount,  List<HistoryParticipantResponse> participants,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _HistoryCycleResponse():
return $default(_that.cycleId,_that.topic,_that.thumbnailUrl,_that.thumbnailUnderReview,_that.starterUserId,_that.participantCount,_that.participants,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int cycleId,  String topic,  String? thumbnailUrl,  bool thumbnailUnderReview,  int starterUserId,  int participantCount,  List<HistoryParticipantResponse> participants,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _HistoryCycleResponse() when $default != null:
return $default(_that.cycleId,_that.topic,_that.thumbnailUrl,_that.thumbnailUnderReview,_that.starterUserId,_that.participantCount,_that.participants,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryCycleResponse implements HistoryCycleResponse {
  const _HistoryCycleResponse({required this.cycleId, required this.topic, required this.thumbnailUrl, required this.thumbnailUnderReview, required this.starterUserId, required this.participantCount, final  List<HistoryParticipantResponse> participants = const <HistoryParticipantResponse>[], required this.date}): _participants = participants;
  factory _HistoryCycleResponse.fromJson(Map<String, dynamic> json) => _$HistoryCycleResponseFromJson(json);

@override final  int cycleId;
@override final  String topic;
// 대표 썸네일. 없으면 null.
@override final  String? thumbnailUrl;
// 썸네일이 신고 접수로 검토 중인지 여부.
@override final  bool thumbnailUnderReview;
// 썸네일(스타터 샷)을 올린 스타터의 userId.
@override final  int starterUserId;
@override final  int participantCount;
// 참가자 목록. (더보기 화면의 참가자 아바타 전용) 서버 미제공 시 빈 목록.
 final  List<HistoryParticipantResponse> _participants;
// 참가자 목록. (더보기 화면의 참가자 아바타 전용) 서버 미제공 시 빈 목록.
@override@JsonKey() List<HistoryParticipantResponse> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

@override final  DateTime date;

/// Create a copy of HistoryCycleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryCycleResponseCopyWith<_HistoryCycleResponse> get copyWith => __$HistoryCycleResponseCopyWithImpl<_HistoryCycleResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryCycleResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryCycleResponse&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.thumbnailUnderReview, thumbnailUnderReview) || other.thumbnailUnderReview == thumbnailUnderReview)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,topic,thumbnailUrl,thumbnailUnderReview,starterUserId,participantCount,const DeepCollectionEquality().hash(_participants),date);

@override
String toString() {
  return 'HistoryCycleResponse(cycleId: $cycleId, topic: $topic, thumbnailUrl: $thumbnailUrl, thumbnailUnderReview: $thumbnailUnderReview, starterUserId: $starterUserId, participantCount: $participantCount, participants: $participants, date: $date)';
}


}

/// @nodoc
abstract mixin class _$HistoryCycleResponseCopyWith<$Res> implements $HistoryCycleResponseCopyWith<$Res> {
  factory _$HistoryCycleResponseCopyWith(_HistoryCycleResponse value, $Res Function(_HistoryCycleResponse) _then) = __$HistoryCycleResponseCopyWithImpl;
@override @useResult
$Res call({
 int cycleId, String topic, String? thumbnailUrl, bool thumbnailUnderReview, int starterUserId, int participantCount, List<HistoryParticipantResponse> participants, DateTime date
});




}
/// @nodoc
class __$HistoryCycleResponseCopyWithImpl<$Res>
    implements _$HistoryCycleResponseCopyWith<$Res> {
  __$HistoryCycleResponseCopyWithImpl(this._self, this._then);

  final _HistoryCycleResponse _self;
  final $Res Function(_HistoryCycleResponse) _then;

/// Create a copy of HistoryCycleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,Object? topic = null,Object? thumbnailUrl = freezed,Object? thumbnailUnderReview = null,Object? starterUserId = null,Object? participantCount = null,Object? participants = null,Object? date = null,}) {
  return _then(_HistoryCycleResponse(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUnderReview: null == thumbnailUnderReview ? _self.thumbnailUnderReview : thumbnailUnderReview // ignore: cast_nullable_to_non_nullable
as bool,starterUserId: null == starterUserId ? _self.starterUserId : starterUserId // ignore: cast_nullable_to_non_nullable
as int,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<HistoryParticipantResponse>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$HistoryParticipantResponse {

 int get userId;// 참가자 프로필 이미지 URL. 없으면 null.
 String? get profileImageUrl;
/// Create a copy of HistoryParticipantResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryParticipantResponseCopyWith<HistoryParticipantResponse> get copyWith => _$HistoryParticipantResponseCopyWithImpl<HistoryParticipantResponse>(this as HistoryParticipantResponse, _$identity);

  /// Serializes this HistoryParticipantResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryParticipantResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,profileImageUrl);

@override
String toString() {
  return 'HistoryParticipantResponse(userId: $userId, profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class $HistoryParticipantResponseCopyWith<$Res>  {
  factory $HistoryParticipantResponseCopyWith(HistoryParticipantResponse value, $Res Function(HistoryParticipantResponse) _then) = _$HistoryParticipantResponseCopyWithImpl;
@useResult
$Res call({
 int userId, String? profileImageUrl
});




}
/// @nodoc
class _$HistoryParticipantResponseCopyWithImpl<$Res>
    implements $HistoryParticipantResponseCopyWith<$Res> {
  _$HistoryParticipantResponseCopyWithImpl(this._self, this._then);

  final HistoryParticipantResponse _self;
  final $Res Function(HistoryParticipantResponse) _then;

/// Create a copy of HistoryParticipantResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? profileImageUrl = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryParticipantResponse].
extension HistoryParticipantResponsePatterns on HistoryParticipantResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryParticipantResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryParticipantResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryParticipantResponse value)  $default,){
final _that = this;
switch (_that) {
case _HistoryParticipantResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryParticipantResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryParticipantResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  String? profileImageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryParticipantResponse() when $default != null:
return $default(_that.userId,_that.profileImageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  String? profileImageUrl)  $default,) {final _that = this;
switch (_that) {
case _HistoryParticipantResponse():
return $default(_that.userId,_that.profileImageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  String? profileImageUrl)?  $default,) {final _that = this;
switch (_that) {
case _HistoryParticipantResponse() when $default != null:
return $default(_that.userId,_that.profileImageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryParticipantResponse implements HistoryParticipantResponse {
  const _HistoryParticipantResponse({required this.userId, required this.profileImageUrl});
  factory _HistoryParticipantResponse.fromJson(Map<String, dynamic> json) => _$HistoryParticipantResponseFromJson(json);

@override final  int userId;
// 참가자 프로필 이미지 URL. 없으면 null.
@override final  String? profileImageUrl;

/// Create a copy of HistoryParticipantResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryParticipantResponseCopyWith<_HistoryParticipantResponse> get copyWith => __$HistoryParticipantResponseCopyWithImpl<_HistoryParticipantResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryParticipantResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryParticipantResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,profileImageUrl);

@override
String toString() {
  return 'HistoryParticipantResponse(userId: $userId, profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class _$HistoryParticipantResponseCopyWith<$Res> implements $HistoryParticipantResponseCopyWith<$Res> {
  factory _$HistoryParticipantResponseCopyWith(_HistoryParticipantResponse value, $Res Function(_HistoryParticipantResponse) _then) = __$HistoryParticipantResponseCopyWithImpl;
@override @useResult
$Res call({
 int userId, String? profileImageUrl
});




}
/// @nodoc
class __$HistoryParticipantResponseCopyWithImpl<$Res>
    implements _$HistoryParticipantResponseCopyWith<$Res> {
  __$HistoryParticipantResponseCopyWithImpl(this._self, this._then);

  final _HistoryParticipantResponse _self;
  final $Res Function(_HistoryParticipantResponse) _then;

/// Create a copy of HistoryParticipantResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? profileImageUrl = freezed,}) {
  return _then(_HistoryParticipantResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
