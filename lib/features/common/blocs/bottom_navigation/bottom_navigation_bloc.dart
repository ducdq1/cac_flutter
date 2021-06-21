import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(BottomNavigationInitial());
  int currentIndex = 0;

  @override
  Stream<BottomNavigationState> mapEventToState(
    BottomNavigationEvent event,
  ) async* {
    if (event is TabStarted) {
      this.add(TabTapped(index: this.currentIndex));
    }
    if (event is TabTapped) {
      this.currentIndex = event.index;
      yield CurrentIndexChanged(currentIndex: this.currentIndex);
      yield PageLoading();

      if (this.currentIndex == 0) {
        yield FirstTabLoaded();
      }
      if (this.currentIndex == 1) {
        yield SecondTabLoaded();
      }
      if(this.currentIndex == 2){
        yield Tab3Loaded();
      }
      if(this.currentIndex == 3){
        yield Tab4Loaded();
      }
    }
  }
}
