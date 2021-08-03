part of 'detailed_paht_bloc.dart';

abstract class DetailedPahtEvent extends Equatable {
  const DetailedPahtEvent();

  @override
  List<Object> get props => [];
}

class DetailedPahtFetching extends DetailedPahtEvent {
  final String pahtId;
  final int productId;
  DetailedPahtFetching({@required this.pahtId,this.productId});

  @override
  List<Object> get props => [pahtId];

  @override
  String toString() =>
      'DetailedPahtFetched { pahtId: $pahtId}';
}
