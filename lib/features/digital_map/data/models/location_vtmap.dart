import 'package:equatable/equatable.dart';

class LocationVTMaps extends Equatable {
  final int id;
  final String name;
  final String address;
  final String districtName;

  LocationVTMaps({this.id, this.name, this.address, this.districtName});
  factory LocationVTMaps.fromJson(Map<String, dynamic> json) {
    return LocationVTMaps(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      districtName: json['districtName'],
    );
  }

  @override
  List<Object> get props => [id, name, address, districtName];
}
