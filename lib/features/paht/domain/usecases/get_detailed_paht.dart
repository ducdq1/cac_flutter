import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetDetailedPaht implements UseCase<PahtEntity, DetailedPahtParams> {
  final PahtRepository repository;

  GetDetailedPaht(this.repository);

  @override
  Future<PahtEntity> call(DetailedPahtParams params) async {
    return await repository.getDetailedPaht(pahtId: params.pahtId);
  }
}

class DetailedPahtParams extends Equatable {
  final String pahtId;

  DetailedPahtParams({
    @required this.pahtId,
  });

  @override
  List<Object> get props => [pahtId];
}
