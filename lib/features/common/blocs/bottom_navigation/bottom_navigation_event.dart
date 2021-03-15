part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class TabStarted extends BottomNavigationEvent {
  @override
  String toString() => "TabStarted";
}

class TabTapped extends BottomNavigationEvent {
  final int index;

  const TabTapped({@required this.index});

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'TabTapped: $index';
}
