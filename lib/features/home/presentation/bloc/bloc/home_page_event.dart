part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class AppModulesFetched extends HomePageEvent {
  final int provinceId;
  final int userId;

  AppModulesFetched({@required this.provinceId, this.userId});
  @override
  String toString() => 'AppModulesFetched';
}
