import 'package:roomtime/data/services/livekit_call_session.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livekit_client/livekit_client.dart' as lk;

lk.ConnectException refused(String body, int status) => lk.ConnectException(
  body,
  reason: lk.ConnectionErrorReason.NotAllowed,
  statusCode: status,
);

void main() {
  test('LiveKit refusing the last seat -> RoomFullFailure', () {
    expect(
      LiveKitCallSession.connectFailure(refused('room is full', 403)),
      const RoomFullFailure(),
    );
    expect(
      LiveKitCallSession.connectFailure(
        refused('max participants exceeded', 429),
      ),
      const RoomFullFailure(),
    );
  });

  test('unknown room (auto_create off) -> RoomNotFoundFailure', () {
    expect(
      LiveKitCallSession.connectFailure(
        refused('requested room does not exist', 404),
      ),
      const RoomNotFoundFailure(),
    );
  });

  test('other refusals keep the status, transport errors are network', () {
    expect(
      LiveKitCallSession.connectFailure(refused('invalid token', 401)),
      const UnknownFailure(statusCode: 401, code: 'media_refused'),
    );
    expect(
      LiveKitCallSession.connectFailure(
        lk.ConnectException(
          'timeout',
          reason: lk.ConnectionErrorReason.Timeout,
        ),
      ),
      const NetworkFailure(),
    );
    expect(
      LiveKitCallSession.connectFailure(lk.MediaConnectException()),
      const NetworkFailure(),
    );
    expect(
      LiveKitCallSession.connectFailure(StateError('x')),
      const UnknownFailure(),
    );
  });

  // CR-C7: /rtc/validate turns a 5xx from the edge into NotAllowed.
  test('a 5xx from the media edge -> ServerFailure, not media_refused', () {
    expect(
      LiveKitCallSession.connectFailure(refused('<html>502', 502)),
      const ServerFailure(statusCode: 502),
    );
  });
}
