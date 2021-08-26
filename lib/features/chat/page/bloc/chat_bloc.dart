import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/paht/data/repositories/paht_repository_impl.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:citizen_app/injection_container.dart';

import 'package:flutter/material.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc()
      : super(ChatInitState());

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ChatSentEvent) {
      try {
        await Future.delayed(Duration(milliseconds: 200));

        PahtRepositoryImpl repo = PahtRepositoryImpl(localDataSource: singleton(),
          networkInfo: singleton(),
          remoteDataSource: singleton(), );
        repo.updateProcessor(event.workerId, event.processor);
        yield ChatSentSuccessState();
      } catch (error) {

      }
    }


  }
}
