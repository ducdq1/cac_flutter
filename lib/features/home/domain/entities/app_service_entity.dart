import 'package:equatable/equatable.dart';

class AppServiceEntity extends Equatable {
  final int id;
  final String name;
  final String icon;
  final String serviceType;

  final String isActive;
  final String needRedirect;
  final String redirectLink;

  AppServiceEntity({
    this.id,
    this.name,
    this.icon,
    this.serviceType,
    this.isActive,
    this.needRedirect,
    this.redirectLink,
  });

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
  Map<String, dynamic> toJson() {
    return {};
  }
}
