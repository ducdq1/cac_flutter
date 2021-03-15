import 'package:citizen_app/features/home/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class AppModuleEntity extends Equatable {
  final List<AppHeaderEntity> headers;
  final List<AppServiceEntity> services;
  final List<AppFooterEntity> footers;
  final bool hasNotification;

  AppModuleEntity({
    this.headers,
    this.services,
    this.footers,
    this.hasNotification,
  });

  @override
  List<Object> get props => [
        headers,
        services,
        footers,
        hasNotification
      ];
  Map<String, dynamic> toJson() {
    return {};
  }
}
