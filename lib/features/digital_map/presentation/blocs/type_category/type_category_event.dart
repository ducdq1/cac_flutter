part of 'type_category_bloc.dart';

abstract class TypeCategoryEvent extends Equatable {
  const TypeCategoryEvent();

  @override
  List<Object> get props => [];
}

class ListTypeCategoryFetched extends TypeCategoryEvent {
  ListTypeCategoryFetched();
  @override
  String toString() => 'FilterCategoryFetched';
}
