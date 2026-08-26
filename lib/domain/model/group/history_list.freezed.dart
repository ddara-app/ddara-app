// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryList {

 HistoryStats get stats; List<HistoryListCycle> get cycles;
/// Create a copy of HistoryList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryListCopyWith<HistoryList> get copyWith => _$HistoryListCopyWithImpl<HistoryList>(this as HistoryList, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryList&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other.cycles, cycles));
}


@override
int get hashCode => Object.hash(runtimeType,stats,const DeepCollectionEquality().hash(cycles));

@override
String toString() {
  return 'HistoryList(stats: $stats, cycles: $cycles)';
}


}

/// @nodoc
abstract mixin class $HistoryListCopyWith<$Res>  {
  factory $HistoryListCopyWith(HistoryList value, $Res Function(HistoryList) _then) = _$HistoryListCopyWithImpl;
@useResult
$Res call({
 HistoryStats stats, List<HistoryListCycle> cycles
});


$HistoryStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$HistoryListCopyWithImpl<$Res>
    implements $HistoryListCopyWith<$Res> {
  _$HistoryListCopyWithImpl(this._self, this._then);

  final HistoryList _self;
  final $Res Function(HistoryList) _then;

/// Create a copy of HistoryList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stats = null,Object? cycles = null,}) {
  return _then(_self.copyWith(
stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as HistoryStats,cycles: null == cycles ? _self.cycles : cycles // ignore: cast_nullable_to_non_nullable
as List<HistoryListCycle>,
  ));
}
/// Create a copy of HistoryList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HistoryStatsCopyWith<$Res> get stats {
  
  return $HistoryStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [HistoryList].
extension HistoryListPatterns on HistoryList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryList value)  $default,){
final _that = this;
switch (_that) {
case _HistoryList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryList value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HistoryStats stats,  List<HistoryListCycle> cycles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HistoryStats stats,  List<HistoryListCycle> cycles)  $default,) {final _that = this;
switch (_that) {
case _HistoryList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HistoryStats stats,  List<HistoryListCycle> cycles)?  $default,) {final _that = this;
switch (_that) {
case _HistoryList() when $default != null:
return $default(_that.stats,_that.cycles);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryList implements HistoryList {
  const _HistoryList({required this.stats, required final  List<HistoryListCycle> cycles}): _cycles = cycles;
  

@override final  HistoryStats stats;
 final  List<HistoryListCycle> _cycles;
@override List<HistoryListCycle> get cycles {
  if (_cycles is EqualUnmodifiableListView) return _cycles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cycles);
}


/// Create a copy of HistoryList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryListCopyWith<_HistoryList> get copyWith => __$HistoryListCopyWithImpl<_HistoryList>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryList&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other._cycles, _cycles));
}


@override
int get hashCode => Object.hash(runtimeType,stats,const DeepCollectionEquality().hash(_cycles));

@override
String toString() {
  return 'HistoryList(stats: $stats, cycles: $cycles)';
}


}

/// @nodoc
abstract mixin class _$HistoryListCopyWith<$Res> implements $HistoryListCopyWith<$Res> {
  factory _$HistoryListCopyWith(_HistoryList value, $Res Function(_HistoryList) _then) = __$HistoryListCopyWithImpl;
@override @useResult
$Res call({
 HistoryStats stats, List<HistoryListCycle> cycles
});


@override $HistoryStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$HistoryListCopyWithImpl<$Res>
    implements _$HistoryListCopyWith<$Res> {
  __$HistoryListCopyWithImpl(this._self, this._then);

  final _HistoryList _self;
  final $Res Function(_HistoryList) _then;

/// Create a copy of HistoryList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stats = null,Object? cycles = null,}) {
  return _then(_HistoryList(
stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as HistoryStats,cycles: null == cycles ? _self._cycles : cycles // ignore: cast_nullable_to_non_nullable
as List<HistoryListCycle>,
  ));
}

/// Create a copy of HistoryList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HistoryStatsCopyWith<$Res> get stats {
  
  return $HistoryStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

/// @nodoc
mixin _$HistoryStats {

// 내가 참여한 따라찍기 수.
 int get myCount;// 모임의 전체 따라찍기 수.
 int get totalCount;
/// Create a copy of HistoryStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryStatsCopyWith<HistoryStats> get copyWith => _$HistoryStatsCopyWithImpl<HistoryStats>(this as HistoryStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryStats&&(identical(other.myCount, myCount) || other.myCount == myCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}


@override
int get hashCode => Object.hash(runtimeType,myCount,totalCount);

@override
String toString() {
  return 'HistoryStats(myCount: $myCount, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class $HistoryStatsCopyWith<$Res>  {
  factory $HistoryStatsCopyWith(HistoryStats value, $Res Function(HistoryStats) _then) = _$HistoryStatsCopyWithImpl;
@useResult
$Res call({
 int myCount, int totalCount
});




}
/// @nodoc
class _$HistoryStatsCopyWithImpl<$Res>
    implements $HistoryStatsCopyWith<$Res> {
  _$HistoryStatsCopyWithImpl(this._self, this._then);

  final HistoryStats _self;
  final $Res Function(HistoryStats) _then;

/// Create a copy of HistoryStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? myCount = null,Object? totalCount = null,}) {
  return _then(_self.copyWith(
myCount: null == myCount ? _self.myCount : myCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryStats].
extension HistoryStatsPatterns on HistoryStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryStats value)  $default,){
final _that = this;
switch (_that) {
case _HistoryStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryStats value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryStats() when $default != null:
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
case _HistoryStats() when $default != null:
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
case _HistoryStats():
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
case _HistoryStats() when $default != null:
return $default(_that.myCount,_that.totalCount);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryStats implements HistoryStats {
  const _HistoryStats({required this.myCount, required this.totalCount});
  

// 내가 참여한 따라찍기 수.
@override final  int myCount;
// 모임의 전체 따라찍기 수.
@override final  int totalCount;

/// Create a copy of HistoryStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryStatsCopyWith<_HistoryStats> get copyWith => __$HistoryStatsCopyWithImpl<_HistoryStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryStats&&(identical(other.myCount, myCount) || other.myCount == myCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}


@override
int get hashCode => Object.hash(runtimeType,myCount,totalCount);

@override
String toString() {
  return 'HistoryStats(myCount: $myCount, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class _$HistoryStatsCopyWith<$Res> implements $HistoryStatsCopyWith<$Res> {
  factory _$HistoryStatsCopyWith(_HistoryStats value, $Res Function(_HistoryStats) _then) = __$HistoryStatsCopyWithImpl;
@override @useResult
$Res call({
 int myCount, int totalCount
});




}
/// @nodoc
class __$HistoryStatsCopyWithImpl<$Res>
    implements _$HistoryStatsCopyWith<$Res> {
  __$HistoryStatsCopyWithImpl(this._self, this._then);

  final _HistoryStats _self;
  final $Res Function(_HistoryStats) _then;

/// Create a copy of HistoryStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? myCount = null,Object? totalCount = null,}) {
  return _then(_HistoryStats(
myCount: null == myCount ? _self.myCount : myCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$HistoryListCycle {

 int get cycleId; String get topic;// 대표 썸네일. 없으면 null.
 String? get thumbnailUrl;// 썸네일이 신고 접수로 검토 중인지 여부.
 bool get thumbnailUnderReview;// 썸네일(스타터 샷)을 올린 스타터의 userId.
 int get starterUserId; int get participantCount;// 참가자 목록. (참가자 아바타 표시에 사용)
 List<HistoryParticipant> get participants; DateTime get date;
/// Create a copy of HistoryListCycle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryListCycleCopyWith<HistoryListCycle> get copyWith => _$HistoryListCycleCopyWithImpl<HistoryListCycle>(this as HistoryListCycle, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryListCycle&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.thumbnailUnderReview, thumbnailUnderReview) || other.thumbnailUnderReview == thumbnailUnderReview)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,cycleId,topic,thumbnailUrl,thumbnailUnderReview,starterUserId,participantCount,const DeepCollectionEquality().hash(participants),date);

@override
String toString() {
  return 'HistoryListCycle(cycleId: $cycleId, topic: $topic, thumbnailUrl: $thumbnailUrl, thumbnailUnderReview: $thumbnailUnderReview, starterUserId: $starterUserId, participantCount: $participantCount, participants: $participants, date: $date)';
}


}

/// @nodoc
abstract mixin class $HistoryListCycleCopyWith<$Res>  {
  factory $HistoryListCycleCopyWith(HistoryListCycle value, $Res Function(HistoryListCycle) _then) = _$HistoryListCycleCopyWithImpl;
@useResult
$Res call({
 int cycleId, String topic, String? thumbnailUrl, bool thumbnailUnderReview, int starterUserId, int participantCount, List<HistoryParticipant> participants, DateTime date
});




}
/// @nodoc
class _$HistoryListCycleCopyWithImpl<$Res>
    implements $HistoryListCycleCopyWith<$Res> {
  _$HistoryListCycleCopyWithImpl(this._self, this._then);

  final HistoryListCycle _self;
  final $Res Function(HistoryListCycle) _then;

/// Create a copy of HistoryListCycle
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
as List<HistoryParticipant>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryListCycle].
extension HistoryListCyclePatterns on HistoryListCycle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryListCycle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryListCycle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryListCycle value)  $default,){
final _that = this;
switch (_that) {
case _HistoryListCycle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryListCycle value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryListCycle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int cycleId,  String topic,  String? thumbnailUrl,  bool thumbnailUnderReview,  int starterUserId,  int participantCount,  List<HistoryParticipant> participants,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryListCycle() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int cycleId,  String topic,  String? thumbnailUrl,  bool thumbnailUnderReview,  int starterUserId,  int participantCount,  List<HistoryParticipant> participants,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _HistoryListCycle():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int cycleId,  String topic,  String? thumbnailUrl,  bool thumbnailUnderReview,  int starterUserId,  int participantCount,  List<HistoryParticipant> participants,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _HistoryListCycle() when $default != null:
return $default(_that.cycleId,_that.topic,_that.thumbnailUrl,_that.thumbnailUnderReview,_that.starterUserId,_that.participantCount,_that.participants,_that.date);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryListCycle implements HistoryListCycle {
  const _HistoryListCycle({required this.cycleId, required this.topic, required this.thumbnailUrl, required this.thumbnailUnderReview, required this.starterUserId, required this.participantCount, required final  List<HistoryParticipant> participants, required this.date}): _participants = participants;
  

@override final  int cycleId;
@override final  String topic;
// 대표 썸네일. 없으면 null.
@override final  String? thumbnailUrl;
// 썸네일이 신고 접수로 검토 중인지 여부.
@override final  bool thumbnailUnderReview;
// 썸네일(스타터 샷)을 올린 스타터의 userId.
@override final  int starterUserId;
@override final  int participantCount;
// 참가자 목록. (참가자 아바타 표시에 사용)
 final  List<HistoryParticipant> _participants;
// 참가자 목록. (참가자 아바타 표시에 사용)
@override List<HistoryParticipant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

@override final  DateTime date;

/// Create a copy of HistoryListCycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryListCycleCopyWith<_HistoryListCycle> get copyWith => __$HistoryListCycleCopyWithImpl<_HistoryListCycle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryListCycle&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.thumbnailUnderReview, thumbnailUnderReview) || other.thumbnailUnderReview == thumbnailUnderReview)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,cycleId,topic,thumbnailUrl,thumbnailUnderReview,starterUserId,participantCount,const DeepCollectionEquality().hash(_participants),date);

@override
String toString() {
  return 'HistoryListCycle(cycleId: $cycleId, topic: $topic, thumbnailUrl: $thumbnailUrl, thumbnailUnderReview: $thumbnailUnderReview, starterUserId: $starterUserId, participantCount: $participantCount, participants: $participants, date: $date)';
}


}

/// @nodoc
abstract mixin class _$HistoryListCycleCopyWith<$Res> implements $HistoryListCycleCopyWith<$Res> {
  factory _$HistoryListCycleCopyWith(_HistoryListCycle value, $Res Function(_HistoryListCycle) _then) = __$HistoryListCycleCopyWithImpl;
@override @useResult
$Res call({
 int cycleId, String topic, String? thumbnailUrl, bool thumbnailUnderReview, int starterUserId, int participantCount, List<HistoryParticipant> participants, DateTime date
});




}
/// @nodoc
class __$HistoryListCycleCopyWithImpl<$Res>
    implements _$HistoryListCycleCopyWith<$Res> {
  __$HistoryListCycleCopyWithImpl(this._self, this._then);

  final _HistoryListCycle _self;
  final $Res Function(_HistoryListCycle) _then;

/// Create a copy of HistoryListCycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,Object? topic = null,Object? thumbnailUrl = freezed,Object? thumbnailUnderReview = null,Object? starterUserId = null,Object? participantCount = null,Object? participants = null,Object? date = null,}) {
  return _then(_HistoryListCycle(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUnderReview: null == thumbnailUnderReview ? _self.thumbnailUnderReview : thumbnailUnderReview // ignore: cast_nullable_to_non_nullable
as bool,starterUserId: null == starterUserId ? _self.starterUserId : starterUserId // ignore: cast_nullable_to_non_nullable
as int,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<HistoryParticipant>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$HistoryParticipant {

 int get userId;// 참가자 프로필 이미지 URL. 없으면 null.
 String? get profileImageUrl;
/// Create a copy of HistoryParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryParticipantCopyWith<HistoryParticipant> get copyWith => _$HistoryParticipantCopyWithImpl<HistoryParticipant>(this as HistoryParticipant, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryParticipant&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,userId,profileImageUrl);

@override
String toString() {
  return 'HistoryParticipant(userId: $userId, profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class $HistoryParticipantCopyWith<$Res>  {
  factory $HistoryParticipantCopyWith(HistoryParticipant value, $Res Function(HistoryParticipant) _then) = _$HistoryParticipantCopyWithImpl;
@useResult
$Res call({
 int userId, String? profileImageUrl
});




}
/// @nodoc
class _$HistoryParticipantCopyWithImpl<$Res>
    implements $HistoryParticipantCopyWith<$Res> {
  _$HistoryParticipantCopyWithImpl(this._self, this._then);

  final HistoryParticipant _self;
  final $Res Function(HistoryParticipant) _then;

/// Create a copy of HistoryParticipant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? profileImageUrl = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryParticipant].
extension HistoryParticipantPatterns on HistoryParticipant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryParticipant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryParticipant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryParticipant value)  $default,){
final _that = this;
switch (_that) {
case _HistoryParticipant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryParticipant value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryParticipant() when $default != null:
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
case _HistoryParticipant() when $default != null:
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
case _HistoryParticipant():
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
case _HistoryParticipant() when $default != null:
return $default(_that.userId,_that.profileImageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryParticipant implements HistoryParticipant {
  const _HistoryParticipant({required this.userId, required this.profileImageUrl});
  

@override final  int userId;
// 참가자 프로필 이미지 URL. 없으면 null.
@override final  String? profileImageUrl;

/// Create a copy of HistoryParticipant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryParticipantCopyWith<_HistoryParticipant> get copyWith => __$HistoryParticipantCopyWithImpl<_HistoryParticipant>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryParticipant&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,userId,profileImageUrl);

@override
String toString() {
  return 'HistoryParticipant(userId: $userId, profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class _$HistoryParticipantCopyWith<$Res> implements $HistoryParticipantCopyWith<$Res> {
  factory _$HistoryParticipantCopyWith(_HistoryParticipant value, $Res Function(_HistoryParticipant) _then) = __$HistoryParticipantCopyWithImpl;
@override @useResult
$Res call({
 int userId, String? profileImageUrl
});




}
/// @nodoc
class __$HistoryParticipantCopyWithImpl<$Res>
    implements _$HistoryParticipantCopyWith<$Res> {
  __$HistoryParticipantCopyWithImpl(this._self, this._then);

  final _HistoryParticipant _self;
  final $Res Function(_HistoryParticipant) _then;

/// Create a copy of HistoryParticipant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? profileImageUrl = freezed,}) {
  return _then(_HistoryParticipant(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
