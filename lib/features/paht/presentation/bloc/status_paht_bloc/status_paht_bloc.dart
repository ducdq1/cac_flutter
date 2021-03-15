import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'status_paht_event.dart';
part 'status_paht_state.dart';

class StatusPahtBloc extends Bloc<StatusPahtEvent, StatusPahtState> {
  final GetListStatusPersonal getListStatusPersonal;
  final GetListStatusPublic getListStatusPublic;

  StatusPahtBloc(
      {@required this.getListStatusPublic,
      @required this.getListStatusPersonal})
      : super(StatusPahtInitial());

  @override
  Stream<StatusPahtState> mapEventToState(
    StatusPahtEvent event,
  ) async* {
    if (event is ListStatusPublicFetched) {
      yield StatusPahtLoading();
      try {
        List<StatusModel> listStatus = await getListStatusPublic(NoParams());
        yield StatusPahtSuccess(listStatus: listStatus);
      } catch (error) {
        yield StatusPahtFailure(error: error.message);
      }
    }
    if (event is ListStatusPersonalFetched) {
      yield StatusPahtLoading();
      try {
        List<StatusModel> listStatus = await getListStatusPersonal(NoParams());
        yield StatusPahtSuccess(listStatus: listStatus);
      } catch (error) {
        yield StatusPahtFailure(error: error.message);
      }
    }
  }
}
