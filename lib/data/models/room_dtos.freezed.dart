// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateRoomRequestDto {

@JsonKey(includeIfNull: false) String? get name;@JsonKey(includeIfNull: false) String? get password;@JsonKey(includeIfNull: false) int? get maxParticipants;@JsonKey(includeIfNull: false) int? get lifetimeMinutes;@JsonKey(includeIfNull: false) bool? get e2ee;
/// Create a copy of CreateRoomRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateRoomRequestDtoCopyWith<CreateRoomRequestDto> get copyWith => _$CreateRoomRequestDtoCopyWithImpl<CreateRoomRequestDto>(this as CreateRoomRequestDto, _$identity);

  /// Serializes this CreateRoomRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateRoomRequestDto&&(identical(other.name, name) || other.name == name)&&(identical(other.password, password) || other.password == password)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.lifetimeMinutes, lifetimeMinutes) || other.lifetimeMinutes == lifetimeMinutes)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,password,maxParticipants,lifetimeMinutes,e2ee);



}

/// @nodoc
abstract mixin class $CreateRoomRequestDtoCopyWith<$Res>  {
  factory $CreateRoomRequestDtoCopyWith(CreateRoomRequestDto value, $Res Function(CreateRoomRequestDto) _then) = _$CreateRoomRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? name,@JsonKey(includeIfNull: false) String? password,@JsonKey(includeIfNull: false) int? maxParticipants,@JsonKey(includeIfNull: false) int? lifetimeMinutes,@JsonKey(includeIfNull: false) bool? e2ee
});




}
/// @nodoc
class _$CreateRoomRequestDtoCopyWithImpl<$Res>
    implements $CreateRoomRequestDtoCopyWith<$Res> {
  _$CreateRoomRequestDtoCopyWithImpl(this._self, this._then);

  final CreateRoomRequestDto _self;
  final $Res Function(CreateRoomRequestDto) _then;

/// Create a copy of CreateRoomRequestDto
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


/// Adds pattern-matching-related methods to [CreateRoomRequestDto].
extension CreateRoomRequestDtoPatterns on CreateRoomRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateRoomRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateRoomRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateRoomRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _CreateRoomRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateRoomRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _CreateRoomRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? name, @JsonKey(includeIfNull: false)  String? password, @JsonKey(includeIfNull: false)  int? maxParticipants, @JsonKey(includeIfNull: false)  int? lifetimeMinutes, @JsonKey(includeIfNull: false)  bool? e2ee)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateRoomRequestDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? name, @JsonKey(includeIfNull: false)  String? password, @JsonKey(includeIfNull: false)  int? maxParticipants, @JsonKey(includeIfNull: false)  int? lifetimeMinutes, @JsonKey(includeIfNull: false)  bool? e2ee)  $default,) {final _that = this;
switch (_that) {
case _CreateRoomRequestDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? name, @JsonKey(includeIfNull: false)  String? password, @JsonKey(includeIfNull: false)  int? maxParticipants, @JsonKey(includeIfNull: false)  int? lifetimeMinutes, @JsonKey(includeIfNull: false)  bool? e2ee)?  $default,) {final _that = this;
switch (_that) {
case _CreateRoomRequestDto() when $default != null:
return $default(_that.name,_that.password,_that.maxParticipants,_that.lifetimeMinutes,_that.e2ee);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateRoomRequestDto extends CreateRoomRequestDto {
  const _CreateRoomRequestDto({@JsonKey(includeIfNull: false) this.name, @JsonKey(includeIfNull: false) this.password, @JsonKey(includeIfNull: false) this.maxParticipants, @JsonKey(includeIfNull: false) this.lifetimeMinutes, @JsonKey(includeIfNull: false) this.e2ee}): super._();
  factory _CreateRoomRequestDto.fromJson(Map<String, dynamic> json) => _$CreateRoomRequestDtoFromJson(json);

@override@JsonKey(includeIfNull: false) final  String? name;
@override@JsonKey(includeIfNull: false) final  String? password;
@override@JsonKey(includeIfNull: false) final  int? maxParticipants;
@override@JsonKey(includeIfNull: false) final  int? lifetimeMinutes;
@override@JsonKey(includeIfNull: false) final  bool? e2ee;

/// Create a copy of CreateRoomRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateRoomRequestDtoCopyWith<_CreateRoomRequestDto> get copyWith => __$CreateRoomRequestDtoCopyWithImpl<_CreateRoomRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateRoomRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRoomRequestDto&&(identical(other.name, name) || other.name == name)&&(identical(other.password, password) || other.password == password)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.lifetimeMinutes, lifetimeMinutes) || other.lifetimeMinutes == lifetimeMinutes)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,password,maxParticipants,lifetimeMinutes,e2ee);



}

/// @nodoc
abstract mixin class _$CreateRoomRequestDtoCopyWith<$Res> implements $CreateRoomRequestDtoCopyWith<$Res> {
  factory _$CreateRoomRequestDtoCopyWith(_CreateRoomRequestDto value, $Res Function(_CreateRoomRequestDto) _then) = __$CreateRoomRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? name,@JsonKey(includeIfNull: false) String? password,@JsonKey(includeIfNull: false) int? maxParticipants,@JsonKey(includeIfNull: false) int? lifetimeMinutes,@JsonKey(includeIfNull: false) bool? e2ee
});




}
/// @nodoc
class __$CreateRoomRequestDtoCopyWithImpl<$Res>
    implements _$CreateRoomRequestDtoCopyWith<$Res> {
  __$CreateRoomRequestDtoCopyWithImpl(this._self, this._then);

  final _CreateRoomRequestDto _self;
  final $Res Function(_CreateRoomRequestDto) _then;

/// Create a copy of CreateRoomRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? password = freezed,Object? maxParticipants = freezed,Object? lifetimeMinutes = freezed,Object? e2ee = freezed,}) {
  return _then(_CreateRoomRequestDto(
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
mixin _$CreateRoomResponseDto {

 String get roomId;@RoomCodeConverter() RoomCode get code;@HttpUriConverter() Uri get inviteUrl; String get ownerToken; String? get name; bool get passwordRequired; bool get e2ee; int get maxParticipants; DateTime get expiresAt;
/// Create a copy of CreateRoomResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateRoomResponseDtoCopyWith<CreateRoomResponseDto> get copyWith => _$CreateRoomResponseDtoCopyWithImpl<CreateRoomResponseDto>(this as CreateRoomResponseDto, _$identity);

  /// Serializes this CreateRoomResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateRoomResponseDto&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl)&&(identical(other.ownerToken, ownerToken) || other.ownerToken == ownerToken)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordRequired, passwordRequired) || other.passwordRequired == passwordRequired)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roomId,code,inviteUrl,ownerToken,name,passwordRequired,e2ee,maxParticipants,expiresAt);



}

/// @nodoc
abstract mixin class $CreateRoomResponseDtoCopyWith<$Res>  {
  factory $CreateRoomResponseDtoCopyWith(CreateRoomResponseDto value, $Res Function(CreateRoomResponseDto) _then) = _$CreateRoomResponseDtoCopyWithImpl;
@useResult
$Res call({
 String roomId,@RoomCodeConverter() RoomCode code,@HttpUriConverter() Uri inviteUrl, String ownerToken, String? name, bool passwordRequired, bool e2ee, int maxParticipants, DateTime expiresAt
});


$RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class _$CreateRoomResponseDtoCopyWithImpl<$Res>
    implements $CreateRoomResponseDtoCopyWith<$Res> {
  _$CreateRoomResponseDtoCopyWithImpl(this._self, this._then);

  final CreateRoomResponseDto _self;
  final $Res Function(CreateRoomResponseDto) _then;

/// Create a copy of CreateRoomResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomId = null,Object? code = null,Object? inviteUrl = null,Object? ownerToken = null,Object? name = freezed,Object? passwordRequired = null,Object? e2ee = null,Object? maxParticipants = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as Uri,ownerToken: null == ownerToken ? _self.ownerToken : ownerToken // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,passwordRequired: null == passwordRequired ? _self.passwordRequired : passwordRequired // ignore: cast_nullable_to_non_nullable
as bool,e2ee: null == e2ee ? _self.e2ee : e2ee // ignore: cast_nullable_to_non_nullable
as bool,maxParticipants: null == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of CreateRoomResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateRoomResponseDto].
extension CreateRoomResponseDtoPatterns on CreateRoomResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateRoomResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateRoomResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateRoomResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _CreateRoomResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateRoomResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _CreateRoomResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String roomId, @RoomCodeConverter()  RoomCode code, @HttpUriConverter()  Uri inviteUrl,  String ownerToken,  String? name,  bool passwordRequired,  bool e2ee,  int maxParticipants,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateRoomResponseDto() when $default != null:
return $default(_that.roomId,_that.code,_that.inviteUrl,_that.ownerToken,_that.name,_that.passwordRequired,_that.e2ee,_that.maxParticipants,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String roomId, @RoomCodeConverter()  RoomCode code, @HttpUriConverter()  Uri inviteUrl,  String ownerToken,  String? name,  bool passwordRequired,  bool e2ee,  int maxParticipants,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _CreateRoomResponseDto():
return $default(_that.roomId,_that.code,_that.inviteUrl,_that.ownerToken,_that.name,_that.passwordRequired,_that.e2ee,_that.maxParticipants,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String roomId, @RoomCodeConverter()  RoomCode code, @HttpUriConverter()  Uri inviteUrl,  String ownerToken,  String? name,  bool passwordRequired,  bool e2ee,  int maxParticipants,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _CreateRoomResponseDto() when $default != null:
return $default(_that.roomId,_that.code,_that.inviteUrl,_that.ownerToken,_that.name,_that.passwordRequired,_that.e2ee,_that.maxParticipants,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateRoomResponseDto extends CreateRoomResponseDto {
  const _CreateRoomResponseDto({required this.roomId, @RoomCodeConverter() required this.code, @HttpUriConverter() required this.inviteUrl, required this.ownerToken, this.name, required this.passwordRequired, required this.e2ee, required this.maxParticipants, required this.expiresAt}): super._();
  factory _CreateRoomResponseDto.fromJson(Map<String, dynamic> json) => _$CreateRoomResponseDtoFromJson(json);

@override final  String roomId;
@override@RoomCodeConverter() final  RoomCode code;
@override@HttpUriConverter() final  Uri inviteUrl;
@override final  String ownerToken;
@override final  String? name;
@override final  bool passwordRequired;
@override final  bool e2ee;
@override final  int maxParticipants;
@override final  DateTime expiresAt;

/// Create a copy of CreateRoomResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateRoomResponseDtoCopyWith<_CreateRoomResponseDto> get copyWith => __$CreateRoomResponseDtoCopyWithImpl<_CreateRoomResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateRoomResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRoomResponseDto&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl)&&(identical(other.ownerToken, ownerToken) || other.ownerToken == ownerToken)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordRequired, passwordRequired) || other.passwordRequired == passwordRequired)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roomId,code,inviteUrl,ownerToken,name,passwordRequired,e2ee,maxParticipants,expiresAt);



}

/// @nodoc
abstract mixin class _$CreateRoomResponseDtoCopyWith<$Res> implements $CreateRoomResponseDtoCopyWith<$Res> {
  factory _$CreateRoomResponseDtoCopyWith(_CreateRoomResponseDto value, $Res Function(_CreateRoomResponseDto) _then) = __$CreateRoomResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String roomId,@RoomCodeConverter() RoomCode code,@HttpUriConverter() Uri inviteUrl, String ownerToken, String? name, bool passwordRequired, bool e2ee, int maxParticipants, DateTime expiresAt
});


@override $RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class __$CreateRoomResponseDtoCopyWithImpl<$Res>
    implements _$CreateRoomResponseDtoCopyWith<$Res> {
  __$CreateRoomResponseDtoCopyWithImpl(this._self, this._then);

  final _CreateRoomResponseDto _self;
  final $Res Function(_CreateRoomResponseDto) _then;

/// Create a copy of CreateRoomResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomId = null,Object? code = null,Object? inviteUrl = null,Object? ownerToken = null,Object? name = freezed,Object? passwordRequired = null,Object? e2ee = null,Object? maxParticipants = null,Object? expiresAt = null,}) {
  return _then(_CreateRoomResponseDto(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as Uri,ownerToken: null == ownerToken ? _self.ownerToken : ownerToken // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,passwordRequired: null == passwordRequired ? _self.passwordRequired : passwordRequired // ignore: cast_nullable_to_non_nullable
as bool,e2ee: null == e2ee ? _self.e2ee : e2ee // ignore: cast_nullable_to_non_nullable
as bool,maxParticipants: null == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of CreateRoomResponseDto
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
mixin _$RoomSummaryDto implements DiagnosticableTreeMixin {

@RoomCodeConverter() RoomCode get code;@HttpUriConverter() Uri get inviteUrl; String? get name; bool get passwordRequired; bool get e2ee; bool get locked; DateTime get expiresAt;
/// Create a copy of RoomSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomSummaryDtoCopyWith<RoomSummaryDto> get copyWith => _$RoomSummaryDtoCopyWithImpl<RoomSummaryDto>(this as RoomSummaryDto, _$identity);

  /// Serializes this RoomSummaryDto to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomSummaryDto'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('inviteUrl', inviteUrl))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('passwordRequired', passwordRequired))..add(DiagnosticsProperty('e2ee', e2ee))..add(DiagnosticsProperty('locked', locked))..add(DiagnosticsProperty('expiresAt', expiresAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomSummaryDto&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordRequired, passwordRequired) || other.passwordRequired == passwordRequired)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,inviteUrl,name,passwordRequired,e2ee,locked,expiresAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomSummaryDto(code: $code, inviteUrl: $inviteUrl, name: $name, passwordRequired: $passwordRequired, e2ee: $e2ee, locked: $locked, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $RoomSummaryDtoCopyWith<$Res>  {
  factory $RoomSummaryDtoCopyWith(RoomSummaryDto value, $Res Function(RoomSummaryDto) _then) = _$RoomSummaryDtoCopyWithImpl;
@useResult
$Res call({
@RoomCodeConverter() RoomCode code,@HttpUriConverter() Uri inviteUrl, String? name, bool passwordRequired, bool e2ee, bool locked, DateTime expiresAt
});


$RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class _$RoomSummaryDtoCopyWithImpl<$Res>
    implements $RoomSummaryDtoCopyWith<$Res> {
  _$RoomSummaryDtoCopyWithImpl(this._self, this._then);

  final RoomSummaryDto _self;
  final $Res Function(RoomSummaryDto) _then;

/// Create a copy of RoomSummaryDto
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
/// Create a copy of RoomSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomSummaryDto].
extension RoomSummaryDtoPatterns on RoomSummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomSummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _RoomSummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _RoomSummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@RoomCodeConverter()  RoomCode code, @HttpUriConverter()  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  bool locked,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomSummaryDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@RoomCodeConverter()  RoomCode code, @HttpUriConverter()  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  bool locked,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _RoomSummaryDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@RoomCodeConverter()  RoomCode code, @HttpUriConverter()  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  bool locked,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _RoomSummaryDto() when $default != null:
return $default(_that.code,_that.inviteUrl,_that.name,_that.passwordRequired,_that.e2ee,_that.locked,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomSummaryDto extends RoomSummaryDto with DiagnosticableTreeMixin {
  const _RoomSummaryDto({@RoomCodeConverter() required this.code, @HttpUriConverter() required this.inviteUrl, this.name, required this.passwordRequired, required this.e2ee, required this.locked, required this.expiresAt}): super._();
  factory _RoomSummaryDto.fromJson(Map<String, dynamic> json) => _$RoomSummaryDtoFromJson(json);

@override@RoomCodeConverter() final  RoomCode code;
@override@HttpUriConverter() final  Uri inviteUrl;
@override final  String? name;
@override final  bool passwordRequired;
@override final  bool e2ee;
@override final  bool locked;
@override final  DateTime expiresAt;

/// Create a copy of RoomSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomSummaryDtoCopyWith<_RoomSummaryDto> get copyWith => __$RoomSummaryDtoCopyWithImpl<_RoomSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomSummaryDtoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomSummaryDto'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('inviteUrl', inviteUrl))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('passwordRequired', passwordRequired))..add(DiagnosticsProperty('e2ee', e2ee))..add(DiagnosticsProperty('locked', locked))..add(DiagnosticsProperty('expiresAt', expiresAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomSummaryDto&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordRequired, passwordRequired) || other.passwordRequired == passwordRequired)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,inviteUrl,name,passwordRequired,e2ee,locked,expiresAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomSummaryDto(code: $code, inviteUrl: $inviteUrl, name: $name, passwordRequired: $passwordRequired, e2ee: $e2ee, locked: $locked, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$RoomSummaryDtoCopyWith<$Res> implements $RoomSummaryDtoCopyWith<$Res> {
  factory _$RoomSummaryDtoCopyWith(_RoomSummaryDto value, $Res Function(_RoomSummaryDto) _then) = __$RoomSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
@RoomCodeConverter() RoomCode code,@HttpUriConverter() Uri inviteUrl, String? name, bool passwordRequired, bool e2ee, bool locked, DateTime expiresAt
});


@override $RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class __$RoomSummaryDtoCopyWithImpl<$Res>
    implements _$RoomSummaryDtoCopyWith<$Res> {
  __$RoomSummaryDtoCopyWithImpl(this._self, this._then);

  final _RoomSummaryDto _self;
  final $Res Function(_RoomSummaryDto) _then;

/// Create a copy of RoomSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? inviteUrl = null,Object? name = freezed,Object? passwordRequired = null,Object? e2ee = null,Object? locked = null,Object? expiresAt = null,}) {
  return _then(_RoomSummaryDto(
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

/// Create a copy of RoomSummaryDto
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
mixin _$JoinRequestDto {

 String get displayName; String get guestId;@JsonKey(includeIfNull: false) String? get password;
/// Create a copy of JoinRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinRequestDtoCopyWith<JoinRequestDto> get copyWith => _$JoinRequestDtoCopyWithImpl<JoinRequestDto>(this as JoinRequestDto, _$identity);

  /// Serializes this JoinRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinRequestDto&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.guestId, guestId) || other.guestId == guestId)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,guestId,password);



}

/// @nodoc
abstract mixin class $JoinRequestDtoCopyWith<$Res>  {
  factory $JoinRequestDtoCopyWith(JoinRequestDto value, $Res Function(JoinRequestDto) _then) = _$JoinRequestDtoCopyWithImpl;
@useResult
$Res call({
 String displayName, String guestId,@JsonKey(includeIfNull: false) String? password
});




}
/// @nodoc
class _$JoinRequestDtoCopyWithImpl<$Res>
    implements $JoinRequestDtoCopyWith<$Res> {
  _$JoinRequestDtoCopyWithImpl(this._self, this._then);

  final JoinRequestDto _self;
  final $Res Function(JoinRequestDto) _then;

/// Create a copy of JoinRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? guestId = null,Object? password = freezed,}) {
  return _then(_self.copyWith(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,guestId: null == guestId ? _self.guestId : guestId // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JoinRequestDto].
extension JoinRequestDtoPatterns on JoinRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JoinRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JoinRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JoinRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _JoinRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JoinRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _JoinRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String displayName,  String guestId, @JsonKey(includeIfNull: false)  String? password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JoinRequestDto() when $default != null:
return $default(_that.displayName,_that.guestId,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String displayName,  String guestId, @JsonKey(includeIfNull: false)  String? password)  $default,) {final _that = this;
switch (_that) {
case _JoinRequestDto():
return $default(_that.displayName,_that.guestId,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String displayName,  String guestId, @JsonKey(includeIfNull: false)  String? password)?  $default,) {final _that = this;
switch (_that) {
case _JoinRequestDto() when $default != null:
return $default(_that.displayName,_that.guestId,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JoinRequestDto extends JoinRequestDto {
  const _JoinRequestDto({required this.displayName, required this.guestId, @JsonKey(includeIfNull: false) this.password}): super._();
  factory _JoinRequestDto.fromJson(Map<String, dynamic> json) => _$JoinRequestDtoFromJson(json);

@override final  String displayName;
@override final  String guestId;
@override@JsonKey(includeIfNull: false) final  String? password;

/// Create a copy of JoinRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JoinRequestDtoCopyWith<_JoinRequestDto> get copyWith => __$JoinRequestDtoCopyWithImpl<_JoinRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JoinRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinRequestDto&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.guestId, guestId) || other.guestId == guestId)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,guestId,password);



}

/// @nodoc
abstract mixin class _$JoinRequestDtoCopyWith<$Res> implements $JoinRequestDtoCopyWith<$Res> {
  factory _$JoinRequestDtoCopyWith(_JoinRequestDto value, $Res Function(_JoinRequestDto) _then) = __$JoinRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String displayName, String guestId,@JsonKey(includeIfNull: false) String? password
});




}
/// @nodoc
class __$JoinRequestDtoCopyWithImpl<$Res>
    implements _$JoinRequestDtoCopyWith<$Res> {
  __$JoinRequestDtoCopyWithImpl(this._self, this._then);

  final _JoinRequestDto _self;
  final $Res Function(_JoinRequestDto) _then;

/// Create a copy of JoinRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? guestId = null,Object? password = freezed,}) {
  return _then(_JoinRequestDto(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,guestId: null == guestId ? _self.guestId : guestId // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RoomInfoDto implements DiagnosticableTreeMixin {

@RoomCodeConverter() RoomCode get code;@HttpUriConverter() Uri get inviteUrl; String? get name; bool get passwordRequired; bool get e2ee; bool get locked; int get maxParticipants; DateTime get expiresAt;
/// Create a copy of RoomInfoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomInfoDtoCopyWith<RoomInfoDto> get copyWith => _$RoomInfoDtoCopyWithImpl<RoomInfoDto>(this as RoomInfoDto, _$identity);

  /// Serializes this RoomInfoDto to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomInfoDto'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('inviteUrl', inviteUrl))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('passwordRequired', passwordRequired))..add(DiagnosticsProperty('e2ee', e2ee))..add(DiagnosticsProperty('locked', locked))..add(DiagnosticsProperty('maxParticipants', maxParticipants))..add(DiagnosticsProperty('expiresAt', expiresAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomInfoDto&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordRequired, passwordRequired) || other.passwordRequired == passwordRequired)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,inviteUrl,name,passwordRequired,e2ee,locked,maxParticipants,expiresAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomInfoDto(code: $code, inviteUrl: $inviteUrl, name: $name, passwordRequired: $passwordRequired, e2ee: $e2ee, locked: $locked, maxParticipants: $maxParticipants, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $RoomInfoDtoCopyWith<$Res>  {
  factory $RoomInfoDtoCopyWith(RoomInfoDto value, $Res Function(RoomInfoDto) _then) = _$RoomInfoDtoCopyWithImpl;
@useResult
$Res call({
@RoomCodeConverter() RoomCode code,@HttpUriConverter() Uri inviteUrl, String? name, bool passwordRequired, bool e2ee, bool locked, int maxParticipants, DateTime expiresAt
});


$RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class _$RoomInfoDtoCopyWithImpl<$Res>
    implements $RoomInfoDtoCopyWith<$Res> {
  _$RoomInfoDtoCopyWithImpl(this._self, this._then);

  final RoomInfoDto _self;
  final $Res Function(RoomInfoDto) _then;

/// Create a copy of RoomInfoDto
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
/// Create a copy of RoomInfoDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomInfoDto].
extension RoomInfoDtoPatterns on RoomInfoDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomInfoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomInfoDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomInfoDto value)  $default,){
final _that = this;
switch (_that) {
case _RoomInfoDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomInfoDto value)?  $default,){
final _that = this;
switch (_that) {
case _RoomInfoDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@RoomCodeConverter()  RoomCode code, @HttpUriConverter()  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  bool locked,  int maxParticipants,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomInfoDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@RoomCodeConverter()  RoomCode code, @HttpUriConverter()  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  bool locked,  int maxParticipants,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _RoomInfoDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@RoomCodeConverter()  RoomCode code, @HttpUriConverter()  Uri inviteUrl,  String? name,  bool passwordRequired,  bool e2ee,  bool locked,  int maxParticipants,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _RoomInfoDto() when $default != null:
return $default(_that.code,_that.inviteUrl,_that.name,_that.passwordRequired,_that.e2ee,_that.locked,_that.maxParticipants,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomInfoDto extends RoomInfoDto with DiagnosticableTreeMixin {
  const _RoomInfoDto({@RoomCodeConverter() required this.code, @HttpUriConverter() required this.inviteUrl, this.name, required this.passwordRequired, required this.e2ee, required this.locked, required this.maxParticipants, required this.expiresAt}): super._();
  factory _RoomInfoDto.fromJson(Map<String, dynamic> json) => _$RoomInfoDtoFromJson(json);

@override@RoomCodeConverter() final  RoomCode code;
@override@HttpUriConverter() final  Uri inviteUrl;
@override final  String? name;
@override final  bool passwordRequired;
@override final  bool e2ee;
@override final  bool locked;
@override final  int maxParticipants;
@override final  DateTime expiresAt;

/// Create a copy of RoomInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomInfoDtoCopyWith<_RoomInfoDto> get copyWith => __$RoomInfoDtoCopyWithImpl<_RoomInfoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomInfoDtoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomInfoDto'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('inviteUrl', inviteUrl))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('passwordRequired', passwordRequired))..add(DiagnosticsProperty('e2ee', e2ee))..add(DiagnosticsProperty('locked', locked))..add(DiagnosticsProperty('maxParticipants', maxParticipants))..add(DiagnosticsProperty('expiresAt', expiresAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomInfoDto&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordRequired, passwordRequired) || other.passwordRequired == passwordRequired)&&(identical(other.e2ee, e2ee) || other.e2ee == e2ee)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,inviteUrl,name,passwordRequired,e2ee,locked,maxParticipants,expiresAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomInfoDto(code: $code, inviteUrl: $inviteUrl, name: $name, passwordRequired: $passwordRequired, e2ee: $e2ee, locked: $locked, maxParticipants: $maxParticipants, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$RoomInfoDtoCopyWith<$Res> implements $RoomInfoDtoCopyWith<$Res> {
  factory _$RoomInfoDtoCopyWith(_RoomInfoDto value, $Res Function(_RoomInfoDto) _then) = __$RoomInfoDtoCopyWithImpl;
@override @useResult
$Res call({
@RoomCodeConverter() RoomCode code,@HttpUriConverter() Uri inviteUrl, String? name, bool passwordRequired, bool e2ee, bool locked, int maxParticipants, DateTime expiresAt
});


@override $RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class __$RoomInfoDtoCopyWithImpl<$Res>
    implements _$RoomInfoDtoCopyWith<$Res> {
  __$RoomInfoDtoCopyWithImpl(this._self, this._then);

  final _RoomInfoDto _self;
  final $Res Function(_RoomInfoDto) _then;

/// Create a copy of RoomInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? inviteUrl = null,Object? name = freezed,Object? passwordRequired = null,Object? e2ee = null,Object? locked = null,Object? maxParticipants = null,Object? expiresAt = null,}) {
  return _then(_RoomInfoDto(
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

/// Create a copy of RoomInfoDto
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
mixin _$RoomJoinDto {

 String get token; String get livekitUrl; String get identity; RoomRole get role; RoomInfoDto get room;
/// Create a copy of RoomJoinDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomJoinDtoCopyWith<RoomJoinDto> get copyWith => _$RoomJoinDtoCopyWithImpl<RoomJoinDto>(this as RoomJoinDto, _$identity);

  /// Serializes this RoomJoinDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomJoinDto&&(identical(other.token, token) || other.token == token)&&(identical(other.livekitUrl, livekitUrl) || other.livekitUrl == livekitUrl)&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.role, role) || other.role == role)&&(identical(other.room, room) || other.room == room));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,livekitUrl,identity,role,room);



}

/// @nodoc
abstract mixin class $RoomJoinDtoCopyWith<$Res>  {
  factory $RoomJoinDtoCopyWith(RoomJoinDto value, $Res Function(RoomJoinDto) _then) = _$RoomJoinDtoCopyWithImpl;
@useResult
$Res call({
 String token, String livekitUrl, String identity, RoomRole role, RoomInfoDto room
});


$RoomInfoDtoCopyWith<$Res> get room;

}
/// @nodoc
class _$RoomJoinDtoCopyWithImpl<$Res>
    implements $RoomJoinDtoCopyWith<$Res> {
  _$RoomJoinDtoCopyWithImpl(this._self, this._then);

  final RoomJoinDto _self;
  final $Res Function(RoomJoinDto) _then;

/// Create a copy of RoomJoinDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? livekitUrl = null,Object? identity = null,Object? role = null,Object? room = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,livekitUrl: null == livekitUrl ? _self.livekitUrl : livekitUrl // ignore: cast_nullable_to_non_nullable
as String,identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoomRole,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as RoomInfoDto,
  ));
}
/// Create a copy of RoomJoinDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomInfoDtoCopyWith<$Res> get room {
  
  return $RoomInfoDtoCopyWith<$Res>(_self.room, (value) {
    return _then(_self.copyWith(room: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomJoinDto].
extension RoomJoinDtoPatterns on RoomJoinDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomJoinDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomJoinDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomJoinDto value)  $default,){
final _that = this;
switch (_that) {
case _RoomJoinDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomJoinDto value)?  $default,){
final _that = this;
switch (_that) {
case _RoomJoinDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String livekitUrl,  String identity,  RoomRole role,  RoomInfoDto room)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomJoinDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String livekitUrl,  String identity,  RoomRole role,  RoomInfoDto room)  $default,) {final _that = this;
switch (_that) {
case _RoomJoinDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String livekitUrl,  String identity,  RoomRole role,  RoomInfoDto room)?  $default,) {final _that = this;
switch (_that) {
case _RoomJoinDto() when $default != null:
return $default(_that.token,_that.livekitUrl,_that.identity,_that.role,_that.room);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomJoinDto extends RoomJoinDto {
  const _RoomJoinDto({required this.token, required this.livekitUrl, required this.identity, required this.role, required this.room}): super._();
  factory _RoomJoinDto.fromJson(Map<String, dynamic> json) => _$RoomJoinDtoFromJson(json);

@override final  String token;
@override final  String livekitUrl;
@override final  String identity;
@override final  RoomRole role;
@override final  RoomInfoDto room;

/// Create a copy of RoomJoinDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomJoinDtoCopyWith<_RoomJoinDto> get copyWith => __$RoomJoinDtoCopyWithImpl<_RoomJoinDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomJoinDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomJoinDto&&(identical(other.token, token) || other.token == token)&&(identical(other.livekitUrl, livekitUrl) || other.livekitUrl == livekitUrl)&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.role, role) || other.role == role)&&(identical(other.room, room) || other.room == room));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,livekitUrl,identity,role,room);



}

/// @nodoc
abstract mixin class _$RoomJoinDtoCopyWith<$Res> implements $RoomJoinDtoCopyWith<$Res> {
  factory _$RoomJoinDtoCopyWith(_RoomJoinDto value, $Res Function(_RoomJoinDto) _then) = __$RoomJoinDtoCopyWithImpl;
@override @useResult
$Res call({
 String token, String livekitUrl, String identity, RoomRole role, RoomInfoDto room
});


@override $RoomInfoDtoCopyWith<$Res> get room;

}
/// @nodoc
class __$RoomJoinDtoCopyWithImpl<$Res>
    implements _$RoomJoinDtoCopyWith<$Res> {
  __$RoomJoinDtoCopyWithImpl(this._self, this._then);

  final _RoomJoinDto _self;
  final $Res Function(_RoomJoinDto) _then;

/// Create a copy of RoomJoinDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? livekitUrl = null,Object? identity = null,Object? role = null,Object? room = null,}) {
  return _then(_RoomJoinDto(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,livekitUrl: null == livekitUrl ? _self.livekitUrl : livekitUrl // ignore: cast_nullable_to_non_nullable
as String,identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoomRole,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as RoomInfoDto,
  ));
}

/// Create a copy of RoomJoinDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomInfoDtoCopyWith<$Res> get room {
  
  return $RoomInfoDtoCopyWith<$Res>(_self.room, (value) {
    return _then(_self.copyWith(room: value));
  });
}
}


/// @nodoc
mixin _$RotatedCodeDto implements DiagnosticableTreeMixin {

@RoomCodeConverter() RoomCode get code;@HttpUriConverter() Uri get inviteUrl;
/// Create a copy of RotatedCodeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RotatedCodeDtoCopyWith<RotatedCodeDto> get copyWith => _$RotatedCodeDtoCopyWithImpl<RotatedCodeDto>(this as RotatedCodeDto, _$identity);

  /// Serializes this RotatedCodeDto to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RotatedCodeDto'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('inviteUrl', inviteUrl));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RotatedCodeDto&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,inviteUrl);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RotatedCodeDto(code: $code, inviteUrl: $inviteUrl)';
}


}

/// @nodoc
abstract mixin class $RotatedCodeDtoCopyWith<$Res>  {
  factory $RotatedCodeDtoCopyWith(RotatedCodeDto value, $Res Function(RotatedCodeDto) _then) = _$RotatedCodeDtoCopyWithImpl;
@useResult
$Res call({
@RoomCodeConverter() RoomCode code,@HttpUriConverter() Uri inviteUrl
});


$RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class _$RotatedCodeDtoCopyWithImpl<$Res>
    implements $RotatedCodeDtoCopyWith<$Res> {
  _$RotatedCodeDtoCopyWithImpl(this._self, this._then);

  final RotatedCodeDto _self;
  final $Res Function(RotatedCodeDto) _then;

/// Create a copy of RotatedCodeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? inviteUrl = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}
/// Create a copy of RotatedCodeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}


/// Adds pattern-matching-related methods to [RotatedCodeDto].
extension RotatedCodeDtoPatterns on RotatedCodeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RotatedCodeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RotatedCodeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RotatedCodeDto value)  $default,){
final _that = this;
switch (_that) {
case _RotatedCodeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RotatedCodeDto value)?  $default,){
final _that = this;
switch (_that) {
case _RotatedCodeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@RoomCodeConverter()  RoomCode code, @HttpUriConverter()  Uri inviteUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RotatedCodeDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@RoomCodeConverter()  RoomCode code, @HttpUriConverter()  Uri inviteUrl)  $default,) {final _that = this;
switch (_that) {
case _RotatedCodeDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@RoomCodeConverter()  RoomCode code, @HttpUriConverter()  Uri inviteUrl)?  $default,) {final _that = this;
switch (_that) {
case _RotatedCodeDto() when $default != null:
return $default(_that.code,_that.inviteUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RotatedCodeDto extends RotatedCodeDto with DiagnosticableTreeMixin {
  const _RotatedCodeDto({@RoomCodeConverter() required this.code, @HttpUriConverter() required this.inviteUrl}): super._();
  factory _RotatedCodeDto.fromJson(Map<String, dynamic> json) => _$RotatedCodeDtoFromJson(json);

@override@RoomCodeConverter() final  RoomCode code;
@override@HttpUriConverter() final  Uri inviteUrl;

/// Create a copy of RotatedCodeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RotatedCodeDtoCopyWith<_RotatedCodeDto> get copyWith => __$RotatedCodeDtoCopyWithImpl<_RotatedCodeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RotatedCodeDtoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RotatedCodeDto'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('inviteUrl', inviteUrl));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RotatedCodeDto&&(identical(other.code, code) || other.code == code)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,inviteUrl);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RotatedCodeDto(code: $code, inviteUrl: $inviteUrl)';
}


}

/// @nodoc
abstract mixin class _$RotatedCodeDtoCopyWith<$Res> implements $RotatedCodeDtoCopyWith<$Res> {
  factory _$RotatedCodeDtoCopyWith(_RotatedCodeDto value, $Res Function(_RotatedCodeDto) _then) = __$RotatedCodeDtoCopyWithImpl;
@override @useResult
$Res call({
@RoomCodeConverter() RoomCode code,@HttpUriConverter() Uri inviteUrl
});


@override $RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class __$RotatedCodeDtoCopyWithImpl<$Res>
    implements _$RotatedCodeDtoCopyWith<$Res> {
  __$RotatedCodeDtoCopyWithImpl(this._self, this._then);

  final _RotatedCodeDto _self;
  final $Res Function(_RotatedCodeDto) _then;

/// Create a copy of RotatedCodeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? inviteUrl = null,}) {
  return _then(_RotatedCodeDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}

/// Create a copy of RotatedCodeDto
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
