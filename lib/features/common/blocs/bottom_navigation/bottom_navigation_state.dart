part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();

  @override
  List<Object> get props => [];
}

class BottomNavigationInitial extends BottomNavigationState {}

class PageLoading extends BottomNavigationState {
  @override
  String toString() => 'Page loading';
}

class CurrentIndexChanged extends BottomNavigationState {
  final int currentIndex;

  CurrentIndexChanged({@required this.currentIndex});

  @override
  String toString() => 'CurrentIndexChanged to $currentIndex';

  @override
  List<Object> get props => [currentIndex];
}

class FirstTabLoaded extends BottomNavigationState {
  @override
  String toString() => 'FirstTabLoaded';
}

class SecondTabLoaded extends BottomNavigationState {
  @override
  String toString() => 'SecondTabLoaded';
}
class Tab3Loaded extends BottomNavigationState {
  @override
  String toString() => 'Tab3Loaded';
}

class Tab4Loaded extends BottomNavigationState {
  @override
  String toString() => 'Tab4Loaded';
}
