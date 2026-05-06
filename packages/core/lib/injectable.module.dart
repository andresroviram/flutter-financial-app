//@GeneratedMicroModule;CorePackageModule;package:core/injectable.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:core/env/i_env_config.dart' as _i693;
import 'package:core/database/app_database.dart' as _i696;
import 'package:core/database/database_module.dart' as _i520;
import 'package:core/network/dio_client.dart' as _i732;
import 'package:core/performance/performance_settings.dart' as _i707;
import 'package:injectable/injectable.dart' as _i526;

class CorePackageModule extends _i526.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final databaseModule = _$DatabaseModule();
    gh.singleton<_i696.AppDatabase>(() => databaseModule.database);
    gh.lazySingleton<_i707.PerformanceSettingsCubit>(
      () => _i707.PerformanceSettingsCubit(),
    );
    gh.lazySingleton<_i732.DioClient>(
      () => _i732.DioClient(gh<_i693.IEnvConfig>()),
    );
  }
}

class _$DatabaseModule extends _i520.DatabaseModule {}
