import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/digital_map/data/models/marker_info_model.dart';
import 'package:citizen_app/features/digital_map/data/repositories/map_repository_impl.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetListMarkerInfoUseCase
    implements UseCase<MarkerInfoModel, MarkerInfoParams> {
  final MapRepositoryImpl repository;

  GetListMarkerInfoUseCase(this.repository);

  @override
  Future<List<MarkerInfoModel>> call(MarkerInfoParams params) async {
    return await repository.getListMarkerInfo(
      query: params.query,
      proximity: params.proximity,
    );
  }
}

class MarkerInfoParams extends Equatable {
  final String query;
  final List<double> proximity;

  MarkerInfoParams({
    @required this.query,
    @required this.proximity,
  });

  @override
  List<Object> get props => [query, proximity];
}
