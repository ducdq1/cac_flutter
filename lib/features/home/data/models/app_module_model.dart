import 'package:citizen_app/features/home/data/models/models.dart';
import 'package:citizen_app/features/home/domain/entities/entities.dart';

class AppModuleModel extends AppModuleEntity {
  AppModuleModel({
    List<AppHeaderModel> headers,
    List<AppServiceModel> services,
    List<AppFooterModel> footers,
    bool hasNotification,
  }) : super(
          headers: headers,
          services: services,
          footers: footers,
          hasNotification: hasNotification,
        );

  @override
  List<Object> get props => [
        headers,
        services,
        footers,
        hasNotification,
      ];

  factory AppModuleModel.fromJson(Map<String, dynamic> json) {
    return AppModuleModel(
        headers: (json['headers'] as List)
            .map((header) => AppHeaderModel.fromJson(header))
            .toList(),
        services: (json['services'] as List)
            .map((service) => AppServiceModel.fromJson(service))
            .toList(),
        footers: (json['footers'] as List)
            .map((footer) => AppFooterModel.fromJson(footer))
            .toList(),
        hasNotification: json['hasNotification'] as bool);
  }
  Map<String, dynamic> toJson() {
    return {
      'headers': headers,
      'services': services,
      'footers': footers,
      'hasNotification': hasNotification,
    };
  }

  @override
  String toString() => 'App module {}';
}
