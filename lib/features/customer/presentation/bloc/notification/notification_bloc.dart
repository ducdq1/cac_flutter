import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/paht/data/repositories/paht_repository_impl.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../injection_container.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class   NotificationBloc
    extends Bloc<BaseNotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial());
  int currentIndex = 0;

  @override
  Stream<NotificationState> mapEventToState(
      BaseNotificationEvent event,
  ) async* {
    if(event is NotificationEvent){
      yield  NotificationInitial();
      print('NotificationChange');
      Future.delayed(Duration(milliseconds: 300));
      //yield PageLoading();
      yield NotificationChange(event.value);
      // yield NotificationChanged(event.value);
    }
    if(event is LoginEvent) {
      PahtRepositoryImpl repo = PahtRepositoryImpl(localDataSource: singleton(),
        networkInfo: singleton(),
        remoteDataSource: singleton(),);
      repo.updateLastLogin(event.id);
    }

  }
}
