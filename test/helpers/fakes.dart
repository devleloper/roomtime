import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:roomtime/core/utils/clock.dart';
import 'package:roomtime/data/local/key_value_store.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/domain/entities/guest_profile.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/domain/repositories/guest_profile_repository.dart';
import 'package:roomtime/domain/repositories/room_repository.dart';
import 'package:roomtime/domain/services/audio_service.dart';
import 'package:roomtime/domain/services/call_session.dart';

final testCode = RoomCode.tryParse('abcdefghjk')!;

final testInviteUrl = Uri.parse('https://calls.test/r/abc-defg-hjk');

class InMemoryKeyValueStore implements KeyValueStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<Map<String, String>> readAll() async => Map.of(values);
}

class FixedClock implements Clock {
  FixedClock(this.current);

  DateTime current;

  @override
  DateTime now() => current;
}

class FakeResponse {
  const FakeResponse(this.status, [this.body, this.headers = const {}]);

  final int status;
  final Object? body;
  final Map<String, String> headers;
}

class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this.handler);

  final FutureOr<FakeResponse> Function(RequestOptions request) handler;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final response = await handler(options);
    final body = response.body;
    final isProblem = response.status >= 400;
    return ResponseBody.fromString(
      body == null ? '' : (body is String ? body : jsonEncode(body)),
      response.status,
      headers: {
        Headers.contentTypeHeader: [
          isProblem ? 'application/problem+json' : 'application/json',
        ],
        for (final MapEntry(:key, :value) in response.headers.entries)
          key: [value],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio fakeDio(FakeHttpAdapter adapter) => Dio(
  BaseOptions(
    baseUrl: 'http://api.test/v1',
    contentType: Headers.jsonContentType,
  ),
)..httpClientAdapter = adapter;

class FakeGuestProfileRepository implements GuestProfileRepository {
  GuestProfile profile = const GuestProfile(
    guestId: '6f1c1a7e-3b0a-4c55-9d1e-2b8f0f4f7a10',
    displayName: 'Ann',
  );

  @override
  Future<GuestProfile> load() async => profile;

  @override
  Future<GuestProfile> updateDisplayName(String displayName) async =>
      profile = profile.copyWith(displayName: displayName);
}

class SilentAudioService implements AudioService {
  int joins = 0;
  int leaves = 0;

  @override
  Future<void> playJoinSound() async => joins++;

  @override
  Future<void> playLeaveSound() async => leaves++;

  @override
  Future<void> dispose() async {}
}

class FakeRoomRepository implements RoomRepository {
  Completer<RoomJoin>? pendingJoin;
  Future<RoomJoin> Function(RoomCode code, String? password)? onJoin;
  final joinPasswords = <String?>[];
  int endCalls = 0;
  final mutes = <(String, String)>[];
  final removals = <(String, bool)>[];
  final patches = <RoomPatch>[];
  int rotateCalls = 0;
  int lookupCalls = 0;

  Object? hostError;

  Completer<void>? pendingEnd;
  int createCalls = 0;
  CreateRoomParams? createdWith;
  bool owner = false;

  Object lookupResult = sampleSummary();
  Object createResult = sampleCreatedRoom();

  @override
  Future<RoomJoin> join(
    RoomCode code, {
    required GuestProfile guest,
    String? password,
  }) {
    joinPasswords.add(password);
    final pending = pendingJoin;
    if (pending != null) return pending.future;
    return onJoin?.call(code, password) ?? Future.value(sampleJoin());
  }

  Future<void> _host() async {
    await pendingEnd?.future;
    final error = hostError;
    if (error != null) throw error;
  }

  @override
  Future<void> endRoom(RoomCode code) async {
    endCalls++;
    await _host();
  }

  @override
  Future<void> muteParticipant(
    RoomCode code, {
    required String identity,
    required String trackSid,
  }) async {
    final error = hostError;
    if (error != null) throw error;
    mutes.add((identity, trackSid));
  }

  @override
  Future<CreatedRoom> createRoom(CreateRoomParams params) async {
    createCalls++;
    createdWith = params;
    final result = createResult;
    if (result is CreatedRoom) return result;
    throw result;
  }

  @override
  Future<RoomSummary> lookup(RoomCode code) async {
    lookupCalls++;
    final result = lookupResult;
    if (result is RoomSummary) return result;
    throw result;
  }

  @override
  Future<bool> isOwner(RoomCode code) async => owner;

  @override
  Future<void> removeParticipant(
    RoomCode code, {
    required String identity,
    bool ban = false,
  }) async {
    final error = hostError;
    if (error != null) throw error;
    removals.add((identity, ban));
  }

  @override
  Future<void> updateRoom(RoomCode code, RoomPatch patch) async {
    final error = hostError;
    if (error != null) throw error;
    patches.add(patch);
  }

  @override
  Future<RotatedCode> rotateCode(RoomCode code) async {
    final error = hostError;
    if (error != null) throw error;
    rotateCalls++;
    return RotatedCode(
      code: RoomCode.tryParse('zzzzzzzzzz')!,
      inviteUrl: Uri.parse('https://calls.test/r/zzz-zzzz-zzz'),
    );
  }
}

CreatedRoom sampleCreatedRoom() => CreatedRoom(
  roomId: 'room-1',
  code: testCode,
  inviteUrl: testInviteUrl,
  name: 'Family',
  passwordRequired: false,
  e2ee: false,
  maxParticipants: 10,
  expiresAt: DateTime.utc(2030),
);

RoomJoin sampleJoin({
  RoomRole role = RoomRole.participant,
  DateTime? expiresAt,
}) => RoomJoin(
  token: 'lk-token',
  livekitUrl: 'wss://media.test',
  identity: 'p_self',
  role: role,
  room: RoomInfo(
    code: testCode,
    inviteUrl: testInviteUrl,
    name: 'Family',
    passwordRequired: false,
    e2ee: false,
    locked: false,
    maxParticipants: 10,
    expiresAt: expiresAt ?? DateTime.utc(2030),
  ),
);

RoomSummary sampleSummary({
  bool passwordRequired = false,
  bool locked = false,
  String? name = 'Family',
}) => RoomSummary(
  code: testCode,
  inviteUrl: testInviteUrl,
  name: name,
  passwordRequired: passwordRequired,
  e2ee: false,
  locked: locked,
  expiresAt: DateTime.utc(2030),
);

const localParticipant = CallParticipant(
  id: 'PA_local',
  identity: 'p_self',
  displayName: 'Ann',
  isLocal: true,
  microphoneEnabled: true,
  cameraEnabled: true,
);

const remoteParticipant = CallParticipant(
  id: 'PA_remote',
  identity: 'p_bob',
  displayName: 'Bob',
  isLocal: false,
  microphoneEnabled: true,
  audioTrackSid: 'TR_audio',
);

class FakeCallSession implements CallSession {
  final _controller = StreamController<CallSnapshot>.broadcast(sync: true);
  CallSnapshot _snapshot = const CallSnapshot();

  Completer<void>? pendingConnect;

  Object? connectError;
  CallConnectOptions? connectedWith;
  int connectCalls = 0;
  int leaveCalls = 0;
  int disposeCalls = 0;
  final cameraCommands = <bool>[];
  final microphoneCommands = <bool>[];
  bool _left = false;

  @override
  Stream<CallSnapshot> get snapshots => _controller.stream;

  @override
  CallSnapshot get snapshot => _snapshot;

  void emit(CallSnapshot next) {
    _snapshot = next;
    if (!_controller.isClosed) _controller.add(next);
  }

  static const connectedSnapshot = CallSnapshot(
    connection: CallConnection.connected,
    participants: [localParticipant],
    microphoneEnabled: true,
    cameraEnabled: true,
  );

  @override
  Future<void> connect(CallConnectOptions options) async {
    connectCalls++;
    connectedWith = options;
    emit(const CallSnapshot(connection: CallConnection.connecting));
    final error = connectError;
    if (error != null) throw error;
    final pending = pendingConnect;
    if (pending != null) await pending.future;
    if (_left) return;
    emit(
      connectedSnapshot.copyWith(
        microphoneEnabled: options.microphoneEnabled,
        cameraEnabled: options.cameraEnabled,
      ),
    );
  }

  @override
  Future<void> leave() async {
    leaveCalls++;
    _left = true;
    final pending = pendingConnect;
    if (pending != null && !pending.isCompleted) await pending.future;
    emit(
      const CallSnapshot(
        connection: CallConnection.disconnected,
        endReason: CallEndReason.left,
      ),
    );
  }

  @override
  Future<void> dispose() async {
    disposeCalls++;
    await leave();
    await _controller.close();
  }

  @override
  Future<void> setCameraEnabled(bool enabled) async {
    cameraCommands.add(enabled);
    emit(_snapshot.copyWith(cameraEnabled: enabled));
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async {
    microphoneCommands.add(enabled);
    emit(_snapshot.copyWith(microphoneEnabled: enabled));
  }

  @override
  Future<void> flipCamera() async =>
      emit(_snapshot.copyWith(frontCamera: !_snapshot.frontCamera));

  @override
  bool get canSwitchAudioOutput => false;

  @override
  Future<void> setSpeakerphoneOn(bool on) async {}

  int startAudioCalls = 0;

  @override
  Future<void> startAudio() async {
    startAudioCalls++;
    emit(_snapshot.copyWith(audioPlaybackBlocked: false));
  }
}
