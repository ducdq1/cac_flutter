part of 'status_paht_bloc.dart';

abstract class StatusPahtEvent extends Equatable {
  const StatusPahtEvent();

  @override
  List<Object> get props => [];
}

class ListStatusPublicFetched extends StatusPahtEvent {}

class ListStatusPersonalFetched extends StatusPahtEvent {}
