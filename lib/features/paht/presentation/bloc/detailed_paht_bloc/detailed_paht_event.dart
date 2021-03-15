part of 'detailed_paht_bloc.dart';

abstract class DetailedPahtEvent extends Equatable {
  const DetailedPahtEvent();

  @override
  List<Object> get props => [];
}

class DetailedPahtFetching extends DetailedPahtEvent {
  final String pahtId;

  DetailedPahtFetching({@required this.pahtId});

  @override
  List<Object> get props => [pahtId];

  @override
  String toString() =>
      'DetailedPahtFetched { pahtId: $pahtId}';
}
