import 'package:citizen_app/features/digital_map/domain/entities/geometry.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MarkerInfo extends Equatable {
  final String id;
  final int poiType;
  final String type;
  final List<String> placeType;
  final double relevance;
  final String text;
  final String placeName;
  final List<double> center;
  // final Set properties;
  final Geometry geometry;
  final String imagepath;
  final String markername;
  final bool saved;

  MarkerInfo(
      {@required this.id,
      @required this.poiType,
      @required this.type,
      @required this.placeType,
      @required this.relevance,
      @required this.text,
      @required this.placeName,
      @required this.center,
      // @required this.properties,
      @required this.geometry,
      @required this.imagepath,
      @required this.markername,
      @required this.saved});

  @override
  List<Object> get props => [
        id,
        poiType,
        type,
        placeType,
        relevance,
        text,
        placeName,
        center,
        // properties,
        geometry,
        imagepath,
        markername,
        saved
      ];
}
