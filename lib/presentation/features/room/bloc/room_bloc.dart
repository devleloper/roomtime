import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:roomtime/core/utils/clock.dart';
import 'package:roomtime/core/utils/dev_log.dart';
import 'package:roomtime/core/utils/platform.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:roomtime/domain/repositories/guest_profile_repository.dart';
import 'package:roomtime/domain/repositories/room_repository.dart';
import 'package:roomtime/domain/services/audio_service.dart';
import 'package:roomtime/domain/services/call_session.dart';

part 'room_event.dart';
part 'room_state.dart';
part 'room_bloc.freezed.dart';

@injectable
class RoomBloc extends Bloc<RoomEvent, RoomState> {
  static const expiryWarningLead = Duration(minutes: 10);

  final RoomRepository _rooms;
  final GuestProfileRepository _profiles;
  final CallSession _session;
  final AudioService _audio;
  final Clock _clock;
  final bool _pauseCameraInBackground;
  final bool _startAudioOnJoin;

  final _effects = StreamController<RoomEffect>.broadcast();
  late final StreamSubscription<CallSnapshot> _callSubscription;

  RoomJoin? _join;
  RoomInfo? _room;
  bool _expiresSoon = false;
  Timer? _expiryTimer;
  CallSnapshot _lastCall = const CallSnapshot();

  // Baseline for join/leave notices; ignores temporary clears during LiveKit reconnects.
  CallSnapshot? _lastConnected;
  bool _leaving = false;

  // LiveKit disconnect often arrives before the HTTP delete response returns.
  bool _endingForAll = false;
  bool _cameraPausedInBackground = false;

  RoomBloc(
    this._rooms,
    this._profiles,
    this._session,
    this._audio,
    this._clock, {
    @ignoreParam bool? pauseCameraInBackground,
    @ignoreParam bool? startAudioOnJoin,
  }) : _pauseCameraInBackground = pauseCameraInBackground ?? isMobilePlatform,
       _startAudioOnJoin = startAudioOnJoin ?? kIsWeb,
       super(const RoomInitial()) {
    on<RoomJoinRequested>(_onJoin);
    on<RoomLeaveRequested>(_onLeave);
    on<_RoomCallUpdated>(_onCallUpdated);
    on<RoomMicrophoneToggled>(_onMicrophone, transformer: _sequential());
    on<RoomCameraToggled>(_onCamera, transformer: _sequential());
    on<RoomCameraFlipped>(_onFlip, transformer: _sequential());
    on<RoomSpeakerphoneToggled>(_onSpeakerphone, transformer: _sequential());
    on<RoomAudioPlaybackStartRequested>(_onStartAudio);
    on<RoomAppLifecycleChanged>(_onLifecycle, transformer: _sequential());
    on<RoomEndForAllRequested>(_onEndForAll);
    on<RoomParticipantMuteRequested>(_onMute);
    on<RoomParticipantRemoveRequested>(_onRemove);
    on<RoomLockRequested>(_onLock);
    on<RoomPasswordChangeRequested>(_onPassword);
    on<RoomInviteRotateRequested>(_onRotate);
    on<_RoomExpiryWarningDue>(_onExpiryWarning);
    _callSubscription = _session.snapshots.listen(
      (snapshot) => add(_RoomCallUpdated(snapshot)),
    );
  }

  Stream<RoomEffect> get effects {
    return _effects.stream;
  }

  bool get canSwitchAudioOutput {
    return _session.canSwitchAudioOutput;
  }

  static EventTransformer<E> _sequential<E>() {
    return (events, mapper) => events.asyncExpand(mapper);
  }

  Future<void> _onJoin(RoomJoinRequested event, Emitter<RoomState> emit) async {
    if (_leaving || state is RoomConnecting || state is RoomInCall) {
      return;
    }
    emit(RoomConnecting(event.code));
    try {
      final name = event.displayName;
      final guest = name == null
          ? await _profiles.load()
          : await _profiles.updateDisplayName(name);
      if (_leaving) {
        return;
      }
      final join = await _rooms.join(
        event.code,
        guest: guest,
        password: event.password,
      );
      if (_leaving) {
        return;
      }
      _join = join;
      _room = join.room;
      await _session.connect(
        CallConnectOptions(
          url: join.livekitUrl,
          token: join.token,
          microphoneEnabled: event.microphoneEnabled,
          cameraEnabled: event.cameraEnabled,
        ),
      );
      if (_leaving) {
        return;
      }
      // Web browsers require a user gesture to unlock audio playback.
      if (_startAudioOnJoin) {
        await _tryStartAudio();
      }
      if (_leaving) {
        return;
      }
      if (join.role == RoomRole.host) {
        _scheduleExpiryWarning(join.room);
      }
      _emitForCall(_session.snapshot, emit);
    } on ArgumentError {
      _fail(
        event.code,
        const InvalidInputFailure(InputField.displayName),
        emit,
      );
    } on Failure catch (failure) {
      devLog('Join failed', name: 'RoomBloc', error: failure);
      _fail(event.code, failure, emit);
    } on Object catch (error, stackTrace) {
      devLog(
        'Unexpected join error',
        name: 'RoomBloc',
        error: error,
        stackTrace: stackTrace,
      );
      _fail(event.code, const UnknownFailure(), emit);
    }
  }

  Future<void> _tryStartAudio() async {
    try {
      await _session.startAudio();
    } on Object catch (error) {
      devLog('startAudio failed: $error', name: 'RoomBloc', error: error);
    }
  }

  void _scheduleExpiryWarning(RoomInfo room) {
    final expiresAt = room.expiresAt;
    final now = _clock.now();
    if (!now.isBefore(expiresAt)) {
      return;
    }
    final delay = expiresAt.subtract(expiryWarningLead).difference(now);
    _expiryTimer?.cancel();
    _expiryTimer = Timer(
      delay.isNegative ? Duration.zero : delay,
      () => add(const _RoomExpiryWarningDue()),
    );
  }

  void _onExpiryWarning(_RoomExpiryWarningDue event, Emitter<RoomState> emit) {
    if (_leaving) {
      return;
    }
    _expiresSoon = true;
    _refreshInCall(emit);
  }

  void _fail(RoomCode code, Failure failure, Emitter<RoomState> emit) {
    if (_leaving) {
      return;
    }
    _join = null;
    _room = null;
    emit(RoomFailed(code: code, failure: failure));
  }

  Future<void> _onLeave(
    RoomLeaveRequested event,
    Emitter<RoomState> emit,
  ) async {
    if (_leaving) {
      return;
    }
    _leaving = true;
    _expiryTimer?.cancel();
    final code = _room?.code;
    await _session.leave();
    emit(RoomEnded(CallEndReason.left, code: code));
  }

  void _onCallUpdated(_RoomCallUpdated event, Emitter<RoomState> emit) {
    final call = event.snapshot;
    _lastCall = call;
    if (_leaving || _join == null) {
      return;
    }
    if (call.connection == CallConnection.connected) {
      final baseline = _lastConnected;
      if (baseline != null) {
        _announceParticipantChanges(baseline, call);
      }
      _lastConnected = call;
    }
    if (state is RoomInCall) {
      _emitForCall(call, emit);
    }
  }

  void _emitForCall(CallSnapshot call, Emitter<RoomState> emit) {
    final join = _join;
    final room = _room;
    if (join == null || room == null) {
      return;
    }
    switch (call.connection) {
      case CallConnection.connected:
        emit(
          RoomConnected(
            room: room,
            role: join.role,
            call: call,
            expiresSoon: _expiresSoon,
          ),
        );
      case CallConnection.reconnecting:
        emit(
          RoomReconnecting(
            room: room,
            role: join.role,
            call: call,
            expiresSoon: _expiresSoon,
          ),
        );
      case CallConnection.disconnected:
        _leaving = true;
        _expiryTimer?.cancel();
        final endedByUs =
            _endingForAll &&
            (call.endReason == CallEndReason.roomDeleted ||
                call.endReason == CallEndReason.endedByHost);
        emit(
          endedByUs
              ? _endedByYou(room.code)
              : RoomEnded(_endReason(call.endReason), code: room.code),
        );
      case CallConnection.idle || CallConnection.connecting:
        break;
    }
  }

  CallEndReason _endReason(CallEndReason? reason) {
    if (reason == null) {
      return CallEndReason.connectionLost;
    }
    // LiveKit reports roomDeleted both when the host ends the call and when the room expires.
    final expiresAt = _room?.expiresAt ?? _join?.room.expiresAt;
    final expired = expiresAt != null && !_clock.now().isBefore(expiresAt);
    return switch (reason) {
      CallEndReason.roomDeleted =>
        expired ? CallEndReason.roomDeleted : CallEndReason.endedByHost,
      CallEndReason.removed when expired => CallEndReason.roomDeleted,
      _ => reason,
    };
  }

  void _announceParticipantChanges(CallSnapshot previous, CallSnapshot next) {
    final before = {for (final p in previous.remote) p.id: p};
    final after = {for (final p in next.remote) p.id: p};
    for (final joined in after.values.where((p) => !before.containsKey(p.id))) {
      unawaited(_audio.playJoinSound());
      _emitEffect(ParticipantJoinedEffect(joined));
    }
    for (final left in before.values.where((p) => !after.containsKey(p.id))) {
      unawaited(_audio.playLeaveSound());
      _emitEffect(ParticipantLeftEffect(left));
    }
  }

  Future<void> _onMicrophone(
    RoomMicrophoneToggled event,
    Emitter<RoomState> _,
  ) {
    return _command(() => _session.setMicrophoneEnabled(event.enabled));
  }

  Future<void> _onCamera(RoomCameraToggled event, Emitter<RoomState> _) {
    _cameraPausedInBackground = false;
    return _command(() => _session.setCameraEnabled(event.enabled));
  }

  Future<void> _onFlip(RoomCameraFlipped event, Emitter<RoomState> _) {
    return _command(_session.flipCamera);
  }

  Future<void> _onSpeakerphone(
    RoomSpeakerphoneToggled event,
    Emitter<RoomState> _,
  ) {
    return _command(() => _session.setSpeakerphoneOn(event.on));
  }

  Future<void> _onStartAudio(
    RoomAudioPlaybackStartRequested event,
    Emitter<RoomState> _,
  ) {
    return _command(_session.startAudio);
  }

  Future<void> _onLifecycle(
    RoomAppLifecycleChanged event,
    Emitter<RoomState> _,
  ) async {
    if (!_pauseCameraInBackground || _leaving) {
      return;
    }
    final current = state;
    if (current is! RoomInCall) {
      return;
    }
    switch (event.state) {
      case AppLifecycleState.hidden || AppLifecycleState.paused:
        if (_cameraPausedInBackground || !current.call.cameraEnabled) {
          return;
        }
        _cameraPausedInBackground = true;
        await _command(() => _session.setCameraEnabled(false));
      case AppLifecycleState.resumed:
        if (!_cameraPausedInBackground) {
          return;
        }
        _cameraPausedInBackground = false;
        await _command(() => _session.setCameraEnabled(true));
      case AppLifecycleState.inactive || AppLifecycleState.detached:
        break;
    }
  }

  Future<void> _onEndForAll(
    RoomEndForAllRequested event,
    Emitter<RoomState> emit,
  ) async {
    final current = state;
    if (current is! RoomInCall ||
        !current.isHost ||
        _leaving ||
        _endingForAll) {
      return;
    }
    _endingForAll = true;
    try {
      await _rooms.endRoom(current.room.code);
    } on Failure catch (failure) {
      _endingForAll = false;
      _emitEffect(RoomActionFailedEffect(failure));
      return;
    }
    if (state is RoomEnded) {
      return;
    }
    _leaving = true;
    _expiryTimer?.cancel();
    await _session.leave();
    emit(_endedByYou(current.room.code));
  }

  RoomEnded _endedByYou(RoomCode code) {
    return RoomEnded(CallEndReason.endedByHost, code: code, endedByYou: true);
  }

  Future<void> _onMute(
    RoomParticipantMuteRequested event,
    Emitter<RoomState> _,
  ) async {
    final target = _participant(event.identity);
    final done = await _hostCommand(
      (code) => _rooms.muteParticipant(
        code,
        identity: event.identity,
        trackSid: event.trackSid,
      ),
    );
    if (done) {
      _emitEffect(ParticipantMutedEffect(target));
    }
  }

  Future<void> _onRemove(
    RoomParticipantRemoveRequested event,
    Emitter<RoomState> _,
  ) async {
    final target = _participant(event.identity);
    final done = await _hostCommand(
      (code) => _rooms.removeParticipant(
        code,
        identity: event.identity,
        ban: event.ban,
      ),
    );
    if (done) {
      _emitEffect(ParticipantRemovedEffect(target));
    }
  }

  CallParticipant? _participant(String identity) {
    final snapshot = _lastConnected ?? _lastCall;
    for (final participant in snapshot.participants) {
      if (participant.identity == identity) {
        return participant;
      }
    }
    return null;
  }

  Future<void> _onLock(RoomLockRequested event, Emitter<RoomState> emit) async {
    final done = await _hostCommand(
      (code) => _rooms.updateRoom(code, RoomPatch(locked: event.locked)),
    );
    if (!done || _leaving) {
      return;
    }
    _room = _room?.copyWith(locked: event.locked);
    _refreshInCall(emit);
    _emitEffect(
      RoomSettingsChangedEffect(RoomSettingsChange.lock(event.locked)),
    );
  }

  Future<void> _onPassword(
    RoomPasswordChangeRequested event,
    Emitter<RoomState> emit,
  ) async {
    final password = event.password;
    final done = await _hostCommand(
      (code) => _rooms.updateRoom(
        code,
        RoomPatch(
          password: password == null
              ? const RemovePassword()
              : SetPassword(password),
        ),
      ),
    );
    if (!done || _leaving) {
      return;
    }
    _room = _room?.copyWith(passwordRequired: password != null);
    _refreshInCall(emit);
    _emitEffect(
      RoomSettingsChangedEffect(
        password == null
            ? RoomSettingsChange.passwordRemoved
            : RoomSettingsChange.passwordSet,
      ),
    );
  }

  Future<void> _onRotate(
    RoomInviteRotateRequested event,
    Emitter<RoomState> emit,
  ) async {
    final current = state;
    if (current is! RoomInCall || !current.isHost || _leaving) {
      return;
    }

    final RotatedCode next;
    try {
      next = await _rooms.rotateCode(current.room.code);
    } on Failure catch (failure) {
      devLog('Room command failed: $failure', name: 'RoomBloc', error: failure);
      _emitEffect(RoomActionFailedEffect(failure));
      return;
    }

    if (_leaving) {
      return;
    }
    _room = _room?.copyWith(code: next.code, inviteUrl: next.inviteUrl);
    _refreshInCall(emit);
    _emitEffect(
      const RoomSettingsChangedEffect(RoomSettingsChange.inviteRotated),
    );
  }

  void _refreshInCall(Emitter<RoomState> emit) {
    final current = state;
    if (current is RoomInCall) {
      _emitForCall(current.call, emit);
    }
  }

  Future<bool> _hostCommand(Future<void> Function(RoomCode code) action) async {
    final current = state;
    if (current is! RoomInCall || !current.isHost) {
      return false;
    }
    return _command(() => action(current.room.code));
  }

  Future<bool> _command(Future<void> Function() action) async {
    if (state is! RoomInCall || _leaving) {
      return false;
    }
    try {
      await action();
      return true;
    } on Failure catch (failure) {
      devLog('Room command failed: $failure', name: 'RoomBloc', error: failure);
      _emitEffect(RoomActionFailedEffect(failure));
      return false;
    }
  }

  void _emitEffect(RoomEffect effect) {
    if (!_effects.isClosed) {
      _effects.add(effect);
    }
  }

  @override
  Future<void> close() async {
    _leaving = true;
    _expiryTimer?.cancel();
    await _callSubscription.cancel();
    await _session.dispose();
    await _effects.close();
    return super.close();
  }
}
