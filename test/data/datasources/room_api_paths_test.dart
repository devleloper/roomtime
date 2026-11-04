import 'package:roomtime/data/datasources/room_api_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

// SEC-16: room codes and identities never reach the logs.
void main() {
  test('masks the room code and participant identity in logged paths', () {
    expect(
      RoomApiDataSource.maskPath('/rooms/abcdefghjk/join'),
      '/rooms/:code/join',
    );
    expect(
      RoomApiDataSource.maskPath('/rooms/abcdefghjk/participants/p_x/mute'),
      '/rooms/:code/participants/:identity/mute',
    );
    expect(RoomApiDataSource.maskPath('/rooms'), '/rooms');
  });
}
