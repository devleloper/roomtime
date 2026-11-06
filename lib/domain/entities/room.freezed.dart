// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomSummary {

 RoomCode get code; Uri get inviteUrl; String? get name; bool get passwordRequired; bool get e2ee; bool get locked; DateTime get expiresAt;
/// Create a copy of RoomSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomSummaryCopyWith<RoomSummary> get copyWith => _$RoomSummaryCopyWithImpl<RoomSummary>(this as RoomSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomSummary&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordRequired, passwordRequired) || other.passwordRequired == passwordRequired)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,code,inviteUrl,name,passwordRequired,e2ee,locked,expiresAt);

@override
String toString() {
  return 'RoomSummary(code: $code, inviteUrl: $inviteUrl, name: $name, passwordRequired: $passwordRequired, e2ee: $e2ee, locked: $locked, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $RoomSummaryCopyWith<$Res>  {
  factory $RoomSummaryCopyWith(RoomSummary value, $Res Function(RoomSummary) _then) = _$RoomSummaryCopyWithImpl;
@useResult
$Res call({
 RoomCode code, Uri inviteUrl, String? name, bool passwordRequired, bool e2ee, bool locked, DateTime expiresAt
});


$RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class _$RoomSummaryCopyWithImpl<$Res>
    implements $RoomSummaryCopyWith<$Res> {
  _$RoomSummaryCopyWithImpl(this._self, this._then);

  final RoomSummary _self;
  final $Res Function(RoomSummary) _then;

/// Create a copy of RoomSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? inviteUrl = null,Object? name = freezed,Object? passwordRequired = null,Object? e2ee = null,Object? locked = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as Uri,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,passwordRequired: null == passwordRequired ? _self.passwordRequired : passwordRequired // ignore: cast_nullable_to_non_nullable
as bool,e2ee: null == e2ee ? _self.e2ee : e2ee // ignore: cast_nullable_to_non_nullable
as bool,locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of RoomSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomSummary].
extension RoomSummaryPatterns on RoomSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomSummary value)  $default,){
final _that = this;
switch (_that) {
case _RoomSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RoomSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RoomCode code,  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  bool locked,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomSummary() when $default != null:
return $default(_that.code,_that.inviteUrl,_that.name,_that.passwordRequired,_that.e2ee,_that.locked,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RoomCode code,  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  bool locked,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _RoomSummary():
return $default(_that.code,_that.inviteUrl,_that.name,_that.passwordRequired,_that.e2ee,_that.locked,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RoomCode code,  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  bool locked,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _RoomSummary() when $default != null:
return $default(_that.code,_that.inviteUrl,_that.name,_that.passwordRequired,_that.e2ee,_that.locked,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _RoomSummary implements RoomSummary {
  const _RoomSummary({required this.code, required this.inviteUrl, this.name, required this.passwordRequired, required this.e2ee, required this.locked, required this.expiresAt});
  

@override final  RoomCode code;
@override final  Uri inviteUrl;
@override final  String? name;
@override final  bool passwordRequired;
@override final  bool e2ee;
@override final  bool locked;
@override final  DateTime expiresAt;

/// Create a copy of RoomSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomSummaryCopyWith<_RoomSummary> get copyWith => __$RoomSummaryCopyWithImpl<_RoomSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomSummary&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordRequired, passwordRequired) || other.passwordRequired == passwordRequired)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,code,inviteUrl,name,passwordRequired,e2ee,locked,expiresAt);

@override
String toString() {
  return 'RoomSummary(code: $code, inviteUrl: $inviteUrl, name: $name, passwordRequired: $passwordRequired, e2ee: $e2ee, locked: $locked, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$RoomSummaryCopyWith<$Res> implements $RoomSummaryCopyWith<$Res> {
  factory _$RoomSummaryCopyWith(_RoomSummary value, $Res Function(_RoomSummary) _then) = __$RoomSummaryCopyWithImpl;
@override @useResult
$Res call({
 RoomCode code, Uri inviteUrl, String? name, bool passwordRequired, bool e2ee, bool locked, DateTime expiresAt
});


@override $RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class __$RoomSummaryCopyWithImpl<$Res>
    implements _$RoomSummaryCopyWith<$Res> {
  __$RoomSummaryCopyWithImpl(this._self, this._then);

  final _RoomSummary _self;
  final $Res Function(_RoomSummary) _then;

/// Create a copy of RoomSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? inviteUrl = null,Object? name = freezed,Object? passwordRequired = null,Object? e2ee = null,Object? locked = null,Object? expiresAt = null,}) {
  return _then(_RoomSummary(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as Uri,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,passwordRequired: null == passwordRequired ? _self.passwordRequired : passwordRequired // ignore: cast_nullable_to_non_nullable
as bool,e2ee: null == e2ee ? _self.e2ee : e2ee // ignore: cast_nullable_to_non_nullable
as bool,locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of RoomSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}

/// @nodoc
mixin _$RoomInfo {

 RoomCode get code; Uri get inviteUrl; String? get name; bool get passwordRequired; bool get e2ee; bool get locked; int get maxParticipants; DateTime get expiresAt;
/// Create a copy of RoomInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomInfoCopyWith<RoomInfo> get copyWith => _$RoomInfoCopyWithImpl<RoomInfo>(this as RoomInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomInfo&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordRequired, passwordRequired) || other.passwordRequired == passwordRequired)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,code,inviteUrl,name,passwordRequired,e2ee,locked,maxParticipants,expiresAt);

@override
String toString() {
  return 'RoomInfo(code: $code, inviteUrl: $inviteUrl, name: $name, passwordRequired: $passwordRequired, e2ee: $e2ee, locked: $locked, maxParticipants: $maxParticipants, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $RoomInfoCopyWith<$Res>  {
  factory $RoomInfoCopyWith(RoomInfo value, $Res Function(RoomInfo) _then) = _$RoomInfoCopyWithImpl;
@useResult
$Res call({
 RoomCode code, Uri inviteUrl, String? name, bool passwordRequired, bool e2ee, bool locked, int maxParticipants, DateTime expiresAt
});


$RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class _$RoomInfoCopyWithImpl<$Res>
    implements $RoomInfoCopyWith<$Res> {
  _$RoomInfoCopyWithImpl(this._self, this._then);

  final RoomInfo _self;
  final $Res Function(RoomInfo) _then;

/// Create a copy of RoomInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? inviteUrl = null,Object? name = freezed,Object? passwordRequired = null,Object? e2ee = null,Object? locked = null,Object? maxParticipants = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as Uri,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,passwordRequired: null == passwordRequired ? _self.passwordRequired : passwordRequired // ignore: cast_nullable_to_non_nullable
as bool,e2ee: null == e2ee ? _self.e2ee : e2ee // ignore: cast_nullable_to_non_nullable
as bool,locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,maxParticipants: null == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of RoomInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomInfo].
extension RoomInfoPatterns on RoomInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomInfo value)  $default,){
final _that = this;
switch (_that) {
case _RoomInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomInfo value)?  $default,){
final _that = this;
switch (_that) {
case _RoomInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RoomCode code,  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  bool locked,  int maxParticipants,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomInfo() when $default != null:
return $default(_that.code,_that.inviteUrl,_that.name,_that.passwordRequired,_that.e2ee,_that.locked,_that.maxParticipants,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RoomCode code,  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  bool locked,  int maxParticipants,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _RoomInfo():
return $default(_that.code,_that.inviteUrl,_that.name,_that.passwordRequired,_that.e2ee,_that.locked,_that.maxParticipants,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RoomCode code,  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  bool locked,  int maxParticipants,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _RoomInfo() when $default != null:
return $default(_that.code,_that.inviteUrl,_that.name,_that.passwordRequired,_that.e2ee,_that.locked,_that.maxParticipants,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _RoomInfo implements RoomInfo {
  const _RoomInfo({required this.code, required this.inviteUrl, this.name, required this.passwordRequired, required this.e2ee, required this.locked, required this.maxParticipants, required this.expiresAt});
  

@override final  RoomCode code;
@override final  Uri inviteUrl;
@override final  String? name;
@override final  bool passwordRequired;
@override final  bool e2ee;
@override final  bool locked;
@override final  int maxParticipants;
@override final  DateTime expiresAt;

/// Create a copy of RoomInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomInfoCopyWith<_RoomInfo> get copyWith => __$RoomInfoCopyWithImpl<_RoomInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomInfo&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordRequired, passwordRequired) || other.passwordRequired == passwordRequired)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,code,inviteUrl,name,passwordRequired,e2ee,locked,maxParticipants,expiresAt);

@override
String toString() {
  return 'RoomInfo(code: $code, inviteUrl: $inviteUrl, name: $name, passwordRequired: $passwordRequired, e2ee: $e2ee, locked: $locked, maxParticipants: $maxParticipants, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$RoomInfoCopyWith<$Res> implements $RoomInfoCopyWith<$Res> {
  factory _$RoomInfoCopyWith(_RoomInfo value, $Res Function(_RoomInfo) _then) = __$RoomInfoCopyWithImpl;
@override @useResult
$Res call({
 RoomCode code, Uri inviteUrl, String? name, bool passwordRequired, bool e2ee, bool locked, int maxParticipants, DateTime expiresAt
});


@override $RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class __$RoomInfoCopyWithImpl<$Res>
    implements _$RoomInfoCopyWith<$Res> {
  __$RoomInfoCopyWithImpl(this._self, this._then);

  final _RoomInfo _self;
  final $Res Function(_RoomInfo) _then;

/// Create a copy of RoomInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? inviteUrl = null,Object? name = freezed,Object? passwordRequired = null,Object? e2ee = null,Object? locked = null,Object? maxParticipants = null,Object? expiresAt = null,}) {
  return _then(_RoomInfo(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as Uri,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,passwordRequired: null == passwordRequired ? _self.passwordRequired : passwordRequired // ignore: cast_nullable_to_non_nullable
as bool,e2ee: null == e2ee ? _self.e2ee : e2ee // ignore: cast_nullable_to_non_nullable
as bool,locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,maxParticipants: null == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of RoomInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}

/// @nodoc
mixin _$CreatedRoom {

 String get roomId; RoomCode get code; Uri get inviteUrl; String? get name; bool get passwordRequired; bool get e2ee; int get maxParticipants; DateTime get expiresAt;
/// Create a copy of CreatedRoom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatedRoomCopyWith<CreatedRoom> get copyWith => _$CreatedRoomCopyWithImpl<CreatedRoom>(this as CreatedRoom, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatedRoom&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordRequired, passwordRequired) || other.passwordRequired == passwordRequired)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,roomId,code,inviteUrl,name,passwordRequired,e2ee,maxParticipants,expiresAt);

@override
String toString() {
  return 'CreatedRoom(roomId: $roomId, code: $code, inviteUrl: $inviteUrl, name: $name, passwordRequired: $passwordRequired, e2ee: $e2ee, maxParticipants: $maxParticipants, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $CreatedRoomCopyWith<$Res>  {
  factory $CreatedRoomCopyWith(CreatedRoom value, $Res Function(CreatedRoom) _then) = _$CreatedRoomCopyWithImpl;
@useResult
$Res call({
 String roomId, RoomCode code, Uri inviteUrl, String? name, bool passwordRequired, bool e2ee, int maxParticipants, DateTime expiresAt
});


$RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class _$CreatedRoomCopyWithImpl<$Res>
    implements $CreatedRoomCopyWith<$Res> {
  _$CreatedRoomCopyWithImpl(this._self, this._then);

  final CreatedRoom _self;
  final $Res Function(CreatedRoom) _then;

/// Create a copy of CreatedRoom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomId = null,Object? code = null,Object? inviteUrl = null,Object? name = freezed,Object? passwordRequired = null,Object? e2ee = null,Object? maxParticipants = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as Uri,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,passwordRequired: null == passwordRequired ? _self.passwordRequired : passwordRequired // ignore: cast_nullable_to_non_nullable
as bool,e2ee: null == e2ee ? _self.e2ee : e2ee // ignore: cast_nullable_to_non_nullable
as bool,maxParticipants: null == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of CreatedRoom
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreatedRoom].
extension CreatedRoomPatterns on CreatedRoom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatedRoom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatedRoom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatedRoom value)  $default,){
final _that = this;
switch (_that) {
case _CreatedRoom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatedRoom value)?  $default,){
final _that = this;
switch (_that) {
case _CreatedRoom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String roomId,  RoomCode code,  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  int maxParticipants,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatedRoom() when $default != null:
return $default(_that.roomId,_that.code,_that.inviteUrl,_that.name,_that.passwordRequired,_that.e2ee,_that.maxParticipants,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String roomId,  RoomCode code,  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  int maxParticipants,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _CreatedRoom():
return $default(_that.roomId,_that.code,_that.inviteUrl,_that.name,_that.passwordRequired,_that.e2ee,_that.maxParticipants,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String roomId,  RoomCode code,  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  int maxParticipants,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _CreatedRoom() when $default != null:
return $default(_that.roomId,_that.code,_that.inviteUrl,_that.name,_that.passwordRequired,_that.e2ee,_that.maxParticipants,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _CreatedRoom implements CreatedRoom {
  const _CreatedRoom({required this.roomId, required this.code, required this.inviteUrl, this.name, required this.passwordRequired, required this.e2ee, required this.maxParticipants, required this.expiresAt});
  

@override final  String roomId;
@override final  RoomCode code;
@override final  Uri inviteUrl;
@override final  String? name;
@override final  bool passwordRequired;
@override final  bool e2ee;
@override final  int maxParticipants;
@override final  DateTime expiresAt;

/// Create a copy of CreatedRoom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedRoomCopyWith<_CreatedRoom> get copyWith => __$CreatedRoomCopyWithImpl<_CreatedRoom>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatedRoom&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordRequired, passwordRequired) || other.passwordRequired == passwordRequired)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,roomId,code,inviteUrl,name,passwordRequired,e2ee,maxParticipants,expiresAt);

@override
String toString() {
  return 'CreatedRoom(roomId: $roomId, code: $code, inviteUrl: $inviteUrl, name: $name, passwordRequired: $passwordRequired, e2ee: $e2ee, maxParticipants: $maxParticipants, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$CreatedRoomCopyWith<$Res> implements $CreatedRoomCopyWith<$Res> {
  factory _$CreatedRoomCopyWith(_CreatedRoom value, $Res Function(_CreatedRoom) _then) = __$CreatedRoomCopyWithImpl;
@override @useResult
$Res call({
 String roomId, RoomCode code, Uri inviteUrl, String? name, bool passwordRequired, bool e2ee, int maxParticipants, DateTime expiresAt
});


@override $RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class __$CreatedRoomCopyWithImpl<$Res>
    implements _$CreatedRoomCopyWith<$Res> {
  __$CreatedRoomCopyWithImpl(this._self, this._then);

  final _CreatedRoom _self;
  final $Res Function(_CreatedRoom) _then;

/// Create a copy of CreatedRoom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomId = null,Object? code = null,Object? inviteUrl = null,Object? name = freezed,Object? passwordRequired = null,Object? e2ee = null,Object? maxParticipants = null,Object? expiresAt = null,}) {
  return _then(_CreatedRoom(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as Uri,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,passwordRequired: null == passwordRequired ? _self.passwordRequired : passwordRequired // ignore: cast_nullable_to_non_nullable
as bool,e2ee: null == e2ee ? _self.e2ee : e2ee // ignore: cast_nullable_to_non_nullable
as bool,maxParticipants: null == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of CreatedRoom
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}

/// @nodoc
mixin _$RoomJoin {

 String get token; String get livekitUrl; String get identity; RoomRole get role; RoomInfo get room;
/// Create a copy of RoomJoin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomJoinCopyWith<RoomJoin> get copyWith => _$RoomJoinCopyWithImpl<RoomJoin>(this as RoomJoin, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomJoin&&(identical(other.token, token) || other.token == token)&&(identical(other.livekitUrl, livekitUrl) || other.livekitUrl == livekitUrl)&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.role, role) || other.role == role)&&(identical(other.room, room) || other.room == room));
}


@override
int get hashCode => Object.hash(runtimeType,token,livekitUrl,identity,role,room);



}

/// @nodoc
abstract mixin class $RoomJoinCopyWith<$Res>  {
  factory $RoomJoinCopyWith(RoomJoin value, $Res Function(RoomJoin) _then) = _$RoomJoinCopyWithImpl;
@useResult
$Res call({
 String token, String livekitUrl, String identity, RoomRole role, RoomInfo room
});


$RoomInfoCopyWith<$Res> get room;

}
/// @nodoc
class _$RoomJoinCopyWithImpl<$Res>
    implements $RoomJoinCopyWith<$Res> {
  _$RoomJoinCopyWithImpl(this._self, this._then);

  final RoomJoin _self;
  final $Res Function(RoomJoin) _then;

/// Create a copy of RoomJoin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? livekitUrl = null,Object? identity = null,Object? role = null,Object? room = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,livekitUrl: null == livekitUrl ? _self.livekitUrl : livekitUrl // ignore: cast_nullable_to_non_nullable
as String,identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoomRole,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as RoomInfo,
  ));
}
/// Create a copy of RoomJoin
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomInfoCopyWith<$Res> get room {
  
  return $RoomInfoCopyWith<$Res>(_self.room, (value) {
    return _then(_self.copyWith(room: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomJoin].
extension RoomJoinPatterns on RoomJoin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomJoin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomJoin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomJoin value)  $default,){
final _that = this;
switch (_that) {
case _RoomJoin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomJoin value)?  $default,){
final _that = this;
switch (_that) {
case _RoomJoin() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String livekitUrl,  String identity,  RoomRole role,  RoomInfo room)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomJoin() when $default != null:
return $default(_that.token,_that.livekitUrl,_that.identity,_that.role,_that.room);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String livekitUrl,  String identity,  RoomRole role,  RoomInfo room)  $default,) {final _that = this;
switch (_that) {
case _RoomJoin():
return $default(_that.token,_that.livekitUrl,_that.identity,_that.role,_that.room);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String livekitUrl,  String identity,  RoomRole role,  RoomInfo room)?  $default,) {final _that = this;
switch (_that) {
case _RoomJoin() when $default != null:
return $default(_that.token,_that.livekitUrl,_that.identity,_that.role,_that.room);case _:
  return null;

}
}

}

/// @nodoc


class _RoomJoin extends RoomJoin {
  const _RoomJoin({required this.token, required this.livekitUrl, required this.identity, required this.role, required this.room}): super._();
  

@override final  String token;
@override final  String livekitUrl;
@override final  String identity;
@override final  RoomRole role;
@override final  RoomInfo room;

/// Create a copy of RoomJoin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomJoinCopyWith<_RoomJoin> get copyWith => __$RoomJoinCopyWithImpl<_RoomJoin>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomJoin&&(identical(other.token, token) || other.token == token)&&(identical(other.livekitUrl, livekitUrl) || other.livekitUrl == livekitUrl)&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.role, role) || other.role == role)&&(identical(other.room, room) || other.room == room));
}


@override
int get hashCode => Object.hash(runtimeType,token,livekitUrl,identity,role,room);



}

/// @nodoc
abstract mixin class _$RoomJoinCopyWith<$Res> implements $RoomJoinCopyWith<$Res> {
  factory _$RoomJoinCopyWith(_RoomJoin value, $Res Function(_RoomJoin) _then) = __$RoomJoinCopyWithImpl;
@override @useResult
$Res call({
 String token, String livekitUrl, String identity, RoomRole role, RoomInfo room
});


@override $RoomInfoCopyWith<$Res> get room;

}
/// @nodoc
class __$RoomJoinCopyWithImpl<$Res>
    implements _$RoomJoinCopyWith<$Res> {
  __$RoomJoinCopyWithImpl(this._self, this._then);

  final _RoomJoin _self;
  final $Res Function(_RoomJoin) _then;

/// Create a copy of RoomJoin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? livekitUrl = null,Object? identity = null,Object? role = null,Object? room = null,}) {
  return _then(_RoomJoin(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,livekitUrl: null == livekitUrl ? _self.livekitUrl : livekitUrl // ignore: cast_nullable_to_non_nullable
as String,identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoomRole,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as RoomInfo,
  ));
}

/// Create a copy of RoomJoin
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomInfoCopyWith<$Res> get room {
  
  return $RoomInfoCopyWith<$Res>(_self.room, (value) {
    return _then(_self.copyWith(room: value));
  });
}
}

/// @nodoc
mixin _$CreateRoomParams {

 String? get name; String? get password; int? get maxParticipants; int? get lifetimeMinutes; bool? get e2ee;
/// Create a copy of CreateRoomParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateRoomParamsCopyWith<CreateRoomParams> get copyWith => _$CreateRoomParamsCopyWithImpl<CreateRoomParams>(this as CreateRoomParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateRoomParams&&(identical(other.name, name) || other.name == name)&&(identical(other.password, password) || other.password == password)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.lifetimeMinutes, lifetimeMinutes) || other.lifetimeMinutes == lifetimeMinutes)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee));
}


@override
int get hashCode => Object.hash(runtimeType,name,password,maxParticipants,lifetimeMinutes,e2ee);



}

/// @nodoc
abstract mixin class $CreateRoomParamsCopyWith<$Res>  {
  factory $CreateRoomParamsCopyWith(CreateRoomParams value, $Res Function(CreateRoomParams) _then) = _$CreateRoomParamsCopyWithImpl;
@useResult
$Res call({
 String? name, String? password, int? maxParticipants, int? lifetimeMinutes, bool? e2ee
});




}
/// @nodoc
class _$CreateRoomParamsCopyWithImpl<$Res>
    implements $CreateRoomParamsCopyWith<$Res> {
  _$CreateRoomParamsCopyWithImpl(this._self, this._then);

  final CreateRoomParams _self;
  final $Res Function(CreateRoomParams) _then;

/// Create a copy of CreateRoomParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? password = freezed,Object? maxParticipants = freezed,Object? lifetimeMinutes = freezed,Object? e2ee = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,maxParticipants: freezed == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int?,lifetimeMinutes: freezed == lifetimeMinutes ? _self.lifetimeMinutes : lifetimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,e2ee: freezed == e2ee ? _self.e2ee : e2ee // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateRoomParams].
extension CreateRoomParamsPatterns on CreateRoomParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateRoomParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateRoomParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateRoomParams value)  $default,){
final _that = this;
switch (_that) {
case _CreateRoomParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateRoomParams value)?  $default,){
final _that = this;
switch (_that) {
case _CreateRoomParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? password,  int? maxParticipants,  int? lifetimeMinutes,  bool? e2ee)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateRoomParams() when $default != null:
return $default(_that.name,_that.password,_that.maxParticipants,_that.lifetimeMinutes,_that.e2ee);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? password,  int? maxParticipants,  int? lifetimeMinutes,  bool? e2ee)  $default,) {final _that = this;
switch (_that) {
case _CreateRoomParams():
return $default(_that.name,_that.password,_that.maxParticipants,_that.lifetimeMinutes,_that.e2ee);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? password,  int? maxParticipants,  int? lifetimeMinutes,  bool? e2ee)?  $default,) {final _that = this;
switch (_that) {
case _CreateRoomParams() when $default != null:
return $default(_that.name,_that.password,_that.maxParticipants,_that.lifetimeMinutes,_that.e2ee);case _:
  return null;

}
}

}

/// @nodoc


class _CreateRoomParams extends CreateRoomParams {
  const _CreateRoomParams({this.name, this.password, this.maxParticipants, this.lifetimeMinutes, this.e2ee}): super._();
  

@override final  String? name;
@override final  String? password;
@override final  int? maxParticipants;
@override final  int? lifetimeMinutes;
@override final  bool? e2ee;

/// Create a copy of CreateRoomParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateRoomParamsCopyWith<_CreateRoomParams> get copyWith => __$CreateRoomParamsCopyWithImpl<_CreateRoomParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRoomParams&&(identical(other.name, name) || other.name == name)&&(identical(other.password, password) || other.password == password)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.lifetimeMinutes, lifetimeMinutes) || other.lifetimeMinutes == lifetimeMinutes)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee));
}


@override
int get hashCode => Object.hash(runtimeType,name,password,maxParticipants,lifetimeMinutes,e2ee);



}

/// @nodoc
abstract mixin class _$CreateRoomParamsCopyWith<$Res> implements $CreateRoomParamsCopyWith<$Res> {
  factory _$CreateRoomParamsCopyWith(_CreateRoomParams value, $Res Function(_CreateRoomParams) _then) = __$CreateRoomParamsCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? password, int? maxParticipants, int? lifetimeMinutes, bool? e2ee
});




}
/// @nodoc
class __$CreateRoomParamsCopyWithImpl<$Res>
    implements _$CreateRoomParamsCopyWith<$Res> {
  __$CreateRoomParamsCopyWithImpl(this._self, this._then);

  final _CreateRoomParams _self;
  final $Res Function(_CreateRoomParams) _then;

/// Create a copy of CreateRoomParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? password = freezed,Object? maxParticipants = freezed,Object? lifetimeMinutes = freezed,Object? e2ee = freezed,}) {
  return _then(_CreateRoomParams(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,maxParticipants: freezed == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int?,lifetimeMinutes: freezed == lifetimeMinutes ? _self.lifetimeMinutes : lifetimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,e2ee: freezed == e2ee ? _self.e2ee : e2ee // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

/// @nodoc
mixin _$PasswordChange {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordChange);
}


@override
int get hashCode => runtimeType.hashCode;



}

/// @nodoc
class $PasswordChangeCopyWith<$Res>  {
$PasswordChangeCopyWith(PasswordChange _, $Res Function(PasswordChange) __);
}


/// Adds pattern-matching-related methods to [PasswordChange].
extension PasswordChangePatterns on PasswordChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SetPassword value)?  set,TResult Function( RemovePassword value)?  remove,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SetPassword() when set != null:
return set(_that);case RemovePassword() when remove != null:
return remove(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SetPassword value)  set,required TResult Function( RemovePassword value)  remove,}){
final _that = this;
switch (_that) {
case SetPassword():
return set(_that);case RemovePassword():
return remove(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SetPassword value)?  set,TResult? Function( RemovePassword value)?  remove,}){
final _that = this;
switch (_that) {
case SetPassword() when set != null:
return set(_that);case RemovePassword() when remove != null:
return remove(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String password)?  set,TResult Function()?  remove,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SetPassword() when set != null:
return set(_that.password);case RemovePassword() when remove != null:
return remove();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String password)  set,required TResult Function()  remove,}) {final _that = this;
switch (_that) {
case SetPassword():
return set(_that.password);case RemovePassword():
return remove();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String password)?  set,TResult? Function()?  remove,}) {final _that = this;
switch (_that) {
case SetPassword() when set != null:
return set(_that.password);case RemovePassword() when remove != null:
return remove();case _:
  return null;

}
}

}

/// @nodoc


class SetPassword implements PasswordChange {
  const SetPassword(this.password);
  

 final  String password;

/// Create a copy of PasswordChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetPasswordCopyWith<SetPassword> get copyWith => _$SetPasswordCopyWithImpl<SetPassword>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetPassword&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,password);



}

/// @nodoc
abstract mixin class $SetPasswordCopyWith<$Res> implements $PasswordChangeCopyWith<$Res> {
  factory $SetPasswordCopyWith(SetPassword value, $Res Function(SetPassword) _then) = _$SetPasswordCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class _$SetPasswordCopyWithImpl<$Res>
    implements $SetPasswordCopyWith<$Res> {
  _$SetPasswordCopyWithImpl(this._self, this._then);

  final SetPassword _self;
  final $Res Function(SetPassword) _then;

/// Create a copy of PasswordChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(SetPassword(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RemovePassword implements PasswordChange {
  const RemovePassword();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemovePassword);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc
mixin _$RoomPatch {

 bool? get locked; String? get name; PasswordChange? get password;
/// Create a copy of RoomPatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomPatchCopyWith<RoomPatch> get copyWith => _$RoomPatchCopyWithImpl<RoomPatch>(this as RoomPatch, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomPatch&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.name, name) || other.name == name)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,locked,name,password);

@override
String toString() {
  return 'RoomPatch(locked: $locked, name: $name, password: $password)';
}


}

/// @nodoc
abstract mixin class $RoomPatchCopyWith<$Res>  {
  factory $RoomPatchCopyWith(RoomPatch value, $Res Function(RoomPatch) _then) = _$RoomPatchCopyWithImpl;
@useResult
$Res call({
 bool? locked, String? name, PasswordChange? password
});


$PasswordChangeCopyWith<$Res>? get password;

}
/// @nodoc
class _$RoomPatchCopyWithImpl<$Res>
    implements $RoomPatchCopyWith<$Res> {
  _$RoomPatchCopyWithImpl(this._self, this._then);

  final RoomPatch _self;
  final $Res Function(RoomPatch) _then;

/// Create a copy of RoomPatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locked = freezed,Object? name = freezed,Object? password = freezed,}) {
  return _then(_self.copyWith(
locked: freezed == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as PasswordChange?,
  ));
}
/// Create a copy of RoomPatch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PasswordChangeCopyWith<$Res>? get password {
    if (_self.password == null) {
    return null;
  }

  return $PasswordChangeCopyWith<$Res>(_self.password!, (value) {
    return _then(_self.copyWith(password: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomPatch].
extension RoomPatchPatterns on RoomPatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomPatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomPatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomPatch value)  $default,){
final _that = this;
switch (_that) {
case _RoomPatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomPatch value)?  $default,){
final _that = this;
switch (_that) {
case _RoomPatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? locked,  String? name,  PasswordChange? password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomPatch() when $default != null:
return $default(_that.locked,_that.name,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? locked,  String? name,  PasswordChange? password)  $default,) {final _that = this;
switch (_that) {
case _RoomPatch():
return $default(_that.locked,_that.name,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? locked,  String? name,  PasswordChange? password)?  $default,) {final _that = this;
switch (_that) {
case _RoomPatch() when $default != null:
return $default(_that.locked,_that.name,_that.password);case _:
  return null;

}
}

}

/// @nodoc


class _RoomPatch implements RoomPatch {
  const _RoomPatch({this.locked, this.name, this.password});
  

@override final  bool? locked;
@override final  String? name;
@override final  PasswordChange? password;

/// Create a copy of RoomPatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomPatchCopyWith<_RoomPatch> get copyWith => __$RoomPatchCopyWithImpl<_RoomPatch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomPatch&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.name, name) || other.name == name)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,locked,name,password);

@override
String toString() {
  return 'RoomPatch(locked: $locked, name: $name, password: $password)';
}


}

/// @nodoc
abstract mixin class _$RoomPatchCopyWith<$Res> implements $RoomPatchCopyWith<$Res> {
  factory _$RoomPatchCopyWith(_RoomPatch value, $Res Function(_RoomPatch) _then) = __$RoomPatchCopyWithImpl;
@override @useResult
$Res call({
 bool? locked, String? name, PasswordChange? password
});


@override $PasswordChangeCopyWith<$Res>? get password;

}
/// @nodoc
class __$RoomPatchCopyWithImpl<$Res>
    implements _$RoomPatchCopyWith<$Res> {
  __$RoomPatchCopyWithImpl(this._self, this._then);

  final _RoomPatch _self;
  final $Res Function(_RoomPatch) _then;

/// Create a copy of RoomPatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locked = freezed,Object? name = freezed,Object? password = freezed,}) {
  return _then(_RoomPatch(
locked: freezed == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as PasswordChange?,
  ));
}

/// Create a copy of RoomPatch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PasswordChangeCopyWith<$Res>? get password {
    if (_self.password == null) {
    return null;
  }

  return $PasswordChangeCopyWith<$Res>(_self.password!, (value) {
    return _then(_self.copyWith(password: value));
  });
}
}

/// @nodoc
mixin _$RotatedCode {

 RoomCode get code; Uri get inviteUrl;
/// Create a copy of RotatedCode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RotatedCodeCopyWith<RotatedCode> get copyWith => _$RotatedCodeCopyWithImpl<RotatedCode>(this as RotatedCode, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RotatedCode&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl));
}


@override
int get hashCode => Object.hash(runtimeType,code,inviteUrl);

@override
String toString() {
  return 'RotatedCode(code: $code, inviteUrl: $inviteUrl)';
}


}

/// @nodoc
abstract mixin class $RotatedCodeCopyWith<$Res>  {
  factory $RotatedCodeCopyWith(RotatedCode value, $Res Function(RotatedCode) _then) = _$RotatedCodeCopyWithImpl;
@useResult
$Res call({
 RoomCode code, Uri inviteUrl
});


$RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class _$RotatedCodeCopyWithImpl<$Res>
    implements $RotatedCodeCopyWith<$Res> {
  _$RotatedCodeCopyWithImpl(this._self, this._then);

  final RotatedCode _self;
  final $Res Function(RotatedCode) _then;

/// Create a copy of RotatedCode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? inviteUrl = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}
/// Create a copy of RotatedCode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}


/// Adds pattern-matching-related methods to [RotatedCode].
extension RotatedCodePatterns on RotatedCode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RotatedCode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RotatedCode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RotatedCode value)  $default,){
final _that = this;
switch (_that) {
case _RotatedCode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RotatedCode value)?  $default,){
final _that = this;
switch (_that) {
case _RotatedCode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RoomCode code,  Uri inviteUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RotatedCode() when $default != null:
return $default(_that.code,_that.inviteUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RoomCode code,  Uri inviteUrl)  $default,) {final _that = this;
switch (_that) {
case _RotatedCode():
return $default(_that.code,_that.inviteUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RoomCode code,  Uri inviteUrl)?  $default,) {final _that = this;
switch (_that) {
case _RotatedCode() when $default != null:
return $default(_that.code,_that.inviteUrl);case _:
  return null;

}
}

}

/// @nodoc


class _RotatedCode implements RotatedCode {
  const _RotatedCode({required this.code, required this.inviteUrl});
  

@override final  RoomCode code;
@override final  Uri inviteUrl;

/// Create a copy of RotatedCode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RotatedCodeCopyWith<_RotatedCode> get copyWith => __$RotatedCodeCopyWithImpl<_RotatedCode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RotatedCode&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl));
}


@override
int get hashCode => Object.hash(runtimeType,code,inviteUrl);

@override
String toString() {
  return 'RotatedCode(code: $code, inviteUrl: $inviteUrl)';
}


}

/// @nodoc
abstract mixin class _$RotatedCodeCopyWith<$Res> implements $RotatedCodeCopyWith<$Res> {
  factory _$RotatedCodeCopyWith(_RotatedCode value, $Res Function(_RotatedCode) _then) = __$RotatedCodeCopyWithImpl;
@override @useResult
$Res call({
 RoomCode code, Uri inviteUrl
});


@override $RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class __$RotatedCodeCopyWithImpl<$Res>
    implements _$RotatedCodeCopyWith<$Res> {
  __$RotatedCodeCopyWithImpl(this._self, this._then);

  final _RotatedCode _self;
  final $Res Function(_RotatedCode) _then;

/// Create a copy of RotatedCode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? inviteUrl = null,}) {
  return _then(_RotatedCode(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}

/// Create a copy of RotatedCode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}

// dart format on
