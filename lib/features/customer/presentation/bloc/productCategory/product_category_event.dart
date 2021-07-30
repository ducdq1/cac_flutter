part of 'product_category_bloc.dart';

abstract class ProductCategoryEvent extends Equatable {
  const ProductCategoryEvent();

  @override
  List<Object> get props => [];
}

class ListProductCategoriesFetching extends ProductCategoryEvent {
  final int type;
  ListProductCategoriesFetching({ @required this.type});
}
