// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomEvent);
}


@override
int get hashCode => runtimeType.hashCode;



}

/// @nodoc
class $RoomEventCopyWith<$Res>  {
$RoomEventCopyWith(RoomEvent _, $Res Function(RoomEvent) __);
}


/// Adds pattern-matching-related methods to [RoomEvent].
extension RoomEventPatterns on RoomEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RoomJoinRequested value)?  joinRequested,TResult Function( RoomLeaveRequested value)?  leaveRequested,TResult Function( RoomMicrophoneToggled value)?  microphoneToggled,TResult Function( RoomCameraToggled value)?  cameraToggled,TResult Function( RoomCameraFlipped value)?  cameraFlipped,TResult Function( RoomSpeakerphoneToggled value)?  speakerphoneToggled,TResult Function( RoomAudioPlaybackStartRequested value)?  audioPlaybackStartRequested,TResult Function( RoomAppLifecycleChanged value)?  appLifecycleChanged,TResult Function( RoomEndForAllRequested value)?  endForAllRequested,TResult Function( RoomParticipantMuteRequested value)?  participantMuteRequested,TResult Function( RoomParticipantRemoveRequested value)?  participantRemoveRequested,TResult Function( RoomLockRequested value)?  lockRequested,TResult Function( RoomPasswordChangeRequested value)?  passwordChangeRequested,TResult Function( RoomInviteRotateRequested value)?  inviteRotateRequested,TResult Function( _RoomExpiryWarningDue value)?  expiryWarningDue,TResult Function( _RoomCallUpdated value)?  callUpdated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RoomJoinRequested() when joinRequested != null:
return joinRequested(_that);case RoomLeaveRequested() when leaveRequested != null:
return leaveRequested(_that);case RoomMicrophoneToggled() when microphoneToggled != null:
return microphoneToggled(_that);case RoomCameraToggled() when cameraToggled != null:
return cameraToggled(_that);case RoomCameraFlipped() when cameraFlipped != null:
return cameraFlipped(_that);case RoomSpeakerphoneToggled() when speakerphoneToggled != null:
return speakerphoneToggled(_that);case RoomAudioPlaybackStartRequested() when audioPlaybackStartRequested != null:
return audioPlaybackStartRequested(_that);case RoomAppLifecycleChanged() when appLifecycleChanged != null:
return appLifecycleChanged(_that);case RoomEndForAllRequested() when endForAllRequested != null:
return endForAllRequested(_that);case RoomParticipantMuteRequested() when participantMuteRequested != null:
return participantMuteRequested(_that);case RoomParticipantRemoveRequested() when participantRemoveRequested != null:
return participantRemoveRequested(_that);case RoomLockRequested() when lockRequested != null:
return lockRequested(_that);case RoomPasswordChangeRequested() when passwordChangeRequested != null:
return passwordChangeRequested(_that);case RoomInviteRotateRequested() when inviteRotateRequested != null:
return inviteRotateRequested(_that);case _RoomExpiryWarningDue() when expiryWarningDue != null:
return expiryWarningDue(_that);case _RoomCallUpdated() when callUpdated != null:
return callUpdated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RoomJoinRequested value)  joinRequested,required TResult Function( RoomLeaveRequested value)  leaveRequested,required TResult Function( RoomMicrophoneToggled value)  microphoneToggled,required TResult Function( RoomCameraToggled value)  cameraToggled,required TResult Function( RoomCameraFlipped value)  cameraFlipped,required TResult Function( RoomSpeakerphoneToggled value)  speakerphoneToggled,required TResult Function( RoomAudioPlaybackStartRequested value)  audioPlaybackStartRequested,required TResult Function( RoomAppLifecycleChanged value)  appLifecycleChanged,required TResult Function( RoomEndForAllRequested value)  endForAllRequested,required TResult Function( RoomParticipantMuteRequested value)  participantMuteRequested,required TResult Function( RoomParticipantRemoveRequested value)  participantRemoveRequested,required TResult Function( RoomLockRequested value)  lockRequested,required TResult Function( RoomPasswordChangeRequested value)  passwordChangeRequested,required TResult Function( RoomInviteRotateRequested value)  inviteRotateRequested,required TResult Function( _RoomExpiryWarningDue value)  expiryWarningDue,required TResult Function( _RoomCallUpdated value)  callUpdated,}){
final _that = this;
switch (_that) {
case RoomJoinRequested():
return joinRequested(_that);case RoomLeaveRequested():
return leaveRequested(_that);case RoomMicrophoneToggled():
return microphoneToggled(_that);case RoomCameraToggled():
return cameraToggled(_that);case RoomCameraFlipped():
return cameraFlipped(_that);case RoomSpeakerphoneToggled():
return speakerphoneToggled(_that);case RoomAudioPlaybackStartRequested():
return audioPlaybackStartRequested(_that);case RoomAppLifecycleChanged():
return appLifecycleChanged(_that);case RoomEndForAllRequested():
return endForAllRequested(_that);case RoomParticipantMuteRequested():
return participantMuteRequested(_that);case RoomParticipantRemoveRequested():
return participantRemoveRequested(_that);case RoomLockRequested():
return lockRequested(_that);case RoomPasswordChangeRequested():
return passwordChangeRequested(_that);case RoomInviteRotateRequested():
return inviteRotateRequested(_that);case _RoomExpiryWarningDue():
return expiryWarningDue(_that);case _RoomCallUpdated():
return callUpdated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RoomJoinRequested value)?  joinRequested,TResult? Function( RoomLeaveRequested value)?  leaveRequested,TResult? Function( RoomMicrophoneToggled value)?  microphoneToggled,TResult? Function( RoomCameraToggled value)?  cameraToggled,TResult? Function( RoomCameraFlipped value)?  cameraFlipped,TResult? Function( RoomSpeakerphoneToggled value)?  speakerphoneToggled,TResult? Function( RoomAudioPlaybackStartRequested value)?  audioPlaybackStartRequested,TResult? Function( RoomAppLifecycleChanged value)?  appLifecycleChanged,TResult? Function( RoomEndForAllRequested value)?  endForAllRequested,TResult? Function( RoomParticipantMuteRequested value)?  participantMuteRequested,TResult? Function( RoomParticipantRemoveRequested value)?  participantRemoveRequested,TResult? Function( RoomLockRequested value)?  lockRequested,TResult? Function( RoomPasswordChangeRequested value)?  passwordChangeRequested,TResult? Function( RoomInviteRotateRequested value)?  inviteRotateRequested,TResult? Function( _RoomExpiryWarningDue value)?  expiryWarningDue,TResult? Function( _RoomCallUpdated value)?  callUpdated,}){
final _that = this;
switch (_that) {
case RoomJoinRequested() when joinRequested != null:
return joinRequested(_that);case RoomLeaveRequested() when leaveRequested != null:
return leaveRequested(_that);case RoomMicrophoneToggled() when microphoneToggled != null:
return microphoneToggled(_that);case RoomCameraToggled() when cameraToggled != null:
return cameraToggled(_that);case RoomCameraFlipped() when cameraFlipped != null:
return cameraFlipped(_that);case RoomSpeakerphoneToggled() when speakerphoneToggled != null:
return speakerphoneToggled(_that);case RoomAudioPlaybackStartRequested() when audioPlaybackStartRequested != null:
return audioPlaybackStartRequested(_that);case RoomAppLifecycleChanged() when appLifecycleChanged != null:
return appLifecycleChanged(_that);case RoomEndForAllRequested() when endForAllRequested != null:
return endForAllRequested(_that);case RoomParticipantMuteRequested() when participantMuteRequested != null:
return participantMuteRequested(_that);case RoomParticipantRemoveRequested() when participantRemoveRequested != null:
return participantRemoveRequested(_that);case RoomLockRequested() when lockRequested != null:
return lockRequested(_that);case RoomPasswordChangeRequested() when passwordChangeRequested != null:
return passwordChangeRequested(_that);case RoomInviteRotateRequested() when inviteRotateRequested != null:
return inviteRotateRequested(_that);case _RoomExpiryWarningDue() when expiryWarningDue != null:
return expiryWarningDue(_that);case _RoomCallUpdated() when callUpdated != null:
return callUpdated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RoomCode code,  String? password,  bool microphoneEnabled,  bool cameraEnabled,  String? displayName)?  joinRequested,TResult Function()?  leaveRequested,TResult Function( bool enabled)?  microphoneToggled,TResult Function( bool enabled)?  cameraToggled,TResult Function()?  cameraFlipped,TResult Function( bool on)?  speakerphoneToggled,TResult Function()?  audioPlaybackStartRequested,TResult Function( AppLifecycleState state)?  appLifecycleChanged,TResult Function()?  endForAllRequested,TResult Function( String identity,  String trackSid)?  participantMuteRequested,TResult Function( String identity,  bool ban)?  participantRemoveRequested,TResult Function( bool locked)?  lockRequested,TResult Function( String? password)?  passwordChangeRequested,TResult Function()?  inviteRotateRequested,TResult Function()?  expiryWarningDue,TResult Function( CallSnapshot snapshot)?  callUpdated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RoomJoinRequested() when joinRequested != null:
return joinRequested(_that.code,_that.password,_that.microphoneEnabled,_that.cameraEnabled,_that.displayName);case RoomLeaveRequested() when leaveRequested != null:
return leaveRequested();case RoomMicrophoneToggled() when microphoneToggled != null:
return microphoneToggled(_that.enabled);case RoomCameraToggled() when cameraToggled != null:
return cameraToggled(_that.enabled);case RoomCameraFlipped() when cameraFlipped != null:
return cameraFlipped();case RoomSpeakerphoneToggled() when speakerphoneToggled != null:
return speakerphoneToggled(_that.on);case RoomAudioPlaybackStartRequested() when audioPlaybackStartRequested != null:
return audioPlaybackStartRequested();case RoomAppLifecycleChanged() when appLifecycleChanged != null:
return appLifecycleChanged(_that.state);case RoomEndForAllRequested() when endForAllRequested != null:
return endForAllRequested();case RoomParticipantMuteRequested() when participantMuteRequested != null:
return participantMuteRequested(_that.identity,_that.trackSid);case RoomParticipantRemoveRequested() when participantRemoveRequested != null:
return participantRemoveRequested(_that.identity,_that.ban);case RoomLockRequested() when lockRequested != null:
return lockRequested(_that.locked);case RoomPasswordChangeRequested() when passwordChangeRequested != null:
return passwordChangeRequested(_that.password);case RoomInviteRotateRequested() when inviteRotateRequested != null:
return inviteRotateRequested();case _RoomExpiryWarningDue() when expiryWarningDue != null:
return expiryWarningDue();case _RoomCallUpdated() when callUpdated != null:
return callUpdated(_that.snapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RoomCode code,  String? password,  bool microphoneEnabled,  bool cameraEnabled,  String? displayName)  joinRequested,required TResult Function()  leaveRequested,required TResult Function( bool enabled)  microphoneToggled,required TResult Function( bool enabled)  cameraToggled,required TResult Function()  cameraFlipped,required TResult Function( bool on)  speakerphoneToggled,required TResult Function()  audioPlaybackStartRequested,required TResult Function( AppLifecycleState state)  appLifecycleChanged,required TResult Function()  endForAllRequested,required TResult Function( String identity,  String trackSid)  participantMuteRequested,required TResult Function( String identity,  bool ban)  participantRemoveRequested,required TResult Function( bool locked)  lockRequested,required TResult Function( String? password)  passwordChangeRequested,required TResult Function()  inviteRotateRequested,required TResult Function()  expiryWarningDue,required TResult Function( CallSnapshot snapshot)  callUpdated,}) {final _that = this;
switch (_that) {
case RoomJoinRequested():
return joinRequested(_that.code,_that.password,_that.microphoneEnabled,_that.cameraEnabled,_that.displayName);case RoomLeaveRequested():
return leaveRequested();case RoomMicrophoneToggled():
return microphoneToggled(_that.enabled);case RoomCameraToggled():
return cameraToggled(_that.enabled);case RoomCameraFlipped():
return cameraFlipped();case RoomSpeakerphoneToggled():
return speakerphoneToggled(_that.on);case RoomAudioPlaybackStartRequested():
return audioPlaybackStartRequested();case RoomAppLifecycleChanged():
return appLifecycleChanged(_that.state);case RoomEndForAllRequested():
return endForAllRequested();case RoomParticipantMuteRequested():
return participantMuteRequested(_that.identity,_that.trackSid);case RoomParticipantRemoveRequested():
return participantRemoveRequested(_that.identity,_that.ban);case RoomLockRequested():
return lockRequested(_that.locked);case RoomPasswordChangeRequested():
return passwordChangeRequested(_that.password);case RoomInviteRotateRequested():
return inviteRotateRequested();case _RoomExpiryWarningDue():
return expiryWarningDue();case _RoomCallUpdated():
return callUpdated(_that.snapshot);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RoomCode code,  String? password,  bool microphoneEnabled,  bool cameraEnabled,  String? displayName)?  joinRequested,TResult? Function()?  leaveRequested,TResult? Function( bool enabled)?  microphoneToggled,TResult? Function( bool enabled)?  cameraToggled,TResult? Function()?  cameraFlipped,TResult? Function( bool on)?  speakerphoneToggled,TResult? Function()?  audioPlaybackStartRequested,TResult? Function( AppLifecycleState state)?  appLifecycleChanged,TResult? Function()?  endForAllRequested,TResult? Function( String identity,  String trackSid)?  participantMuteRequested,TResult? Function( String identity,  bool ban)?  participantRemoveRequested,TResult? Function( bool locked)?  lockRequested,TResult? Function( String? password)?  passwordChangeRequested,TResult? Function()?  inviteRotateRequested,TResult? Function()?  expiryWarningDue,TResult? Function( CallSnapshot snapshot)?  callUpdated,}) {final _that = this;
switch (_that) {
case RoomJoinRequested() when joinRequested != null:
return joinRequested(_that.code,_that.password,_that.microphoneEnabled,_that.cameraEnabled,_that.displayName);case RoomLeaveRequested() when leaveRequested != null:
return leaveRequested();case RoomMicrophoneToggled() when microphoneToggled != null:
return microphoneToggled(_that.enabled);case RoomCameraToggled() when cameraToggled != null:
return cameraToggled(_that.enabled);case RoomCameraFlipped() when cameraFlipped != null:
return cameraFlipped();case RoomSpeakerphoneToggled() when speakerphoneToggled != null:
return speakerphoneToggled(_that.on);case RoomAudioPlaybackStartRequested() when audioPlaybackStartRequested != null:
return audioPlaybackStartRequested();case RoomAppLifecycleChanged() when appLifecycleChanged != null:
return appLifecycleChanged(_that.state);case RoomEndForAllRequested() when endForAllRequested != null:
return endForAllRequested();case RoomParticipantMuteRequested() when participantMuteRequested != null:
return participantMuteRequested(_that.identity,_that.trackSid);case RoomParticipantRemoveRequested() when participantRemoveRequested != null:
return participantRemoveRequested(_that.identity,_that.ban);case RoomLockRequested() when lockRequested != null:
return lockRequested(_that.locked);case RoomPasswordChangeRequested() when passwordChangeRequested != null:
return passwordChangeRequested(_that.password);case RoomInviteRotateRequested() when inviteRotateRequested != null:
return inviteRotateRequested();case _RoomExpiryWarningDue() when expiryWarningDue != null:
return expiryWarningDue();case _RoomCallUpdated() when callUpdated != null:
return callUpdated(_that.snapshot);case _:
  return null;

}
}

}

/// @nodoc


class RoomJoinRequested implements RoomEvent {
  const RoomJoinRequested({required this.code, this.password, this.microphoneEnabled = true, this.cameraEnabled = true, this.displayName});
  

 final  RoomCode code;
 final  String? password;
@JsonKey() final  bool microphoneEnabled;
@JsonKey() final  bool cameraEnabled;
 final  String? displayName;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomJoinRequestedCopyWith<RoomJoinRequested> get copyWith => _$RoomJoinRequestedCopyWithImpl<RoomJoinRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomJoinRequested&&(identical(other.code, code) || other.code == code)&&(identical(other.password, password) || other.password == password)&&(identical(other.microphoneEnabled, microphoneEnabled) || other.microphoneEnabled == microphoneEnabled)&&(identical(other.cameraEnabled, cameraEnabled) || other.cameraEnabled == cameraEnabled)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}


@override
int get hashCode => Object.hash(runtimeType,code,password,microphoneEnabled,cameraEnabled,displayName);



}

/// @nodoc
abstract mixin class $RoomJoinRequestedCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $RoomJoinRequestedCopyWith(RoomJoinRequested value, $Res Function(RoomJoinRequested) _then) = _$RoomJoinRequestedCopyWithImpl;
@useResult
$Res call({
 RoomCode code, String? password, bool microphoneEnabled, bool cameraEnabled, String? displayName
});


$RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class _$RoomJoinRequestedCopyWithImpl<$Res>
    implements $RoomJoinRequestedCopyWith<$Res> {
  _$RoomJoinRequestedCopyWithImpl(this._self, this._then);

  final RoomJoinRequested _self;
  final $Res Function(RoomJoinRequested) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,Object? password = freezed,Object? microphoneEnabled = null,Object? cameraEnabled = null,Object? displayName = freezed,}) {
  return _then(RoomJoinRequested(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,microphoneEnabled: null == microphoneEnabled ? _self.microphoneEnabled : microphoneEnabled // ignore: cast_nullable_to_non_nullable
as bool,cameraEnabled: null == cameraEnabled ? _self.cameraEnabled : cameraEnabled // ignore: cast_nullable_to_non_nullable
as bool,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RoomEvent
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


class RoomLeaveRequested implements RoomEvent {
  const RoomLeaveRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomLeaveRequested);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class RoomMicrophoneToggled implements RoomEvent {
  const RoomMicrophoneToggled(this.enabled);
  

 final  bool enabled;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomMicrophoneToggledCopyWith<RoomMicrophoneToggled> get copyWith => _$RoomMicrophoneToggledCopyWithImpl<RoomMicrophoneToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomMicrophoneToggled&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);



}

/// @nodoc
abstract mixin class $RoomMicrophoneToggledCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $RoomMicrophoneToggledCopyWith(RoomMicrophoneToggled value, $Res Function(RoomMicrophoneToggled) _then) = _$RoomMicrophoneToggledCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class _$RoomMicrophoneToggledCopyWithImpl<$Res>
    implements $RoomMicrophoneToggledCopyWith<$Res> {
  _$RoomMicrophoneToggledCopyWithImpl(this._self, this._then);

  final RoomMicrophoneToggled _self;
  final $Res Function(RoomMicrophoneToggled) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(RoomMicrophoneToggled(
null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class RoomCameraToggled implements RoomEvent {
  const RoomCameraToggled(this.enabled);
  

 final  bool enabled;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomCameraToggledCopyWith<RoomCameraToggled> get copyWith => _$RoomCameraToggledCopyWithImpl<RoomCameraToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomCameraToggled&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);



}

/// @nodoc
abstract mixin class $RoomCameraToggledCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $RoomCameraToggledCopyWith(RoomCameraToggled value, $Res Function(RoomCameraToggled) _then) = _$RoomCameraToggledCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class _$RoomCameraToggledCopyWithImpl<$Res>
    implements $RoomCameraToggledCopyWith<$Res> {
  _$RoomCameraToggledCopyWithImpl(this._self, this._then);

  final RoomCameraToggled _self;
  final $Res Function(RoomCameraToggled) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(RoomCameraToggled(
null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class RoomCameraFlipped implements RoomEvent {
  const RoomCameraFlipped();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomCameraFlipped);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class RoomSpeakerphoneToggled implements RoomEvent {
  const RoomSpeakerphoneToggled(this.on);
  

 final  bool on;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomSpeakerphoneToggledCopyWith<RoomSpeakerphoneToggled> get copyWith => _$RoomSpeakerphoneToggledCopyWithImpl<RoomSpeakerphoneToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomSpeakerphoneToggled&&(identical(other.on, on) || other.on == on));
}


@override
int get hashCode => Object.hash(runtimeType,on);



}

/// @nodoc
abstract mixin class $RoomSpeakerphoneToggledCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $RoomSpeakerphoneToggledCopyWith(RoomSpeakerphoneToggled value, $Res Function(RoomSpeakerphoneToggled) _then) = _$RoomSpeakerphoneToggledCopyWithImpl;
@useResult
$Res call({
 bool on
});




}
/// @nodoc
class _$RoomSpeakerphoneToggledCopyWithImpl<$Res>
    implements $RoomSpeakerphoneToggledCopyWith<$Res> {
  _$RoomSpeakerphoneToggledCopyWithImpl(this._self, this._then);

  final RoomSpeakerphoneToggled _self;
  final $Res Function(RoomSpeakerphoneToggled) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? on = null,}) {
  return _then(RoomSpeakerphoneToggled(
null == on ? _self.on : on // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class RoomAudioPlaybackStartRequested implements RoomEvent {
  const RoomAudioPlaybackStartRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomAudioPlaybackStartRequested);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class RoomAppLifecycleChanged implements RoomEvent {
  const RoomAppLifecycleChanged(this.state);
  

 final  AppLifecycleState state;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomAppLifecycleChangedCopyWith<RoomAppLifecycleChanged> get copyWith => _$RoomAppLifecycleChangedCopyWithImpl<RoomAppLifecycleChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomAppLifecycleChanged&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,state);



}

/// @nodoc
abstract mixin class $RoomAppLifecycleChangedCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $RoomAppLifecycleChangedCopyWith(RoomAppLifecycleChanged value, $Res Function(RoomAppLifecycleChanged) _then) = _$RoomAppLifecycleChangedCopyWithImpl;
@useResult
$Res call({
 AppLifecycleState state
});




}
/// @nodoc
class _$RoomAppLifecycleChangedCopyWithImpl<$Res>
    implements $RoomAppLifecycleChangedCopyWith<$Res> {
  _$RoomAppLifecycleChangedCopyWithImpl(this._self, this._then);

  final RoomAppLifecycleChanged _self;
  final $Res Function(RoomAppLifecycleChanged) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? state = null,}) {
  return _then(RoomAppLifecycleChanged(
null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AppLifecycleState,
  ));
}


}

/// @nodoc


class RoomEndForAllRequested implements RoomEvent {
  const RoomEndForAllRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomEndForAllRequested);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class RoomParticipantMuteRequested implements RoomEvent {
  const RoomParticipantMuteRequested({required this.identity, required this.trackSid});
  

 final  String identity;
 final  String trackSid;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomParticipantMuteRequestedCopyWith<RoomParticipantMuteRequested> get copyWith => _$RoomParticipantMuteRequestedCopyWithImpl<RoomParticipantMuteRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomParticipantMuteRequested&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.trackSid, trackSid) || other.trackSid == trackSid));
}


@override
int get hashCode => Object.hash(runtimeType,identity,trackSid);



}

/// @nodoc
abstract mixin class $RoomParticipantMuteRequestedCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $RoomParticipantMuteRequestedCopyWith(RoomParticipantMuteRequested value, $Res Function(RoomParticipantMuteRequested) _then) = _$RoomParticipantMuteRequestedCopyWithImpl;
@useResult
$Res call({
 String identity, String trackSid
});




}
/// @nodoc
class _$RoomParticipantMuteRequestedCopyWithImpl<$Res>
    implements $RoomParticipantMuteRequestedCopyWith<$Res> {
  _$RoomParticipantMuteRequestedCopyWithImpl(this._self, this._then);

  final RoomParticipantMuteRequested _self;
  final $Res Function(RoomParticipantMuteRequested) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? identity = null,Object? trackSid = null,}) {
  return _then(RoomParticipantMuteRequested(
identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as String,trackSid: null == trackSid ? _self.trackSid : trackSid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RoomParticipantRemoveRequested implements RoomEvent {
  const RoomParticipantRemoveRequested({required this.identity, this.ban = false});
  

 final  String identity;
@JsonKey() final  bool ban;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomParticipantRemoveRequestedCopyWith<RoomParticipantRemoveRequested> get copyWith => _$RoomParticipantRemoveRequestedCopyWithImpl<RoomParticipantRemoveRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomParticipantRemoveRequested&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.ban, ban) || other.ban == ban));
}


@override
int get hashCode => Object.hash(runtimeType,identity,ban);



}

/// @nodoc
abstract mixin class $RoomParticipantRemoveRequestedCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $RoomParticipantRemoveRequestedCopyWith(RoomParticipantRemoveRequested value, $Res Function(RoomParticipantRemoveRequested) _then) = _$RoomParticipantRemoveRequestedCopyWithImpl;
@useResult
$Res call({
 String identity, bool ban
});




}
/// @nodoc
class _$RoomParticipantRemoveRequestedCopyWithImpl<$Res>
    implements $RoomParticipantRemoveRequestedCopyWith<$Res> {
  _$RoomParticipantRemoveRequestedCopyWithImpl(this._self, this._then);

  final RoomParticipantRemoveRequested _self;
  final $Res Function(RoomParticipantRemoveRequested) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? identity = null,Object? ban = null,}) {
  return _then(RoomParticipantRemoveRequested(
identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as String,ban: null == ban ? _self.ban : ban // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class RoomLockRequested implements RoomEvent {
  const RoomLockRequested(this.locked);
  

 final  bool locked;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomLockRequestedCopyWith<RoomLockRequested> get copyWith => _$RoomLockRequestedCopyWithImpl<RoomLockRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomLockRequested&&(identical(other.locked, locked) || other.locked == locked));
}


@override
int get hashCode => Object.hash(runtimeType,locked);



}

/// @nodoc
abstract mixin class $RoomLockRequestedCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $RoomLockRequestedCopyWith(RoomLockRequested value, $Res Function(RoomLockRequested) _then) = _$RoomLockRequestedCopyWithImpl;
@useResult
$Res call({
 bool locked
});




}
/// @nodoc
class _$RoomLockRequestedCopyWithImpl<$Res>
    implements $RoomLockRequestedCopyWith<$Res> {
  _$RoomLockRequestedCopyWithImpl(this._self, this._then);

  final RoomLockRequested _self;
  final $Res Function(RoomLockRequested) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? locked = null,}) {
  return _then(RoomLockRequested(
null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class RoomPasswordChangeRequested implements RoomEvent {
  const RoomPasswordChangeRequested(this.password);
  

 final  String? password;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomPasswordChangeRequestedCopyWith<RoomPasswordChangeRequested> get copyWith => _$RoomPasswordChangeRequestedCopyWithImpl<RoomPasswordChangeRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomPasswordChangeRequested&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,password);



}

/// @nodoc
abstract mixin class $RoomPasswordChangeRequestedCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $RoomPasswordChangeRequestedCopyWith(RoomPasswordChangeRequested value, $Res Function(RoomPasswordChangeRequested) _then) = _$RoomPasswordChangeRequestedCopyWithImpl;
@useResult
$Res call({
 String? password
});




}
/// @nodoc
class _$RoomPasswordChangeRequestedCopyWithImpl<$Res>
    implements $RoomPasswordChangeRequestedCopyWith<$Res> {
  _$RoomPasswordChangeRequestedCopyWithImpl(this._self, this._then);

  final RoomPasswordChangeRequested _self;
  final $Res Function(RoomPasswordChangeRequested) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = freezed,}) {
  return _then(RoomPasswordChangeRequested(
freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RoomInviteRotateRequested implements RoomEvent {
  const RoomInviteRotateRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomInviteRotateRequested);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class _RoomExpiryWarningDue implements RoomEvent {
  const _RoomExpiryWarningDue();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomExpiryWarningDue);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class _RoomCallUpdated implements RoomEvent {
  const _RoomCallUpdated(this.snapshot);
  

 final  CallSnapshot snapshot;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomCallUpdatedCopyWith<_RoomCallUpdated> get copyWith => __$RoomCallUpdatedCopyWithImpl<_RoomCallUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomCallUpdated&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}


@override
int get hashCode => Object.hash(runtimeType,snapshot);



}

/// @nodoc
abstract mixin class _$RoomCallUpdatedCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory _$RoomCallUpdatedCopyWith(_RoomCallUpdated value, $Res Function(_RoomCallUpdated) _then) = __$RoomCallUpdatedCopyWithImpl;
@useResult
$Res call({
 CallSnapshot snapshot
});


$CallSnapshotCopyWith<$Res> get snapshot;

}
/// @nodoc
class __$RoomCallUpdatedCopyWithImpl<$Res>
    implements _$RoomCallUpdatedCopyWith<$Res> {
  __$RoomCallUpdatedCopyWithImpl(this._self, this._then);

  final _RoomCallUpdated _self;
  final $Res Function(_RoomCallUpdated) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? snapshot = null,}) {
  return _then(_RoomCallUpdated(
null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as CallSnapshot,
  ));
}

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallSnapshotCopyWith<$Res> get snapshot {
  
  return $CallSnapshotCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}

/// @nodoc
mixin _$RoomState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomState()';
}


}




/// Adds pattern-matching-related methods to [RoomState].
extension RoomStatePatterns on RoomState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RoomInitial value)?  initial,TResult Function( RoomConnecting value)?  connecting,TResult Function( RoomConnected value)?  connected,TResult Function( RoomReconnecting value)?  reconnecting,TResult Function( RoomEnded value)?  ended,TResult Function( RoomFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RoomInitial() when initial != null:
return initial(_that);case RoomConnecting() when connecting != null:
return connecting(_that);case RoomConnected() when connected != null:
return connected(_that);case RoomReconnecting() when reconnecting != null:
return reconnecting(_that);case RoomEnded() when ended != null:
return ended(_that);case RoomFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RoomInitial value)  initial,required TResult Function( RoomConnecting value)  connecting,required TResult Function( RoomConnected value)  connected,required TResult Function( RoomReconnecting value)  reconnecting,required TResult Function( RoomEnded value)  ended,required TResult Function( RoomFailed value)  failed,}){
final _that = this;
switch (_that) {
case RoomInitial():
return initial(_that);case RoomConnecting():
return connecting(_that);case RoomConnected():
return connected(_that);case RoomReconnecting():
return reconnecting(_that);case RoomEnded():
return ended(_that);case RoomFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RoomInitial value)?  initial,TResult? Function( RoomConnecting value)?  connecting,TResult? Function( RoomConnected value)?  connected,TResult? Function( RoomReconnecting value)?  reconnecting,TResult? Function( RoomEnded value)?  ended,TResult? Function( RoomFailed value)?  failed,}){
final _that = this;
switch (_that) {
case RoomInitial() when initial != null:
return initial(_that);case RoomConnecting() when connecting != null:
return connecting(_that);case RoomConnected() when connected != null:
return connected(_that);case RoomReconnecting() when reconnecting != null:
return reconnecting(_that);case RoomEnded() when ended != null:
return ended(_that);case RoomFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( RoomCode code)?  connecting,TResult Function( RoomInfo room,  RoomRole role,  CallSnapshot call,  bool expiresSoon)?  connected,TResult Function( RoomInfo room,  RoomRole role,  CallSnapshot call,  bool expiresSoon)?  reconnecting,TResult Function( CallEndReason reason,  RoomCode? code,  bool endedByYou)?  ended,TResult Function( RoomCode code,  Failure failure)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RoomInitial() when initial != null:
return initial();case RoomConnecting() when connecting != null:
return connecting(_that.code);case RoomConnected() when connected != null:
return connected(_that.room,_that.role,_that.call,_that.expiresSoon);case RoomReconnecting() when reconnecting != null:
return reconnecting(_that.room,_that.role,_that.call,_that.expiresSoon);case RoomEnded() when ended != null:
return ended(_that.reason,_that.code,_that.endedByYou);case RoomFailed() when failed != null:
return failed(_that.code,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( RoomCode code)  connecting,required TResult Function( RoomInfo room,  RoomRole role,  CallSnapshot call,  bool expiresSoon)  connected,required TResult Function( RoomInfo room,  RoomRole role,  CallSnapshot call,  bool expiresSoon)  reconnecting,required TResult Function( CallEndReason reason,  RoomCode? code,  bool endedByYou)  ended,required TResult Function( RoomCode code,  Failure failure)  failed,}) {final _that = this;
switch (_that) {
case RoomInitial():
return initial();case RoomConnecting():
return connecting(_that.code);case RoomConnected():
return connected(_that.room,_that.role,_that.call,_that.expiresSoon);case RoomReconnecting():
return reconnecting(_that.room,_that.role,_that.call,_that.expiresSoon);case RoomEnded():
return ended(_that.reason,_that.code,_that.endedByYou);case RoomFailed():
return failed(_that.code,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( RoomCode code)?  connecting,TResult? Function( RoomInfo room,  RoomRole role,  CallSnapshot call,  bool expiresSoon)?  connected,TResult? Function( RoomInfo room,  RoomRole role,  CallSnapshot call,  bool expiresSoon)?  reconnecting,TResult? Function( CallEndReason reason,  RoomCode? code,  bool endedByYou)?  ended,TResult? Function( RoomCode code,  Failure failure)?  failed,}) {final _that = this;
switch (_that) {
case RoomInitial() when initial != null:
return initial();case RoomConnecting() when connecting != null:
return connecting(_that.code);case RoomConnected() when connected != null:
return connected(_that.room,_that.role,_that.call,_that.expiresSoon);case RoomReconnecting() when reconnecting != null:
return reconnecting(_that.room,_that.role,_that.call,_that.expiresSoon);case RoomEnded() when ended != null:
return ended(_that.reason,_that.code,_that.endedByYou);case RoomFailed() when failed != null:
return failed(_that.code,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class RoomInitial with DiagnosticableTreeMixin implements RoomState {
  const RoomInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomState.initial()';
}


}




/// @nodoc


class RoomConnecting with DiagnosticableTreeMixin implements RoomState {
  const RoomConnecting(this.code);
  

 final  RoomCode code;



@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomState.connecting'))
    ..add(DiagnosticsProperty('code', code));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomConnecting&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomState.connecting(code: $code)';
}


}




/// @nodoc


class RoomConnected with DiagnosticableTreeMixin implements RoomState, RoomInCall {
  const RoomConnected({required this.room, required this.role, required this.call, this.expiresSoon = false});
  

 final  RoomInfo room;
 final  RoomRole role;
 final  CallSnapshot call;
@JsonKey() final  bool expiresSoon;



@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomState.connected'))
    ..add(DiagnosticsProperty('room', room))..add(DiagnosticsProperty('role', role))..add(DiagnosticsProperty('call', call))..add(DiagnosticsProperty('expiresSoon', expiresSoon));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomConnected&&(identical(other.room, room) || other.room == room)&&(identical(other.role, role) || other.role == role)&&(identical(other.call, call) || other.call == call)&&(identical(other.expiresSoon, expiresSoon) || other.expiresSoon == expiresSoon));
}


@override
int get hashCode => Object.hash(runtimeType,room,role,call,expiresSoon);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomState.connected(room: $room, role: $role, call: $call, expiresSoon: $expiresSoon)';
}


}




/// @nodoc


class RoomReconnecting with DiagnosticableTreeMixin implements RoomState, RoomInCall {
  const RoomReconnecting({required this.room, required this.role, required this.call, this.expiresSoon = false});
  

 final  RoomInfo room;
 final  RoomRole role;
 final  CallSnapshot call;
@JsonKey() final  bool expiresSoon;



@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomState.reconnecting'))
    ..add(DiagnosticsProperty('room', room))..add(DiagnosticsProperty('role', role))..add(DiagnosticsProperty('call', call))..add(DiagnosticsProperty('expiresSoon', expiresSoon));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomReconnecting&&(identical(other.room, room) || other.room == room)&&(identical(other.role, role) || other.role == role)&&(identical(other.call, call) || other.call == call)&&(identical(other.expiresSoon, expiresSoon) || other.expiresSoon == expiresSoon));
}


@override
int get hashCode => Object.hash(runtimeType,room,role,call,expiresSoon);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomState.reconnecting(room: $room, role: $role, call: $call, expiresSoon: $expiresSoon)';
}


}




/// @nodoc


class RoomEnded with DiagnosticableTreeMixin implements RoomState {
  const RoomEnded(this.reason, {this.code, this.endedByYou = false});
  

 final  CallEndReason reason;
 final  RoomCode? code;
@JsonKey() final  bool endedByYou;



@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomState.ended'))
    ..add(DiagnosticsProperty('reason', reason))..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('endedByYou', endedByYou));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomEnded&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.code, code) || other.code == code)&&(identical(other.endedByYou, endedByYou) || other.endedByYou == endedByYou));
}


@override
int get hashCode => Object.hash(runtimeType,reason,code,endedByYou);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomState.ended(reason: $reason, code: $code, endedByYou: $endedByYou)';
}


}




/// @nodoc


class RoomFailed with DiagnosticableTreeMixin implements RoomState {
  const RoomFailed({required this.code, required this.failure});
  

 final  RoomCode code;
 final  Failure failure;



@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomState.failed'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('failure', failure));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomFailed&&(identical(other.code, code) || other.code == code)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,code,failure);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomState.failed(code: $code, failure: $failure)';
}


}




/// @nodoc
mixin _$RoomEffect implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomEffect'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomEffect);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomEffect()';
}


}

/// @nodoc
class $RoomEffectCopyWith<$Res>  {
$RoomEffectCopyWith(RoomEffect _, $Res Function(RoomEffect) __);
}


/// Adds pattern-matching-related methods to [RoomEffect].
extension RoomEffectPatterns on RoomEffect {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ParticipantJoinedEffect value)?  participantJoined,TResult Function( ParticipantLeftEffect value)?  participantLeft,TResult Function( ParticipantMutedEffect value)?  participantMuted,TResult Function( ParticipantRemovedEffect value)?  participantRemoved,TResult Function( RoomSettingsChangedEffect value)?  settingsChanged,TResult Function( RoomActionFailedEffect value)?  actionFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ParticipantJoinedEffect() when participantJoined != null:
return participantJoined(_that);case ParticipantLeftEffect() when participantLeft != null:
return participantLeft(_that);case ParticipantMutedEffect() when participantMuted != null:
return participantMuted(_that);case ParticipantRemovedEffect() when participantRemoved != null:
return participantRemoved(_that);case RoomSettingsChangedEffect() when settingsChanged != null:
return settingsChanged(_that);case RoomActionFailedEffect() when actionFailed != null:
return actionFailed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ParticipantJoinedEffect value)  participantJoined,required TResult Function( ParticipantLeftEffect value)  participantLeft,required TResult Function( ParticipantMutedEffect value)  participantMuted,required TResult Function( ParticipantRemovedEffect value)  participantRemoved,required TResult Function( RoomSettingsChangedEffect value)  settingsChanged,required TResult Function( RoomActionFailedEffect value)  actionFailed,}){
final _that = this;
switch (_that) {
case ParticipantJoinedEffect():
return participantJoined(_that);case ParticipantLeftEffect():
return participantLeft(_that);case ParticipantMutedEffect():
return participantMuted(_that);case ParticipantRemovedEffect():
return participantRemoved(_that);case RoomSettingsChangedEffect():
return settingsChanged(_that);case RoomActionFailedEffect():
return actionFailed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ParticipantJoinedEffect value)?  participantJoined,TResult? Function( ParticipantLeftEffect value)?  participantLeft,TResult? Function( ParticipantMutedEffect value)?  participantMuted,TResult? Function( ParticipantRemovedEffect value)?  participantRemoved,TResult? Function( RoomSettingsChangedEffect value)?  settingsChanged,TResult? Function( RoomActionFailedEffect value)?  actionFailed,}){
final _that = this;
switch (_that) {
case ParticipantJoinedEffect() when participantJoined != null:
return participantJoined(_that);case ParticipantLeftEffect() when participantLeft != null:
return participantLeft(_that);case ParticipantMutedEffect() when participantMuted != null:
return participantMuted(_that);case ParticipantRemovedEffect() when participantRemoved != null:
return participantRemoved(_that);case RoomSettingsChangedEffect() when settingsChanged != null:
return settingsChanged(_that);case RoomActionFailedEffect() when actionFailed != null:
return actionFailed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( CallParticipant participant)?  participantJoined,TResult Function( CallParticipant participant)?  participantLeft,TResult Function( CallParticipant? participant)?  participantMuted,TResult Function( CallParticipant? participant)?  participantRemoved,TResult Function( RoomSettingsChange change)?  settingsChanged,TResult Function( Failure failure)?  actionFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ParticipantJoinedEffect() when participantJoined != null:
return participantJoined(_that.participant);case ParticipantLeftEffect() when participantLeft != null:
return participantLeft(_that.participant);case ParticipantMutedEffect() when participantMuted != null:
return participantMuted(_that.participant);case ParticipantRemovedEffect() when participantRemoved != null:
return participantRemoved(_that.participant);case RoomSettingsChangedEffect() when settingsChanged != null:
return settingsChanged(_that.change);case RoomActionFailedEffect() when actionFailed != null:
return actionFailed(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( CallParticipant participant)  participantJoined,required TResult Function( CallParticipant participant)  participantLeft,required TResult Function( CallParticipant? participant)  participantMuted,required TResult Function( CallParticipant? participant)  participantRemoved,required TResult Function( RoomSettingsChange change)  settingsChanged,required TResult Function( Failure failure)  actionFailed,}) {final _that = this;
switch (_that) {
case ParticipantJoinedEffect():
return participantJoined(_that.participant);case ParticipantLeftEffect():
return participantLeft(_that.participant);case ParticipantMutedEffect():
return participantMuted(_that.participant);case ParticipantRemovedEffect():
return participantRemoved(_that.participant);case RoomSettingsChangedEffect():
return settingsChanged(_that.change);case RoomActionFailedEffect():
return actionFailed(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( CallParticipant participant)?  participantJoined,TResult? Function( CallParticipant participant)?  participantLeft,TResult? Function( CallParticipant? participant)?  participantMuted,TResult? Function( CallParticipant? participant)?  participantRemoved,TResult? Function( RoomSettingsChange change)?  settingsChanged,TResult? Function( Failure failure)?  actionFailed,}) {final _that = this;
switch (_that) {
case ParticipantJoinedEffect() when participantJoined != null:
return participantJoined(_that.participant);case ParticipantLeftEffect() when participantLeft != null:
return participantLeft(_that.participant);case ParticipantMutedEffect() when participantMuted != null:
return participantMuted(_that.participant);case ParticipantRemovedEffect() when participantRemoved != null:
return participantRemoved(_that.participant);case RoomSettingsChangedEffect() when settingsChanged != null:
return settingsChanged(_that.change);case RoomActionFailedEffect() when actionFailed != null:
return actionFailed(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ParticipantJoinedEffect with DiagnosticableTreeMixin implements RoomEffect {
  const ParticipantJoinedEffect(this.participant);
  

 final  CallParticipant participant;

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantJoinedEffectCopyWith<ParticipantJoinedEffect> get copyWith => _$ParticipantJoinedEffectCopyWithImpl<ParticipantJoinedEffect>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomEffect.participantJoined'))
    ..add(DiagnosticsProperty('participant', participant));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantJoinedEffect&&(identical(other.participant, participant) || other.participant == participant));
}


@override
int get hashCode => Object.hash(runtimeType,participant);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomEffect.participantJoined(participant: $participant)';
}


}

/// @nodoc
abstract mixin class $ParticipantJoinedEffectCopyWith<$Res> implements $RoomEffectCopyWith<$Res> {
  factory $ParticipantJoinedEffectCopyWith(ParticipantJoinedEffect value, $Res Function(ParticipantJoinedEffect) _then) = _$ParticipantJoinedEffectCopyWithImpl;
@useResult
$Res call({
 CallParticipant participant
});


$CallParticipantCopyWith<$Res> get participant;

}
/// @nodoc
class _$ParticipantJoinedEffectCopyWithImpl<$Res>
    implements $ParticipantJoinedEffectCopyWith<$Res> {
  _$ParticipantJoinedEffectCopyWithImpl(this._self, this._then);

  final ParticipantJoinedEffect _self;
  final $Res Function(ParticipantJoinedEffect) _then;

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? participant = null,}) {
  return _then(ParticipantJoinedEffect(
null == participant ? _self.participant : participant // ignore: cast_nullable_to_non_nullable
as CallParticipant,
  ));
}

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallParticipantCopyWith<$Res> get participant {
  
  return $CallParticipantCopyWith<$Res>(_self.participant, (value) {
    return _then(_self.copyWith(participant: value));
  });
}
}

/// @nodoc


class ParticipantLeftEffect with DiagnosticableTreeMixin implements RoomEffect {
  const ParticipantLeftEffect(this.participant);
  

 final  CallParticipant participant;

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantLeftEffectCopyWith<ParticipantLeftEffect> get copyWith => _$ParticipantLeftEffectCopyWithImpl<ParticipantLeftEffect>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomEffect.participantLeft'))
    ..add(DiagnosticsProperty('participant', participant));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantLeftEffect&&(identical(other.participant, participant) || other.participant == participant));
}


@override
int get hashCode => Object.hash(runtimeType,participant);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomEffect.participantLeft(participant: $participant)';
}


}

/// @nodoc
abstract mixin class $ParticipantLeftEffectCopyWith<$Res> implements $RoomEffectCopyWith<$Res> {
  factory $ParticipantLeftEffectCopyWith(ParticipantLeftEffect value, $Res Function(ParticipantLeftEffect) _then) = _$ParticipantLeftEffectCopyWithImpl;
@useResult
$Res call({
 CallParticipant participant
});


$CallParticipantCopyWith<$Res> get participant;

}
/// @nodoc
class _$ParticipantLeftEffectCopyWithImpl<$Res>
    implements $ParticipantLeftEffectCopyWith<$Res> {
  _$ParticipantLeftEffectCopyWithImpl(this._self, this._then);

  final ParticipantLeftEffect _self;
  final $Res Function(ParticipantLeftEffect) _then;

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? participant = null,}) {
  return _then(ParticipantLeftEffect(
null == participant ? _self.participant : participant // ignore: cast_nullable_to_non_nullable
as CallParticipant,
  ));
}

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallParticipantCopyWith<$Res> get participant {
  
  return $CallParticipantCopyWith<$Res>(_self.participant, (value) {
    return _then(_self.copyWith(participant: value));
  });
}
}

/// @nodoc


class ParticipantMutedEffect with DiagnosticableTreeMixin implements RoomEffect {
  const ParticipantMutedEffect(this.participant);
  

 final  CallParticipant? participant;

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantMutedEffectCopyWith<ParticipantMutedEffect> get copyWith => _$ParticipantMutedEffectCopyWithImpl<ParticipantMutedEffect>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomEffect.participantMuted'))
    ..add(DiagnosticsProperty('participant', participant));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantMutedEffect&&(identical(other.participant, participant) || other.participant == participant));
}


@override
int get hashCode => Object.hash(runtimeType,participant);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomEffect.participantMuted(participant: $participant)';
}


}

/// @nodoc
abstract mixin class $ParticipantMutedEffectCopyWith<$Res> implements $RoomEffectCopyWith<$Res> {
  factory $ParticipantMutedEffectCopyWith(ParticipantMutedEffect value, $Res Function(ParticipantMutedEffect) _then) = _$ParticipantMutedEffectCopyWithImpl;
@useResult
$Res call({
 CallParticipant? participant
});


$CallParticipantCopyWith<$Res>? get participant;

}
/// @nodoc
class _$ParticipantMutedEffectCopyWithImpl<$Res>
    implements $ParticipantMutedEffectCopyWith<$Res> {
  _$ParticipantMutedEffectCopyWithImpl(this._self, this._then);

  final ParticipantMutedEffect _self;
  final $Res Function(ParticipantMutedEffect) _then;

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? participant = freezed,}) {
  return _then(ParticipantMutedEffect(
freezed == participant ? _self.participant : participant // ignore: cast_nullable_to_non_nullable
as CallParticipant?,
  ));
}

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallParticipantCopyWith<$Res>? get participant {
    if (_self.participant == null) {
    return null;
  }

  return $CallParticipantCopyWith<$Res>(_self.participant!, (value) {
    return _then(_self.copyWith(participant: value));
  });
}
}

/// @nodoc


class ParticipantRemovedEffect with DiagnosticableTreeMixin implements RoomEffect {
  const ParticipantRemovedEffect(this.participant);
  

 final  CallParticipant? participant;

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantRemovedEffectCopyWith<ParticipantRemovedEffect> get copyWith => _$ParticipantRemovedEffectCopyWithImpl<ParticipantRemovedEffect>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomEffect.participantRemoved'))
    ..add(DiagnosticsProperty('participant', participant));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantRemovedEffect&&(identical(other.participant, participant) || other.participant == participant));
}


@override
int get hashCode => Object.hash(runtimeType,participant);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomEffect.participantRemoved(participant: $participant)';
}


}

/// @nodoc
abstract mixin class $ParticipantRemovedEffectCopyWith<$Res> implements $RoomEffectCopyWith<$Res> {
  factory $ParticipantRemovedEffectCopyWith(ParticipantRemovedEffect value, $Res Function(ParticipantRemovedEffect) _then) = _$ParticipantRemovedEffectCopyWithImpl;
@useResult
$Res call({
 CallParticipant? participant
});


$CallParticipantCopyWith<$Res>? get participant;

}
/// @nodoc
class _$ParticipantRemovedEffectCopyWithImpl<$Res>
    implements $ParticipantRemovedEffectCopyWith<$Res> {
  _$ParticipantRemovedEffectCopyWithImpl(this._self, this._then);

  final ParticipantRemovedEffect _self;
  final $Res Function(ParticipantRemovedEffect) _then;

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? participant = freezed,}) {
  return _then(ParticipantRemovedEffect(
freezed == participant ? _self.participant : participant // ignore: cast_nullable_to_non_nullable
as CallParticipant?,
  ));
}

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallParticipantCopyWith<$Res>? get participant {
    if (_self.participant == null) {
    return null;
  }

  return $CallParticipantCopyWith<$Res>(_self.participant!, (value) {
    return _then(_self.copyWith(participant: value));
  });
}
}

/// @nodoc


class RoomSettingsChangedEffect with DiagnosticableTreeMixin implements RoomEffect {
  const RoomSettingsChangedEffect(this.change);
  

 final  RoomSettingsChange change;

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomSettingsChangedEffectCopyWith<RoomSettingsChangedEffect> get copyWith => _$RoomSettingsChangedEffectCopyWithImpl<RoomSettingsChangedEffect>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomEffect.settingsChanged'))
    ..add(DiagnosticsProperty('change', change));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomSettingsChangedEffect&&(identical(other.change, change) || other.change == change));
}


@override
int get hashCode => Object.hash(runtimeType,change);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomEffect.settingsChanged(change: $change)';
}


}

/// @nodoc
abstract mixin class $RoomSettingsChangedEffectCopyWith<$Res> implements $RoomEffectCopyWith<$Res> {
  factory $RoomSettingsChangedEffectCopyWith(RoomSettingsChangedEffect value, $Res Function(RoomSettingsChangedEffect) _then) = _$RoomSettingsChangedEffectCopyWithImpl;
@useResult
$Res call({
 RoomSettingsChange change
});




}
/// @nodoc
class _$RoomSettingsChangedEffectCopyWithImpl<$Res>
    implements $RoomSettingsChangedEffectCopyWith<$Res> {
  _$RoomSettingsChangedEffectCopyWithImpl(this._self, this._then);

  final RoomSettingsChangedEffect _self;
  final $Res Function(RoomSettingsChangedEffect) _then;

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? change = null,}) {
  return _then(RoomSettingsChangedEffect(
null == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as RoomSettingsChange,
  ));
}


}

/// @nodoc


class RoomActionFailedEffect with DiagnosticableTreeMixin implements RoomEffect {
  const RoomActionFailedEffect(this.failure);
  

 final  Failure failure;

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomActionFailedEffectCopyWith<RoomActionFailedEffect> get copyWith => _$RoomActionFailedEffectCopyWithImpl<RoomActionFailedEffect>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RoomEffect.actionFailed'))
    ..add(DiagnosticsProperty('failure', failure));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomActionFailedEffect&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RoomEffect.actionFailed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $RoomActionFailedEffectCopyWith<$Res> implements $RoomEffectCopyWith<$Res> {
  factory $RoomActionFailedEffectCopyWith(RoomActionFailedEffect value, $Res Function(RoomActionFailedEffect) _then) = _$RoomActionFailedEffectCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$RoomActionFailedEffectCopyWithImpl<$Res>
    implements $RoomActionFailedEffectCopyWith<$Res> {
  _$RoomActionFailedEffectCopyWithImpl(this._self, this._then);

  final RoomActionFailedEffect _self;
  final $Res Function(RoomActionFailedEffect) _then;

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(RoomActionFailedEffect(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of RoomEffect
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
