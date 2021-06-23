import 'package:citizen_app/features/customer/domain/entities/category_entity.dart';
import 'package:citizen_app/features/customer/domain/entities/promotion_entity.dart';

class ProductCategoryModel extends ProductCategoryEntity {
  ProductCategoryModel({int id,
    String name,
    String imageUrl,
    String description,
    }) : super(
      id :id,
      name: name,
      description: description,
      imageUrl: imageUrl
      );

  factory ProductCategoryModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);O
    return ProductCategoryModel(
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
