import 'package:equatable/equatable.dart';

class AppFooterEntity extends Equatable {
  final int id;
  final String name;
  final String link;
  final String image;
  final String isActive;

  AppFooterEntity({
    this.id,
    this.name,
    this.link,
    this.image,
    this.isActive,
  });

  @override
  List<Object> get props => [
        id,
        name,
        link,
        image,
        isActive,
      ];
  Map<String, dynamic> toJson() {
    return {};
  }
}
