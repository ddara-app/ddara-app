// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentResponse {

 int get commentId; int get userId; String get nickname;// 프로필 이미지 URL. 없으면 null.
 String? get profileImageUrl; String? get content;// 신고 접수로 검토 중인 댓글인지 여부.
 bool get underReview;// 내가 신고한 댓글인지 여부.
 bool get reportedByMe; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of CommentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentResponseCopyWith<CommentResponse> get copyWith => _$CommentResponseCopyWithImpl<CommentResponse>(this as CommentResponse, _$identity);

  /// Serializes this CommentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentResponse&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.content, content) || other.content == content)&&(identical(other.underReview, underReview) || other.underReview == underReview)&&(identical(other.reportedByMe, reportedByMe) || other.reportedByMe == reportedByMe)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,commentId,userId,nickname,profileImageUrl,content,underReview,reportedByMe,createdAt,updatedAt);

@override
String toString() {
  return 'CommentResponse(commentId: $commentId, userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, content: $content, underReview: $underReview, reportedByMe: $reportedByMe, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CommentResponseCopyWith<$Res>  {
  factory $CommentResponseCopyWith(CommentResponse value, $Res Function(CommentResponse) _then) = _$CommentResponseCopyWithImpl;
@useResult
$Res call({
 int commentId, int userId, String nickname, String? profileImageUrl, String? content, bool underReview, bool reportedByMe, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$CommentResponseCopyWithImpl<$Res>
    implements $CommentResponseCopyWith<$Res> {
  _$CommentResponseCopyWithImpl(this._self, this._then);

  final CommentResponse _self;
  final $Res Function(CommentResponse) _then;

/// Create a copy of CommentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? commentId = null,Object? userId = null,Object? nickname = null,Object? profileImageUrl = freezed,Object? content = freezed,Object? underReview = null,Object? reportedByMe = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
commentId: null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,underReview: null == underReview ? _self.underReview : underReview // ignore: cast_nullable_to_non_nullable
as bool,reportedByMe: null == reportedByMe ? _self.reportedByMe : reportedByMe // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentResponse].
extension CommentResponsePatterns on CommentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentResponse value)  $default,){
final _that = this;
switch (_that) {
case _CommentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CommentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int commentId,  int userId,  String nickname,  String? profileImageUrl,  String? content,  bool underReview,  bool reportedByMe,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentResponse() when $default != null:
return $default(_that.commentId,_that.userId,_that.nickname,_that.profileImageUrl,_that.content,_that.underReview,_that.reportedByMe,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int commentId,  int userId,  String nickname,  String? profileImageUrl,  String? content,  bool underReview,  bool reportedByMe,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CommentResponse():
return $default(_that.commentId,_that.userId,_that.nickname,_that.profileImageUrl,_that.content,_that.underReview,_that.reportedByMe,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int commentId,  int userId,  String nickname,  String? profileImageUrl,  String? content,  bool underReview,  bool reportedByMe,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CommentResponse() when $default != null:
return $default(_that.commentId,_that.userId,_that.nickname,_that.profileImageUrl,_that.content,_that.underReview,_that.reportedByMe,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentResponse implements CommentResponse {
  const _CommentResponse({required this.commentId, required this.userId, required this.nickname, required this.profileImageUrl, required this.content, this.underReview = false, this.reportedByMe = false, required this.createdAt, this.updatedAt});
  factory _CommentResponse.fromJson(Map<String, dynamic> json) => _$CommentResponseFromJson(json);

@override final  int commentId;
@override final  int userId;
@override final  String nickname;
// 프로필 이미지 URL. 없으면 null.
@override final  String? profileImageUrl;
@override final  String? content;
// 신고 접수로 검토 중인 댓글인지 여부.
@override@JsonKey() final  bool underReview;
// 내가 신고한 댓글인지 여부.
@override@JsonKey() final  bool reportedByMe;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of CommentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentResponseCopyWith<_CommentResponse> get copyWith => __$CommentResponseCopyWithImpl<_CommentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentResponse&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.content, content) || other.content == content)&&(identical(other.underReview, underReview) || other.underReview == underReview)&&(identical(other.reportedByMe, reportedByMe) || other.reportedByMe == reportedByMe)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,commentId,userId,nickname,profileImageUrl,content,underReview,reportedByMe,createdAt,updatedAt);

@override
String toString() {
  return 'CommentResponse(commentId: $commentId, userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, content: $content, underReview: $underReview, reportedByMe: $reportedByMe, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CommentResponseCopyWith<$Res> implements $CommentResponseCopyWith<$Res> {
  factory _$CommentResponseCopyWith(_CommentResponse value, $Res Function(_CommentResponse) _then) = __$CommentResponseCopyWithImpl;
@override @useResult
$Res call({
 int commentId, int userId, String nickname, String? profileImageUrl, String? content, bool underReview, bool reportedByMe, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$CommentResponseCopyWithImpl<$Res>
    implements _$CommentResponseCopyWith<$Res> {
  __$CommentResponseCopyWithImpl(this._self, this._then);

  final _CommentResponse _self;
  final $Res Function(_CommentResponse) _then;

/// Create a copy of CommentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? commentId = null,Object? userId = null,Object? nickname = null,Object? profileImageUrl = freezed,Object? content = freezed,Object? underReview = null,Object? reportedByMe = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_CommentResponse(
commentId: null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,underReview: null == underReview ? _self.underReview : underReview // ignore: cast_nullable_to_non_nullable
as bool,reportedByMe: null == reportedByMe ? _self.reportedByMe : reportedByMe // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CommentListResponse {

 List<CommentResponse> get comments;
/// Create a copy of CommentListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentListResponseCopyWith<CommentListResponse> get copyWith => _$CommentListResponseCopyWithImpl<CommentListResponse>(this as CommentListResponse, _$identity);

  /// Serializes this CommentListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentListResponse&&const DeepCollectionEquality().equals(other.comments, comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(comments));

@override
String toString() {
  return 'CommentListResponse(comments: $comments)';
}


}

/// @nodoc
abstract mixin class $CommentListResponseCopyWith<$Res>  {
  factory $CommentListResponseCopyWith(CommentListResponse value, $Res Function(CommentListResponse) _then) = _$CommentListResponseCopyWithImpl;
@useResult
$Res call({
 List<CommentResponse> comments
});




}
/// @nodoc
class _$CommentListResponseCopyWithImpl<$Res>
    implements $CommentListResponseCopyWith<$Res> {
  _$CommentListResponseCopyWithImpl(this._self, this._then);

  final CommentListResponse _self;
  final $Res Function(CommentListResponse) _then;

/// Create a copy of CommentListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? comments = null,}) {
  return _then(_self.copyWith(
comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentListResponse].
extension CommentListResponsePatterns on CommentListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentListResponse value)  $default,){
final _that = this;
switch (_that) {
case _CommentListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CommentListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CommentResponse> comments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentListResponse() when $default != null:
return $default(_that.comments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CommentResponse> comments)  $default,) {final _that = this;
switch (_that) {
case _CommentListResponse():
return $default(_that.comments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CommentResponse> comments)?  $default,) {final _that = this;
switch (_that) {
case _CommentListResponse() when $default != null:
return $default(_that.comments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentListResponse implements CommentListResponse {
  const _CommentListResponse({required final  List<CommentResponse> comments}): _comments = comments;
  factory _CommentListResponse.fromJson(Map<String, dynamic> json) => _$CommentListResponseFromJson(json);

 final  List<CommentResponse> _comments;
@override List<CommentResponse> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}


/// Create a copy of CommentListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentListResponseCopyWith<_CommentListResponse> get copyWith => __$CommentListResponseCopyWithImpl<_CommentListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentListResponse&&const DeepCollectionEquality().equals(other._comments, _comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_comments));

@override
String toString() {
  return 'CommentListResponse(comments: $comments)';
}


}

/// @nodoc
abstract mixin class _$CommentListResponseCopyWith<$Res> implements $CommentListResponseCopyWith<$Res> {
  factory _$CommentListResponseCopyWith(_CommentListResponse value, $Res Function(_CommentListResponse) _then) = __$CommentListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<CommentResponse> comments
});




}
/// @nodoc
class __$CommentListResponseCopyWithImpl<$Res>
    implements _$CommentListResponseCopyWith<$Res> {
  __$CommentListResponseCopyWithImpl(this._self, this._then);

  final _CommentListResponse _self;
  final $Res Function(_CommentListResponse) _then;

/// Create a copy of CommentListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? comments = null,}) {
  return _then(_CommentListResponse(
comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentResponse>,
  ));
}


}


/// @nodoc
mixin _$CommentUpdateResponse {

 int get commentId; String get content; DateTime get updatedAt;
/// Create a copy of CommentUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentUpdateResponseCopyWith<CommentUpdateResponse> get copyWith => _$CommentUpdateResponseCopyWithImpl<CommentUpdateResponse>(this as CommentUpdateResponse, _$identity);

  /// Serializes this CommentUpdateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentUpdateResponse&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.content, content) || other.content == content)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,commentId,content,updatedAt);

@override
String toString() {
  return 'CommentUpdateResponse(commentId: $commentId, content: $content, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CommentUpdateResponseCopyWith<$Res>  {
  factory $CommentUpdateResponseCopyWith(CommentUpdateResponse value, $Res Function(CommentUpdateResponse) _then) = _$CommentUpdateResponseCopyWithImpl;
@useResult
$Res call({
 int commentId, String content, DateTime updatedAt
});




}
/// @nodoc
class _$CommentUpdateResponseCopyWithImpl<$Res>
    implements $CommentUpdateResponseCopyWith<$Res> {
  _$CommentUpdateResponseCopyWithImpl(this._self, this._then);

  final CommentUpdateResponse _self;
  final $Res Function(CommentUpdateResponse) _then;

/// Create a copy of CommentUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? commentId = null,Object? content = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
commentId: null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentUpdateResponse].
extension CommentUpdateResponsePatterns on CommentUpdateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentUpdateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentUpdateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentUpdateResponse value)  $default,){
final _that = this;
switch (_that) {
case _CommentUpdateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentUpdateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CommentUpdateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int commentId,  String content,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentUpdateResponse() when $default != null:
return $default(_that.commentId,_that.content,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int commentId,  String content,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CommentUpdateResponse():
return $default(_that.commentId,_that.content,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int commentId,  String content,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CommentUpdateResponse() when $default != null:
return $default(_that.commentId,_that.content,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentUpdateResponse implements CommentUpdateResponse {
  const _CommentUpdateResponse({required this.commentId, required this.content, required this.updatedAt});
  factory _CommentUpdateResponse.fromJson(Map<String, dynamic> json) => _$CommentUpdateResponseFromJson(json);

@override final  int commentId;
@override final  String content;
@override final  DateTime updatedAt;

/// Create a copy of CommentUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentUpdateResponseCopyWith<_CommentUpdateResponse> get copyWith => __$CommentUpdateResponseCopyWithImpl<_CommentUpdateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentUpdateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentUpdateResponse&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.content, content) || other.content == content)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,commentId,content,updatedAt);

@override
String toString() {
  return 'CommentUpdateResponse(commentId: $commentId, content: $content, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CommentUpdateResponseCopyWith<$Res> implements $CommentUpdateResponseCopyWith<$Res> {
  factory _$CommentUpdateResponseCopyWith(_CommentUpdateResponse value, $Res Function(_CommentUpdateResponse) _then) = __$CommentUpdateResponseCopyWithImpl;
@override @useResult
$Res call({
 int commentId, String content, DateTime updatedAt
});




}
/// @nodoc
class __$CommentUpdateResponseCopyWithImpl<$Res>
    implements _$CommentUpdateResponseCopyWith<$Res> {
  __$CommentUpdateResponseCopyWithImpl(this._self, this._then);

  final _CommentUpdateResponse _self;
  final $Res Function(_CommentUpdateResponse) _then;

/// Create a copy of CommentUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? commentId = null,Object? content = null,Object? updatedAt = null,}) {
  return _then(_CommentUpdateResponse(
commentId: null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
