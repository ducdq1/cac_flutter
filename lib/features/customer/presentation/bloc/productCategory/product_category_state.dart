part of 'product_category_bloc.dart';

abstract class ProductCategoryState extends Equatable {
  const ProductCategoryState();

  @override
  List<Object> get props => [];
}

class ProductCategoryInitial extends ProductCategoryState {}

class ProductCategoryFailure extends ProductCategoryState {
  final dynamic error;

  ProductCategoryFailure({@required this.error});
  @override
  String toString() => 'ProductCategoryFailure $error';
}

class ProductCategorySuccess extends ProductCategoryState {
  final List<ProductCategoryModel> listCategories;

  ProductCategorySuccess({@required this.listCategories});
  @override
  String toString() => 'ProductCategory ${listCategories.length}';
}
