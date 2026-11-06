// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaPreviewState {

 bool get cameraEnabled; bool get microphoneEnabled; bool get cameraStarting; DeviceAccess get cameraAccess; DeviceAccess get microphoneAccess; Object? get videoTrack;
/// Create a copy of MediaPreviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaPreviewStateCopyWith<MediaPreviewState> get copyWith => _$MediaPreviewStateCopyWithImpl<MediaPreviewState>(this as MediaPreviewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaPreviewState&&(identical(other.cameraEnabled, cameraEnabled) || other.cameraEnabled == cameraEnabled)&&(identical(other.microphoneEnabled, microphoneEnabled) || other.microphoneEnabled == microphoneEnabled)&&(identical(other.cameraStarting, cameraStarting) || other.cameraStarting == cameraStarting)&&(identical(other.cameraAccess, cameraAccess) || other.cameraAccess == cameraAccess)&&(identical(other.microphoneAccess, microphoneAccess) || other.microphoneAccess == microphoneAccess)&&const DeepCollectionEquality().equals(other.videoTrack, videoTrack));
}


@override
int get hashCode => Object.hash(runtimeType,cameraEnabled,microphoneEnabled,cameraStarting,cameraAccess,microphoneAccess,const DeepCollectionEquality().hash(videoTrack));

@override
String toString() {
  return 'MediaPreviewState(cameraEnabled: $cameraEnabled, microphoneEnabled: $microphoneEnabled, cameraStarting: $cameraStarting, cameraAccess: $cameraAccess, microphoneAccess: $microphoneAccess, videoTrack: $videoTrack)';
}


}

/// @nodoc
abstract mixin class $MediaPreviewStateCopyWith<$Res>  {
  factory $MediaPreviewStateCopyWith(MediaPreviewState value, $Res Function(MediaPreviewState) _then) = _$MediaPreviewStateCopyWithImpl;
@useResult
$Res call({
 bool cameraEnabled, bool microphoneEnabled, bool cameraStarting, DeviceAccess cameraAccess, DeviceAccess microphoneAccess, Object? videoTrack
});




}
/// @nodoc
class _$MediaPreviewStateCopyWithImpl<$Res>
    implements $MediaPreviewStateCopyWith<$Res> {
  _$MediaPreviewStateCopyWithImpl(this._self, this._then);

  final MediaPreviewState _self;
  final $Res Function(MediaPreviewState) _then;

/// Create a copy of MediaPreviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cameraEnabled = null,Object? microphoneEnabled = null,Object? cameraStarting = null,Object? cameraAccess = null,Object? microphoneAccess = null,Object? videoTrack = freezed,}) {
  return _then(_self.copyWith(
cameraEnabled: null == cameraEnabled ? _self.cameraEnabled : cameraEnabled // ignore: cast_nullable_to_non_nullable
as bool,microphoneEnabled: null == microphoneEnabled ? _self.microphoneEnabled : microphoneEnabled // ignore: cast_nullable_to_non_nullable
as bool,cameraStarting: null == cameraStarting ? _self.cameraStarting : cameraStarting // ignore: cast_nullable_to_non_nullable
as bool,cameraAccess: null == cameraAccess ? _self.cameraAccess : cameraAccess // ignore: cast_nullable_to_non_nullable
as DeviceAccess,microphoneAccess: null == microphoneAccess ? _self.microphoneAccess : microphoneAccess // ignore: cast_nullable_to_non_nullable
as DeviceAccess,videoTrack: freezed == videoTrack ? _self.videoTrack : videoTrack ,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaPreviewState].
extension MediaPreviewStatePatterns on MediaPreviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaPreviewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaPreviewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaPreviewState value)  $default,){
final _that = this;
switch (_that) {
case _MediaPreviewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaPreviewState value)?  $default,){
final _that = this;
switch (_that) {
case _MediaPreviewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool cameraEnabled,  bool microphoneEnabled,  bool cameraStarting,  DeviceAccess cameraAccess,  DeviceAccess microphoneAccess,  Object? videoTrack)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaPreviewState() when $default != null:
return $default(_that.cameraEnabled,_that.microphoneEnabled,_that.cameraStarting,_that.cameraAccess,_that.microphoneAccess,_that.videoTrack);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool cameraEnabled,  bool microphoneEnabled,  bool cameraStarting,  DeviceAccess cameraAccess,  DeviceAccess microphoneAccess,  Object? videoTrack)  $default,) {final _that = this;
switch (_that) {
case _MediaPreviewState():
return $default(_that.cameraEnabled,_that.microphoneEnabled,_that.cameraStarting,_that.cameraAccess,_that.microphoneAccess,_that.videoTrack);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool cameraEnabled,  bool microphoneEnabled,  bool cameraStarting,  DeviceAccess cameraAccess,  DeviceAccess microphoneAccess,  Object? videoTrack)?  $default,) {final _that = this;
switch (_that) {
case _MediaPreviewState() when $default != null:
return $default(_that.cameraEnabled,_that.microphoneEnabled,_that.cameraStarting,_that.cameraAccess,_that.microphoneAccess,_that.videoTrack);case _:
  return null;

}
}

}

/// @nodoc


class _MediaPreviewState extends MediaPreviewState {
  const _MediaPreviewState({this.cameraEnabled = false, this.microphoneEnabled = false, this.cameraStarting = false, this.cameraAccess = DeviceAccess.unknown, this.microphoneAccess = DeviceAccess.unknown, this.videoTrack}): super._();
  

@override@JsonKey() final  bool cameraEnabled;
@override@JsonKey() final  bool microphoneEnabled;
@override@JsonKey() final  bool cameraStarting;
@override@JsonKey() final  DeviceAccess cameraAccess;
@override@JsonKey() final  DeviceAccess microphoneAccess;
@override final  Object? videoTrack;

/// Create a copy of MediaPreviewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaPreviewStateCopyWith<_MediaPreviewState> get copyWith => __$MediaPreviewStateCopyWithImpl<_MediaPreviewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaPreviewState&&(identical(other.cameraEnabled, cameraEnabled) || other.cameraEnabled == cameraEnabled)&&(identical(other.microphoneEnabled, microphoneEnabled) || other.microphoneEnabled == microphoneEnabled)&&(identical(other.cameraStarting, cameraStarting) || other.cameraStarting == cameraStarting)&&(identical(other.cameraAccess, cameraAccess) || other.cameraAccess == cameraAccess)&&(identical(other.microphoneAccess, microphoneAccess) || other.microphoneAccess == microphoneAccess)&&const DeepCollectionEquality().equals(other.videoTrack, videoTrack));
}


@override
int get hashCode => Object.hash(runtimeType,cameraEnabled,microphoneEnabled,cameraStarting,cameraAccess,microphoneAccess,const DeepCollectionEquality().hash(videoTrack));

@override
String toString() {
  return 'MediaPreviewState(cameraEnabled: $cameraEnabled, microphoneEnabled: $microphoneEnabled, cameraStarting: $cameraStarting, cameraAccess: $cameraAccess, microphoneAccess: $microphoneAccess, videoTrack: $videoTrack)';
}


}

/// @nodoc
abstract mixin class _$MediaPreviewStateCopyWith<$Res> implements $MediaPreviewStateCopyWith<$Res> {
  factory _$MediaPreviewStateCopyWith(_MediaPreviewState value, $Res Function(_MediaPreviewState) _then) = __$MediaPreviewStateCopyWithImpl;
@override @useResult
$Res call({
 bool cameraEnabled, bool microphoneEnabled, bool cameraStarting, DeviceAccess cameraAccess, DeviceAccess microphoneAccess, Object? videoTrack
});




}
/// @nodoc
class __$MediaPreviewStateCopyWithImpl<$Res>
    implements _$MediaPreviewStateCopyWith<$Res> {
  __$MediaPreviewStateCopyWithImpl(this._self, this._then);

  final _MediaPreviewState _self;
  final $Res Function(_MediaPreviewState) _then;

/// Create a copy of MediaPreviewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cameraEnabled = null,Object? microphoneEnabled = null,Object? cameraStarting = null,Object? cameraAccess = null,Object? microphoneAccess = null,Object? videoTrack = freezed,}) {
  return _then(_MediaPreviewState(
cameraEnabled: null == cameraEnabled ? _self.cameraEnabled : cameraEnabled // ignore: cast_nullable_to_non_nullable
as bool,microphoneEnabled: null == microphoneEnabled ? _self.microphoneEnabled : microphoneEnabled // ignore: cast_nullable_to_non_nullable
as bool,cameraStarting: null == cameraStarting ? _self.cameraStarting : cameraStarting // ignore: cast_nullable_to_non_nullable
as bool,cameraAccess: null == cameraAccess ? _self.cameraAccess : cameraAccess // ignore: cast_nullable_to_non_nullable
as DeviceAccess,microphoneAccess: null == microphoneAccess ? _self.microphoneAccess : microphoneAccess // ignore: cast_nullable_to_non_nullable
as DeviceAccess,videoTrack: freezed == videoTrack ? _self.videoTrack : videoTrack ,
  ));
}


}

// dart format on
