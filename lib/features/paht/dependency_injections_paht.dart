import 'package:citizen_app/features/paht/data/data_sources/data_sources.dart';
import 'package:citizen_app/features/paht/data/repositories/paht_repository_impl.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:citizen_app/features/paht/domain/usecases/get_comments.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:citizen_app/features/paht/presentation/bloc/category_paht_bloc/category_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/comment_bloc/comment_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/detailed_paht_bloc/detailed_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/create_issue_bloc/create_issue_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/personal_paht_bloc/personal_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/status_paht_bloc/status_paht_bloc.dart';

import 'package:get_it/get_it.dart';

Future<void> dependencyInjectionsPaht(GetIt singleton) async {
  singleton.registerFactory(
    () => PersonalPahtBloc(
        getListPersonalPaht: singleton(), deletePaht: singleton()),
  );
  singleton.registerFactory(
    () => PublicPahtBloc(
      getListPublicPaht: singleton(),deletePaht: singleton()
    ),
  );
  singleton.registerFactory(
    () => DetailedPahtBloc(
      getDetailedPaht: singleton(),
    ),
  );
  singleton.registerFactory(
    () => CommentBloc(
        getComments: singleton(),
        createComment: singleton(),
        replyComment: singleton()),
  );
  singleton.registerFactory(
      () => CategoryPahtBloc(getListCategoriesPaht: singleton()));
  singleton.registerFactory(() =>
      CreateIssueBloc(createIssuePaht: singleton(), updatePaht: singleton()));
  singleton.registerFactory(() => StatusPahtBloc(
      getListStatusPersonal: singleton(), getListStatusPublic: singleton()));

  // Use cases
  singleton.registerLazySingleton(() => GetListPersonalPaht(singleton()));
  singleton.registerLazySingleton(() => GetListPublicPaht(singleton()));
  singleton.registerLazySingleton(() => GetListCategoriesPaht(singleton()));
  singleton.registerLazySingleton(() => GetListStatusPublic(singleton()));
  singleton.registerLazySingleton(() => GetListStatusPersonal(singleton()));
  singleton.registerLazySingleton(() => GetDetailedPaht(singleton()));
  singleton.registerLazySingleton(() => GetComments(singleton()));
  singleton.registerLazySingleton(() => CreateIssuePaht(singleton()));
  singleton.registerLazySingleton(() => DeletePaht(singleton()));
  singleton.registerLazySingleton(() => UpdatePaht(singleton()));
  singleton.registerLazySingleton(() => CreateComment(singleton()));
  singleton.registerLazySingleton(() => ReplyComment(singleton()));

  // Repository
  singleton.registerLazySingleton<PahtRepository>(
    () => PahtRepositoryImpl(
      localDataSource: singleton(),
      networkInfo: singleton(),
      remoteDataSource: singleton(),
    ),
  );

  singleton.registerLazySingleton<PahtRemoteDataSource>(
    () => PahtRemoteDataSourceImpl(
        client: singleton(),
        networkRequest: singleton(),
        sharedPreferences: singleton()),
  );

  singleton.registerLazySingleton<PahtLocalDataSource>(
    () => PahtLocalDataSourceImpl(sharedPreferences: singleton()),
  );
}
