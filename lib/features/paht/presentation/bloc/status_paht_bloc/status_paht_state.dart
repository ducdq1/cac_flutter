part of 'status_paht_bloc.dart';

abstract class StatusPahtState extends Equatable {
  const StatusPahtState();

  @override
  List<Object> get props => [];
}

class StatusPahtInitial extends StatusPahtState {}

class StatusPahtLoading extends StatusPahtState {}

class StatusPahtFailure extends StatusPahtState {
  final dynamic error;

  StatusPahtFailure({@required this.error});
  @override
  String toString() => 'CategoryPahtFailure $error';
}

class StatusPahtSuccess extends StatusPahtState {
  final List<StatusModel> listStatus;

  StatusPahtSuccess({@required this.listStatus});
  @override
  String toString() => 'StatusPahtSuccess ${listStatus.length}';
}
