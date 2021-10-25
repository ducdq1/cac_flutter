import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/search_product_model.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:citizen_app/features/paht/presentation/pages/paht_detail_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetDetailedPaht implements UseCase<PahtEntity, SearchProductParam> {
  final PahtRepository repository;

  GetDetailedPaht(this.repository);

  @override
  Future<SearchProductModel> call(SearchProductParam params) async {
    return await repository.getDetailedPaht(params);
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
