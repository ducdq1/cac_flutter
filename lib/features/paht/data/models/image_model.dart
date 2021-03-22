import 'package:citizen_app/features/paht/data/models/business_hour_model.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/domain/entities/image_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/paht_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:citizen_app/features/paht/domain/entities/product_entity.dart';

class ImageModel extends ImageEntity {
  ImageModel({int attachId, String path})
      : super(attachId: attachId, path: path);

  factory ImageModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);
    return ImageModel(
      attachId: json['attachId'],
      path: json['path'],
    );
  }
}
