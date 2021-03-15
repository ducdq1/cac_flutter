import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetListPersonalPaht implements UseCase<PahtEntity, PahtParams> {
  final PahtRepository repository;

  GetListPersonalPaht(this.repository);

  @override
  Future<List<PahtEntity>> call(PahtParams params) async {
    return await repository.getListPersonalPaht(
        search: params.search,
        categoryIds: params.categoryIds,
        statusIds: params.statusIds,
        limit: params.limit,
        offset: params.offset);
  }
}

class PahtParams extends Equatable {
  final String search;
  final String categoryIds;
  final String statusIds;
  final int limit;
  final int offset;

  PahtParams(
      {@required this.search,
      @required this.categoryIds,
      @required this.statusIds,
      @required this.limit,
      @required this.offset});

  @override
  List<Object> get props => [search, categoryIds, statusIds];
}
