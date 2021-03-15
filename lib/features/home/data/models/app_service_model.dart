import 'package:citizen_app/features/home/domain/entities/entities.dart';

class AppServiceModel extends AppServiceEntity {
  AppServiceModel({
    int id,
    String name,
    String icon,
    String serviceType,
    String isActive,
    String needRedirect,
    String redirectLink,
  }) : super(
            icon: icon,
            id: id,
            isActive: isActive,
            name: name,
            needRedirect: needRedirect,
            redirectLink: redirectLink,
            serviceType: serviceType);

  @override
  List<Object> get props => [
        id,
        name,
        icon,
        serviceType,
        isActive,
        needRedirect,
        redirectLink,
      ];

  factory AppServiceModel.fromJson(Map<String, dynamic> json) {
    return AppServiceModel(
      id: json['id'] as num,
      name: json['name'].toString(),
      icon: json['icon'].toString(),
      serviceType: json['serviceType'].toString(),
      isActive: json['isActive'].toString(),
      needRedirect: json['needRedirect'].toString(),
      redirectLink: json['redirectLink'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'serviceType': serviceType,
      'isActive': isActive,
      'needRedirect': needRedirect,
      'redirectLink': redirectLink,
    };
  }

  @override
  String toString() =>
      'App Service { id: $id, name: $name, serviceType: $serviceType,isActive : $isActive }';
}
