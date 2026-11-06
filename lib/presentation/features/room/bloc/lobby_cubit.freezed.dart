// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LobbyState {

 LobbyStatus get status; RoomSummary? get summary; bool get isHost; String get displayName; Failure? get failure; MediaPreviewState get preview;
/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LobbyStateCopyWith<LobbyState> get copyWith => _$LobbyStateCopyWithImpl<LobbyState>(this as LobbyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LobbyState&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.isHost, isHost) || other.isHost == isHost)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.preview, preview) || other.preview == preview));
}


@override
int get hashCode => Object.hash(runtimeType,status,summary,isHost,displayName,failure,preview);

@override
String toString() {
  return 'LobbyState(status: $status, summary: $summary, isHost: $isHost, displayName: $displayName, failure: $failure, preview: $preview)';
}


}

/// @nodoc
abstract mixin class $LobbyStateCopyWith<$Res>  {
  factory $LobbyStateCopyWith(LobbyState value, $Res Function(LobbyState) _then) = _$LobbyStateCopyWithImpl;
@useResult
$Res call({
 LobbyStatus status, RoomSummary? summary, bool isHost, String displayName, Failure? failure, MediaPreviewState preview
});


$RoomSummaryCopyWith<$Res>? get summary;$FailureCopyWith<$Res>? get failure;$MediaPreviewStateCopyWith<$Res> get preview;

}
/// @nodoc
class _$LobbyStateCopyWithImpl<$Res>
    implements $LobbyStateCopyWith<$Res> {
  _$LobbyStateCopyWithImpl(this._self, this._then);

  final LobbyState _self;
  final $Res Function(LobbyState) _then;

/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? summary = freezed,Object? isHost = null,Object? displayName = null,Object? failure = freezed,Object? preview = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LobbyStatus,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as RoomSummary?,isHost: null == isHost ? _self.isHost : isHost // ignore: cast_nullable_to_non_nullable
as bool,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as MediaPreviewState,
  ));
}
/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $RoomSummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaPreviewStateCopyWith<$Res> get preview {
  
  return $MediaPreviewStateCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}


/// Adds pattern-matching-related methods to [LobbyState].
extension LobbyStatePatterns on LobbyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LobbyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LobbyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LobbyState value)  $default,){
final _that = this;
switch (_that) {
case _LobbyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LobbyState value)?  $default,){
final _that = this;
switch (_that) {
case _LobbyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LobbyStatus status,  RoomSummary? summary,  bool isHost,  String displayName,  Failure? failure,  MediaPreviewState preview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LobbyState() when $default != null:
return $default(_that.status,_that.summary,_that.isHost,_that.displayName,_that.failure,_that.preview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LobbyStatus status,  RoomSummary? summary,  bool isHost,  String displayName,  Failure? failure,  MediaPreviewState preview)  $default,) {final _that = this;
switch (_that) {
case _LobbyState():
return $default(_that.status,_that.summary,_that.isHost,_that.displayName,_that.failure,_that.preview);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LobbyStatus status,  RoomSummary? summary,  bool isHost,  String displayName,  Failure? failure,  MediaPreviewState preview)?  $default,) {final _that = this;
switch (_that) {
case _LobbyState() when $default != null:
return $default(_that.status,_that.summary,_that.isHost,_that.displayName,_that.failure,_that.preview);case _:
  return null;

}
}

}

/// @nodoc


class _LobbyState implements LobbyState {
  const _LobbyState({this.status = LobbyStatus.loading, this.summary, this.isHost = false, this.displayName = '', this.failure, this.preview = const MediaPreviewState()});
  

@override@JsonKey() final  LobbyStatus status;
@override final  RoomSummary? summary;
@override@JsonKey() final  bool isHost;
@override@JsonKey() final  String displayName;
@override final  Failure? failure;
@override@JsonKey() final  MediaPreviewState preview;

/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LobbyStateCopyWith<_LobbyState> get copyWith => __$LobbyStateCopyWithImpl<_LobbyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LobbyState&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.isHost, isHost) || other.isHost == isHost)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.preview, preview) || other.preview == preview));
}


@override
int get hashCode => Object.hash(runtimeType,status,summary,isHost,displayName,failure,preview);

@override
String toString() {
  return 'LobbyState(status: $status, summary: $summary, isHost: $isHost, displayName: $displayName, failure: $failure, preview: $preview)';
}


}

/// @nodoc
abstract mixin class _$LobbyStateCopyWith<$Res> implements $LobbyStateCopyWith<$Res> {
  factory _$LobbyStateCopyWith(_LobbyState value, $Res Function(_LobbyState) _then) = __$LobbyStateCopyWithImpl;
@override @useResult
$Res call({
 LobbyStatus status, RoomSummary? summary, bool isHost, String displayName, Failure? failure, MediaPreviewState preview
});


@override $RoomSummaryCopyWith<$Res>? get summary;@override $FailureCopyWith<$Res>? get failure;@override $MediaPreviewStateCopyWith<$Res> get preview;

}
/// @nodoc
class __$LobbyStateCopyWithImpl<$Res>
    implements _$LobbyStateCopyWith<$Res> {
  __$LobbyStateCopyWithImpl(this._self, this._then);

  final _LobbyState _self;
  final $Res Function(_LobbyState) _then;

/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? summary = freezed,Object? isHost = null,Object? displayName = null,Object? failure = freezed,Object? preview = null,}) {
  return _then(_LobbyState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LobbyStatus,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as RoomSummary?,isHost: null == isHost ? _self.isHost : isHost // ignore: cast_nullable_to_non_nullable
as bool,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as MediaPreviewState,
  ));
}

/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $RoomSummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaPreviewStateCopyWith<$Res> get preview {
  
  return $MediaPreviewStateCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}

// dart format on
