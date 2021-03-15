import 'package:citizen_app/features/paht/domain/entities/media_entity.dart';

class MediaModel extends MediaEntity {
  MediaModel({List<LocationUrlEntity> photos, List<LocationUrlEntity> videos})
      : super(photos: photos, videos: videos);

  factory MediaModel.fromJson(Map json) {
    return MediaModel(
      photos: (json['photos'] as List).map((e) {
        LocationUrlModel locationUrl = LocationUrlModel.fromJson(e);
        return locationUrl;
      }).toList(),
      videos: (json['videos'] as List).map((e) {
        LocationUrlModel locationUrl = LocationUrlModel.fromJson(e);
        return locationUrl;
      }).toList(),
    );
  }

  @override
  String toString() => 'Media { photos: $photos, videos: $videos}';
}

class LocationUrlModel extends LocationUrlEntity {
  LocationUrlModel({String relLocation, String location})
      : super(relLocation: relLocation, location: location);

  factory LocationUrlModel.fromJson(Map json) {
    return LocationUrlModel(
      relLocation: json['relLocation'],
      location: json['location'],
    );
  }

  @override
  String toString() =>
      'Media { relLocation: $relLocation, location: $location}';
}
// import 'package:citizen_app/features/paht/domain/entities/media_entity.dart';

// class MediaModel extends MediaEntity {
//   MediaModel({List<String> photos, List<String> videos})
//       : super(photos: photos, videos: videos);

//   factory MediaModel.fromJson(Map json) {
//     return MediaModel(
//       photos: (json['photos'] as List).map((e) => e.toString()).toList(),
//       videos: (json['videos'] as List).map((e) => e.toString()).toList(),
//     );
//   }

//   Map<String, List<String>> toJson() {
//     return {
//       'photos': photos,
//       'videos': videos,
//     };
//   }

//   @override
//   String toString() => 'Media { photos: $photos, videos: $videos}';
// }
