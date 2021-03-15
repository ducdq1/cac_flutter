part of 'marker_info_bloc.dart';

abstract class MarkerInfoEvent extends Equatable {
  const MarkerInfoEvent();

  @override
  List<Object> get props => [];
}

class ListMarkerInfoFetched extends MarkerInfoEvent {
  final String query;
  final List<double> proximity;
  ListMarkerInfoFetched({this.query, this.proximity});

  @override
  List<Object> get props => [query, proximity];

  @override
  String toString() => 'MarkerInfoFetched';
}

class ListMarkerInfoClear extends MarkerInfoEvent {
  ListMarkerInfoClear();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'MarkerInfoClear';
}
