final class RoomExitGuard {
  Future<bool> Function()? _onExit;

  void attach(Future<bool> Function() onExit) {
    _onExit = onExit;
  }

  void detach(Future<bool> Function() onExit) {
    if (_onExit == onExit) {
      _onExit = null;
    }
  }

  Future<bool> mayExit() {
    final onExit = _onExit;
    if (onExit == null) {
      return Future.value(true);
    }
    return onExit();
  }
}
