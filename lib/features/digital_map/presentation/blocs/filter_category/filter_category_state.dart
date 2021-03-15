part of 'filter_category_bloc.dart';

abstract class FilterCategoryState extends Equatable {
  const FilterCategoryState();

  @override
  List<Object> get props => [];
}

class FilterCategoryInitial extends FilterCategoryState {}

class FilterCategoryLoading extends FilterCategoryState {}

class FilterCategoryFailure extends FilterCategoryState {
  final dynamic error;

  FilterCategoryFailure({@required this.error});
  @override
  String toString() => 'FilterCategoryPageFailure';
}

class FilterCategorySuccess extends FilterCategoryState {
  final List<FilterCategoryModel> listFilterCategory;

  FilterCategorySuccess({@required this.listFilterCategory});
  @override
  String toString() => 'FilterCategoryPageSuccess';
}
