import 'package:citizen_app/features/customer/domain/entities/category_entity.dart';
import 'package:citizen_app/features/customer/domain/entities/promotion_entity.dart';

class ProductCategoryModel extends ProductCategoryEntity {
  ProductCategoryModel({int id,
    String name,
    String imageUrl,
    String description,
    int type,
    String code
    }) : super(
      id :id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      type: type,
      code : code
      );

  factory ProductCategoryModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);O
    return ProductCategoryModel(
        id: json['id'],
        name: json['name'],
        description: json['description'] !=null ? json['description'] : null,
        imageUrl: json['imageUrl'] !=null ? json['imageUrl'] : null,
        type: json['type'],
        code: json['code']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "imageUrl": imageUrl,
      "description": description,
      "type" : type,
      "code" : code
    };
  }

  @override
  String toString() => '';
}
