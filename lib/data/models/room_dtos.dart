import 'package:flutter/foundation.dart';

import '../../domain/entities/room.dart';
import '../../domain/entities/room_code.dart';

// Wire DTOs for the room API v1 (`/v1/rooms`, docs/api/openapi.yaml). Parsing is strict and follows
// docs/api/openapi.yaml: a missing or mistyped required field throws
// [FormatException], which the data source maps to `UnknownFailure`.

typedef Json = Map<String, dynamic>;

T _required<T>(Json json, String key) {
  final value = json[key];
  if (value is T) return value;
  throw FormatException('Field "$key" missing or not $T', json.toString());
}

T? _optional<T>(Json json, String key) {
  final value = json[key];
  if (value == null || value is T) return value as T?;
  throw FormatException('Field "$key" is not $T', json.toString());
}

RoomCode _code(String raw) =>
    RoomCode.tryParse(raw) ?? (throw FormatException('Invalid room code', raw));

DateTime _dateTime(String raw) =>
    DateTime.tryParse(raw) ?? (throw FormatException('Invalid date-time', raw));

/// An invite link: absolute http(s) with a host, shown and shared as is.
Uri _uri(String raw) {
  final uri = Uri.tryParse(raw);
  if (uri != null &&
      (uri.isScheme('https') || uri.isScheme('http')) &&
      uri.host.isNotEmpty) {
    return uri;
  }
  throw FormatException('Invalid URL', raw);
}

RoomRole _role(String raw) => switch (raw) {
  'host' => RoomRole.host,
  'participant' => RoomRole.participant,
  _ => throw FormatException('Unknown role', raw),
};

/// `POST /rooms` body.
class CreateRoomRequestDto {
  const CreateRoomRequestDto(this.params);

  final CreateRoomParams params;

  Json toJson() => {
    if (params.name != null) 'name': params.name,
    if (params.password != null) 'password': params.password,
    if (params.maxParticipants != null)
      'maxParticipants': params.maxParticipants,
    if (params.lifetimeMinutes != null)
      'lifetimeMinutes': params.lifetimeMinutes,
    if (params.e2ee != null) 'e2ee': params.e2ee,
  };
}

/// `201` of `POST /rooms`.
class CreateRoomResponseDto {
  const CreateRoomResponseDto({required this.room, required this.ownerToken});

  factory CreateRoomResponseDto.fromJson(Json json) => CreateRoomResponseDto(
    ownerToken: _required<String>(json, 'ownerToken'),
    room: CreatedRoom(
      roomId: _required<String>(json, 'roomId'),
      code: _code(_required<String>(json, 'code')),
      inviteUrl: _uri(_required<String>(json, 'inviteUrl')),
      name: _optional<String>(json, 'name'),
      passwordRequired: _required<bool>(json, 'passwordRequired'),
      e2ee: _required<bool>(json, 'e2ee'),
      maxParticipants: _required<int>(json, 'maxParticipants'),
      expiresAt: _dateTime(_required<String>(json, 'expiresAt')),
    ),
  );

  final CreatedRoom room;
  final String ownerToken;
}

/// `200` of `GET /rooms/{code}`.
RoomSummary roomSummaryFromJson(Json json) => RoomSummary(
  code: _code(_required<String>(json, 'code')),
  inviteUrl: _uri(_required<String>(json, 'inviteUrl')),
  name: _optional<String>(json, 'name'),
  passwordRequired: _required<bool>(json, 'passwordRequired'),
  e2ee: _required<bool>(json, 'e2ee'),
  locked: _required<bool>(json, 'locked'),
  expiresAt: _dateTime(_required<String>(json, 'expiresAt')),
);

/// `POST /rooms/{code}/join` body.
class JoinRequestDto {
  const JoinRequestDto({
    required this.displayName,
    required this.guestId,
    this.password,
  });

  final String displayName;
  final String guestId;
  final String? password;

  Json toJson() => {
    'displayName': displayName,
    'guestId': guestId,
    if (password != null) 'password': password,
  };
}

/// `200` of `POST /rooms/{code}/join`. Every field the contract marks
/// required is required here (`JoinResponse`, `JoinedRoom`).
RoomJoin roomJoinFromJson(Json json, {bool requireSecureMedia = kReleaseMode}) {
  final room = _required<Json>(json, 'room');
  return RoomJoin(
    token: _required<String>(json, 'token'),
    livekitUrl: mediaUrl(
      _required<String>(json, 'livekitUrl'),
      requireSecure: requireSecureMedia,
    ),
    identity: _required<String>(json, 'identity'),
    role: _role(_required<String>(json, 'role')),
    room: RoomInfo(
      code: _code(_required<String>(room, 'code')),
      inviteUrl: _uri(_required<String>(room, 'inviteUrl')),
      name: _optional<String>(room, 'name'),
      passwordRequired: _required<bool>(room, 'passwordRequired'),
      e2ee: _required<bool>(room, 'e2ee'),
      locked: _required<bool>(room, 'locked'),
      maxParticipants: _required<int>(room, 'maxParticipants'),
      expiresAt: _dateTime(_required<String>(room, 'expiresAt')),
    ),
  );
}

/// Checks the LiveKit URL from a join response (SEC-17). Release builds
/// accept `wss://` and, for a local development backend, `ws://` on a
/// loopback host only (that traffic never leaves the device; QA D3: a release
/// web build against a local backend failed every join). Debug and
/// profile builds accept any `ws://` host. Anything else is a malformed
/// response.
@visibleForTesting
String mediaUrl(String raw, {required bool requireSecure}) {
  final uri = Uri.tryParse(raw);
  final secure = uri != null && uri.isScheme('wss') && uri.host.isNotEmpty;
  final plain = uri != null && uri.isScheme('ws') && uri.host.isNotEmpty;
  final loopback = plain && _loopbackHosts.contains(uri.host);
  if (secure || loopback || (plain && !requireSecure)) return raw;
  throw const FormatException('insecure_media_url');
}

const _loopbackHosts = {'localhost', '127.0.0.1', '::1'};

/// `PATCH /rooms/{code}` body.
Json roomPatchToJson(RoomPatch patch) => {
  if (patch.locked != null) 'locked': patch.locked,
  if (patch.name != null) 'name': patch.name,
  if (patch.password case final change?)
    'password': switch (change) {
      SetPassword(:final password) => password,
      RemovePassword() => null,
    },
};

/// `200` of `POST /rooms/{code}/rotate-code`.
RotatedCode rotatedCodeFromJson(Json json) => RotatedCode(
  code: _code(_required<String>(json, 'code')),
  inviteUrl: _uri(_required<String>(json, 'inviteUrl')),
);
