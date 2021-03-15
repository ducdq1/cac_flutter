part of 'personal_paht_bloc.dart';

abstract class PersonalPahtEvent extends Equatable {
  const PersonalPahtEvent();

  @override
  List<Object> get props => [];
}

class ListPersonalPahtFetchingEvent extends PersonalPahtEvent {
  final int offset;
  final int limit;

  final String search;
  final List<String> categoryIds;
  final List<String> statusIds;

  ListPersonalPahtFetchingEvent(
      {this.offset, this.search, this.categoryIds, this.statusIds, this.limit });

  @override
  List<Object> get props => [offset, search, categoryIds, statusIds];

  @override
  String toString() => 'ListPublicPahtFetched { offset: $offset}';
}

class ListPersonalPahtFetchedEvent extends PersonalPahtEvent {
  final List<PahtModel> paht;
  final bool hasReachedMax;
  final int offset;
  final String error;

  ListPersonalPahtFetchedEvent(
      {@required this.paht, this.hasReachedMax, this.offset, this.error});
}

class PersonalPahtRefreshRequestedEvent extends PersonalPahtEvent {
  final String search;
  final List<String> categoryIds;
  final List<String> statusIds;
  final int type;
  PersonalPahtRefreshRequestedEvent(
      {this.search, this.categoryIds, this.statusIds, this.type});

  @override
  List<Object> get props => [search, categoryIds, statusIds];
  @override
  String toString() => 'PersonalPahtRefreshRequested';
}

class DeleteButtonPressedEvent extends PersonalPahtEvent {
  final String id;
  final List<String> filters;

  DeleteButtonPressedEvent({@required this.id, this.filters});
}

class FilterPersonalButtonPressedEvent extends PersonalPahtEvent {
  final String search;
  final List<String> categoryIds;
  final List<String> statusIds;
  FilterPersonalButtonPressedEvent({
    this.search,
    this.categoryIds,
    this.statusIds,
  });

  @override
  List<Object> get props => [search, categoryIds, statusIds];
  @override
  String toString() => 'PersonalPahtRefreshRequested';
}

class SearchPersonalButtonPressedEvent extends PersonalPahtEvent {
  final String search;
  SearchPersonalButtonPressedEvent({
    this.search,
  });

  @override
  List<Object> get props => [
        search,
      ];
  @override
  String toString() => 'SearchPersonalButtonPressedEvent';
}
