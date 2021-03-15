import 'dart:convert';

import 'package:citizen_app/core/error/exceptions.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/home/data/models/models.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppModuleLocalDataSource {
  Future<AppModuleModel> getLastAppModules();

  Future<void> cacheAppModules(AppModuleModel appModulestoCache);
}

class AppModuleLocalDataSourceImpl implements AppModuleLocalDataSource {
  final SharedPreferences sharedPreferences;

  AppModuleLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<AppModuleModel> getLastAppModules() {
    final jsonString = sharedPreferences.getString(CACHED_APP_MODULE);
    if (jsonString != null) {
      Map cachedAppModule = jsonDecode(jsonString);
      return Future.value(AppModuleModel.fromJson(cachedAppModule));
    } else {
      throw CacheException('ERROR CACHED DATA');
    }
  }

  @override
  Future<void> cacheAppModules(AppModuleModel appModulesToCache) {
    return sharedPreferences.setString(
      CACHED_APP_MODULE,
      appModulesToCache.toString(),
    );
  }
}
