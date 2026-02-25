// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/datasources/api_data_source.dart' as _i882;
import '../../data/datasources/livekit_data_source.dart' as _i926;
import '../../data/repositories/auth_repository.dart' as _i481;
import '../../data/repositories/room_repository.dart' as _i393;
import '../../domain/repositories/i_auth_repository.dart' as _i841;
import '../../domain/repositories/i_room_repository.dart' as _i80;
import '../../presentation/features/auth/bloc/auth_bloc.dart' as _i379;
import '../../presentation/features/home/bloc/home_bloc.dart' as _i635;
import '../../presentation/features/room/bloc/room_bloc.dart' as _i1033;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i882.ApiDataSource>(() => _i882.ApiDataSource());
    gh.factory<_i926.LiveKitDataSource>(() => _i926.LiveKitDataSource());
    gh.factory<_i80.IRoomRepository>(
      () => _i393.RoomRepository(
        gh<_i882.ApiDataSource>(),
        gh<_i926.LiveKitDataSource>(),
      ),
    );
    gh.factory<_i841.IAuthRepository>(
      () => _i481.AuthRepository(gh<_i882.ApiDataSource>()),
    );
    gh.factory<_i635.HomeBloc>(() => _i635.HomeBloc(gh<_i882.ApiDataSource>()));
    gh.factory<_i1033.RoomBloc>(
      () => _i1033.RoomBloc(gh<_i80.IRoomRepository>()),
    );
    gh.factory<_i379.AuthBloc>(
      () => _i379.AuthBloc(gh<_i841.IAuthRepository>()),
    );
    return this;
  }
}
