import 'dart:convert';

import 'package:citizen_app/core/error/exceptions.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PahtLocalDataSource {
  Future<List<PahtModel>> getLastPaht();
  Future<void> cachePaht(List<PahtModel> pahttoCache);

  Future<List<CategoryModel>> getLastCategoriesPaht();
  Future<void> cacheCategoriesPaht(List<CategoryModel> categoriesToCache);

  Future<List<StatusModel>> getLastStatusPaht();
  Future<void> cacheStatusPaht(List<StatusModel> statusToCache);
}

class PahtLocalDataSourceImpl implements PahtLocalDataSource {
  final SharedPreferences sharedPreferences;

  PahtLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<List<PahtModel>> getLastPaht() {
    final jsonString = sharedPreferences.getString(CACHED_PAHT);
    if (jsonString != null) {
      List listCachedPaht = jsonDecode(jsonString);
      return Future.value(listCachedPaht
          .map((cachedPaht) => PahtModel.fromJson(cachedPaht))
          .toList());
    } else {
      throw CacheException('ERROR CACHED DATA');
    }
  }

  @override
  Future<void> cachePaht(List<PahtModel> pahtToCache) {
    return sharedPreferences.setString(
      CACHED_PAHT,
      pahtToCache.toString(),
    );
  }

  @override
  Future<List<CategoryModel>> getLastCategoriesPaht() {
    final jsonString = sharedPreferences.getString(CACHED_CATEGORY);
    if (jsonString != null) {
      List listCachedCategories = jsonDecode(jsonString);
      return Future.value(listCachedCategories
          .map((cachedPaht) => CategoryModel.fromJson(cachedPaht))
          .toList());
    } else {
      throw CacheException('ERROR CACHED DATA');
    }
  }

  @override
  Future<void> cacheCategoriesPaht(List<CategoryModel> categoriesToCache) {
    return sharedPreferences.setString(
      CACHED_CATEGORY,
      categoriesToCache.toString(),
    );
  }

  @override
  Future<List<StatusModel>> getLastStatusPaht() {
    final jsonString = sharedPreferences.getString(CACHED_CATEGORY);
    if (jsonString != null) {
      List listCachedStatus = jsonDecode(jsonString);
      return Future.value(listCachedStatus
          .map((cachedPaht) => StatusModel.fromJson(cachedPaht))
          .toList());
    } else {
      throw CacheException('ERROR CACHED DATA');
    }
  }

  @override
  Future<void> cacheStatusPaht(List<StatusModel> statusToCache) {
    return sharedPreferences.setString(
      CACHED_CATEGORY,
      statusToCache.toString(),
    );
  }
}
