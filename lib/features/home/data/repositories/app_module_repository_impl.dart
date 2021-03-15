import 'package:citizen_app/features/home/data/datasources/datasources.dart';
import 'package:citizen_app/features/home/data/models/models.dart';
import 'package:citizen_app/features/home/domain/repositories/repositories.dart';

import 'package:meta/meta.dart';

import '../../../../core/network/network_info.dart';

class AppModuleRepositoryImpl implements AppModuleRepository {
  final AppModuleRemoteDataSource remoteDataSource;
  final AppModuleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AppModuleRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<AppModuleModel> getAppModules({int provinceId, int userId}) async {
    // if (await networkInfo.isConnected) {
    //   print('network is connect');
    //   try {
    //     final remoteAppModules = await remoteDataSource.getAppModules();
    //     localDataSource.cacheAppModules(remoteAppModules);
    //     return remoteAppModules;
    //   } catch (error) {
    //     print('network ');

    //     throw Exception(error.message);
    //   }
    // } else {
    //   print('network is not connect');
    //   try {
    //     final localAppModule = await localDataSource.getLastAppModules();
    //     return localAppModule;
    //   } catch (error) {
    //     print('error network 2');

    //     throw Exception(error.message);
    //   }
    // }
    try {
      final remoteAppModules = await remoteDataSource.getAppModules(
          provinceId: provinceId, userId: userId);
      localDataSource.cacheAppModules(remoteAppModules);
      return remoteAppModules;
    } catch (error) {
      throw Exception(error);
    }
  }
}
