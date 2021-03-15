import 'package:citizen_app/features/home/domain/entities/entities.dart';

class AppFooterModel extends AppFooterEntity {
  AppFooterModel({
    int id,
    String name,
    String link,
    String image,
    String isActive,
  }) : super(id: id, name: name, link: link, image: image, isActive: isActive);

  @override
  List<Object> get props => [
        id,
        name,
        link,
        image,
        isActive,
      ];

  factory AppFooterModel.fromJson(Map<String, dynamic> json) {
    return AppFooterModel(
      id: json['id'] as num,
      name: json['name'].toString(),
      link: json['link'].toString(),
      image: json['image'].toString(),
      isActive: json['isActive'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'link': link,
      'image': image,
      'isActive': isActive,
    };
  }

  @override
  String toString() =>
      'App Footer { id: $id, name: $name, link: $link, image : $image }';
}
