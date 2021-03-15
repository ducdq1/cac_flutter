import 'package:citizen_app/features/digital_map/domain/entities/filter_category.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class TypeCategory extends Equatable {
  final int id;
  final String name;
  final List<FilterCategory> categories;

  TypeCategory({
    @required this.id,
    @required this.name,
    @required this.categories,
  });

  @override
  List<Object> get props => [
        id,
        name,
        categories,
      ];
}
