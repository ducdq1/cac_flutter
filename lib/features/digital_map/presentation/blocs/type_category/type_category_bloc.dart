import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/digital_map/data/models/filter_category_model.dart';
import 'package:citizen_app/features/digital_map/data/models/type_category_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'type_category_event.dart';
part 'type_category_state.dart';

class TypeCategoryBloc extends Bloc<TypeCategoryEvent, TypeCategoryState> {
  // final GetListTypeCategoryUseCase getListTypeCategoryUseCase;
  // TypeCategoryBloc({@required this.getListTypeCategoryUseCase})
  TypeCategoryBloc() : super(TypeCategoryInitial());

  @override
  Stream<TypeCategoryState> mapEventToState(
    TypeCategoryEvent event,
  ) async* {
    if (event is ListTypeCategoryFetched) {
      yield TypeCategoryLoading();
      await Future.delayed(Duration(milliseconds: 300));
      try {
        List<FilterCategoryModel> atcate = [
          new FilterCategoryModel(
              name: "Nhà hàng",
              nameEn: "Restaurant",
              iconName:
                  "https://files.viettelmaps.vn/images/icon/icon_restaurant.png",
              type: 13),
          new FilterCategoryModel(
              name: "Khách sạn",
              nameEn: "Hotel",
              iconName:
                  "https://files.viettelmaps.vn/images/icon/icon_hotel.png",
              type: 15),
          new FilterCategoryModel(
              name: "Quán cà phê",
              nameEn: "Coffee",
              iconName:
                  "https://files.viettelmaps.vn/images/icon/icon_cafe.png",
              type: 16),
        ];
        List<TypeCategoryModel> listTypeCategory = [
          new TypeCategoryModel(id: 1, name: "Ẩm thực", categories: atcate),
          new TypeCategoryModel(id: 2, name: "Giải trí", categories: atcate),
          new TypeCategoryModel(id: 3, name: "Mua sắm", categories: atcate),
          new TypeCategoryModel(id: 4, name: "Dịch vụ", categories: atcate),
        ];
        // await getListTypeCategoryUseCase(NoParams());
        // print('listTypeCategory ${listTypeCategory[0].name}');

        yield TypeCategorySuccess(listTypeCategory: listTypeCategory);
      } catch (error) {
        yield TypeCategoryFailure(error: error.message);
      }
    }
  }
}
