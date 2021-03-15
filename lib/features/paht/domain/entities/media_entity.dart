import 'package:equatable/equatable.dart';

class MediaEntity extends Equatable {
  final List<LocationUrlEntity> photos;
  final List<LocationUrlEntity> videos;

  MediaEntity({this.photos, this.videos});

  @override
  List<Object> get props => [];
  Map<String, dynamic> toJson() {
    return {};
  }
}

class LocationUrlEntity extends Equatable {
  final String relLocation;
  final String location;

  LocationUrlEntity({this.relLocation, this.location});

  @override
  List<Object> get props => [relLocation, location];
}
// import 'package:equatable/equatable.dart';

// class MediaEntity extends Equatable {
//   final List<String> photos;
//   final List<String> videos;

//   MediaEntity({this.photos, this.videos});

//   @override
//   List<Object> get props => [];
//   Map<String, dynamic> toJson() {
//     return {};
//   }
// }
