// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure()';
}


}

/// @nodoc
class $FailureCopyWith<$Res>  {
$FailureCopyWith(Failure _, $Res Function(Failure) __);
}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RoomNotFoundFailure value)?  roomNotFound,TResult Function( PasswordRequiredFailure value)?  passwordRequired,TResult Function( InvalidPasswordFailure value)?  invalidPassword,TResult Function( RoomFullFailure value)?  roomFull,TResult Function( RoomLockedFailure value)?  roomLocked,TResult Function( TooManyAttemptsFailure value)?  tooManyAttempts,TResult Function( ServerBusyFailure value)?  serverBusy,TResult Function( InvalidCodeFailure value)?  invalidCode,TResult Function( ForbiddenFailure value)?  forbidden,TResult Function( ParticipantBannedFailure value)?  participantBanned,TResult Function( ParticipantNotFoundFailure value)?  participantNotFound,TResult Function( InvalidInputFailure value)?  invalidInput,TResult Function( MediaDeviceFailure value)?  mediaDevice,TResult Function( NetworkFailure value)?  network,TResult Function( ServerFailure value)?  server,TResult Function( UnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RoomNotFoundFailure() when roomNotFound != null:
return roomNotFound(_that);case PasswordRequiredFailure() when passwordRequired != null:
return passwordRequired(_that);case InvalidPasswordFailure() when invalidPassword != null:
return invalidPassword(_that);case RoomFullFailure() when roomFull != null:
return roomFull(_that);case RoomLockedFailure() when roomLocked != null:
return roomLocked(_that);case TooManyAttemptsFailure() when tooManyAttempts != null:
return tooManyAttempts(_that);case ServerBusyFailure() when serverBusy != null:
return serverBusy(_that);case InvalidCodeFailure() when invalidCode != null:
return invalidCode(_that);case ForbiddenFailure() when forbidden != null:
return forbidden(_that);case ParticipantBannedFailure() when participantBanned != null:
return participantBanned(_that);case ParticipantNotFoundFailure() when participantNotFound != null:
return participantNotFound(_that);case InvalidInputFailure() when invalidInput != null:
return invalidInput(_that);case MediaDeviceFailure() when mediaDevice != null:
return mediaDevice(_that);case NetworkFailure() when network != null:
return network(_that);case ServerFailure() when server != null:
return server(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RoomNotFoundFailure value)  roomNotFound,required TResult Function( PasswordRequiredFailure value)  passwordRequired,required TResult Function( InvalidPasswordFailure value)  invalidPassword,required TResult Function( RoomFullFailure value)  roomFull,required TResult Function( RoomLockedFailure value)  roomLocked,required TResult Function( TooManyAttemptsFailure value)  tooManyAttempts,required TResult Function( ServerBusyFailure value)  serverBusy,required TResult Function( InvalidCodeFailure value)  invalidCode,required TResult Function( ForbiddenFailure value)  forbidden,required TResult Function( ParticipantBannedFailure value)  participantBanned,required TResult Function( ParticipantNotFoundFailure value)  participantNotFound,required TResult Function( InvalidInputFailure value)  invalidInput,required TResult Function( MediaDeviceFailure value)  mediaDevice,required TResult Function( NetworkFailure value)  network,required TResult Function( ServerFailure value)  server,required TResult Function( UnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case RoomNotFoundFailure():
return roomNotFound(_that);case PasswordRequiredFailure():
return passwordRequired(_that);case InvalidPasswordFailure():
return invalidPassword(_that);case RoomFullFailure():
return roomFull(_that);case RoomLockedFailure():
return roomLocked(_that);case TooManyAttemptsFailure():
return tooManyAttempts(_that);case ServerBusyFailure():
return serverBusy(_that);case InvalidCodeFailure():
return invalidCode(_that);case ForbiddenFailure():
return forbidden(_that);case ParticipantBannedFailure():
return participantBanned(_that);case ParticipantNotFoundFailure():
return participantNotFound(_that);case InvalidInputFailure():
return invalidInput(_that);case MediaDeviceFailure():
return mediaDevice(_that);case NetworkFailure():
return network(_that);case ServerFailure():
return server(_that);case UnknownFailure():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RoomNotFoundFailure value)?  roomNotFound,TResult? Function( PasswordRequiredFailure value)?  passwordRequired,TResult? Function( InvalidPasswordFailure value)?  invalidPassword,TResult? Function( RoomFullFailure value)?  roomFull,TResult? Function( RoomLockedFailure value)?  roomLocked,TResult? Function( TooManyAttemptsFailure value)?  tooManyAttempts,TResult? Function( ServerBusyFailure value)?  serverBusy,TResult? Function( InvalidCodeFailure value)?  invalidCode,TResult? Function( ForbiddenFailure value)?  forbidden,TResult? Function( ParticipantBannedFailure value)?  participantBanned,TResult? Function( ParticipantNotFoundFailure value)?  participantNotFound,TResult? Function( InvalidInputFailure value)?  invalidInput,TResult? Function( MediaDeviceFailure value)?  mediaDevice,TResult? Function( NetworkFailure value)?  network,TResult? Function( ServerFailure value)?  server,TResult? Function( UnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case RoomNotFoundFailure() when roomNotFound != null:
return roomNotFound(_that);case PasswordRequiredFailure() when passwordRequired != null:
return passwordRequired(_that);case InvalidPasswordFailure() when invalidPassword != null:
return invalidPassword(_that);case RoomFullFailure() when roomFull != null:
return roomFull(_that);case RoomLockedFailure() when roomLocked != null:
return roomLocked(_that);case TooManyAttemptsFailure() when tooManyAttempts != null:
return tooManyAttempts(_that);case ServerBusyFailure() when serverBusy != null:
return serverBusy(_that);case InvalidCodeFailure() when invalidCode != null:
return invalidCode(_that);case ForbiddenFailure() when forbidden != null:
return forbidden(_that);case ParticipantBannedFailure() when participantBanned != null:
return participantBanned(_that);case ParticipantNotFoundFailure() when participantNotFound != null:
return participantNotFound(_that);case InvalidInputFailure() when invalidInput != null:
return invalidInput(_that);case MediaDeviceFailure() when mediaDevice != null:
return mediaDevice(_that);case NetworkFailure() when network != null:
return network(_that);case ServerFailure() when server != null:
return server(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  roomNotFound,TResult Function()?  passwordRequired,TResult Function()?  invalidPassword,TResult Function()?  roomFull,TResult Function()?  roomLocked,TResult Function( Duration? retryAfter)?  tooManyAttempts,TResult Function( Duration? retryAfter)?  serverBusy,TResult Function()?  invalidCode,TResult Function()?  forbidden,TResult Function()?  participantBanned,TResult Function()?  participantNotFound,TResult Function( InputField field)?  invalidInput,TResult Function()?  mediaDevice,TResult Function()?  network,TResult Function( int? statusCode)?  server,TResult Function( int? statusCode,  String? code)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RoomNotFoundFailure() when roomNotFound != null:
return roomNotFound();case PasswordRequiredFailure() when passwordRequired != null:
return passwordRequired();case InvalidPasswordFailure() when invalidPassword != null:
return invalidPassword();case RoomFullFailure() when roomFull != null:
return roomFull();case RoomLockedFailure() when roomLocked != null:
return roomLocked();case TooManyAttemptsFailure() when tooManyAttempts != null:
return tooManyAttempts(_that.retryAfter);case ServerBusyFailure() when serverBusy != null:
return serverBusy(_that.retryAfter);case InvalidCodeFailure() when invalidCode != null:
return invalidCode();case ForbiddenFailure() when forbidden != null:
return forbidden();case ParticipantBannedFailure() when participantBanned != null:
return participantBanned();case ParticipantNotFoundFailure() when participantNotFound != null:
return participantNotFound();case InvalidInputFailure() when invalidInput != null:
return invalidInput(_that.field);case MediaDeviceFailure() when mediaDevice != null:
return mediaDevice();case NetworkFailure() when network != null:
return network();case ServerFailure() when server != null:
return server(_that.statusCode);case UnknownFailure() when unknown != null:
return unknown(_that.statusCode,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  roomNotFound,required TResult Function()  passwordRequired,required TResult Function()  invalidPassword,required TResult Function()  roomFull,required TResult Function()  roomLocked,required TResult Function( Duration? retryAfter)  tooManyAttempts,required TResult Function( Duration? retryAfter)  serverBusy,required TResult Function()  invalidCode,required TResult Function()  forbidden,required TResult Function()  participantBanned,required TResult Function()  participantNotFound,required TResult Function( InputField field)  invalidInput,required TResult Function()  mediaDevice,required TResult Function()  network,required TResult Function( int? statusCode)  server,required TResult Function( int? statusCode,  String? code)  unknown,}) {final _that = this;
switch (_that) {
case RoomNotFoundFailure():
return roomNotFound();case PasswordRequiredFailure():
return passwordRequired();case InvalidPasswordFailure():
return invalidPassword();case RoomFullFailure():
return roomFull();case RoomLockedFailure():
return roomLocked();case TooManyAttemptsFailure():
return tooManyAttempts(_that.retryAfter);case ServerBusyFailure():
return serverBusy(_that.retryAfter);case InvalidCodeFailure():
return invalidCode();case ForbiddenFailure():
return forbidden();case ParticipantBannedFailure():
return participantBanned();case ParticipantNotFoundFailure():
return participantNotFound();case InvalidInputFailure():
return invalidInput(_that.field);case MediaDeviceFailure():
return mediaDevice();case NetworkFailure():
return network();case ServerFailure():
return server(_that.statusCode);case UnknownFailure():
return unknown(_that.statusCode,_that.code);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  roomNotFound,TResult? Function()?  passwordRequired,TResult? Function()?  invalidPassword,TResult? Function()?  roomFull,TResult? Function()?  roomLocked,TResult? Function( Duration? retryAfter)?  tooManyAttempts,TResult? Function( Duration? retryAfter)?  serverBusy,TResult? Function()?  invalidCode,TResult? Function()?  forbidden,TResult? Function()?  participantBanned,TResult? Function()?  participantNotFound,TResult? Function( InputField field)?  invalidInput,TResult? Function()?  mediaDevice,TResult? Function()?  network,TResult? Function( int? statusCode)?  server,TResult? Function( int? statusCode,  String? code)?  unknown,}) {final _that = this;
switch (_that) {
case RoomNotFoundFailure() when roomNotFound != null:
return roomNotFound();case PasswordRequiredFailure() when passwordRequired != null:
return passwordRequired();case InvalidPasswordFailure() when invalidPassword != null:
return invalidPassword();case RoomFullFailure() when roomFull != null:
return roomFull();case RoomLockedFailure() when roomLocked != null:
return roomLocked();case TooManyAttemptsFailure() when tooManyAttempts != null:
return tooManyAttempts(_that.retryAfter);case ServerBusyFailure() when serverBusy != null:
return serverBusy(_that.retryAfter);case InvalidCodeFailure() when invalidCode != null:
return invalidCode();case ForbiddenFailure() when forbidden != null:
return forbidden();case ParticipantBannedFailure() when participantBanned != null:
return participantBanned();case ParticipantNotFoundFailure() when participantNotFound != null:
return participantNotFound();case InvalidInputFailure() when invalidInput != null:
return invalidInput(_that.field);case MediaDeviceFailure() when mediaDevice != null:
return mediaDevice();case NetworkFailure() when network != null:
return network();case ServerFailure() when server != null:
return server(_that.statusCode);case UnknownFailure() when unknown != null:
return unknown(_that.statusCode,_that.code);case _:
  return null;

}
}

}

/// @nodoc


class RoomNotFoundFailure extends Failure {
  const RoomNotFoundFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomNotFoundFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.roomNotFound()';
}


}




/// @nodoc


class PasswordRequiredFailure extends Failure {
  const PasswordRequiredFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordRequiredFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.passwordRequired()';
}


}




/// @nodoc


class InvalidPasswordFailure extends Failure {
  const InvalidPasswordFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidPasswordFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.invalidPassword()';
}


}




/// @nodoc


class RoomFullFailure extends Failure {
  const RoomFullFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomFullFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.roomFull()';
}


}




/// @nodoc


class RoomLockedFailure extends Failure {
  const RoomLockedFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomLockedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.roomLocked()';
}


}




/// @nodoc


class TooManyAttemptsFailure extends Failure {
  const TooManyAttemptsFailure({this.retryAfter}): super._();
  

 final  Duration? retryAfter;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TooManyAttemptsFailureCopyWith<TooManyAttemptsFailure> get copyWith => _$TooManyAttemptsFailureCopyWithImpl<TooManyAttemptsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TooManyAttemptsFailure&&(identical(other.retryAfter, retryAfter) || other.retryAfter == retryAfter));
}


@override
int get hashCode => Object.hash(runtimeType,retryAfter);

@override
String toString() {
  return 'Failure.tooManyAttempts(retryAfter: $retryAfter)';
}


}

/// @nodoc
abstract mixin class $TooManyAttemptsFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $TooManyAttemptsFailureCopyWith(TooManyAttemptsFailure value, $Res Function(TooManyAttemptsFailure) _then) = _$TooManyAttemptsFailureCopyWithImpl;
@useResult
$Res call({
 Duration? retryAfter
});




}
/// @nodoc
class _$TooManyAttemptsFailureCopyWithImpl<$Res>
    implements $TooManyAttemptsFailureCopyWith<$Res> {
  _$TooManyAttemptsFailureCopyWithImpl(this._self, this._then);

  final TooManyAttemptsFailure _self;
  final $Res Function(TooManyAttemptsFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? retryAfter = freezed,}) {
  return _then(TooManyAttemptsFailure(
retryAfter: freezed == retryAfter ? _self.retryAfter : retryAfter // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

/// @nodoc


class ServerBusyFailure extends Failure {
  const ServerBusyFailure({this.retryAfter}): super._();
  

 final  Duration? retryAfter;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerBusyFailureCopyWith<ServerBusyFailure> get copyWith => _$ServerBusyFailureCopyWithImpl<ServerBusyFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerBusyFailure&&(identical(other.retryAfter, retryAfter) || other.retryAfter == retryAfter));
}


@override
int get hashCode => Object.hash(runtimeType,retryAfter);

@override
String toString() {
  return 'Failure.serverBusy(retryAfter: $retryAfter)';
}


}

/// @nodoc
abstract mixin class $ServerBusyFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ServerBusyFailureCopyWith(ServerBusyFailure value, $Res Function(ServerBusyFailure) _then) = _$ServerBusyFailureCopyWithImpl;
@useResult
$Res call({
 Duration? retryAfter
});




}
/// @nodoc
class _$ServerBusyFailureCopyWithImpl<$Res>
    implements $ServerBusyFailureCopyWith<$Res> {
  _$ServerBusyFailureCopyWithImpl(this._self, this._then);

  final ServerBusyFailure _self;
  final $Res Function(ServerBusyFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? retryAfter = freezed,}) {
  return _then(ServerBusyFailure(
retryAfter: freezed == retryAfter ? _self.retryAfter : retryAfter // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

/// @nodoc


class InvalidCodeFailure extends Failure {
  const InvalidCodeFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidCodeFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.invalidCode()';
}


}




/// @nodoc


class ForbiddenFailure extends Failure {
  const ForbiddenFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForbiddenFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.forbidden()';
}


}




/// @nodoc


class ParticipantBannedFailure extends Failure {
  const ParticipantBannedFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantBannedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.participantBanned()';
}


}




/// @nodoc


class ParticipantNotFoundFailure extends Failure {
  const ParticipantNotFoundFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantNotFoundFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.participantNotFound()';
}


}




/// @nodoc


class InvalidInputFailure extends Failure {
  const InvalidInputFailure(this.field): super._();
  

 final  InputField field;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvalidInputFailureCopyWith<InvalidInputFailure> get copyWith => _$InvalidInputFailureCopyWithImpl<InvalidInputFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidInputFailure&&(identical(other.field, field) || other.field == field));
}


@override
int get hashCode => Object.hash(runtimeType,field);

@override
String toString() {
  return 'Failure.invalidInput(field: $field)';
}


}

/// @nodoc
abstract mixin class $InvalidInputFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $InvalidInputFailureCopyWith(InvalidInputFailure value, $Res Function(InvalidInputFailure) _then) = _$InvalidInputFailureCopyWithImpl;
@useResult
$Res call({
 InputField field
});




}
/// @nodoc
class _$InvalidInputFailureCopyWithImpl<$Res>
    implements $InvalidInputFailureCopyWith<$Res> {
  _$InvalidInputFailureCopyWithImpl(this._self, this._then);

  final InvalidInputFailure _self;
  final $Res Function(InvalidInputFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field = null,}) {
  return _then(InvalidInputFailure(
null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as InputField,
  ));
}


}

/// @nodoc


class MediaDeviceFailure extends Failure {
  const MediaDeviceFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaDeviceFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.mediaDevice()';
}


}




/// @nodoc


class NetworkFailure extends Failure {
  const NetworkFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.network()';
}


}




/// @nodoc


class ServerFailure extends Failure {
  const ServerFailure({this.statusCode}): super._();
  

 final  int? statusCode;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFailureCopyWith<ServerFailure> get copyWith => _$ServerFailureCopyWithImpl<ServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFailure&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode);

@override
String toString() {
  return 'Failure.server(statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ServerFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ServerFailureCopyWith(ServerFailure value, $Res Function(ServerFailure) _then) = _$ServerFailureCopyWithImpl;
@useResult
$Res call({
 int? statusCode
});




}
/// @nodoc
class _$ServerFailureCopyWithImpl<$Res>
    implements $ServerFailureCopyWith<$Res> {
  _$ServerFailureCopyWithImpl(this._self, this._then);

  final ServerFailure _self;
  final $Res Function(ServerFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,}) {
  return _then(ServerFailure(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class UnknownFailure extends Failure {
  const UnknownFailure({this.statusCode, this.code}): super._();
  

 final  int? statusCode;
 final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownFailureCopyWith<UnknownFailure> get copyWith => _$UnknownFailureCopyWithImpl<UnknownFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownFailure&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode,code);

@override
String toString() {
  return 'Failure.unknown(statusCode: $statusCode, code: $code)';
}


}

/// @nodoc
abstract mixin class $UnknownFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnknownFailureCopyWith(UnknownFailure value, $Res Function(UnknownFailure) _then) = _$UnknownFailureCopyWithImpl;
@useResult
$Res call({
 int? statusCode, String? code
});




}
/// @nodoc
class _$UnknownFailureCopyWithImpl<$Res>
    implements $UnknownFailureCopyWith<$Res> {
  _$UnknownFailureCopyWithImpl(this._self, this._then);

  final UnknownFailure _self;
  final $Res Function(UnknownFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,Object? code = freezed,}) {
  return _then(UnknownFailure(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
