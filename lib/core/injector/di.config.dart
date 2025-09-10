// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../repositories/business_repository.dart' as _i146;
import '../repositories/local_business_repository_impl.dart' as _i155;
import '../services/register_module.dart' as _i421;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i361.Dio>(() => registerModule.dioInstance);
    gh.lazySingleton<_i146.BusinessRepository>(
      () => _i155.LocalBusinessRepositoryImpl(dio: gh<_i361.Dio>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i421.RegisterModule {}
