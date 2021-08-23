import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class   NotificationBloc
    extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial());
  int currentIndex = 0;

  @override
  Stream<NotificationState> mapEventToState(
      NotificationEvent event,
  ) async* {
    if(event is NotificationEvent){
      yield  NotificationInitial();
      print('NotificationChange');
      Future.delayed(Duration(milliseconds: 300));
      //yield PageLoading();
      yield NotificationChange(event.value);
      // yield NotificationChanged(event.value);
    }

  }
}
