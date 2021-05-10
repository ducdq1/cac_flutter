import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/data/models/search_product_model.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:citizen_app/features/paht/presentation/pages/paht_detail_page.dart';

class SearchProduct implements UseCase<PahtEntity, SearchProductParam> {
  final PahtRepository repository;

  SearchProduct(this.repository);

  @override
  Future<SearchProductModel> call(SearchProductParam params) async {
    return await repository.searchProduct(params);
  }
}
