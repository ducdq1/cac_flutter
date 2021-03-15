import 'package:citizen_app/features/home/domain/entities/entities.dart';

class AppHeaderModel extends AppHeaderEntity {
  AppHeaderModel({
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

  factory AppHeaderModel.fromJson(Map<String, dynamic> json) {
    return AppHeaderModel(
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
      'App Header { id: $id, name: $name, link: $link, image : $image }';
}
