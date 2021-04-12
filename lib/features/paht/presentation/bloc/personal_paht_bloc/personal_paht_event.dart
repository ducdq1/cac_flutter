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
  final bool isSaled;
  ListPersonalPahtFetchingEvent(
      {this.offset, this.search, this.categoryIds, this.statusIds, this.limit,this.isSaled = false });

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
  final bool isSaled;
  ListPersonalPahtFetchedEvent(
      {@required this.paht, this.hasReachedMax, this.offset, this.error,this.isSaled = false});
}

class PersonalPahtRefreshRequestedEvent extends PersonalPahtEvent {
  final String search;
  final List<String> categoryIds;
  final List<String> statusIds;
  final int type;
  final bool isSaled;
  PersonalPahtRefreshRequestedEvent(
      {this.search, this.categoryIds, this.statusIds, this.type,this.isSaled = false});

  @override
  List<Object> get props => [search, categoryIds, statusIds];
  @override
  String toString() => 'PersonalPahtRefreshRequested';
}

class DeleteButtonPressedEvent extends PersonalPahtEvent {
  final String id;
  final List<String> filters;
  final bool isSaled;
  DeleteButtonPressedEvent({@required this.id, this.filters, this.isSaled = false});
}

class FilterPersonalButtonPressedEvent extends PersonalPahtEvent {
  final String search;
  final List<String> categoryIds;
  final List<String> statusIds;
  final bool isSaled;
  FilterPersonalButtonPressedEvent({
    this.search,
    this.categoryIds,
    this.statusIds,
    this.isSaled = false
  });

  @override
  List<Object> get props => [search, categoryIds, statusIds];
  @override
  String toString() => 'PersonalPahtRefreshRequested';
}

class SearchPersonalButtonPressedEvent extends PersonalPahtEvent {
  final String search;
  final bool isSaled;
  SearchPersonalButtonPressedEvent({
    this.search,
    this.isSaled = false
  });

  @override
  List<Object> get props => [
        search,
      ];
  @override
  String toString() => 'SearchPersonalButtonPressedEvent';
}
