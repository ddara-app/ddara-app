// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_cycles.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryCycles {

 List<HistoryCycle> get cycles;
/// Create a copy of HistoryCycles
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryCyclesCopyWith<HistoryCycles> get copyWith => _$HistoryCyclesCopyWithImpl<HistoryCycles>(this as HistoryCycles, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryCycles&&const DeepCollectionEquality().equals(other.cycles, cycles));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cycles));

@override
String toString() {
  return 'HistoryCycles(cycles: $cycles)';
}


}

/// @nodoc
abstract mixin class $HistoryCyclesCopyWith<$Res>  {
  factory $HistoryCyclesCopyWith(HistoryCycles value, $Res Function(HistoryCycles) _then) = _$HistoryCyclesCopyWithImpl;
@useResult
$Res call({
 List<HistoryCycle> cycles
});




}
/// @nodoc
class _$HistoryCyclesCopyWithImpl<$Res>
    implements $HistoryCyclesCopyWith<$Res> {
  _$HistoryCyclesCopyWithImpl(this._self, this._then);

  final HistoryCycles _self;
  final $Res Function(HistoryCycles) _then;

/// Create a copy of HistoryCycles
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cycles = null,}) {
  return _then(_self.copyWith(
cycles: null == cycles ? _self.cycles : cycles // ignore: cast_nullable_to_non_nullable
as List<HistoryCycle>,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryCycles].
extension HistoryCyclesPatterns on HistoryCycles {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryCycles value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryCycles() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryCycles value)  $default,){
final _that = this;
switch (_that) {
case _HistoryCycles():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryCycles value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryCycles() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HistoryCycle> cycles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryCycles() when $default != null:
return $default(_that.cycles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HistoryCycle> cycles)  $default,) {final _that = this;
switch (_that) {
case _HistoryCycles():
return $default(_that.cycles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HistoryCycle> cycles)?  $default,) {final _that = this;
switch (_that) {
case _HistoryCycles() when $default != null:
return $default(_that.cycles);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryCycles implements HistoryCycles {
  const _HistoryCycles({required final  List<HistoryCycle> cycles}): _cycles = cycles;
  

 final  List<HistoryCycle> _cycles;
@override List<HistoryCycle> get cycles {
  if (_cycles is EqualUnmodifiableListView) return _cycles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cycles);
}


/// Create a copy of HistoryCycles
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryCyclesCopyWith<_HistoryCycles> get copyWith => __$HistoryCyclesCopyWithImpl<_HistoryCycles>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryCycles&&const DeepCollectionEquality().equals(other._cycles, _cycles));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cycles));

@override
String toString() {
  return 'HistoryCycles(cycles: $cycles)';
}


}

/// @nodoc
abstract mixin class _$HistoryCyclesCopyWith<$Res> implements $HistoryCyclesCopyWith<$Res> {
  factory _$HistoryCyclesCopyWith(_HistoryCycles value, $Res Function(_HistoryCycles) _then) = __$HistoryCyclesCopyWithImpl;
@override @useResult
$Res call({
 List<HistoryCycle> cycles
});




}
/// @nodoc
class __$HistoryCyclesCopyWithImpl<$Res>
    implements _$HistoryCyclesCopyWith<$Res> {
  __$HistoryCyclesCopyWithImpl(this._self, this._then);

  final _HistoryCycles _self;
  final $Res Function(_HistoryCycles) _then;

/// Create a copy of HistoryCycles
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycles = null,}) {
  return _then(_HistoryCycles(
cycles: null == cycles ? _self._cycles : cycles // ignore: cast_nullable_to_non_nullable
as List<HistoryCycle>,
  ));
}


}

/// @nodoc
mixin _$HistoryCycle {

 int get cycleId; String get topic;// 대표 썸네일. 없으면 null.
 String? get thumbnailUrl; int get participantCount; DateTime get date;
/// Create a copy of HistoryCycle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryCycleCopyWith<HistoryCycle> get copyWith => _$HistoryCycleCopyWithImpl<HistoryCycle>(this as HistoryCycle, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryCycle&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,cycleId,topic,thumbnailUrl,participantCount,date);

@override
String toString() {
  return 'HistoryCycle(cycleId: $cycleId, topic: $topic, thumbnailUrl: $thumbnailUrl, participantCount: $participantCount, date: $date)';
}


}

/// @nodoc
abstract mixin class $HistoryCycleCopyWith<$Res>  {
  factory $HistoryCycleCopyWith(HistoryCycle value, $Res Function(HistoryCycle) _then) = _$HistoryCycleCopyWithImpl;
@useResult
$Res call({
 int cycleId, String topic, String? thumbnailUrl, int participantCount, DateTime date
});




}
/// @nodoc
class _$HistoryCycleCopyWithImpl<$Res>
    implements $HistoryCycleCopyWith<$Res> {
  _$HistoryCycleCopyWithImpl(this._self, this._then);

  final HistoryCycle _self;
  final $Res Function(HistoryCycle) _then;

/// Create a copy of HistoryCycle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cycleId = null,Object? topic = null,Object? thumbnailUrl = freezed,Object? participantCount = null,Object? date = null,}) {
  return _then(_self.copyWith(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryCycle].
extension HistoryCyclePatterns on HistoryCycle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryCycle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryCycle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryCycle value)  $default,){
final _that = this;
switch (_that) {
case _HistoryCycle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryCycle value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryCycle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int cycleId,  String topic,  String? thumbnailUrl,  int participantCount,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryCycle() when $default != null:
return $default(_that.cycleId,_that.topic,_that.thumbnailUrl,_that.participantCount,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int cycleId,  String topic,  String? thumbnailUrl,  int participantCount,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _HistoryCycle():
return $default(_that.cycleId,_that.topic,_that.thumbnailUrl,_that.participantCount,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int cycleId,  String topic,  String? thumbnailUrl,  int participantCount,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _HistoryCycle() when $default != null:
return $default(_that.cycleId,_that.topic,_that.thumbnailUrl,_that.participantCount,_that.date);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryCycle implements HistoryCycle {
  const _HistoryCycle({required this.cycleId, required this.topic, required this.thumbnailUrl, required this.participantCount, required this.date});
  

@override final  int cycleId;
@override final  String topic;
// 대표 썸네일. 없으면 null.
@override final  String? thumbnailUrl;
@override final  int participantCount;
@override final  DateTime date;

/// Create a copy of HistoryCycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryCycleCopyWith<_HistoryCycle> get copyWith => __$HistoryCycleCopyWithImpl<_HistoryCycle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryCycle&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,cycleId,topic,thumbnailUrl,participantCount,date);

@override
String toString() {
  return 'HistoryCycle(cycleId: $cycleId, topic: $topic, thumbnailUrl: $thumbnailUrl, participantCount: $participantCount, date: $date)';
}


}

/// @nodoc
abstract mixin class _$HistoryCycleCopyWith<$Res> implements $HistoryCycleCopyWith<$Res> {
  factory _$HistoryCycleCopyWith(_HistoryCycle value, $Res Function(_HistoryCycle) _then) = __$HistoryCycleCopyWithImpl;
@override @useResult
$Res call({
 int cycleId, String topic, String? thumbnailUrl, int participantCount, DateTime date
});




}
/// @nodoc
class __$HistoryCycleCopyWithImpl<$Res>
    implements _$HistoryCycleCopyWith<$Res> {
  __$HistoryCycleCopyWithImpl(this._self, this._then);

  final _HistoryCycle _self;
  final $Res Function(_HistoryCycle) _then;

/// Create a copy of HistoryCycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,Object? topic = null,Object? thumbnailUrl = freezed,Object? participantCount = null,Object? date = null,}) {
  return _then(_HistoryCycle(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
