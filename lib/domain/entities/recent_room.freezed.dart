// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecentRoom {

@RoomCodeConverter() RoomCode get code; String? get name; RoomRole get role;@JsonKey(toJson: _utcIso) DateTime get lastJoined;
/// Create a copy of RecentRoom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentRoomCopyWith<RecentRoom> get copyWith => _$RecentRoomCopyWithImpl<RecentRoom>(this as RecentRoom, _$identity);

  /// Serializes this RecentRoom to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentRoom&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.lastJoined, lastJoined) || other.lastJoined == lastJoined));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,role,lastJoined);

@override
String toString() {
  return 'RecentRoom(code: $code, name: $name, role: $role, lastJoined: $lastJoined)';
}


}

/// @nodoc
abstract mixin class $RecentRoomCopyWith<$Res>  {
  factory $RecentRoomCopyWith(RecentRoom value, $Res Function(RecentRoom) _then) = _$RecentRoomCopyWithImpl;
@useResult
$Res call({
@RoomCodeConverter() RoomCode code, String? name, RoomRole role,@JsonKey(toJson: _utcIso) DateTime lastJoined
});


$RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class _$RecentRoomCopyWithImpl<$Res>
    implements $RecentRoomCopyWith<$Res> {
  _$RecentRoomCopyWithImpl(this._self, this._then);

  final RecentRoom _self;
  final $Res Function(RecentRoom) _then;

/// Create a copy of RecentRoom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = freezed,Object? role = null,Object? lastJoined = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoomRole,lastJoined: null == lastJoined ? _self.lastJoined : lastJoined // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of RecentRoom
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCodeCopyWith<$Res> get code {
  
  return $RoomCodeCopyWith<$Res>(_self.code, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecentRoom].
extension RecentRoomPatterns on RecentRoom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentRoom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentRoom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentRoom value)  $default,){
final _that = this;
switch (_that) {
case _RecentRoom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentRoom value)?  $default,){
final _that = this;
switch (_that) {
case _RecentRoom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@RoomCodeConverter()  RoomCode code,  String? name,  RoomRole role, @JsonKey(toJson: _utcIso)  DateTime lastJoined)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentRoom() when $default != null:
return $default(_that.code,_that.name,_that.role,_that.lastJoined);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@RoomCodeConverter()  RoomCode code,  String? name,  RoomRole role, @JsonKey(toJson: _utcIso)  DateTime lastJoined)  $default,) {final _that = this;
switch (_that) {
case _RecentRoom():
return $default(_that.code,_that.name,_that.role,_that.lastJoined);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@RoomCodeConverter()  RoomCode code,  String? name,  RoomRole role, @JsonKey(toJson: _utcIso)  DateTime lastJoined)?  $default,) {final _that = this;
switch (_that) {
case _RecentRoom() when $default != null:
return $default(_that.code,_that.name,_that.role,_that.lastJoined);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecentRoom implements RecentRoom {
  const _RecentRoom({@RoomCodeConverter() required this.code, this.name, required this.role, @JsonKey(toJson: _utcIso) required this.lastJoined});
  factory _RecentRoom.fromJson(Map<String, dynamic> json) => _$RecentRoomFromJson(json);

@override@RoomCodeConverter() final  RoomCode code;
@override final  String? name;
@override final  RoomRole role;
@override@JsonKey(toJson: _utcIso) final  DateTime lastJoined;

/// Create a copy of RecentRoom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentRoomCopyWith<_RecentRoom> get copyWith => __$RecentRoomCopyWithImpl<_RecentRoom>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecentRoomToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentRoom&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.lastJoined, lastJoined) || other.lastJoined == lastJoined));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,role,lastJoined);

@override
String toString() {
  return 'RecentRoom(code: $code, name: $name, role: $role, lastJoined: $lastJoined)';
}


}

/// @nodoc
abstract mixin class _$RecentRoomCopyWith<$Res> implements $RecentRoomCopyWith<$Res> {
  factory _$RecentRoomCopyWith(_RecentRoom value, $Res Function(_RecentRoom) _then) = __$RecentRoomCopyWithImpl;
@override @useResult
$Res call({
@RoomCodeConverter() RoomCode code, String? name, RoomRole role,@JsonKey(toJson: _utcIso) DateTime lastJoined
});


@override $RoomCodeCopyWith<$Res> get code;

}
/// @nodoc
class __$RecentRoomCopyWithImpl<$Res>
    implements _$RecentRoomCopyWith<$Res> {
  __$RecentRoomCopyWithImpl(this._self, this._then);

  final _RecentRoom _self;
  final $Res Function(_RecentRoom) _then;

/// Create a copy of RecentRoom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = freezed,Object? role = null,Object? lastJoined = null,}) {
  return _then(_RecentRoom(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as RoomCode,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoomRole,lastJoined: null == lastJoined ? _self.lastJoined : lastJoined // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of RecentRoom
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
