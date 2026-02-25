import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Map<String, dynamic>> rooms;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.rooms = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Map<String, dynamic>>? rooms,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      rooms: rooms ?? this.rooms,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, rooms, errorMessage];
}
