import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

part 'personal_paht_event.dart';

part 'personal_paht_state.dart';

class PersonalPahtBloc extends Bloc<PersonalPahtEvent, PersonalPahtState> {
  final GetListPersonalPaht getListPersonalPaht;
  final DeletePaht deletePaht;

  PersonalPahtBloc(
      {@required this.getListPersonalPaht, @required this.deletePaht})
      : super(PersonalPahtInitial());

  bool _hasReachedMax(PersonalPahtState state) =>
      state is PersonalPahtSuccess && state.hasReachedMax;

  // @override
  // Stream<Transition<PersonalPahtEvent, PersonalPahtState>> transformEvents(
  //     Stream<PersonalPahtEvent> events,
  //     TransitionFunction<PersonalPahtEvent, PersonalPahtState> transitionFn,
  //     ) {
  //   return super.transformEvents(
  //     events.distinct(),
  //     transitionFn,
  //   );
  // }

  @override
  Stream<PersonalPahtState> mapEventToState(
    PersonalPahtEvent event,
  ) async* {
    final currentState = state;

    if (event is SearchPersonalButtonPressedEvent) {
      yield PersonalPahtLoading();

      List<PahtModel> listPublicPaht = await getListPersonalPaht(PahtParams(
          limit: 10,
          offset: 0,
          search: event.search,
          status: 1));

      yield PersonalPahtSuccess(
          paht: listPublicPaht,
          offset: 0,
          hasReachedMax: listPublicPaht.length < 10 ? true : false);
      return;
    }

    if (event is FilterPersonalButtonPressedEvent) {
      yield PersonalPahtLoading();
      List<PahtModel> listPublicPaht = await getListPersonalPaht(PahtParams(
          limit: 10,
          offset: 0,
          search: event.search != null ? '=${event.search}' : '=',
          status: 1
           ));
      yield PersonalPahtSuccess(
          paht: listPublicPaht,
          offset: 0,
          hasReachedMax: listPublicPaht.length < 10 ? true : false);
      return;
    }

    if (event is ListPersonalPahtFetchedEvent) {
      if (event.error != null) {
        yield PersonalPahtFailure(error: event.error);
        return;
      }

      yield PersonalPahtSuccess(
          paht: event.paht,
          offset: event.offset,
          hasReachedMax: event.paht.length < 10 ? true : false,
          error: event.error);
      return;
    }

    if (event is ListPersonalPahtFetchingEvent) {
      if (currentState is PersonalPahtInitial ||
          currentState is PersonalPahtFailure) {
        yield PersonalPahtLoading();
      }

      try {
        if (currentState is PersonalPahtFailure || currentState is PersonalPahtInitial &&
                !_hasReachedMax(
                    currentState) //||state is PersonalPahtLoading && !_hasReachedMax(currentState)
            ) {
          await Future.delayed(Duration(milliseconds: 500));

          getListPersonalPaht(PahtParams(
                  limit: 10,
                  offset: 0,
                  search: event.search != null ? '=${event.search}' : '=',
                  status: 1))
              .then((value) {
            add(ListPersonalPahtFetchedEvent(offset: 1, paht: value));
            return;
          }).catchError((error) {
            add(ListPersonalPahtFetchedEvent(
                offset: 0, paht: [], error: error.message));
          });
        } else if (currentState is PersonalPahtSuccess &&
            !_hasReachedMax(currentState)) {
          int nextOffset = currentState.offset + 1;
          print('nextOffset ' + nextOffset.toString());
          // yield PersonalPahtLoadmore();
          yield PersonalPahtLoadmore(
            paht: currentState.paht,
            offset: currentState.offset,
            hasReachedMax: false,
          );

          List<PahtModel> listPersonalPaht = await getListPersonalPaht(
              PahtParams(
                  limit: 10,
                  offset: nextOffset,
                  search: event.search != null ? '=${event.search}' : '=',
                  status: 1));

          print(" yield PersonalPahtSuccess...");

          yield listPersonalPaht.isEmpty
              ? currentState.copyWith(
                  hasReachedMax: true, offset: currentState.offset)
              : PersonalPahtSuccess(
                  paht: currentState.paht + listPersonalPaht,
                  offset: nextOffset,
                  hasReachedMax: listPersonalPaht.isNotEmpty &&
                          listPersonalPaht.length == 10
                      ? false
                      : true,
                );

          return;
        } else {
          if (currentState is PersonalPahtSuccess) {
            yield PersonalPahtSuccess(
              paht: currentState.paht,
              offset: currentState.offset,
              hasReachedMax: true,
            );
          }
          return;
        }
      } catch (error) {
        if (currentState is PersonalPahtSuccess) {
          yield PersonalPahtSuccess(
            paht: currentState.paht,
            offset: currentState.offset,
            hasReachedMax: true,
          );
        } else if (currentState is PersonalPahtRefreshSuccess) {
          yield PersonalPahtSuccess(
            paht: currentState.paht,
            offset: currentState.offset,
            hasReachedMax: true,
          );
        } else
          yield PersonalPahtFailure(error: error.message);
      }
    }
    if (event is PersonalPahtRefreshRequestedEvent) {
      if (event.type == 1) {
        yield PersonalPahtLoading();
      }
      try {
        List<PahtModel> listPersonalPaht = await getListPersonalPaht(PahtParams(
            limit: 10,
            offset: 0,
            search: event.search != null ? '=${event.search}' : '=',
           status: 1));

        yield PersonalPahtRefreshSuccess(
            paht: listPersonalPaht,
            offset:0,
            hasReachedMax: listPersonalPaht.length < 10 ? true : false);
        yield PersonalPahtSuccess(
            paht: listPersonalPaht,
            offset: 0,
            hasReachedMax: listPersonalPaht.length < 10 ? true : false);
        return;
      } catch (error) {
        if (currentState is PersonalPahtSuccess) {
          yield PersonalPahtSuccess(
              paht: currentState.paht,
              offset: currentState.offset,
              hasReachedMax: true,
              error: error.message);
        } else if (currentState is PersonalPahtRefreshSuccess) {
          yield PersonalPahtSuccess(
              paht: currentState.paht,
              offset: currentState.offset,
              hasReachedMax: true,
              error: error.message);
        } else {
          yield PersonalPahtFailure(error: error.message);
        }
      }
    }
    if (event is DeleteButtonPressedEvent) {
      try {
        await deletePaht(event.id);
        yield DeletePersonalPahtSuccess();
        List<PahtModel> results = await getListPersonalPaht(PahtParams(
            offset: 0,
            limit: 10,
            status: 1,
            search: ''));

        yield PersonalPahtSuccess(
            paht: results, hasReachedMax: results.length < 10 ? true : false);
      } catch (error) {
        yield DeletePersonalPahtFailure(error: error);
      }
    }
  }
}
