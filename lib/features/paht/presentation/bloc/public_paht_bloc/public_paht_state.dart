part of 'public_paht_bloc.dart';

abstract class PublicPahtState extends Equatable {
  const PublicPahtState();

  @override
  List<Object> get props => [];
}

class PublicPahtInitial extends PublicPahtState {}

class PublicPahtLoading extends PublicPahtState {}

class SearchProductSuccess extends PublicPahtState {
  final List<ProductModel> lstProduct;
  final bool hasReachedMax;
  final int offset;
  final String error;

  SearchProductSuccess(
      {@required this.lstProduct, this.hasReachedMax, this.offset, this.error});
}
class SearchProducttFailure extends PublicPahtState {
  final dynamic error;

  SearchProducttFailure({@required this.error});
  @override
  String toString() => 'PublicPahtFailure';
}

class PublicPahtSuccess extends PublicPahtState {
  final List<PahtModel> paht;
  final bool hasReachedMax;
  final int offset;
  final String error;
  PublicPahtSuccess(
      {@required this.paht, this.hasReachedMax, this.offset, this.error});

  PublicPahtSuccess copyWith(
      {List<PahtModel> paht, bool hasReachedMax, int offset}) {
    return PublicPahtSuccess(
        paht: paht ?? this.paht,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        offset: offset);
  }

  @override
  List<Object> get props => [paht, offset, hasReachedMax];
  @override
  String toString() => 'PublicPahtSuccess';
}

class PublicPahtFailure extends PublicPahtState {
  final dynamic error;

  PublicPahtFailure({@required this.error});
  @override
  String toString() => 'PublicPahtFailure';
}

class PublicPahtRefreshSuccess extends PublicPahtState {
  final List<PahtModel> paht;
  final bool hasReachedMax;
  final int offset;
  final int limit;

  const PublicPahtRefreshSuccess(
      {this.paht, this.hasReachedMax, this.offset, this.limit});

  PublicPahtRefreshSuccess copyWith(
      {List<PahtModel> warnings, bool hasReachedMax, int offset}) {
    return PublicPahtRefreshSuccess(
        paht: warnings ?? this.paht,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        offset: offset,
        limit: limit);
  }

  @override
  List<Object> get props => [paht, offset, hasReachedMax];

  @override
  String toString() =>
      'PublicPahtRefreshSuccess { paht: ${paht.length}, offset: $offset, hasReachedMax: $hasReachedMax }';
}

class FilterPublicPahtSuccess extends PublicPahtState {}

class SearchPublicPahtSuccess extends PublicPahtState {}
class DeletePersonalPahtSuccess extends PublicPahtState {}

class DeletePersonalPahtFailure extends PublicPahtState {
  final dynamic error;

  DeletePersonalPahtFailure({this.error});
  @override
  String toString() => error.toString();
}
