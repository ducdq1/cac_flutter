import 'package:citizen_app/features/digital_map/domain/entities/filter_category.dart';
import 'package:citizen_app/features/digital_map/domain/entities/marker_info.dart';

abstract class MapRepository {
  Future<List<MarkerInfo>> getListMarkerInfo({
    String query,
    List<double> proximity,
  });
  
  Future<List<FilterCategory>> getListFilterCategory();
}
