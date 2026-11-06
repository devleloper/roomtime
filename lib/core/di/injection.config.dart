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

import '../../data/local/key_value_store.dart' as _i861;
import '../../data/local/owner_token_store.dart' as _i541;
import '../../data/network/room_api_data_source.dart' as _i531;
import '../../data/repositories/guest_profile_repository.dart' as _i569;
import '../../data/repositories/recent_rooms_repository.dart' as _i856;
import '../../data/repositories/room_repository.dart' as _i393;
import '../../data/services/audio_service.dart' as _i186;
import '../../data/services/call_foreground_service.dart' as _i511;
import '../../data/services/livekit_call_session.dart' as _i627;
import '../../data/services/livekit_media_preview.dart' as _i90;
import '../../domain/repositories/guest_profile_repository.dart' as _i329;
import '../../domain/repositories/recent_rooms_repository.dart' as _i1012;
import '../../domain/repositories/room_repository.dart' as _i8;
import '../../domain/services/audio_service.dart' as _i907;
import '../../domain/services/call_session.dart' as _i1059;
import '../../domain/services/media_preview.dart' as _i1019;
import '../../presentation/features/home/bloc/home_bloc.dart' as _i635;
import '../../presentation/features/room/bloc/lobby_cubit.dart' as _i294;
import '../../presentation/features/room/bloc/room_bloc.dart' as _i1033;
import '../config/app_config.dart' as _i650;
import '../utils/clock.dart' as _i76;
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
    gh.lazySingleton<_i76.Clock>(() => const _i76.Clock());
    gh.lazySingleton<_i511.CallForegroundService>(
      () => _i511.CallForegroundService(),
    );
    gh.factory<_i1019.MediaPreview>(() => _i90.LiveKitMediaPreview());
    gh.lazySingleton<_i861.KeyValueStore>(
      () => _i861.SecureKeyValueStore(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i541.OwnerTokenStore>(
      () => _i541.OwnerTokenStore(gh<_i861.KeyValueStore>()),
    );
    gh.lazySingleton<_i907.AudioService>(
      () => _i186.AssetAudioService(),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i1059.CallSession>(
      () => _i627.LiveKitCallSession(gh<_i511.CallForegroundService>()),
    );
    gh.lazySingleton<_i361.Dio>(() => appModule.dio(gh<_i650.AppConfig>()));
    gh.lazySingleton<_i329.GuestProfileRepository>(
      () => _i569.LocalGuestProfileRepository(gh<_i861.KeyValueStore>()),
    );
    gh.lazySingleton<_i1012.RecentRoomsRepository>(
      () => _i856.LocalRecentRoomsRepository(gh<_i861.KeyValueStore>()),
    );
    gh.lazySingleton<_i531.RoomApiDataSource>(
      () => _i531.RoomApiDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i8.RoomRepository>(
      () => _i393.ApiRoomRepository(
        gh<_i531.RoomApiDataSource>(),
        gh<_i541.OwnerTokenStore>(),
        gh<_i1012.RecentRoomsRepository>(),
        gh<_i76.Clock>(),
      ),
    );
    gh.factory<_i1033.RoomBloc>(
      () => _i1033.RoomBloc(
        gh<_i8.RoomRepository>(),
        gh<_i329.GuestProfileRepository>(),
        gh<_i1059.CallSession>(),
        gh<_i907.AudioService>(),
        gh<_i76.Clock>(),
      ),
    );
    gh.factory<_i294.LobbyCubit>(
      () => _i294.LobbyCubit(
        gh<_i8.RoomRepository>(),
        gh<_i329.GuestProfileRepository>(),
        gh<_i1019.MediaPreview>(),
      ),
    );
    gh.factory<_i635.HomeBloc>(
      () => _i635.HomeBloc(
        gh<_i1012.RecentRoomsRepository>(),
        gh<_i8.RoomRepository>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
