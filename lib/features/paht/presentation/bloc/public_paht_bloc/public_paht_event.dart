part of 'public_paht_bloc.dart';

abstract class PublicPahtEvent extends Equatable {
  const PublicPahtEvent();

  @override
  List<Object> get props => [];
}

class ListPublicPahtFetchedEvent extends PublicPahtEvent {
  final List<PahtModel> paht;
  final bool hasReachedMax;
  final int offset;
  final String error;

  ListPublicPahtFetchedEvent(
      {@required this.paht, this.hasReachedMax, this.offset, this.error});
}

class ListProductFetchingEvent extends PublicPahtEvent {
  final int offset;
  final int limit;
  final String search;
  ListProductFetchingEvent(
      {this.offset, this.search , this.limit = 10});

  @override
  List<Object> get props => [offset, search];

  @override
  String toString() => 'ListProductFetchingEvent { offset: $offset}';
}

class ListPublicPahtFetchingEvent extends PublicPahtEvent {
  final int offset;
  final int limit;
  final bool isApproveAble;
  final bool isSaled;
  final String search;
  final List<String> categoryIds;
  final List<String> statusIds;
  ListPublicPahtFetchingEvent(
      {this.offset, this.search, this.categoryIds, this.statusIds, this.limit,this.isApproveAble = false,this.isSaled=false});

  @override
  List<Object> get props => [offset, search, categoryIds, statusIds];

  @override
  String toString() => 'ListPublicPahtFetched { offset: $offset}';
}

class PublicPahtRefreshRequestedEvent extends PublicPahtEvent {
  final int type;
  final String search;
  final List<String> categoryIds;
  final bool isApproveAble;
  final List<String> statusIds;
  final bool isSaled;
  PublicPahtRefreshRequestedEvent(
      {this.search, this.categoryIds, this.statusIds, this.type,this.isApproveAble = false, this.isSaled = false});

  @override
  List<Object> get props => [search, categoryIds, statusIds];
  @override
  String toString() => 'PublicPahtRefreshRequested';
}

class ReloadListEvent extends PublicPahtEvent {
  final bool isApproveAble;
  final bool isSaled;
  ReloadListEvent({@required this.isApproveAble=false,this.isSaled=false});
}

class DeleteButtonEvent extends PublicPahtEvent {
  final String id;
  final List<String> filters;

  DeleteButtonEvent({@required this.id, this.filters});
}

class FilterPublicButtonPressedEvent extends PublicPahtEvent {
  final String search;
  final List<String> categoryIds;
  final List<String> statusIds;
  final bool isApproveAble;
  FilterPublicButtonPressedEvent({
    this.search,
    this.categoryIds,
    this.statusIds,
    this.isApproveAble = false
  });

  @override
  List<Object> get props => [search, categoryIds, statusIds];
  @override
  String toString() => 'FilterButtonPressedEvent';
}

class SearchPublicButtonPressedEvent extends PublicPahtEvent {
  final String search;
  final bool isApproveAble;
  SearchPublicButtonPressedEvent({
    this.search,
    this.isApproveAble
  });

  @override
  List<Object> get props => [
        search,
      ];
  @override
  String toString() => 'SearchPublicButtonPressedEvent';
}
