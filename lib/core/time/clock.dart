import 'package:injectable/injectable.dart';

/// Injectable source of the current time, so time-dependent logic is testable.
@lazySingleton
class Clock {
  const Clock();

  DateTime now() => DateTime.now();
}
