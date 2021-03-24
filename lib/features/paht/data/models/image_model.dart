import 'package:citizen_app/features/paht/data/models/business_hour_model.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/domain/entities/image_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/paht_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:citizen_app/features/paht/domain/entities/product_entity.dart';

class ImageModel extends ImageEntity {
  ImageModel({int attachId, String path,String name})
      : super(attachId: attachId, path: path,name: name);

  factory ImageModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);
    return ImageModel(
      attachId: json['attachId'],
      path: json['attachPath'].toString().endsWith("/") ? json['attachPath'] : json['attachPath'].toString() +"_",
      name: json['attachName'] ,
    );
  }
}
