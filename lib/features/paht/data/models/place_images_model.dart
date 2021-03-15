import 'package:citizen_app/features/paht/domain/entities/place_images_entity.dart';

class PlaceImagesModel extends PlaceImagesEntity {
  PlaceImagesModel({String imageUrl, String imageThumbUrl, int id, int approveStatus})
      : super(imageUrl: imageUrl, imageThumbUrl: imageThumbUrl,id:id,approveStatus: approveStatus);

  factory PlaceImagesModel.fromJson(Map json) {
    return PlaceImagesModel(
      imageUrl: json['imageUrl'],
      imageThumbUrl:  json['imageThumbUrl'],
      id:  json['id'],
      approveStatus:  json['approveStatus'],
    );
  }

  @override
  String toString() => '';
}
