import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/search_product_model.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:citizen_app/features/paht/presentation/pages/paht_detail_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:citizen_app/core/resources/resources.dart';

part 'detailed_paht_event.dart';

part 'detailed_paht_state.dart';

class DetailedPahtBloc extends Bloc<DetailedPahtEvent, DetailedPahtState> {
  final GetDetailedPaht getDetailedPaht;

  DetailedPahtBloc({@required this.getDetailedPaht})
      : super(DetailedPahtInitial());

  @override
  Stream<DetailedPahtState> mapEventToState(
    DetailedPahtEvent event,
  ) async* {
    if (event is DetailedPahtFetching) {
      try {
        yield DetailedPahtLoading();
        await Future.delayed(Duration(milliseconds: 100));
        print('detail loading');
        int userType = pref.getInt('userType');
        String userName = pref.getString('userName');
        SearchProductModel paht = await getDetailedPaht(SearchProductParam(
            productCode: event.pahtId,
            isAgent: userType == 4,
            productId: event.productId,
            userName: userName,
            userType: userType));
        yield DetailedPahtSuccess(paht: null, searchProductModel: paht);
      } catch (error) {
        print(error);
        yield DetailedPahtFailure(error: error.message);
      }
    }
  }
}
