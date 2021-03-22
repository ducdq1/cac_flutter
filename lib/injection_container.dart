import 'package:citizen_app/core/network/network_request.dart';
import 'package:citizen_app/core/utils/utils.dart';
import 'package:citizen_app/features/address_picker/dependency_injections_address_picker.dart';
import 'package:citizen_app/features/home/dependency_injections_home.dart';
import 'package:citizen_app/features/paht/dependency_injections_paht.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final singleton = GetIt.instance;

Future<void> init() async {
  //! Core
  singleton.registerLazySingleton(() => InputConverter());
  singleton
      .registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(singleton()));
  singleton.registerLazySingleton<NetworkRequest>(
    () =>
        NetworkRequestImpl(client: singleton(), sharedPreferences: singleton()),
  );

  //! External
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final sharedPreferences = await SharedPreferences.getInstance();
  singleton.registerLazySingleton(() => sharedPreferences);
  singleton.registerLazySingleton(() => packageInfo);
  singleton.registerLazySingleton(() => http.Client());
  singleton.registerLazySingleton(() => DataConnectionChecker());

  //Feature - Bloc - Usecase - Repository - Datasource
  await dependencyInjectionsPaht(singleton);
  await dependencyInjectionsHome(singleton);
  await dependencyInjectionsAddressPicker(singleton);

  //! Features - Number Trivia
  // Bloc
  singleton.registerFactory(
    () => NumberTriviaBloc(
      concrete: singleton(),
      inputConverter: singleton(),
      random: singleton(),
    ),
  );
  // Use cases
  singleton.registerLazySingleton(() => GetConcreteNumberTrivia(singleton()));
  singleton.registerLazySingleton(() => GetRandomNumberTrivia(singleton()));

  // Repository
  singleton.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: singleton(),
      networkInfo: singleton(),
      remoteDataSource: singleton(),
    ),
  );

  // Data sources
  singleton.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: singleton()),
  );

  singleton.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: singleton()),
  );
}
