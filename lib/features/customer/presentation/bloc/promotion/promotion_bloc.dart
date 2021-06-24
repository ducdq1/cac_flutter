import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/customer/data/models/promotion_model.dart';
import 'package:citizen_app/features/customer/domain/usecases/get_list_promotion.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'promotion_event.dart';

part 'promotion_state.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  final GetListPromotion getListPromotion;

  PromotionBloc({@required this.getListPromotion}) : super(PromotionInitial());

  @override
  Stream<PromotionState> mapEventToState(
    PromotionEvent event,
  ) async* {
    if (event is ListPromotionFetching) {
      try {
        yield PromotionLoading();
        List<PromotionModel> listCategories = await getListPromotion('');
        yield PromotionSuccess(listPromotion: listCategories);
      } catch (error) {
        print(error);
        yield PromotionFailure(error: error.message);
      }
    }
  }
}
