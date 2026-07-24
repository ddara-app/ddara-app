// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockListResponse {

 List<BlockedUserResponse> get blocks;
/// Create a copy of BlockListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockListResponseCopyWith<BlockListResponse> get copyWith => _$BlockListResponseCopyWithImpl<BlockListResponse>(this as BlockListResponse, _$identity);

  /// Serializes this BlockListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockListResponse&&const DeepCollectionEquality().equals(other.blocks, blocks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(blocks));

@override
String toString() {
  return 'BlockListResponse(blocks: $blocks)';
}


}

/// @nodoc
abstract mixin class $BlockListResponseCopyWith<$Res>  {
  factory $BlockListResponseCopyWith(BlockListResponse value, $Res Function(BlockListResponse) _then) = _$BlockListResponseCopyWithImpl;
@useResult
$Res call({
 List<BlockedUserResponse> blocks
});




}
/// @nodoc
class _$BlockListResponseCopyWithImpl<$Res>
    implements $BlockListResponseCopyWith<$Res> {
  _$BlockListResponseCopyWithImpl(this._self, this._then);

  final BlockListResponse _self;
  final $Res Function(BlockListResponse) _then;

/// Create a copy of BlockListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? blocks = null,}) {
  return _then(_self.copyWith(
blocks: null == blocks ? _self.blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<BlockedUserResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [BlockListResponse].
extension BlockListResponsePatterns on BlockListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlockListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlockListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlockListResponse value)  $default,){
final _that = this;
switch (_that) {
case _BlockListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlockListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BlockListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BlockedUserResponse> blocks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlockListResponse() when $default != null:
return $default(_that.blocks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BlockedUserResponse> blocks)  $default,) {final _that = this;
switch (_that) {
case _BlockListResponse():
return $default(_that.blocks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BlockedUserResponse> blocks)?  $default,) {final _that = this;
switch (_that) {
case _BlockListResponse() when $default != null:
return $default(_that.blocks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlockListResponse implements BlockListResponse {
  const _BlockListResponse({required final  List<BlockedUserResponse> blocks}): _blocks = blocks;
  factory _BlockListResponse.fromJson(Map<String, dynamic> json) => _$BlockListResponseFromJson(json);

 final  List<BlockedUserResponse> _blocks;
@override List<BlockedUserResponse> get blocks {
  if (_blocks is EqualUnmodifiableListView) return _blocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blocks);
}


/// Create a copy of BlockListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockListResponseCopyWith<_BlockListResponse> get copyWith => __$BlockListResponseCopyWithImpl<_BlockListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockListResponse&&const DeepCollectionEquality().equals(other._blocks, _blocks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_blocks));

@override
String toString() {
  return 'BlockListResponse(blocks: $blocks)';
}


}

/// @nodoc
abstract mixin class _$BlockListResponseCopyWith<$Res> implements $BlockListResponseCopyWith<$Res> {
  factory _$BlockListResponseCopyWith(_BlockListResponse value, $Res Function(_BlockListResponse) _then) = __$BlockListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<BlockedUserResponse> blocks
});




}
/// @nodoc
class __$BlockListResponseCopyWithImpl<$Res>
    implements _$BlockListResponseCopyWith<$Res> {
  __$BlockListResponseCopyWithImpl(this._self, this._then);

  final _BlockListResponse _self;
  final $Res Function(_BlockListResponse) _then;

/// Create a copy of BlockListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blocks = null,}) {
  return _then(_BlockListResponse(
blocks: null == blocks ? _self._blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<BlockedUserResponse>,
  ));
}


}


/// @nodoc
mixin _$BlockedUserResponse {

 int get userId; String get name; String get blockedNickname; DateTime get blockedAt;
/// Create a copy of BlockedUserResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockedUserResponseCopyWith<BlockedUserResponse> get copyWith => _$BlockedUserResponseCopyWithImpl<BlockedUserResponse>(this as BlockedUserResponse, _$identity);

  /// Serializes this BlockedUserResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockedUserResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.blockedNickname, blockedNickname) || other.blockedNickname == blockedNickname)&&(identical(other.blockedAt, blockedAt) || other.blockedAt == blockedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,name,blockedNickname,blockedAt);

@override
String toString() {
  return 'BlockedUserResponse(userId: $userId, name: $name, blockedNickname: $blockedNickname, blockedAt: $blockedAt)';
}


}

/// @nodoc
abstract mixin class $BlockedUserResponseCopyWith<$Res>  {
  factory $BlockedUserResponseCopyWith(BlockedUserResponse value, $Res Function(BlockedUserResponse) _then) = _$BlockedUserResponseCopyWithImpl;
@useResult
$Res call({
 int userId, String name, String blockedNickname, DateTime blockedAt
});




}
/// @nodoc
class _$BlockedUserResponseCopyWithImpl<$Res>
    implements $BlockedUserResponseCopyWith<$Res> {
  _$BlockedUserResponseCopyWithImpl(this._self, this._then);

  final BlockedUserResponse _self;
  final $Res Function(BlockedUserResponse) _then;

/// Create a copy of BlockedUserResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? blockedNickname = null,Object? blockedAt = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,blockedNickname: null == blockedNickname ? _self.blockedNickname : blockedNickname // ignore: cast_nullable_to_non_nullable
as String,blockedAt: null == blockedAt ? _self.blockedAt : blockedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BlockedUserResponse].
extension BlockedUserResponsePatterns on BlockedUserResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlockedUserResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlockedUserResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlockedUserResponse value)  $default,){
final _that = this;
switch (_that) {
case _BlockedUserResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlockedUserResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BlockedUserResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  String name,  String blockedNickname,  DateTime blockedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlockedUserResponse() when $default != null:
return $default(_that.userId,_that.name,_that.blockedNickname,_that.blockedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  String name,  String blockedNickname,  DateTime blockedAt)  $default,) {final _that = this;
switch (_that) {
case _BlockedUserResponse():
return $default(_that.userId,_that.name,_that.blockedNickname,_that.blockedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  String name,  String blockedNickname,  DateTime blockedAt)?  $default,) {final _that = this;
switch (_that) {
case _BlockedUserResponse() when $default != null:
return $default(_that.userId,_that.name,_that.blockedNickname,_that.blockedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlockedUserResponse implements BlockedUserResponse {
  const _BlockedUserResponse({required this.userId, required this.name, required this.blockedNickname, required this.blockedAt});
  factory _BlockedUserResponse.fromJson(Map<String, dynamic> json) => _$BlockedUserResponseFromJson(json);

@override final  int userId;
@override final  String name;
@override final  String blockedNickname;
@override final  DateTime blockedAt;

/// Create a copy of BlockedUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedUserResponseCopyWith<_BlockedUserResponse> get copyWith => __$BlockedUserResponseCopyWithImpl<_BlockedUserResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockedUserResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedUserResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.blockedNickname, blockedNickname) || other.blockedNickname == blockedNickname)&&(identical(other.blockedAt, blockedAt) || other.blockedAt == blockedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,name,blockedNickname,blockedAt);

@override
String toString() {
  return 'BlockedUserResponse(userId: $userId, name: $name, blockedNickname: $blockedNickname, blockedAt: $blockedAt)';
}


}

/// @nodoc
abstract mixin class _$BlockedUserResponseCopyWith<$Res> implements $BlockedUserResponseCopyWith<$Res> {
  factory _$BlockedUserResponseCopyWith(_BlockedUserResponse value, $Res Function(_BlockedUserResponse) _then) = __$BlockedUserResponseCopyWithImpl;
@override @useResult
$Res call({
 int userId, String name, String blockedNickname, DateTime blockedAt
});




}
/// @nodoc
class __$BlockedUserResponseCopyWithImpl<$Res>
    implements _$BlockedUserResponseCopyWith<$Res> {
  __$BlockedUserResponseCopyWithImpl(this._self, this._then);

  final _BlockedUserResponse _self;
  final $Res Function(_BlockedUserResponse) _then;

/// Create a copy of BlockedUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? blockedNickname = null,Object? blockedAt = null,}) {
  return _then(_BlockedUserResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,blockedNickname: null == blockedNickname ? _self.blockedNickname : blockedNickname // ignore: cast_nullable_to_non_nullable
as String,blockedAt: null == blockedAt ? _self.blockedAt : blockedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
