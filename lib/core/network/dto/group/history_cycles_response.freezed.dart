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

 List<HistoryCycleResponse> get cycles;
/// Create a copy of HistoryCyclesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryCyclesResponseCopyWith<HistoryCyclesResponse> get copyWith => _$HistoryCyclesResponseCopyWithImpl<HistoryCyclesResponse>(this as HistoryCyclesResponse, _$identity);

  /// Serializes this HistoryCyclesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryCyclesResponse&&const DeepCollectionEquality().equals(other.cycles, cycles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cycles));

@override
String toString() {
  return 'HistoryCyclesResponse(cycles: $cycles)';
}


}

/// @nodoc
abstract mixin class $HistoryCyclesResponseCopyWith<$Res>  {
  factory $HistoryCyclesResponseCopyWith(HistoryCyclesResponse value, $Res Function(HistoryCyclesResponse) _then) = _$HistoryCyclesResponseCopyWithImpl;
@useResult
$Res call({
 List<HistoryCycleResponse> cycles
});




}
/// @nodoc
class _$HistoryCyclesResponseCopyWithImpl<$Res>
    implements $HistoryCyclesResponseCopyWith<$Res> {
  _$HistoryCyclesResponseCopyWithImpl(this._self, this._then);

  final HistoryCyclesResponse _self;
  final $Res Function(HistoryCyclesResponse) _then;

/// Create a copy of HistoryCyclesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cycles = null,}) {
  return _then(_self.copyWith(
cycles: null == cycles ? _self.cycles : cycles // ignore: cast_nullable_to_non_nullable
as List<HistoryCycleResponse>,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HistoryCycleResponse> cycles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryCyclesResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HistoryCycleResponse> cycles)  $default,) {final _that = this;
switch (_that) {
case _HistoryCyclesResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HistoryCycleResponse> cycles)?  $default,) {final _that = this;
switch (_that) {
case _HistoryCyclesResponse() when $default != null:
return $default(_that.cycles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryCyclesResponse implements HistoryCyclesResponse {
  const _HistoryCyclesResponse({required final  List<HistoryCycleResponse> cycles}): _cycles = cycles;
  factory _HistoryCyclesResponse.fromJson(Map<String, dynamic> json) => _$HistoryCyclesResponseFromJson(json);

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryCyclesResponse&&const DeepCollectionEquality().equals(other._cycles, _cycles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cycles));

@override
String toString() {
  return 'HistoryCyclesResponse(cycles: $cycles)';
}


}

/// @nodoc
abstract mixin class _$HistoryCyclesResponseCopyWith<$Res> implements $HistoryCyclesResponseCopyWith<$Res> {
  factory _$HistoryCyclesResponseCopyWith(_HistoryCyclesResponse value, $Res Function(_HistoryCyclesResponse) _then) = __$HistoryCyclesResponseCopyWithImpl;
@override @useResult
$Res call({
 List<HistoryCycleResponse> cycles
});




}
/// @nodoc
class __$HistoryCyclesResponseCopyWithImpl<$Res>
    implements _$HistoryCyclesResponseCopyWith<$Res> {
  __$HistoryCyclesResponseCopyWithImpl(this._self, this._then);

  final _HistoryCyclesResponse _self;
  final $Res Function(_HistoryCyclesResponse) _then;

/// Create a copy of HistoryCyclesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycles = null,}) {
  return _then(_HistoryCyclesResponse(
cycles: null == cycles ? _self._cycles : cycles // ignore: cast_nullable_to_non_nullable
as List<HistoryCycleResponse>,
  ));
}


}


/// @nodoc
mixin _$HistoryCycleResponse {

 int get cycleId; String get topic;// 대표 썸네일. 없으면 null.
 String? get thumbnailUrl; int get participantCount; DateTime get date;
/// Create a copy of HistoryCycleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryCycleResponseCopyWith<HistoryCycleResponse> get copyWith => _$HistoryCycleResponseCopyWithImpl<HistoryCycleResponse>(this as HistoryCycleResponse, _$identity);

  /// Serializes this HistoryCycleResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryCycleResponse&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,topic,thumbnailUrl,participantCount,date);

@override
String toString() {
  return 'HistoryCycleResponse(cycleId: $cycleId, topic: $topic, thumbnailUrl: $thumbnailUrl, participantCount: $participantCount, date: $date)';
}


}

/// @nodoc
abstract mixin class $HistoryCycleResponseCopyWith<$Res>  {
  factory $HistoryCycleResponseCopyWith(HistoryCycleResponse value, $Res Function(HistoryCycleResponse) _then) = _$HistoryCycleResponseCopyWithImpl;
@useResult
$Res call({
 int cycleId, String topic, String? thumbnailUrl, int participantCount, DateTime date
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int cycleId,  String topic,  String? thumbnailUrl,  int participantCount,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryCycleResponse() when $default != null:
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
case _HistoryCycleResponse():
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
case _HistoryCycleResponse() when $default != null:
return $default(_that.cycleId,_that.topic,_that.thumbnailUrl,_that.participantCount,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryCycleResponse implements HistoryCycleResponse {
  const _HistoryCycleResponse({required this.cycleId, required this.topic, required this.thumbnailUrl, required this.participantCount, required this.date});
  factory _HistoryCycleResponse.fromJson(Map<String, dynamic> json) => _$HistoryCycleResponseFromJson(json);

@override final  int cycleId;
@override final  String topic;
// 대표 썸네일. 없으면 null.
@override final  String? thumbnailUrl;
@override final  int participantCount;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryCycleResponse&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,topic,thumbnailUrl,participantCount,date);

@override
String toString() {
  return 'HistoryCycleResponse(cycleId: $cycleId, topic: $topic, thumbnailUrl: $thumbnailUrl, participantCount: $participantCount, date: $date)';
}


}

/// @nodoc
abstract mixin class _$HistoryCycleResponseCopyWith<$Res> implements $HistoryCycleResponseCopyWith<$Res> {
  factory _$HistoryCycleResponseCopyWith(_HistoryCycleResponse value, $Res Function(_HistoryCycleResponse) _then) = __$HistoryCycleResponseCopyWithImpl;
@override @useResult
$Res call({
 int cycleId, String topic, String? thumbnailUrl, int participantCount, DateTime date
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
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,Object? topic = null,Object? thumbnailUrl = freezed,Object? participantCount = null,Object? date = null,}) {
  return _then(_HistoryCycleResponse(
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
