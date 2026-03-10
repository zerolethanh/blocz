// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:blocz_example/api/example_api.dart' as _i919;
import 'package:blocz_example/features/user/presentation/bloc/user_bloc.dart'
    as _i624;
import 'package:blocz_example/injection.dart' as _i400;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i919.ExampleApi>(() => registerModule.exampleApi);
    gh.lazySingleton<_i624.UserBloc>(() => _i624.UserBloc());
    return this;
  }
}

class _$RegisterModule extends _i400.RegisterModule {}
