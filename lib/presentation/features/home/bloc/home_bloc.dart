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
    print('HomeBloc: _onFetchRooms - Started');
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      print('HomeBloc: _onFetchRooms - Requesting rooms from ApiDataSource...');
      final rooms = await _apiDataSource.fetchRooms();
      print(
        'HomeBloc: _onFetchRooms - Successfully fetched ${rooms.length} rooms',
      );
      emit(state.copyWith(status: HomeStatus.success, rooms: rooms));
    } catch (e, stackTrace) {
      print('HomeBloc: _onFetchRooms - Error fetching rooms: $e');
      print('HomeBloc: _onFetchRooms - StackTrace: $stackTrace');
      emit(
        state.copyWith(status: HomeStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
