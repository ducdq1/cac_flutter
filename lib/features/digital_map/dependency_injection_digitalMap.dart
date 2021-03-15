import 'package:citizen_app/features/digital_map/data/datasources/map_remote_data_source.dart';
import 'package:citizen_app/features/digital_map/data/repositories/map_repository_impl.dart';
import 'package:citizen_app/features/digital_map/domain/repositories/map_repository.dart';
import 'package:citizen_app/features/digital_map/domain/usecases/get_list_filter_category.dart';
import 'package:citizen_app/features/digital_map/domain/usecases/get_list_marker_info.dart';
import 'package:citizen_app/features/digital_map/presentation/blocs/filter_category/filter_category_bloc.dart';
import 'package:citizen_app/features/digital_map/presentation/blocs/marker_info/marker_info_bloc.dart';
import 'package:citizen_app/features/digital_map/presentation/blocs/type_category/type_category_bloc.dart';

import 'package:get_it/get_it.dart';

Future<void> dependencyInjectionsDigitalMap(GetIt singleton) async {
  singleton.registerFactory(
      () => FilterCategoryBloc(getListFilterCategoryUseCase: singleton()));

  singleton.registerFactory(
      () => MarkerInfoBloc(getListMarkerInfoUseCase: singleton()));

  singleton.registerFactory(() => TypeCategoryBloc());

  // Use cases
  singleton
      .registerLazySingleton(() => GetListFilterCategoryUseCase(singleton()));

  singleton.registerLazySingleton(() => GetListMarkerInfoUseCase(singleton()));

  // Repository
  singleton.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(
      //localDataSource: singleton(),
      networkInfo: singleton(),
      remoteDataSource: singleton(),
    ),
  );

  singleton.registerLazySingleton<MapRepositoryImpl>(
    () => MapRepositoryImpl(
      //localDataSource: singleton(),
      networkInfo: singleton(),
      remoteDataSource: singleton(),
    ),
  );

  singleton.registerLazySingleton<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(
        client: singleton(), networkRequest: singleton()),
  );

  // singleton.registerLazySingleton<PahtLocalDataSource>(
  //   () => PahtLocalDataSourceImpl(sharedPreferences: singleton()),
  // );
}
