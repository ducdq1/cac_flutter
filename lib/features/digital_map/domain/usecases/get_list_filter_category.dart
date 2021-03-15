import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/digital_map/data/models/filter_category_model.dart';
import 'package:citizen_app/features/digital_map/domain/repositories/map_repository.dart';

class GetListFilterCategoryUseCase
    implements UseCase<FilterCategoryModel, NoParams> {
  final MapRepository repository;

  GetListFilterCategoryUseCase(this.repository);

  @override
  Future<List<FilterCategoryModel>> call(NoParams params) async {
    return await repository.getListFilterCategory();
  }
}
