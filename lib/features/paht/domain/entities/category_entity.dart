import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int type;
  final String name;
  final String nameEn;

  CategoryEntity({this.type, this.name, this.nameEn});

  @override
  List<Object> get props => [type, name, nameEn];
  Map<String, dynamic> toJson() {
    return {};
  }
}
