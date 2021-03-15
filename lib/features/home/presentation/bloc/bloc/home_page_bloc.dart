import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/home/data/models/models.dart';
import 'package:citizen_app/features/home/domain/usecases/app_module_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final GetListAppModulesUseCase getAppModulesUseCase;
  HomePageBloc({@required this.getAppModulesUseCase})
      : super(HomePageInitial());

  @override
  Stream<HomePageState> mapEventToState(
    HomePageEvent event,
  ) async* {
    if (event is AppModulesFetched) {
      yield HomePageLoading();
      try {
        // await Future.delayed(Duration(milliseconds: 200));
        final appModules = await getAppModulesUseCase(AppModuleParams(
            provinceId: event.provinceId, userId: event.userId));
        //print('listAppModules: $appModules');
        yield HomePageSuccess(appModules: appModules);
      } catch (error) {
        await Future.delayed(Duration(milliseconds: 200));
        yield HomePageFailure(error: error.message);
      }
    }
  }
}
