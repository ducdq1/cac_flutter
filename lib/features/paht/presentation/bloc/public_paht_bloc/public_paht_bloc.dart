import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'public_paht_event.dart';
part 'public_paht_state.dart';

class PublicPahtBloc extends Bloc<PublicPahtEvent, PublicPahtState> {
  final GetListPublicPaht getListPublicPaht;
  final DeletePaht deletePaht;
  PublicPahtBloc({@required this.getListPublicPaht, @required this.deletePaht})
      : super(PublicPahtInitial());
  bool _hasReachedMax(PublicPahtState state) =>
      state is PublicPahtSuccess && state.hasReachedMax;

  // @override
  // Stream<Transition<PublicPahtEvent, PublicPahtState>> transformEvents(
  //     Stream<PublicPahtEvent> events,
  //     TransitionFunction<PublicPahtEvent, PublicPahtState> transitionFn,
  //     ) {
  //   return super.transformEvents(
  //     events.distinct(),
  //     transitionFn,
  //   );
  // }

  @override
  Stream<PublicPahtState> mapEventToState(
    PublicPahtEvent event,
  ) async* {
    final currentState = state;

    if (event is SearchPublicButtonPressedEvent) {
      yield PublicPahtLoading();
      String categories = '=';
      String status = '=0';

      List<PahtModel> listPublicPaht = await getListPublicPaht(PahtParams(
          limit: 10,
          offset: 1,
          search: event.search != null ? '=${event.search}' : '=',
          categoryIds: categories,
          statusIds: status));
      yield PublicPahtSuccess(
          paht: listPublicPaht, offset: 1, hasReachedMax: true);
      return;
    }
    if (event is FilterPublicButtonPressedEvent) {
      yield PublicPahtLoading();
      String categories = '=';
      String status = '=';
      if (event.categoryIds != null) {
        for (int i = 0; i < event.categoryIds.length; i++) {
          if (i != 0) {
            categories += ',' + event.categoryIds[i];
          } else {
            categories += event.categoryIds[i];
          }
        }
      }
      if (event.statusIds != null) {
        for (int i = 0; i < event.statusIds.length; i++) {
          if (i != 0) {
            status += ',' + event.statusIds[i];
          } else {
            status += event.statusIds[i];
          }
        }
      }
      List<PahtModel> listPublicPaht = await getListPublicPaht(PahtParams(
          limit: 10,
          offset: 1,
          search: event.search != null ? '=${event.search}' : '=',
          categoryIds: event.categoryIds == null ? '' : categories,
          statusIds: event.statusIds == null ? '' : status));
      yield PublicPahtSuccess(
        paht: listPublicPaht,
        offset: 1,
        hasReachedMax: true,
      );
      return;
    }
    if (event is ListPublicPahtFetchedEvent) {
      if (event.error != null) {
        yield PublicPahtFailure(error: event.error);
        return;
      }

      yield PublicPahtSuccess(
          paht: event.paht,
          offset: event.offset,
          hasReachedMax: event.paht.length < 10 ? true : false,
          error: event.error);
      return;
    }
    if (event is ListPublicPahtFetchingEvent) {
      if (currentState is PublicPahtFailure ||
          currentState is PublicPahtSuccess && (currentState.paht == null)) {
        yield PublicPahtLoading();
      }

      String categories = '=';
      String status = '=';
      if (event.categoryIds != null) {
        for (int i = 0; i < event.categoryIds.length; i++) {
          if (i != 0) {
            categories += ',' + event.categoryIds[i];
          } else {
            categories += event.categoryIds[i];
          }
        }
      }
      if (event.statusIds != null) {
        for (int i = 0; i < event.statusIds.length; i++) {
          if (i != 0) {
            status += ',' + event.statusIds[i];
          } else {
            status += event.statusIds[i];
          }
        }
      }

      try {
        if (currentState is PublicPahtFailure || currentState is PublicPahtInitial &&
            !_hasReachedMax(currentState)) {
          //await Future.delayed(Duration(milliseconds: 2000));
          getListPublicPaht(PahtParams(
              limit: 10,
              offset: 1,
              search: event.search != null ? '=${event.search}' : '=',
              categoryIds: event.categoryIds == null ? '' : categories,
              statusIds: event.statusIds == null ? '' : status)).then((value) {
            add(ListPublicPahtFetchedEvent(offset: 1,paht: value));
          }).catchError((err) {
            add(ListPublicPahtFetchedEvent(offset: 1,paht: [],error: err.message));
          });
        } else if (currentState is PublicPahtSuccess &&
            !_hasReachedMax(currentState)) {
          int nextOffset = currentState.offset + 1;
          List<PahtModel> listPublicPaht = await getListPublicPaht(PahtParams(
              limit: 10,
              offset: nextOffset,
              search: event.search != null ? '=${event.search}' : '=',
              categoryIds: event.categoryIds == null ? '' : categories,
              statusIds: event.statusIds == null ? '' : status));

          yield listPublicPaht.isEmpty
              ? currentState.copyWith(
                  hasReachedMax: true, offset: currentState.offset)
              : PublicPahtSuccess(
                  paht: currentState.paht + listPublicPaht,
                  offset: nextOffset,
                  hasReachedMax:
                      listPublicPaht.isNotEmpty && listPublicPaht.length == 10
                          ? false
                          : true,
                );
        } else {
          if (currentState is PublicPahtSuccess &&
              _hasReachedMax(currentState)) {
            yield PublicPahtSuccess(
              paht: currentState.paht,
              offset: currentState.offset,
              hasReachedMax: true,
            );
            return;
          }
        }
      } catch (error) {
        if (currentState is PublicPahtSuccess) {
          yield PublicPahtSuccess(
            paht: currentState.paht,
            offset: currentState.offset,
            hasReachedMax: true,
          );
        } else if (currentState is PublicPahtRefreshSuccess) {
          yield PublicPahtSuccess(
            paht: currentState.paht,
            offset: currentState.offset,
            hasReachedMax: true,
          );
        } else
          yield PublicPahtFailure(error: error.message);
      }
    }
    if (event is PublicPahtRefreshRequestedEvent) {
      if (event.type == 1) {
        yield PublicPahtLoading();
      }
      String categories = '=';
      String status = '=';
      if (event.categoryIds != null) {
        for (int i = 0; i < event.categoryIds.length; i++) {
          if (i != 0) {
            categories += ',' + event.categoryIds[i];
          } else {
            categories += event.categoryIds[i];
          }
        }
      }
      if (event.statusIds != null) {
        for (int i = 0; i < event.statusIds.length; i++) {
          if (i != 0) {
            status += ',' + event.statusIds[i];
          } else {
            status += event.statusIds[i];
          }
        }
      }
      try {
        List<PahtModel> listPublicPaht = await getListPublicPaht(PahtParams(
            limit: 10,
            offset: 1,
            search: event.search != null ? '=${event.search}' : '=',
            categoryIds: event.categoryIds == null ? '' : categories,
            statusIds: event.statusIds == null ? '' : status));

        yield PublicPahtRefreshSuccess(
            paht: listPublicPaht,
            offset: 1,
            hasReachedMax: listPublicPaht.length < 10 ? true : false);
        yield PublicPahtSuccess(
            paht: listPublicPaht,
            offset: 1,
            hasReachedMax: listPublicPaht.length < 10 ? true : false);
        return;
      } catch (error) {
        if (currentState is PublicPahtSuccess) {
          yield PublicPahtSuccess(
              paht: currentState.paht,
              offset: currentState.offset,
              hasReachedMax: true,
              error: error.message);
        } else if (currentState is PublicPahtRefreshSuccess) {
          yield PublicPahtSuccess(
              paht: currentState.paht,
              offset: currentState.offset,
              hasReachedMax: true,
              error: error.message);
        } else {
          print(error);
          yield PublicPahtFailure(error: error.message);
        }
      }
    }

    if (event is DeleteButtonEvent) {
      try {
        await deletePaht(event.id);
        yield DeletePersonalPahtSuccess();
        List<PahtModel> results = await getListPublicPaht(PahtParams(
            offset: 1,
            limit: 10,
            categoryIds: '',
            search: '',
            statusIds: '=0'));

        yield PublicPahtSuccess(
            offset: 1,
            paht: results,
            hasReachedMax: results.length < 10 ? true : false);
      } catch (error) {
        yield DeletePersonalPahtFailure(error: error);
      }
    }

    if (event is ReloadListEvent) {
      try {
        yield DeletePersonalPahtSuccess();
        List<PahtModel> results = await getListPublicPaht(PahtParams(
            offset: 1,
            limit: 10,
            categoryIds: '',
            search: '',
            statusIds: '=0'));

        yield PublicPahtSuccess(
            offset: 1,
            paht: results,
            hasReachedMax: results.length < 10 ? true : false);
      } catch (error) {
        yield DeletePersonalPahtFailure(error: error);
      }
    }
  }
}
