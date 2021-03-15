import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';

class GetListCategoriesPaht implements UseCase<CategoryEntity, NoParams> {
  final PahtRepository repository;

  GetListCategoriesPaht(this.repository);

  @override
  Future<List<CategoryEntity>> call(NoParams params) async {
    return await repository.getListCategoriesPaht();
  }
}
