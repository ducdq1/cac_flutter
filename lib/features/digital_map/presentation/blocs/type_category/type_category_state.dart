part of 'type_category_bloc.dart';

abstract class TypeCategoryState extends Equatable {
  const TypeCategoryState();

  @override
  List<Object> get props => [];
}

class TypeCategoryInitial extends TypeCategoryState {}

class TypeCategoryLoading extends TypeCategoryState {}

class TypeCategoryFailure extends TypeCategoryState {
  final dynamic error;

  TypeCategoryFailure({@required this.error});
  @override
  String toString() => 'TypeCategoryPageFailure';
}

class TypeCategorySuccess extends TypeCategoryState {
  final List<TypeCategoryModel> listTypeCategory;

  TypeCategorySuccess({@required this.listTypeCategory});
  @override
  String toString() => 'TypeCategoryPageSuccess';
}
