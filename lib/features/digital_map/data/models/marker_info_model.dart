import 'dart:convert';

import 'package:citizen_app/features/digital_map/data/models/geometry_model.dart';
import 'package:citizen_app/features/digital_map/domain/entities/marker_info.dart';
import 'package:meta/meta.dart';

class MarkerInfoModel extends MarkerInfo {
  MarkerInfoModel({
    @required String id,
    @required int poiType,
    @required String type,
    @required List<String> placeType,
    @required double relevance,
    @required String text,
    @required String placeName,
    @required List<double> center,
    // @required Set properties,
    @required GeometryModel geometry,
    @required String imagepath,
    @required String markername,
    @required bool saved,
  }) : super(
            id: id,
            poiType: poiType,
            type: type,
            relevance: relevance,
            text: text,
            placeType: placeType,
            placeName: placeName,
            center: center,
            // properties: properties,
            geometry: geometry,
            imagepath: imagepath,
            markername: markername,
            saved: saved);

  factory MarkerInfoModel.fromJson(Map json) {
    return MarkerInfoModel(
      id: json['id'].toString(),
      poiType: json['poiType'] as num,
      type: json['type'].toString(),
      placeType: (json['place_type'] as List).map((e) => e.toString()).toList(),
      relevance: json['relevance'] as double,
      text: json['text'].toString(),
      placeName: json['place_name'].toString(),
      center: (json['center'] as List).map((e) => e as double).toList(),
      // properties: jsonDecode(json['properties']),
      geometry: GeometryModel.fromJson(json['geometry']),
      imagepath: json['imagepath'].toString(),
      markername: json['markername'].toString(),
      saved: json['saved'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poiType': poiType,
      'type': type,
      'relevance': relevance,
      'text': text,
      'placeName': placeName,
      'center': center,
      // 'properties': properties,
      'geometry': geometry,
      'imagepath': imagepath,
      'markername': markername,
      'saved': saved,
    };
  }
}
