import 'package:citizen_app/features/paht/data/models/business_hour_model.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/customer/domain/entities/promotion_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';

class PromotionModel extends PromotionEntity {
  PromotionModel({int id,
    String name,
    String imageUrl,
    String description,
    }) : super(
      id :id,
      name: name,
      description: description,
      imageUrl: imageUrl
      );

  factory PromotionModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);O
    return PromotionModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        imageUrl: json['imageUrl']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "imageUrl": imageUrl,
      "description": description
    };
  }

  @override
  String toString() => '';
}
