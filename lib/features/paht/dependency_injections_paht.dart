import 'package:citizen_app/features/customer/data/data_sources/cus_remote_data_source.dart';
import 'package:citizen_app/features/customer/data/repositories/cus_repository.dart';
import 'package:citizen_app/features/customer/data/repositories/cus_repository_impl.dart';
import 'package:citizen_app/features/customer/presentation/bloc/notification/notification_bloc.dart';
import 'package:citizen_app/features/customer/presentation/bloc/productCategory/product_category_bloc.dart';
import 'package:citizen_app/features/customer/presentation/bloc/promotion/promotion_bloc.dart';
import 'package:citizen_app/features/paht/data/data_sources/data_sources.dart';
import 'package:citizen_app/features/paht/data/repositories/paht_repository_impl.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:citizen_app/features/paht/domain/usecases/get_list_quotation_detail.dart';
import 'package:citizen_app/features/paht/domain/usecases/search_product.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:citizen_app/features/paht/presentation/bloc/create_ckbg_bloc/create_ckbg_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/detailed_paht_bloc/detailed_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/create_issue_bloc/create_issue_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/personal_paht_bloc/personal_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/status_paht_bloc/status_paht_bloc.dart';
import 'package:citizen_app/features/customer/data/data_sources/data_sources.dart';
import 'package:citizen_app/features/customer/domain/usecases/usecases.dart';

import 'package:get_it/get_it.dart';

import 'domain/usecases/create_ckbg.dart';

Future<void> dependencyInjectionsPaht(GetIt singleton) async {

  // Use cases
  singleton.registerLazySingleton(() => GetListPersonalPaht(singleton()));
  singleton.registerLazySingleton(() => GetListPublicPaht(singleton()));
  singleton.registerLazySingleton(() => GetListStatusPublic(singleton()));
  singleton.registerLazySingleton(() => GetListStatusPersonal(singleton()));
  singleton.registerLazySingleton(() => GetDetailedPaht(singleton()));
  singleton.registerLazySingleton(() => CreateIssuePaht(singleton()));
  singleton.registerLazySingleton(() => CreateCKBG(singleton()));
  singleton.registerLazySingleton(() => GetQuotationDetail(singleton()));
  singleton.registerLazySingleton(() => DeletePaht(singleton()));
  singleton.registerLazySingleton(() => UpdatePaht(singleton()));
  singleton.registerLazySingleton(() => SearchProduct(singleton()));
  singleton.registerLazySingleton(() => GetListProductCategory(singleton()));
  singleton.registerLazySingleton(() => GetListPromotion(singleton()));
  singleton.registerFactory(
    () => PersonalPahtBloc(
        getListPersonalPaht: singleton(), deletePaht: singleton()),
  );
  singleton.registerFactory(
    () => PublicPahtBloc(
      getListPublicPaht: singleton(),deletePaht: singleton(),searchProduct: singleton()
    ),
  );

  singleton.registerFactory(
    () => DetailedPahtBloc(
      getDetailedPaht: singleton(),
    ),
  );

  singleton.registerFactory(
        () => PromotionBloc(
      getListPromotion: singleton(),
    ),
  );

  singleton.registerFactory(
        () => ProductCategoryBloc(
      getListProductCategory: singleton(),
    ),
  );

  singleton.registerFactory(() =>
      CreateIssueBloc(createIssuePaht: singleton(), updatePaht: singleton(), getQuotationDetailPaht: singleton()));

  singleton.registerFactory(() => StatusPahtBloc(
      getListStatusPersonal: singleton(), getListStatusPublic: singleton()));

  singleton.registerFactory(() =>
      CreateCKBGBloc(createCKBG: singleton(), getCKBGDetail: singleton()));


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

  // Repository
  singleton.registerLazySingleton<CusRepository>(
        () => CusRepositoryImpl(
      remoteDataSource: singleton(),
    ),
  );

  /// singleton notificatonbloc dau anh? do khong phai la singleton :D))))

  singleton.registerLazySingleton<CusRemoteDataSource>(
        () => CusRemoteDataSourceImpl(
        client: singleton(),
        networkRequest: singleton(),
        sharedPreferences: singleton()),
  );

  singleton.registerLazySingleton<PahtLocalDataSource>(
    () => PahtLocalDataSourceImpl(sharedPreferences: singleton()),
  );

  // anh chay lay thu di ok
  singleton.registerLazySingleton(
        () => NotificationBloc(),
  );
}
