// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallConnectOptions {

 String get url; String get token; bool get microphoneEnabled; bool get cameraEnabled;
/// Create a copy of CallConnectOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallConnectOptionsCopyWith<CallConnectOptions> get copyWith => _$CallConnectOptionsCopyWithImpl<CallConnectOptions>(this as CallConnectOptions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallConnectOptions&&(identical(other.url, url) || other.url == url)&&(identical(other.token, token) || other.token == token)&&(identical(other.microphoneEnabled, microphoneEnabled) || other.microphoneEnabled == microphoneEnabled)&&(identical(other.cameraEnabled, cameraEnabled) || other.cameraEnabled == cameraEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,url,token,microphoneEnabled,cameraEnabled);



}

/// @nodoc
abstract mixin class $CallConnectOptionsCopyWith<$Res>  {
  factory $CallConnectOptionsCopyWith(CallConnectOptions value, $Res Function(CallConnectOptions) _then) = _$CallConnectOptionsCopyWithImpl;
@useResult
$Res call({
 String url, String token, bool microphoneEnabled, bool cameraEnabled
});




}
/// @nodoc
class _$CallConnectOptionsCopyWithImpl<$Res>
    implements $CallConnectOptionsCopyWith<$Res> {
  _$CallConnectOptionsCopyWithImpl(this._self, this._then);

  final CallConnectOptions _self;
  final $Res Function(CallConnectOptions) _then;

/// Create a copy of CallConnectOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? token = null,Object? microphoneEnabled = null,Object? cameraEnabled = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,microphoneEnabled: null == microphoneEnabled ? _self.microphoneEnabled : microphoneEnabled // ignore: cast_nullable_to_non_nullable
as bool,cameraEnabled: null == cameraEnabled ? _self.cameraEnabled : cameraEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CallConnectOptions].
extension CallConnectOptionsPatterns on CallConnectOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallConnectOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallConnectOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallConnectOptions value)  $default,){
final _that = this;
switch (_that) {
case _CallConnectOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallConnectOptions value)?  $default,){
final _that = this;
switch (_that) {
case _CallConnectOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String token,  bool microphoneEnabled,  bool cameraEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallConnectOptions() when $default != null:
return $default(_that.url,_that.token,_that.microphoneEnabled,_that.cameraEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String token,  bool microphoneEnabled,  bool cameraEnabled)  $default,) {final _that = this;
switch (_that) {
case _CallConnectOptions():
return $default(_that.url,_that.token,_that.microphoneEnabled,_that.cameraEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String token,  bool microphoneEnabled,  bool cameraEnabled)?  $default,) {final _that = this;
switch (_that) {
case _CallConnectOptions() when $default != null:
return $default(_that.url,_that.token,_that.microphoneEnabled,_that.cameraEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _CallConnectOptions extends CallConnectOptions {
  const _CallConnectOptions({required this.url, required this.token, this.microphoneEnabled = true, this.cameraEnabled = true}): super._();
  

@override final  String url;
@override final  String token;
@override@JsonKey() final  bool microphoneEnabled;
@override@JsonKey() final  bool cameraEnabled;

/// Create a copy of CallConnectOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallConnectOptionsCopyWith<_CallConnectOptions> get copyWith => __$CallConnectOptionsCopyWithImpl<_CallConnectOptions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallConnectOptions&&(identical(other.url, url) || other.url == url)&&(identical(other.token, token) || other.token == token)&&(identical(other.microphoneEnabled, microphoneEnabled) || other.microphoneEnabled == microphoneEnabled)&&(identical(other.cameraEnabled, cameraEnabled) || other.cameraEnabled == cameraEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,url,token,microphoneEnabled,cameraEnabled);



}

/// @nodoc
abstract mixin class _$CallConnectOptionsCopyWith<$Res> implements $CallConnectOptionsCopyWith<$Res> {
  factory _$CallConnectOptionsCopyWith(_CallConnectOptions value, $Res Function(_CallConnectOptions) _then) = __$CallConnectOptionsCopyWithImpl;
@override @useResult
$Res call({
 String url, String token, bool microphoneEnabled, bool cameraEnabled
});




}
/// @nodoc
class __$CallConnectOptionsCopyWithImpl<$Res>
    implements _$CallConnectOptionsCopyWith<$Res> {
  __$CallConnectOptionsCopyWithImpl(this._self, this._then);

  final _CallConnectOptions _self;
  final $Res Function(_CallConnectOptions) _then;

/// Create a copy of CallConnectOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? token = null,Object? microphoneEnabled = null,Object? cameraEnabled = null,}) {
  return _then(_CallConnectOptions(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,microphoneEnabled: null == microphoneEnabled ? _self.microphoneEnabled : microphoneEnabled // ignore: cast_nullable_to_non_nullable
as bool,cameraEnabled: null == cameraEnabled ? _self.cameraEnabled : cameraEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
