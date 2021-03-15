import 'package:citizen_app/features/digital_map/domain/entities/filter_category.dart';
import 'package:meta/meta.dart';

class FilterCategoryModel extends FilterCategory {
  FilterCategoryModel({
    @required String name,
    @required String nameEn,
    @required String iconName,
    @required int type,
  }) : super(name: name, nameEn: nameEn, iconName: iconName, type: type);

  factory FilterCategoryModel.fromJson(Map json) {
    return FilterCategoryModel(
      name: json['name'].toString(),
      nameEn: json['nameEn'].toString(),
      iconName: json['iconName'].toString(),
      type: json['type'] as num,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'nameEn': nameEn, 'iconName': iconName, 'type': type};
  }
}
