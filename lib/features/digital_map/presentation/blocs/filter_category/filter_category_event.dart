part of 'filter_category_bloc.dart';

abstract class FilterCategoryEvent extends Equatable {
  const FilterCategoryEvent();

  @override
  List<Object> get props => [];
}

class ListFilterCategoryFetched extends FilterCategoryEvent {
  ListFilterCategoryFetched();
  @override
  String toString() => 'FilterCategoryFetched';
}
