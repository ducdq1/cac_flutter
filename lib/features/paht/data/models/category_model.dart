import 'package:citizen_app/features/paht/domain/entities/entities.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({int type, String name, String nameEn})
      : super(type: type, name: name, nameEn: nameEn);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      type: json['type'],
      name: json['name'],
      nameEn: json['nameEn'],
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {'type': type, 'categoryName': name, 'nameEn': nameEn};
  }

  @override
  String toString() => 'Category { type: $type, categoryName: $name}';
}
