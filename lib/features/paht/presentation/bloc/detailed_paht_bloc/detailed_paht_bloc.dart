import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
        await Future.delayed(Duration(milliseconds: 100));
        PahtModel paht =
            await getDetailedPaht(DetailedPahtParams(pahtId: event.pahtId));
        yield DetailedPahtSuccess(paht: paht);
      } catch (error) {
        print(error);
        yield DetailedPahtFailure(error: error.message);
      }
    }
  }
}
