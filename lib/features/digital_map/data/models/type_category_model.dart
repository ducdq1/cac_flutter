import 'package:citizen_app/features/digital_map/data/models/filter_category_model.dart';
import 'package:citizen_app/features/digital_map/domain/entities/type_category.dart';
import 'package:meta/meta.dart';

class TypeCategoryModel extends TypeCategory {
  TypeCategoryModel({
    @required int id,
    @required String name,
    @required List<FilterCategoryModel> categories,
  }) : super(id: id, name: name, categories: categories);

  factory TypeCategoryModel.fromJson(Map json) {
    return TypeCategoryModel(
      id: json['id'] as num,
      name: json['name'].toString(),
      categories: (json['categories'] as List)
          .map((category) => FilterCategoryModel.fromJson(category))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categories': categories,
    };
  }
}
