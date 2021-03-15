import 'package:citizen_app/features/digital_map/domain/entities/geometry.dart';
import 'package:meta/meta.dart';

class GeometryModel extends Geometry {
  GeometryModel({
    @required String type,
    @required List<double> coordinates,
  }) : super(type: type, coordinates: coordinates);

  factory GeometryModel.fromJson(Map json) {
    return GeometryModel(
      type: json['type'].toString(),
      coordinates: (json['coordinates'] as List)
          .map((coordinate) => coordinate as double)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
