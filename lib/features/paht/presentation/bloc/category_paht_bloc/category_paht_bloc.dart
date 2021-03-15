import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'category_paht_event.dart';
part 'category_paht_state.dart';

class CategoryPahtBloc extends Bloc<CategoryPahtEvent, CategoryPahtState> {
  final GetListCategoriesPaht getListCategoriesPaht;
  CategoryPahtBloc({@required this.getListCategoriesPaht})
      : super(CategoryPahtInitial());

  @override
  Stream<CategoryPahtState> mapEventToState(
    CategoryPahtEvent event,
  ) async* {
    if (event is ListCategoriesFetched) {
      print('====================== ListCategoriesFetched:');
      try {
        List<CategoryModel> listCategories =
            await getListCategoriesPaht(NoParams());
        yield CategoryPahtSuccess(listCategories: listCategories);
      } catch (error) {
        print(error);
        yield CategoryPahtFailure(error: error.message);
      }
    }
  }
}
