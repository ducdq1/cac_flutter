import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/media_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/place_images_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:equatable/equatable.dart';

class ProductCategoryEntity extends Equatable {
  int id;
  String name;
  String description;
  String imageUrl;

  ProductCategoryEntity({this.id, this.name, this.description, this.imageUrl});

  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
