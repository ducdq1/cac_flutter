import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:citizen_app/features/digital_map/data/models/filter_category_model.dart';
import 'package:citizen_app/features/digital_map/domain/usecases/get_list_filter_category.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'filter_category_event.dart';
part 'filter_category_state.dart';

class FilterCategoryBloc
    extends Bloc<FilterCategoryEvent, FilterCategoryState> {
  final GetListFilterCategoryUseCase getListFilterCategoryUseCase;
  FilterCategoryBloc({@required this.getListFilterCategoryUseCase})
      : super(FilterCategoryInitial());

  @override
  Stream<FilterCategoryState> mapEventToState(
    FilterCategoryEvent event,
  ) async* {
    if (event is ListFilterCategoryFetched) {
      yield FilterCategoryLoading();
      try {
        List<FilterCategoryModel> listFilterCategory = [
          new FilterCategoryModel(
              name: "Nhà hàng",
              nameEn: "Restaurant",
              type: 13,
              iconName: 'icon_filter_restaurant.png'),
          new FilterCategoryModel(
              name: "Khách sạn",
              nameEn: "Hotel",
              type: 14,
              iconName: 'icon_filter_hotel.png'),
          new FilterCategoryModel(
              name: "Quán cà phê",
              nameEn: "Coffee",
              type: 15,
              iconName: 'icon_filter_coffee.png'),
          new FilterCategoryModel(
              name: "ATM",
              nameEn: "ATM",
              type: 17,
              iconName: 'icon_filter_atm.png'),
          new FilterCategoryModel(
              name: "Trạm xăng",
              nameEn: "Gas",
              type: 13,
              iconName: 'icon_filter_gas.png'),
          new FilterCategoryModel(
              name: "Siêu thị",
              nameEn: "Supermarket",
              type: 19,
              iconName: 'icon_filter_supermarket.png'),
        ];
        // await getListFilterCategoryUseCase(NoParams());
        print('listFilterCategory ${listFilterCategory[0].name}');
        yield FilterCategorySuccess(listFilterCategory: listFilterCategory);
      } catch (error) {
        yield FilterCategoryFailure(error: error.message);
      }
    }
  }
}
