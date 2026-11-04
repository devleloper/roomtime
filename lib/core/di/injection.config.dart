// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/datasources/key_value_store.dart' as _i887;
import '../../data/datasources/owner_token_store.dart' as _i787;
import '../../data/datasources/room_api_data_source.dart' as _i213;
import '../../data/repositories/guest_profile_repository.dart' as _i569;
import '../../data/repositories/recent_rooms_repository.dart' as _i856;
import '../../data/repositories/room_repository.dart' as _i393;
import '../../data/services/audio_service.dart' as _i186;
import '../../data/services/call_foreground_service.dart' as _i511;
import '../../data/services/livekit_call_session.dart' as _i627;
import '../../data/services/livekit_media_preview.dart' as _i90;
import '../../domain/repositories/i_guest_profile_repository.dart' as _i224;
import '../../domain/repositories/i_recent_rooms_repository.dart' as _i668;
import '../../domain/repositories/i_room_repository.dart' as _i80;
import '../../domain/services/call_session.dart' as _i1059;
import '../../domain/services/i_audio_service.dart' as _i560;
import '../../domain/services/media_preview.dart' as _i1019;
import '../../presentation/features/home/bloc/home_bloc.dart' as _i635;
import '../../presentation/features/room/bloc/lobby_cubit.dart' as _i294;
import '../../presentation/features/room/bloc/room_bloc.dart' as _i1033;
import '../config/app_config.dart' as _i650;
import '../time/clock.dart' as _i807;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.singleton<_i650.AppConfig>(() => appModule.config);
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => appModule.secureStorage);
    gh.lazySingleton<_i807.Clock>(() => const _i807.Clock());
    gh.lazySingleton<_i511.CallForegroundService>(
      () => _i511.CallForegroundService(),
    );
    gh.factory<_i1019.MediaPreview>(() => _i90.LiveKitMediaPreview());
    gh.lazySingleton<_i560.IAudioService>(() => _i186.AudioService());
    gh.lazySingleton<_i887.KeyValueStore>(
      () => _i887.SecureKeyValueStore(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i668.IRecentRoomsRepository>(
      () => _i856.RecentRoomsRepository(gh<_i887.KeyValueStore>()),
    );
    gh.factory<_i1059.CallSession>(
      () => _i627.LiveKitCallSession(gh<_i511.CallForegroundService>()),
    );
    gh.lazySingleton<_i361.Dio>(() => appModule.dio(gh<_i650.AppConfig>()));
    gh.lazySingleton<_i787.OwnerTokenStore>(
      () => _i787.OwnerTokenStore(gh<_i887.KeyValueStore>()),
    );
    gh.lazySingleton<_i224.IGuestProfileRepository>(
      () => _i569.GuestProfileRepository(gh<_i887.KeyValueStore>()),
    );
    gh.lazySingleton<_i213.RoomApiDataSource>(
      () => _i213.RoomApiDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i80.IRoomRepository>(
      () => _i393.RoomRepository(
        gh<_i213.RoomApiDataSource>(),
        gh<_i787.OwnerTokenStore>(),
        gh<_i668.IRecentRoomsRepository>(),
        gh<_i807.Clock>(),
      ),
    );
    gh.factory<_i1033.RoomBloc>(
      () => _i1033.RoomBloc(
        gh<_i80.IRoomRepository>(),
        gh<_i224.IGuestProfileRepository>(),
        gh<_i1059.CallSession>(),
        gh<_i560.IAudioService>(),
        gh<_i807.Clock>(),
      ),
    );
    gh.factory<_i635.HomeBloc>(
      () => _i635.HomeBloc(
        gh<_i668.IRecentRoomsRepository>(),
        gh<_i80.IRoomRepository>(),
        gh<_i224.IGuestProfileRepository>(),
      ),
    );
    gh.factory<_i294.LobbyCubit>(
      () => _i294.LobbyCubit(
        gh<_i80.IRoomRepository>(),
        gh<_i224.IGuestProfileRepository>(),
        gh<_i1019.MediaPreview>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
