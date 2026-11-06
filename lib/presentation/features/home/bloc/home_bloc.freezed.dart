// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent()';
}


}

/// @nodoc
class $HomeEventCopyWith<$Res>  {
$HomeEventCopyWith(HomeEvent _, $Res Function(HomeEvent) __);
}


/// Adds pattern-matching-related methods to [HomeEvent].
extension HomeEventPatterns on HomeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HomeStarted value)?  started,TResult Function( HomeJoinSubmitted value)?  joinSubmitted,TResult Function( HomeJoinInputChanged value)?  joinInputChanged,TResult Function( HomeRecentRoomRemoved value)?  recentRoomRemoved,TResult Function( HomeRecentRoomRestored value)?  recentRoomRestored,TResult Function( HomeCreateFormOpened value)?  createFormOpened,TResult Function( HomeCreateRoomRequested value)?  createRoomRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HomeStarted() when started != null:
return started(_that);case HomeJoinSubmitted() when joinSubmitted != null:
return joinSubmitted(_that);case HomeJoinInputChanged() when joinInputChanged != null:
return joinInputChanged(_that);case HomeRecentRoomRemoved() when recentRoomRemoved != null:
return recentRoomRemoved(_that);case HomeRecentRoomRestored() when recentRoomRestored != null:
return recentRoomRestored(_that);case HomeCreateFormOpened() when createFormOpened != null:
return createFormOpened(_that);case HomeCreateRoomRequested() when createRoomRequested != null:
return createRoomRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HomeStarted value)  started,required TResult Function( HomeJoinSubmitted value)  joinSubmitted,required TResult Function( HomeJoinInputChanged value)  joinInputChanged,required TResult Function( HomeRecentRoomRemoved value)  recentRoomRemoved,required TResult Function( HomeRecentRoomRestored value)  recentRoomRestored,required TResult Function( HomeCreateFormOpened value)  createFormOpened,required TResult Function( HomeCreateRoomRequested value)  createRoomRequested,}){
final _that = this;
switch (_that) {
case HomeStarted():
return started(_that);case HomeJoinSubmitted():
return joinSubmitted(_that);case HomeJoinInputChanged():
return joinInputChanged(_that);case HomeRecentRoomRemoved():
return recentRoomRemoved(_that);case HomeRecentRoomRestored():
return recentRoomRestored(_that);case HomeCreateFormOpened():
return createFormOpened(_that);case HomeCreateRoomRequested():
return createRoomRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HomeStarted value)?  started,TResult? Function( HomeJoinSubmitted value)?  joinSubmitted,TResult? Function( HomeJoinInputChanged value)?  joinInputChanged,TResult? Function( HomeRecentRoomRemoved value)?  recentRoomRemoved,TResult? Function( HomeRecentRoomRestored value)?  recentRoomRestored,TResult? Function( HomeCreateFormOpened value)?  createFormOpened,TResult? Function( HomeCreateRoomRequested value)?  createRoomRequested,}){
final _that = this;
switch (_that) {
case HomeStarted() when started != null:
return started(_that);case HomeJoinSubmitted() when joinSubmitted != null:
return joinSubmitted(_that);case HomeJoinInputChanged() when joinInputChanged != null:
return joinInputChanged(_that);case HomeRecentRoomRemoved() when recentRoomRemoved != null:
return recentRoomRemoved(_that);case HomeRecentRoomRestored() when recentRoomRestored != null:
return recentRoomRestored(_that);case HomeCreateFormOpened() when createFormOpened != null:
return createFormOpened(_that);case HomeCreateRoomRequested() when createRoomRequested != null:
return createRoomRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String input)?  joinSubmitted,TResult Function()?  joinInputChanged,TResult Function( RoomCode code)?  recentRoomRemoved,TResult Function( RecentRoom room)?  recentRoomRestored,TResult Function()?  createFormOpened,TResult Function( CreateRoomParams params)?  createRoomRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HomeStarted() when started != null:
return started();case HomeJoinSubmitted() when joinSubmitted != null:
return joinSubmitted(_that.input);case HomeJoinInputChanged() when joinInputChanged != null:
return joinInputChanged();case HomeRecentRoomRemoved() when recentRoomRemoved != null:
return recentRoomRemoved(_that.code);case HomeRecentRoomRestored() when recentRoomRestored != null:
return recentRoomRestored(_that.room);case HomeCreateFormOpened() when createFormOpened != null:
return createFormOpened();case HomeCreateRoomRequested() when createRoomRequested != null:
return createRoomRequested(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String input)  joinSubmitted,required TResult Function()  joinInputChanged,required TResult Function( RoomCode code)  recentRoomRemoved,required TResult Function( RecentRoom room)  recentRoomRestored,required TResult Function()  createFormOpened,required TResult Function( CreateRoomParams params)  createRoomRequested,}) {final _that = this;
switch (_that) {
case HomeStarted():
return started();case HomeJoinSubmitted():
return joinSubmitted(_that.input);case HomeJoinInputChanged():
return joinInputChanged();case HomeRecentRoomRemoved():
return recentRoomRemoved(_that.code);case HomeRecentRoomRestored():
return recentRoomRestored(_that.room);case HomeCreateFormOpened():
return createFormOpened();case HomeCreateRoomRequested():
return createRoomRequested(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String input)?  joinSubmitted,TResult? Function()?  joinInputChanged,TResult? Function( RoomCode code)?  recentRoomRemoved,TResult? Function( RecentRoom room)?  recentRoomRestored,TResult? Function()?  createFormOpened,TResult? Function( CreateRoomParams params)?  createRoomRequested,}) {final _that = this;
switch (_that) {
case HomeStarted() when started != null:
return started();case HomeJoinSubmitted() when joinSubmitted != null:
return joinSubmitted(_that.input);case HomeJoinInputChanged() when joinInputChanged != null:
return joinInputChanged();case HomeRecentRoomRemoved() when recentRoomRemoved != null:
return recentRoomRemoved(_that.code);case HomeRecentRoomRestored() when recentRoomRestored != null:
return recentRoomRestored(_that.room);case HomeCreateFormOpened() when createFormOpened != null:
return createFormOpened();case HomeCreateRoomRequested() when createRoomRequested != null:
return createRoomRequested(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class HomeStarted implements HomeEvent {
  const HomeStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.started()';
}


}




/// @nodoc


class HomeJoinSubmitted implements HomeEvent {
  const HomeJoinSubmitted(this.input);
  

 final  String input;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeJoinSubmittedCopyWith<HomeJoinSubmitted> get copyWith => _$HomeJoinSubmittedCopyWithImpl<HomeJoinSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeJoinSubmitted&&(identical(other.input, input) || other.input == input));
}


@override
int get hashCode => Object.hash(runtimeType,input);

@override
String toString() {
  return 'HomeEvent.joinSubmitted(input: $input)';
}


}

/// @nodoc
abstract mixin class $HomeJoinSubmittedCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory $HomeJoinSubmittedCopyWith(HomeJoinSubmitted value, $Res Function(HomeJoinSubmitted) _then) = _$HomeJoinSubmittedCopyWithImpl;
@useResult
$Res call({
 String input
});




}
/// @nodoc
class _$HomeJoinSubmittedCopyWithImpl<$Res>
    implements $HomeJoinSubmittedCopyWith<$Res> {
  _$HomeJoinSubmittedCopyWithImpl(this._self, this._then);

  final HomeJoinSubmitted _self;
  final $Res Function(HomeJoinSubmitted) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? input = null,}) {
  return _then(HomeJoinSubmitted(
null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HomeJoinInputChanged implements HomeEvent {
  const HomeJoinInputChanged();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeJoinInputChanged);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.joinInputChanged()';
}


}




/// @nodoc


class HomeRecentRoomRemoved implements HomeEvent {
  const HomeRecentRoomRemoved(this.code);
  

 final  RoomCode code;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeRecentRoomRemovedCopyWith<HomeRecentRoomRemoved> get copyWith => _$HomeRecentRoomRemovedCopyWithImpl<HomeRecentRoomRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeRecentRoomRemoved&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString() {
  return 'HomeEvent.recentRoomRemoved(code: $code)';
}


}

/// @nodoc
abstract mixin class $HomeRecentRoomRemovedCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory $HomeRecentRoomRemovedCopyWith(HomeRecentRoomRemoved value, $Res Function(HomeRecentRoomRemoved) _then) = _$HomeRecentRoomRemovedCopyWithImpl;
@useResult
$Res call({
 RoomCode code
});


$RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class _$HomeRecentRoomRemovedCopyWithImpl<$Res>
    implements $HomeRecentRoomRemovedCopyWith<$Res> {
  _$HomeRecentRoomRemovedCopyWithImpl(this._self, this._then);

  final HomeRecentRoomRemoved _self;
  final $Res Function(HomeRecentRoomRemoved) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(HomeRecentRoomRemoved(
null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,
  ));
}

/// Create a copy of HomeEvent
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


class HomeRecentRoomRestored implements HomeEvent {
  const HomeRecentRoomRestored(this.room);
  

 final  RecentRoom room;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeRecentRoomRestoredCopyWith<HomeRecentRoomRestored> get copyWith => _$HomeRecentRoomRestoredCopyWithImpl<HomeRecentRoomRestored>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeRecentRoomRestored&&(identical(other.room, room) || other.room == room));
}


@override
int get hashCode => Object.hash(runtimeType,room);

@override
String toString() {
  return 'HomeEvent.recentRoomRestored(room: $room)';
}


}

/// @nodoc
abstract mixin class $HomeRecentRoomRestoredCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory $HomeRecentRoomRestoredCopyWith(HomeRecentRoomRestored value, $Res Function(HomeRecentRoomRestored) _then) = _$HomeRecentRoomRestoredCopyWithImpl;
@useResult
$Res call({
 RecentRoom room
});


$RecentRoomCopyWith<$Res> get room;

}
/// @nodoc
class _$HomeRecentRoomRestoredCopyWithImpl<$Res>
    implements $HomeRecentRoomRestoredCopyWith<$Res> {
  _$HomeRecentRoomRestoredCopyWithImpl(this._self, this._then);

  final HomeRecentRoomRestored _self;
  final $Res Function(HomeRecentRoomRestored) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? room = null,}) {
  return _then(HomeRecentRoomRestored(
null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as RecentRoom,
  ));
}

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentRoomCopyWith<$Res> get room {
  
  return $RecentRoomCopyWith<$Res>(_self.room, (value) {
    return _then(_self.copyWith(room: value));
  });
}
}

/// @nodoc


class HomeCreateFormOpened implements HomeEvent {
  const HomeCreateFormOpened();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeCreateFormOpened);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.createFormOpened()';
}


}




/// @nodoc


class HomeCreateRoomRequested implements HomeEvent {
  const HomeCreateRoomRequested(this.params);
  

 final  CreateRoomParams params;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeCreateRoomRequestedCopyWith<HomeCreateRoomRequested> get copyWith => _$HomeCreateRoomRequestedCopyWithImpl<HomeCreateRoomRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeCreateRoomRequested&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'HomeEvent.createRoomRequested(params: $params)';
}


}

/// @nodoc
abstract mixin class $HomeCreateRoomRequestedCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory $HomeCreateRoomRequestedCopyWith(HomeCreateRoomRequested value, $Res Function(HomeCreateRoomRequested) _then) = _$HomeCreateRoomRequestedCopyWithImpl;
@useResult
$Res call({
 CreateRoomParams params
});


$CreateRoomParamsCopyWith<$Res> get params;

}
/// @nodoc
class _$HomeCreateRoomRequestedCopyWithImpl<$Res>
    implements $HomeCreateRoomRequestedCopyWith<$Res> {
  _$HomeCreateRoomRequestedCopyWithImpl(this._self, this._then);

  final HomeCreateRoomRequested _self;
  final $Res Function(HomeCreateRoomRequested) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? params = null,}) {
  return _then(HomeCreateRoomRequested(
null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as CreateRoomParams,
  ));
}

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreateRoomParamsCopyWith<$Res> get params {
  
  return $CreateRoomParamsCopyWith<$Res>(_self.params, (value) {
    return _then(_self.copyWith(params: value));
  });
}
}

/// @nodoc
mixin _$HomeState {

 List<RecentRoom> get recentRooms; bool get isLoading; bool get isLookingUp; JoinInputError? get joinError; Failure? get joinFailure; RoomSummary? get joinTarget; bool get isCreating; Failure? get createFailure; CreatedRoom? get createdRoom;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&const DeepCollectionEquality().equals(other.recentRooms, recentRooms)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLookingUp, isLookingUp) || other.isLookingUp == isLookingUp)&&(identical(other.joinError, joinError) || other.joinError == joinError)&&(identical(other.joinFailure, joinFailure) || other.joinFailure == joinFailure)&&(identical(other.joinTarget, joinTarget) || other.joinTarget == joinTarget)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating)&&(identical(other.createFailure, createFailure) || other.createFailure == createFailure)&&(identical(other.createdRoom, createdRoom) || other.createdRoom == createdRoom));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(recentRooms),isLoading,isLookingUp,joinError,joinFailure,joinTarget,isCreating,createFailure,createdRoom);

@override
String toString() {
  return 'HomeState(recentRooms: $recentRooms, isLoading: $isLoading, isLookingUp: $isLookingUp, joinError: $joinError, joinFailure: $joinFailure, joinTarget: $joinTarget, isCreating: $isCreating, createFailure: $createFailure, createdRoom: $createdRoom)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 List<RecentRoom> recentRooms, bool isLoading, bool isLookingUp, JoinInputError? joinError, Failure? joinFailure, RoomSummary? joinTarget, bool isCreating, Failure? createFailure, CreatedRoom? createdRoom
});


$FailureCopyWith<$Res>? get joinFailure;$RoomSummaryCopyWith<$Res>? get joinTarget;$FailureCopyWith<$Res>? get createFailure;$CreatedRoomCopyWith<$Res>? get createdRoom;

}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recentRooms = null,Object? isLoading = null,Object? isLookingUp = null,Object? joinError = freezed,Object? joinFailure = freezed,Object? joinTarget = freezed,Object? isCreating = null,Object? createFailure = freezed,Object? createdRoom = freezed,}) {
  return _then(_self.copyWith(
recentRooms: null == recentRooms ? _self.recentRooms : recentRooms // ignore: cast_nullable_to_non_nullable
as List<RecentRoom>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLookingUp: null == isLookingUp ? _self.isLookingUp : isLookingUp // ignore: cast_nullable_to_non_nullable
as bool,joinError: freezed == joinError ? _self.joinError : joinError // ignore: cast_nullable_to_non_nullable
as JoinInputError?,joinFailure: freezed == joinFailure ? _self.joinFailure : joinFailure // ignore: cast_nullable_to_non_nullable
as Failure?,joinTarget: freezed == joinTarget ? _self.joinTarget : joinTarget // ignore: cast_nullable_to_non_nullable
as RoomSummary?,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,createFailure: freezed == createFailure ? _self.createFailure : createFailure // ignore: cast_nullable_to_non_nullable
as Failure?,createdRoom: freezed == createdRoom ? _self.createdRoom : createdRoom // ignore: cast_nullable_to_non_nullable
as CreatedRoom?,
  ));
}
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get joinFailure {
    if (_self.joinFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.joinFailure!, (value) {
    return _then(_self.copyWith(joinFailure: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomSummaryCopyWith<$Res>? get joinTarget {
    if (_self.joinTarget == null) {
    return null;
  }

  return $RoomSummaryCopyWith<$Res>(_self.joinTarget!, (value) {
    return _then(_self.copyWith(joinTarget: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get createFailure {
    if (_self.createFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.createFailure!, (value) {
    return _then(_self.copyWith(createFailure: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatedRoomCopyWith<$Res>? get createdRoom {
    if (_self.createdRoom == null) {
    return null;
  }

  return $CreatedRoomCopyWith<$Res>(_self.createdRoom!, (value) {
    return _then(_self.copyWith(createdRoom: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RecentRoom> recentRooms,  bool isLoading,  bool isLookingUp,  JoinInputError? joinError,  Failure? joinFailure,  RoomSummary? joinTarget,  bool isCreating,  Failure? createFailure,  CreatedRoom? createdRoom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.recentRooms,_that.isLoading,_that.isLookingUp,_that.joinError,_that.joinFailure,_that.joinTarget,_that.isCreating,_that.createFailure,_that.createdRoom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RecentRoom> recentRooms,  bool isLoading,  bool isLookingUp,  JoinInputError? joinError,  Failure? joinFailure,  RoomSummary? joinTarget,  bool isCreating,  Failure? createFailure,  CreatedRoom? createdRoom)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.recentRooms,_that.isLoading,_that.isLookingUp,_that.joinError,_that.joinFailure,_that.joinTarget,_that.isCreating,_that.createFailure,_that.createdRoom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RecentRoom> recentRooms,  bool isLoading,  bool isLookingUp,  JoinInputError? joinError,  Failure? joinFailure,  RoomSummary? joinTarget,  bool isCreating,  Failure? createFailure,  CreatedRoom? createdRoom)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.recentRooms,_that.isLoading,_that.isLookingUp,_that.joinError,_that.joinFailure,_that.joinTarget,_that.isCreating,_that.createFailure,_that.createdRoom);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({final  List<RecentRoom> recentRooms = const <RecentRoom>[], this.isLoading = false, this.isLookingUp = false, this.joinError, this.joinFailure, this.joinTarget, this.isCreating = false, this.createFailure, this.createdRoom}): _recentRooms = recentRooms;
  

 final  List<RecentRoom> _recentRooms;
@override@JsonKey() List<RecentRoom> get recentRooms {
  if (_recentRooms is EqualUnmodifiableListView) return _recentRooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentRooms);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLookingUp;
@override final  JoinInputError? joinError;
@override final  Failure? joinFailure;
@override final  RoomSummary? joinTarget;
@override@JsonKey() final  bool isCreating;
@override final  Failure? createFailure;
@override final  CreatedRoom? createdRoom;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&const DeepCollectionEquality().equals(other._recentRooms, _recentRooms)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLookingUp, isLookingUp) || other.isLookingUp == isLookingUp)&&(identical(other.joinError, joinError) || other.joinError == joinError)&&(identical(other.joinFailure, joinFailure) || other.joinFailure == joinFailure)&&(identical(other.joinTarget, joinTarget) || other.joinTarget == joinTarget)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating)&&(identical(other.createFailure, createFailure) || other.createFailure == createFailure)&&(identical(other.createdRoom, createdRoom) || other.createdRoom == createdRoom));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_recentRooms),isLoading,isLookingUp,joinError,joinFailure,joinTarget,isCreating,createFailure,createdRoom);

@override
String toString() {
  return 'HomeState(recentRooms: $recentRooms, isLoading: $isLoading, isLookingUp: $isLookingUp, joinError: $joinError, joinFailure: $joinFailure, joinTarget: $joinTarget, isCreating: $isCreating, createFailure: $createFailure, createdRoom: $createdRoom)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 List<RecentRoom> recentRooms, bool isLoading, bool isLookingUp, JoinInputError? joinError, Failure? joinFailure, RoomSummary? joinTarget, bool isCreating, Failure? createFailure, CreatedRoom? createdRoom
});


@override $FailureCopyWith<$Res>? get joinFailure;@override $RoomSummaryCopyWith<$Res>? get joinTarget;@override $FailureCopyWith<$Res>? get createFailure;@override $CreatedRoomCopyWith<$Res>? get createdRoom;

}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recentRooms = null,Object? isLoading = null,Object? isLookingUp = null,Object? joinError = freezed,Object? joinFailure = freezed,Object? joinTarget = freezed,Object? isCreating = null,Object? createFailure = freezed,Object? createdRoom = freezed,}) {
  return _then(_HomeState(
recentRooms: null == recentRooms ? _self._recentRooms : recentRooms // ignore: cast_nullable_to_non_nullable
as List<RecentRoom>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLookingUp: null == isLookingUp ? _self.isLookingUp : isLookingUp // ignore: cast_nullable_to_non_nullable
as bool,joinError: freezed == joinError ? _self.joinError : joinError // ignore: cast_nullable_to_non_nullable
as JoinInputError?,joinFailure: freezed == joinFailure ? _self.joinFailure : joinFailure // ignore: cast_nullable_to_non_nullable
as Failure?,joinTarget: freezed == joinTarget ? _self.joinTarget : joinTarget // ignore: cast_nullable_to_non_nullable
as RoomSummary?,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,createFailure: freezed == createFailure ? _self.createFailure : createFailure // ignore: cast_nullable_to_non_nullable
as Failure?,createdRoom: freezed == createdRoom ? _self.createdRoom : createdRoom // ignore: cast_nullable_to_non_nullable
as CreatedRoom?,
  ));
}

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get joinFailure {
    if (_self.joinFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.joinFailure!, (value) {
    return _then(_self.copyWith(joinFailure: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomSummaryCopyWith<$Res>? get joinTarget {
    if (_self.joinTarget == null) {
    return null;
  }

  return $RoomSummaryCopyWith<$Res>(_self.joinTarget!, (value) {
    return _then(_self.copyWith(joinTarget: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get createFailure {
    if (_self.createFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.createFailure!, (value) {
    return _then(_self.copyWith(createFailure: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatedRoomCopyWith<$Res>? get createdRoom {
    if (_self.createdRoom == null) {
    return null;
  }

  return $CreatedRoomCopyWith<$Res>(_self.createdRoom!, (value) {
    return _then(_self.copyWith(createdRoom: value));
  });
}
}

// dart format on
