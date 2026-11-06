abstract interface class AudioService {
  Future<void> playJoinSound();
  Future<void> playLeaveSound();
  Future<void> dispose();
}
