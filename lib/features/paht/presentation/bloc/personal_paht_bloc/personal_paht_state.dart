part of 'personal_paht_bloc.dart';

abstract class PersonalPahtState extends Equatable {
  const PersonalPahtState();

  @override
  List<Object> get props => [];
}

class PersonalPahtInitial extends PersonalPahtState {}

class PersonalPahtLoading extends PersonalPahtState {}

class PersonalPahtSuccess extends PersonalPahtState {
  final List<PahtModel> paht;
  final bool hasReachedMax;
  final int offset;
  final String error;
  PersonalPahtSuccess(
      {@required this.paht, this.hasReachedMax, this.offset, this.error});

  PersonalPahtSuccess copyWith(
      {List<PahtModel> paht, bool hasReachedMax, int offset}) {
    return PersonalPahtSuccess(
        paht: paht ?? this.paht,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        offset: offset);
  }
}

class PersonalPahtLoadmore extends PersonalPahtState {
  final List<PahtModel> paht;
  final bool hasReachedMax;
  final int offset;
  final String error;

  PersonalPahtLoadmore(
      {@required this.paht, this.hasReachedMax, this.offset, this.error});

  PersonalPahtLoadmore copyWith(
      {List<PahtModel> paht, bool hasReachedMax, int offset}) {
    return PersonalPahtLoadmore(
        paht: paht ?? this.paht,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        offset: offset);
  }
}

class PersonalPahtFailure extends PersonalPahtState {
  final dynamic error;

  PersonalPahtFailure({@required this.error});
}

class PersonalPahtRefreshSuccess extends PersonalPahtState {
  final List<PahtModel> paht;
  final bool hasReachedMax;
  final int offset;
  final int limit;

  const PersonalPahtRefreshSuccess(
      {this.paht, this.hasReachedMax, this.offset, this.limit});

  PersonalPahtRefreshSuccess copyWith(
      {List<PahtModel> warnings, bool hasReachedMax, int offset}) {
    return PersonalPahtRefreshSuccess(
        paht: warnings ?? this.paht,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        offset: offset,
        limit: limit);
  }

  @override
  List<Object> get props => [paht, offset, hasReachedMax];

  @override
  String toString() =>
      'PersonalPahtRefreshSuccess { paht: ${paht.length}, offset: $offset, hasReachedMax: $hasReachedMax }';
}

class DeletePersonalPahtSuccess extends PersonalPahtState {}

class DeletePersonalPahtFailure extends PersonalPahtState {
  final dynamic error;

  DeletePersonalPahtFailure({this.error});
  @override
  String toString() => error.toString();
}

class FilterPersonalPahtSuccess extends PersonalPahtState {}
