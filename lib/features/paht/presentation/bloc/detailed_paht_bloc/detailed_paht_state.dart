part of 'detailed_paht_bloc.dart';

abstract class DetailedPahtState extends Equatable {
  const DetailedPahtState();

  @override
  List<Object> get props => [];
}

class DetailedPahtInitial extends DetailedPahtState {}

class DetailedPahtLoading extends DetailedPahtState {}

class DetailedPahtSuccess extends DetailedPahtState {
  final PahtModel paht;
  SearchProductModel searchProductModel;
  DetailedPahtSuccess({@required this.paht,this.searchProductModel});
}

class DetailedPahtFailure extends DetailedPahtState {
  final dynamic error;

  DetailedPahtFailure({@required this.error});
}
