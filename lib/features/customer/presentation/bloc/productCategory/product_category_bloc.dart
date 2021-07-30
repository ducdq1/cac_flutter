import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/customer/data/models/product_category_model.dart';
import 'package:citizen_app/features/customer/domain/usecases/get_list_product_category.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'product_category_event.dart';
part 'product_category_state.dart';

class ProductCategoryBloc extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  final GetListProductCategory getListProductCategory;
  ProductCategoryBloc({@required this.getListProductCategory})
      : super(ProductCategoryInitial());

  @override
  Stream<ProductCategoryState> mapEventToState(
      ProductCategoryEvent event,
  ) async* {
    if (event is ListProductCategoriesFetching) {
      try {
        yield ProductCategoryLoading();
        List<ProductCategoryModel> listCategories =
            await getListProductCategory(event.type);
        yield ProductCategorySuccess(listCategories: listCategories);
      } catch (error) {
        print(error);
        yield ProductCategoryFailure(error: error.message);
      }
    }
  }
}
