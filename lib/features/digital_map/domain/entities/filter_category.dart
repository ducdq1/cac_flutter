import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class FilterCategory extends Equatable {
  final String name;
  final String nameEn;
  final String iconName;
  final int type;

  FilterCategory({
    @required this.name,
    @required this.nameEn,
    @required this.iconName,
    @required this.type,
  });

  @override
  List<Object> get props => [
        name,
        nameEn,
        iconName,
        type,
      ];
}
