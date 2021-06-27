import 'package:citizen_app/features/customer/domain/entities/promotion_entity.dart';

class PromotionModel extends PromotionEntity {
  PromotionModel({int id,
    String name,
    String imageUrl,
    String description,
    String numberSaleOff,
    }) : super(
      id :id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      numberSaleOff: numberSaleOff
      );

  factory PromotionModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);O
    return PromotionModel(
        id: json['id'],
        name: json['name'],
        description: json['description'] ?? null,
        imageUrl: json['imageUrl'] ?? null,
        numberSaleOff : json['numberSaleOff'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "imageUrl": imageUrl,
      "description": description,
      "numberSaleOff" : numberSaleOff
    };
  }

  @override
  String toString() => '';
}
