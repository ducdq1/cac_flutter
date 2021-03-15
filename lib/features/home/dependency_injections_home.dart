import 'package:citizen_app/features/home/data/datasources/datasources.dart';
import 'package:citizen_app/features/home/data/repositories/repositories.dart';
import 'package:citizen_app/features/home/domain/repositories/repositories.dart';
import 'package:citizen_app/features/home/domain/usecases/usecases.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';

import 'package:get_it/get_it.dart';

Future<void> dependencyInjectionsHome(GetIt singleton) async {
  singleton.registerFactory(
    () => HomePageBloc(getAppModulesUseCase: singleton()),
  );
  // Use cases
  singleton.registerLazySingleton(() => GetListAppModulesUseCase(singleton()));
  singleton.registerLazySingleton<AppModuleRepository>(
    () => AppModuleRepositoryImpl(
      localDataSource: singleton(),
      networkInfo: singleton(),
      remoteDataSource: singleton(),
    ),
  );
  singleton.registerLazySingleton<AppModuleRemoteDataSource>(
    () => AppModuleRemoteDataSourceImpl(
        client: singleton(), networkRequest: singleton()),
  );

  singleton.registerLazySingleton<AppModuleLocalDataSource>(
    () => AppModuleLocalDataSourceImpl(sharedPreferences: singleton()),
  );
}
