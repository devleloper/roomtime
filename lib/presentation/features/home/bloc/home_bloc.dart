import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/datasources/api_data_source.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiDataSource _apiDataSource;

  HomeBloc(this._apiDataSource) : super(const HomeState()) {
    on<FetchRooms>(_onFetchRooms);
  }

  Future<void> _onFetchRooms(FetchRooms event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final rooms = await _apiDataSource.fetchRooms();
      emit(state.copyWith(status: HomeStatus.success, rooms: rooms));
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
