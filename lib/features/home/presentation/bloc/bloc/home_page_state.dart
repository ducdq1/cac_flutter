part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  final AppModuleModel appModules;
  const HomePageState({@required this.appModules});

  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageFailure extends HomePageState {
  final dynamic error;

  HomePageFailure({@required this.error});
  @override
  String toString() => 'HomePageFailure';
}

class HomePageSuccess extends HomePageState {
  final AppModuleModel appModules;

  HomePageSuccess({@required this.appModules});
  @override
  String toString() => 'HomePageSuccess';
}
