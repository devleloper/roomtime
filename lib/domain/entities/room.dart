import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'room_code.dart';

enum RoomRole { host, participant }

/// Public pre-join view of a room (`GET /rooms/{code}`).
/// [name] is null when the room requires a password.
final class RoomSummary extends Equatable {
  const RoomSummary({
    required this.code,
    required this.inviteUrl,
    this.name,
    required this.passwordRequired,
    required this.e2ee,
    required this.locked,
    required this.expiresAt,
  });

  final RoomCode code;

  /// The server's invite link for [code]; never built on the client.
  final Uri inviteUrl;
  final String? name;
  final bool passwordRequired;
  final bool e2ee;
  final bool locked;

  /// End of the invitation (not of a call in progress).
  final DateTime expiresAt;

  @override
  List<Object?> get props => [
    code,
    inviteUrl,
    name,
    passwordRequired,
    e2ee,
    locked,
    expiresAt,
  ];
}

/// Room details returned with a successful join.
final class RoomInfo extends Equatable {
  const RoomInfo({
    required this.code,
    required this.inviteUrl,
    this.name,
    required this.passwordRequired,
    required this.e2ee,
    required this.locked,
    required this.maxParticipants,
    required this.expiresAt,
  });

  final RoomCode code;

  /// The server's invite link for [code]; changes with [code] on rotation.
  final Uri inviteUrl;
  final String? name;
  final bool passwordRequired;
  final bool e2ee;
  final bool locked;
  final int maxParticipants;

  /// End of the invitation and of the host controls, not of the call.
  final DateTime expiresAt;

  RoomInfo copyWith({
    RoomCode? code,
    Uri? inviteUrl,
    bool? passwordRequired,
    bool? locked,
  }) => RoomInfo(
    code: code ?? this.code,
    inviteUrl: inviteUrl ?? this.inviteUrl,
    name: name,
    passwordRequired: passwordRequired ?? this.passwordRequired,
    e2ee: e2ee,
    locked: locked ?? this.locked,
    maxParticipants: maxParticipants,
    expiresAt: expiresAt,
  );

  @override
  List<Object?> get props => [
    code,
    inviteUrl,
    name,
    passwordRequired,
    e2ee,
    locked,
    maxParticipants,
    expiresAt,
  ];
}

/// Result of `POST /rooms`. The owner token stays in the data layer.
final class CreatedRoom extends Equatable {
  const CreatedRoom({
    required this.roomId,
    required this.code,
    required this.inviteUrl,
    this.name,
    required this.passwordRequired,
    required this.e2ee,
    required this.maxParticipants,
    required this.expiresAt,
  });

  final String roomId;
  final RoomCode code;
  final Uri inviteUrl;
  final String? name;
  final bool passwordRequired;
  final bool e2ee;
  final int maxParticipants;
  final DateTime expiresAt;

  @override
  List<Object?> get props => [
    roomId,
    code,
    inviteUrl,
    name,
    passwordRequired,
    e2ee,
    maxParticipants,
    expiresAt,
  ];
}

/// Media grant from `POST /rooms/{code}/join`. Kept in memory only.
final class RoomJoin extends Equatable {
  const RoomJoin({
    required this.token,
    required this.livekitUrl,
    required this.identity,
    required this.role,
    required this.room,
  });

  /// Short-lived LiveKit token; never persisted or logged.
  final String token;
  final String livekitUrl;
  final String identity;
  final RoomRole role;
  final RoomInfo room;

  @override
  List<Object?> get props => [token, livekitUrl, identity, role, room];

  @override
  String toString() => 'RoomJoin(identity: $identity, role: $role)';
}

/// Why a password breaks [RoomPassword].
enum RoomPasswordIssue { tooShort, tooLong }

/// Room password rule of the API, taken verbatim: 4..64 characters (Unicode
/// code points, as the server counts runes) and at most 72 bytes of UTF-8
/// (openapi `CreateRoomRequest.password`, server `room.ValidatePassword`).
/// The one place the client keeps it (A6-04).
abstract final class RoomPassword {
  static const minLength = 4;
  static const maxLength = 64;
  static const maxBytes = 72;

  /// Null when [password] is valid.
  static RoomPasswordIssue? check(String password) {
    final characters = password.runes.length;
    if (characters < minLength) return RoomPasswordIssue.tooShort;
    if (characters > maxLength || utf8.encode(password).length > maxBytes) {
      return RoomPasswordIssue.tooLong;
    }
    return null;
  }
}

/// Options for `POST /rooms`; null fields use the server defaults (the
/// default limits live only on the server).
final class CreateRoomParams extends Equatable {
  const CreateRoomParams({
    this.name,
    this.password,
    this.maxParticipants,
    this.lifetimeMinutes,
    this.e2ee,
  });

  final String? name;
  final String? password;
  final int? maxParticipants;
  final int? lifetimeMinutes;
  final bool? e2ee;

  @override
  List<Object?> get props => [
    name,
    password,
    maxParticipants,
    lifetimeMinutes,
    e2ee,
  ];

  @override
  String toString() =>
      'CreateRoomParams(name: $name, hasPassword: ${password != null})';
}

/// Password change in a [RoomPatch].
sealed class PasswordChange {
  const PasswordChange();
}

final class SetPassword extends PasswordChange {
  const SetPassword(this.password);

  final String password;
}

final class RemovePassword extends PasswordChange {
  const RemovePassword();
}

/// Owner settings change (`PATCH /rooms/{code}`); null fields stay unchanged.
final class RoomPatch {
  const RoomPatch({this.locked, this.name, this.password});

  final bool? locked;
  final String? name;
  final PasswordChange? password;
}

/// New invitation after `POST /rooms/{code}/rotate-code`.
final class RotatedCode extends Equatable {
  const RotatedCode({required this.code, required this.inviteUrl});

  final RoomCode code;
  final Uri inviteUrl;

  @override
  List<Object?> get props => [code, inviteUrl];
}
