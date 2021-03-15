import 'package:citizen_app/core/network/network_info.dart';
import 'package:citizen_app/features/digital_map/data/datasources/map_remote_data_source.dart';
import 'package:citizen_app/features/digital_map/data/models/filter_category_model.dart';
import 'package:citizen_app/features/digital_map/data/models/marker_info_model.dart';
import 'package:citizen_app/features/digital_map/domain/repositories/map_repository.dart';

import 'package:meta/meta.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MapRepositoryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
  });

  @override
  Future<List<FilterCategoryModel>> getListFilterCategory() async {
    try {
      final remoteFilterCategory =
          await remoteDataSource.getListFilterCategory();
      return remoteFilterCategory;
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<List<MarkerInfoModel>> getListMarkerInfo(
      {String query, List<double> proximity}) async {
    try {
      final remoteListMarkerInfo = await remoteDataSource.getListMarkerInfo(
        query: query,
        proximity: proximity,
      );
      return remoteListMarkerInfo;
    } catch (error) {
      throw Exception(error);
    }
  }
}
