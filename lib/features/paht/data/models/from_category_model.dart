import 'package:equatable/equatable.dart';

class FromCategoryModel extends FromCategoryEntity {
  FromCategoryModel({String name, String nameEn})
      : super(name: name,nameEn: nameEn);

  factory FromCategoryModel.fromJson(Map json) {
    return FromCategoryModel(
      name: json['name'],
      nameEn:  json['nameEn'],
    );
  }

  @override
  String toString() => 'FromCategoryModel { name: $name, nameEn: $nameEn}';
}

class FromCategoryEntity extends Equatable {
  String name;
  String nameEn;

  FromCategoryEntity({this.name, this.nameEn});

  @override
  List<Object> get props => [name, nameEn];

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "nameEn": nameEn
    };
  }
}
