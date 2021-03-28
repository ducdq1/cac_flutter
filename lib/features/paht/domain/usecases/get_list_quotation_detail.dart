import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/search_product_model.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:citizen_app/features/paht/presentation/pages/paht_detail_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetQuotationDetail implements UseCase<StatusEntity, int> {
  final PahtRepository repository;

  GetQuotationDetail(this.repository);

  @override
  Future<List<QuotationDetailModel>> call(int id) async {
    return await repository.getListQuotationDetail(id);
  }
}
