// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallParticipant {

 String get id; String get identity; String get displayName; bool get isLocal; bool get isSpeaking; bool get microphoneEnabled; bool get cameraEnabled; bool get weakConnection; String? get audioTrackSid; double? get videoAspectRatio; Object? get videoTrack;
/// Create a copy of CallParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallParticipantCopyWith<CallParticipant> get copyWith => _$CallParticipantCopyWithImpl<CallParticipant>(this as CallParticipant, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallParticipant&&(identical(other.id, id) || other.id == id)&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.isLocal, isLocal) || other.isLocal == isLocal)&&(identical(other.isSpeaking, isSpeaking) || other.isSpeaking == isSpeaking)&&(identical(other.microphoneEnabled, microphoneEnabled) || other.microphoneEnabled == microphoneEnabled)&&(identical(other.cameraEnabled, cameraEnabled) || other.cameraEnabled == cameraEnabled)&&(identical(other.weakConnection, weakConnection) || other.weakConnection == weakConnection)&&(identical(other.audioTrackSid, audioTrackSid) || other.audioTrackSid == audioTrackSid)&&(identical(other.videoAspectRatio, videoAspectRatio) || other.videoAspectRatio == videoAspectRatio)&&const DeepCollectionEquality().equals(other.videoTrack, videoTrack));
}


@override
int get hashCode => Object.hash(runtimeType,id,identity,displayName,isLocal,isSpeaking,microphoneEnabled,cameraEnabled,weakConnection,audioTrackSid,videoAspectRatio,const DeepCollectionEquality().hash(videoTrack));

@override
String toString() {
  return 'CallParticipant(id: $id, identity: $identity, displayName: $displayName, isLocal: $isLocal, isSpeaking: $isSpeaking, microphoneEnabled: $microphoneEnabled, cameraEnabled: $cameraEnabled, weakConnection: $weakConnection, audioTrackSid: $audioTrackSid, videoAspectRatio: $videoAspectRatio, videoTrack: $videoTrack)';
}


}

/// @nodoc
abstract mixin class $CallParticipantCopyWith<$Res>  {
  factory $CallParticipantCopyWith(CallParticipant value, $Res Function(CallParticipant) _then) = _$CallParticipantCopyWithImpl;
@useResult
$Res call({
 String id, String identity, String displayName, bool isLocal, bool isSpeaking, bool microphoneEnabled, bool cameraEnabled, bool weakConnection, String? audioTrackSid, double? videoAspectRatio, Object? videoTrack
});




}
/// @nodoc
class _$CallParticipantCopyWithImpl<$Res>
    implements $CallParticipantCopyWith<$Res> {
  _$CallParticipantCopyWithImpl(this._self, this._then);

  final CallParticipant _self;
  final $Res Function(CallParticipant) _then;

/// Create a copy of CallParticipant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? identity = null,Object? displayName = null,Object? isLocal = null,Object? isSpeaking = null,Object? microphoneEnabled = null,Object? cameraEnabled = null,Object? weakConnection = null,Object? audioTrackSid = freezed,Object? videoAspectRatio = freezed,Object? videoTrack = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isLocal: null == isLocal ? _self.isLocal : isLocal // ignore: cast_nullable_to_non_nullable
as bool,isSpeaking: null == isSpeaking ? _self.isSpeaking : isSpeaking // ignore: cast_nullable_to_non_nullable
as bool,microphoneEnabled: null == microphoneEnabled ? _self.microphoneEnabled : microphoneEnabled // ignore: cast_nullable_to_non_nullable
as bool,cameraEnabled: null == cameraEnabled ? _self.cameraEnabled : cameraEnabled // ignore: cast_nullable_to_non_nullable
as bool,weakConnection: null == weakConnection ? _self.weakConnection : weakConnection // ignore: cast_nullable_to_non_nullable
as bool,audioTrackSid: freezed == audioTrackSid ? _self.audioTrackSid : audioTrackSid // ignore: cast_nullable_to_non_nullable
as String?,videoAspectRatio: freezed == videoAspectRatio ? _self.videoAspectRatio : videoAspectRatio // ignore: cast_nullable_to_non_nullable
as double?,videoTrack: freezed == videoTrack ? _self.videoTrack : videoTrack ,
  ));
}

}


/// Adds pattern-matching-related methods to [CallParticipant].
extension CallParticipantPatterns on CallParticipant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallParticipant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallParticipant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallParticipant value)  $default,){
final _that = this;
switch (_that) {
case _CallParticipant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallParticipant value)?  $default,){
final _that = this;
switch (_that) {
case _CallParticipant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String identity,  String displayName,  bool isLocal,  bool isSpeaking,  bool microphoneEnabled,  bool cameraEnabled,  bool weakConnection,  String? audioTrackSid,  double? videoAspectRatio,  Object? videoTrack)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallParticipant() when $default != null:
return $default(_that.id,_that.identity,_that.displayName,_that.isLocal,_that.isSpeaking,_that.microphoneEnabled,_that.cameraEnabled,_that.weakConnection,_that.audioTrackSid,_that.videoAspectRatio,_that.videoTrack);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String identity,  String displayName,  bool isLocal,  bool isSpeaking,  bool microphoneEnabled,  bool cameraEnabled,  bool weakConnection,  String? audioTrackSid,  double? videoAspectRatio,  Object? videoTrack)  $default,) {final _that = this;
switch (_that) {
case _CallParticipant():
return $default(_that.id,_that.identity,_that.displayName,_that.isLocal,_that.isSpeaking,_that.microphoneEnabled,_that.cameraEnabled,_that.weakConnection,_that.audioTrackSid,_that.videoAspectRatio,_that.videoTrack);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String identity,  String displayName,  bool isLocal,  bool isSpeaking,  bool microphoneEnabled,  bool cameraEnabled,  bool weakConnection,  String? audioTrackSid,  double? videoAspectRatio,  Object? videoTrack)?  $default,) {final _that = this;
switch (_that) {
case _CallParticipant() when $default != null:
return $default(_that.id,_that.identity,_that.displayName,_that.isLocal,_that.isSpeaking,_that.microphoneEnabled,_that.cameraEnabled,_that.weakConnection,_that.audioTrackSid,_that.videoAspectRatio,_that.videoTrack);case _:
  return null;

}
}

}

/// @nodoc


class _CallParticipant implements CallParticipant {
  const _CallParticipant({required this.id, required this.identity, required this.displayName, required this.isLocal, this.isSpeaking = false, this.microphoneEnabled = false, this.cameraEnabled = false, this.weakConnection = false, this.audioTrackSid, this.videoAspectRatio, this.videoTrack});
  

@override final  String id;
@override final  String identity;
@override final  String displayName;
@override final  bool isLocal;
@override@JsonKey() final  bool isSpeaking;
@override@JsonKey() final  bool microphoneEnabled;
@override@JsonKey() final  bool cameraEnabled;
@override@JsonKey() final  bool weakConnection;
@override final  String? audioTrackSid;
@override final  double? videoAspectRatio;
@override final  Object? videoTrack;

/// Create a copy of CallParticipant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallParticipantCopyWith<_CallParticipant> get copyWith => __$CallParticipantCopyWithImpl<_CallParticipant>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallParticipant&&(identical(other.id, id) || other.id == id)&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.isLocal, isLocal) || other.isLocal == isLocal)&&(identical(other.isSpeaking, isSpeaking) || other.isSpeaking == isSpeaking)&&(identical(other.microphoneEnabled, microphoneEnabled) || other.microphoneEnabled == microphoneEnabled)&&(identical(other.cameraEnabled, cameraEnabled) || other.cameraEnabled == cameraEnabled)&&(identical(other.weakConnection, weakConnection) || other.weakConnection == weakConnection)&&(identical(other.audioTrackSid, audioTrackSid) || other.audioTrackSid == audioTrackSid)&&(identical(other.videoAspectRatio, videoAspectRatio) || other.videoAspectRatio == videoAspectRatio)&&const DeepCollectionEquality().equals(other.videoTrack, videoTrack));
}


@override
int get hashCode => Object.hash(runtimeType,id,identity,displayName,isLocal,isSpeaking,microphoneEnabled,cameraEnabled,weakConnection,audioTrackSid,videoAspectRatio,const DeepCollectionEquality().hash(videoTrack));

@override
String toString() {
  return 'CallParticipant(id: $id, identity: $identity, displayName: $displayName, isLocal: $isLocal, isSpeaking: $isSpeaking, microphoneEnabled: $microphoneEnabled, cameraEnabled: $cameraEnabled, weakConnection: $weakConnection, audioTrackSid: $audioTrackSid, videoAspectRatio: $videoAspectRatio, videoTrack: $videoTrack)';
}


}

/// @nodoc
abstract mixin class _$CallParticipantCopyWith<$Res> implements $CallParticipantCopyWith<$Res> {
  factory _$CallParticipantCopyWith(_CallParticipant value, $Res Function(_CallParticipant) _then) = __$CallParticipantCopyWithImpl;
@override @useResult
$Res call({
 String id, String identity, String displayName, bool isLocal, bool isSpeaking, bool microphoneEnabled, bool cameraEnabled, bool weakConnection, String? audioTrackSid, double? videoAspectRatio, Object? videoTrack
});




}
/// @nodoc
class __$CallParticipantCopyWithImpl<$Res>
    implements _$CallParticipantCopyWith<$Res> {
  __$CallParticipantCopyWithImpl(this._self, this._then);

  final _CallParticipant _self;
  final $Res Function(_CallParticipant) _then;

/// Create a copy of CallParticipant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? identity = null,Object? displayName = null,Object? isLocal = null,Object? isSpeaking = null,Object? microphoneEnabled = null,Object? cameraEnabled = null,Object? weakConnection = null,Object? audioTrackSid = freezed,Object? videoAspectRatio = freezed,Object? videoTrack = freezed,}) {
  return _then(_CallParticipant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isLocal: null == isLocal ? _self.isLocal : isLocal // ignore: cast_nullable_to_non_nullable
as bool,isSpeaking: null == isSpeaking ? _self.isSpeaking : isSpeaking // ignore: cast_nullable_to_non_nullable
as bool,microphoneEnabled: null == microphoneEnabled ? _self.microphoneEnabled : microphoneEnabled // ignore: cast_nullable_to_non_nullable
as bool,cameraEnabled: null == cameraEnabled ? _self.cameraEnabled : cameraEnabled // ignore: cast_nullable_to_non_nullable
as bool,weakConnection: null == weakConnection ? _self.weakConnection : weakConnection // ignore: cast_nullable_to_non_nullable
as bool,audioTrackSid: freezed == audioTrackSid ? _self.audioTrackSid : audioTrackSid // ignore: cast_nullable_to_non_nullable
as String?,videoAspectRatio: freezed == videoAspectRatio ? _self.videoAspectRatio : videoAspectRatio // ignore: cast_nullable_to_non_nullable
as double?,videoTrack: freezed == videoTrack ? _self.videoTrack : videoTrack ,
  ));
}


}

/// @nodoc
mixin _$CallSnapshot {

 CallConnection get connection; CallEndReason? get endReason; List<CallParticipant> get participants; bool get microphoneEnabled; bool get cameraEnabled; bool get frontCamera; bool get speakerphoneOn; bool get audioPlaybackBlocked; bool get microphoneUnavailable;
/// Create a copy of CallSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallSnapshotCopyWith<CallSnapshot> get copyWith => _$CallSnapshotCopyWithImpl<CallSnapshot>(this as CallSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallSnapshot&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.endReason, endReason) || other.endReason == endReason)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.microphoneEnabled, microphoneEnabled) || other.microphoneEnabled == microphoneEnabled)&&(identical(other.cameraEnabled, cameraEnabled) || other.cameraEnabled == cameraEnabled)&&(identical(other.frontCamera, frontCamera) || other.frontCamera == frontCamera)&&(identical(other.speakerphoneOn, speakerphoneOn) || other.speakerphoneOn == speakerphoneOn)&&(identical(other.audioPlaybackBlocked, audioPlaybackBlocked) || other.audioPlaybackBlocked == audioPlaybackBlocked)&&(identical(other.microphoneUnavailable, microphoneUnavailable) || other.microphoneUnavailable == microphoneUnavailable));
}


@override
int get hashCode => Object.hash(runtimeType,connection,endReason,const DeepCollectionEquality().hash(participants),microphoneEnabled,cameraEnabled,frontCamera,speakerphoneOn,audioPlaybackBlocked,microphoneUnavailable);

@override
String toString() {
  return 'CallSnapshot(connection: $connection, endReason: $endReason, participants: $participants, microphoneEnabled: $microphoneEnabled, cameraEnabled: $cameraEnabled, frontCamera: $frontCamera, speakerphoneOn: $speakerphoneOn, audioPlaybackBlocked: $audioPlaybackBlocked, microphoneUnavailable: $microphoneUnavailable)';
}


}

/// @nodoc
abstract mixin class $CallSnapshotCopyWith<$Res>  {
  factory $CallSnapshotCopyWith(CallSnapshot value, $Res Function(CallSnapshot) _then) = _$CallSnapshotCopyWithImpl;
@useResult
$Res call({
 CallConnection connection, CallEndReason? endReason, List<CallParticipant> participants, bool microphoneEnabled, bool cameraEnabled, bool frontCamera, bool speakerphoneOn, bool audioPlaybackBlocked, bool microphoneUnavailable
});




}
/// @nodoc
class _$CallSnapshotCopyWithImpl<$Res>
    implements $CallSnapshotCopyWith<$Res> {
  _$CallSnapshotCopyWithImpl(this._self, this._then);

  final CallSnapshot _self;
  final $Res Function(CallSnapshot) _then;

/// Create a copy of CallSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connection = null,Object? endReason = freezed,Object? participants = null,Object? microphoneEnabled = null,Object? cameraEnabled = null,Object? frontCamera = null,Object? speakerphoneOn = null,Object? audioPlaybackBlocked = null,Object? microphoneUnavailable = null,}) {
  return _then(_self.copyWith(
connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as CallConnection,endReason: freezed == endReason ? _self.endReason : endReason // ignore: cast_nullable_to_non_nullable
as CallEndReason?,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<CallParticipant>,microphoneEnabled: null == microphoneEnabled ? _self.microphoneEnabled : microphoneEnabled // ignore: cast_nullable_to_non_nullable
as bool,cameraEnabled: null == cameraEnabled ? _self.cameraEnabled : cameraEnabled // ignore: cast_nullable_to_non_nullable
as bool,frontCamera: null == frontCamera ? _self.frontCamera : frontCamera // ignore: cast_nullable_to_non_nullable
as bool,speakerphoneOn: null == speakerphoneOn ? _self.speakerphoneOn : speakerphoneOn // ignore: cast_nullable_to_non_nullable
as bool,audioPlaybackBlocked: null == audioPlaybackBlocked ? _self.audioPlaybackBlocked : audioPlaybackBlocked // ignore: cast_nullable_to_non_nullable
as bool,microphoneUnavailable: null == microphoneUnavailable ? _self.microphoneUnavailable : microphoneUnavailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CallSnapshot].
extension CallSnapshotPatterns on CallSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _CallSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _CallSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CallConnection connection,  CallEndReason? endReason,  List<CallParticipant> participants,  bool microphoneEnabled,  bool cameraEnabled,  bool frontCamera,  bool speakerphoneOn,  bool audioPlaybackBlocked,  bool microphoneUnavailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallSnapshot() when $default != null:
return $default(_that.connection,_that.endReason,_that.participants,_that.microphoneEnabled,_that.cameraEnabled,_that.frontCamera,_that.speakerphoneOn,_that.audioPlaybackBlocked,_that.microphoneUnavailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CallConnection connection,  CallEndReason? endReason,  List<CallParticipant> participants,  bool microphoneEnabled,  bool cameraEnabled,  bool frontCamera,  bool speakerphoneOn,  bool audioPlaybackBlocked,  bool microphoneUnavailable)  $default,) {final _that = this;
switch (_that) {
case _CallSnapshot():
return $default(_that.connection,_that.endReason,_that.participants,_that.microphoneEnabled,_that.cameraEnabled,_that.frontCamera,_that.speakerphoneOn,_that.audioPlaybackBlocked,_that.microphoneUnavailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CallConnection connection,  CallEndReason? endReason,  List<CallParticipant> participants,  bool microphoneEnabled,  bool cameraEnabled,  bool frontCamera,  bool speakerphoneOn,  bool audioPlaybackBlocked,  bool microphoneUnavailable)?  $default,) {final _that = this;
switch (_that) {
case _CallSnapshot() when $default != null:
return $default(_that.connection,_that.endReason,_that.participants,_that.microphoneEnabled,_that.cameraEnabled,_that.frontCamera,_that.speakerphoneOn,_that.audioPlaybackBlocked,_that.microphoneUnavailable);case _:
  return null;

}
}

}

/// @nodoc


class _CallSnapshot extends CallSnapshot {
  const _CallSnapshot({this.connection = CallConnection.idle, this.endReason, final  List<CallParticipant> participants = const <CallParticipant>[], this.microphoneEnabled = false, this.cameraEnabled = false, this.frontCamera = true, this.speakerphoneOn = false, this.audioPlaybackBlocked = false, this.microphoneUnavailable = false}): _participants = participants,super._();
  

@override@JsonKey() final  CallConnection connection;
@override final  CallEndReason? endReason;
 final  List<CallParticipant> _participants;
@override@JsonKey() List<CallParticipant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

@override@JsonKey() final  bool microphoneEnabled;
@override@JsonKey() final  bool cameraEnabled;
@override@JsonKey() final  bool frontCamera;
@override@JsonKey() final  bool speakerphoneOn;
@override@JsonKey() final  bool audioPlaybackBlocked;
@override@JsonKey() final  bool microphoneUnavailable;

/// Create a copy of CallSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallSnapshotCopyWith<_CallSnapshot> get copyWith => __$CallSnapshotCopyWithImpl<_CallSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallSnapshot&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.endReason, endReason) || other.endReason == endReason)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.microphoneEnabled, microphoneEnabled) || other.microphoneEnabled == microphoneEnabled)&&(identical(other.cameraEnabled, cameraEnabled) || other.cameraEnabled == cameraEnabled)&&(identical(other.frontCamera, frontCamera) || other.frontCamera == frontCamera)&&(identical(other.speakerphoneOn, speakerphoneOn) || other.speakerphoneOn == speakerphoneOn)&&(identical(other.audioPlaybackBlocked, audioPlaybackBlocked) || other.audioPlaybackBlocked == audioPlaybackBlocked)&&(identical(other.microphoneUnavailable, microphoneUnavailable) || other.microphoneUnavailable == microphoneUnavailable));
}


@override
int get hashCode => Object.hash(runtimeType,connection,endReason,const DeepCollectionEquality().hash(_participants),microphoneEnabled,cameraEnabled,frontCamera,speakerphoneOn,audioPlaybackBlocked,microphoneUnavailable);

@override
String toString() {
  return 'CallSnapshot(connection: $connection, endReason: $endReason, participants: $participants, microphoneEnabled: $microphoneEnabled, cameraEnabled: $cameraEnabled, frontCamera: $frontCamera, speakerphoneOn: $speakerphoneOn, audioPlaybackBlocked: $audioPlaybackBlocked, microphoneUnavailable: $microphoneUnavailable)';
}


}

/// @nodoc
abstract mixin class _$CallSnapshotCopyWith<$Res> implements $CallSnapshotCopyWith<$Res> {
  factory _$CallSnapshotCopyWith(_CallSnapshot value, $Res Function(_CallSnapshot) _then) = __$CallSnapshotCopyWithImpl;
@override @useResult
$Res call({
 CallConnection connection, CallEndReason? endReason, List<CallParticipant> participants, bool microphoneEnabled, bool cameraEnabled, bool frontCamera, bool speakerphoneOn, bool audioPlaybackBlocked, bool microphoneUnavailable
});




}
/// @nodoc
class __$CallSnapshotCopyWithImpl<$Res>
    implements _$CallSnapshotCopyWith<$Res> {
  __$CallSnapshotCopyWithImpl(this._self, this._then);

  final _CallSnapshot _self;
  final $Res Function(_CallSnapshot) _then;

/// Create a copy of CallSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connection = null,Object? endReason = freezed,Object? participants = null,Object? microphoneEnabled = null,Object? cameraEnabled = null,Object? frontCamera = null,Object? speakerphoneOn = null,Object? audioPlaybackBlocked = null,Object? microphoneUnavailable = null,}) {
  return _then(_CallSnapshot(
connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as CallConnection,endReason: freezed == endReason ? _self.endReason : endReason // ignore: cast_nullable_to_non_nullable
as CallEndReason?,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<CallParticipant>,microphoneEnabled: null == microphoneEnabled ? _self.microphoneEnabled : microphoneEnabled // ignore: cast_nullable_to_non_nullable
as bool,cameraEnabled: null == cameraEnabled ? _self.cameraEnabled : cameraEnabled // ignore: cast_nullable_to_non_nullable
as bool,frontCamera: null == frontCamera ? _self.frontCamera : frontCamera // ignore: cast_nullable_to_non_nullable
as bool,speakerphoneOn: null == speakerphoneOn ? _self.speakerphoneOn : speakerphoneOn // ignore: cast_nullable_to_non_nullable
as bool,audioPlaybackBlocked: null == audioPlaybackBlocked ? _self.audioPlaybackBlocked : audioPlaybackBlocked // ignore: cast_nullable_to_non_nullable
as bool,microphoneUnavailable: null == microphoneUnavailable ? _self.microphoneUnavailable : microphoneUnavailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
