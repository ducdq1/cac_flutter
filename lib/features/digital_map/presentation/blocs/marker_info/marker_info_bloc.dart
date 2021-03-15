import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/digital_map/data/models/marker_info_model.dart';
import 'package:citizen_app/features/digital_map/domain/usecases/get_list_marker_info.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

part 'marker_info_event.dart';
part 'marker_info_state.dart';

class MarkerInfoBloc extends Bloc<MarkerInfoEvent, MarkerInfoState> {
  final GetListMarkerInfoUseCase getListMarkerInfoUseCase;
  MarkerInfoBloc({@required this.getListMarkerInfoUseCase})
      : super(MarkerInfoInitial());

  @override
  Stream<Transition<MarkerInfoEvent, MarkerInfoState>> transformEvents(
    Stream<MarkerInfoEvent> events,
    TransitionFunction<MarkerInfoEvent, MarkerInfoState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<MarkerInfoState> mapEventToState(
    MarkerInfoEvent event,
  ) async* {
    if (event is ListMarkerInfoFetched) {
      //if (!(currentState is MarkerInfoSuccess)) yield MarkerInfoLoading();
      try {
        yield MarkerInfoLoading();
        List<MarkerInfoModel> listMarkerInfoFetched =
            await getListMarkerInfoUseCase(MarkerInfoParams(
          query: event.query,
          proximity: event.proximity,
        ));
        //print(listMarkerInfoFetched);
        yield MarkerInfoSuccess(listMarkerInfo: listMarkerInfoFetched);
        return;
      } catch (error) {
        await Future.delayed(Duration(milliseconds: 200));
        yield MarkerInfoFailure(error: error.message);
      }
    }
    if (event is ListMarkerInfoClear) {
      yield MarkerInfoInitial();
    }
  }
}
