part of 'marker_info_bloc.dart';

abstract class MarkerInfoState extends Equatable {
  const MarkerInfoState();

  @override
  List<Object> get props => [];
}

class MarkerInfoInitial extends MarkerInfoState {}

class MarkerInfoLoading extends MarkerInfoState {}

class MarkerInfoFailure extends MarkerInfoState {
  final dynamic error;

  MarkerInfoFailure({@required this.error});
  @override
  String toString() => 'MarkerInfoPageFailure';
}

class MarkerInfoSuccess extends MarkerInfoState {
  final List<MarkerInfoModel> listMarkerInfo;

  MarkerInfoSuccess({
    @required this.listMarkerInfo,
  });
  @override
  String toString() => 'MarkerInfoSuccess';
}
