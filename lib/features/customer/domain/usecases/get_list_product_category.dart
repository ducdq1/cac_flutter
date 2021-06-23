import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/customer/data/repositories/cus_repository.dart';
import 'package:citizen_app/features/customer/domain/entities/category_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';

class GetListProductCategory implements UseCase<ProductCategoryEntity, String> {
  final CusRepository repository;

  GetListProductCategory(this.repository);

  @override
  Future<List<ProductCategoryEntity>> call(String params) async {
    return await repository.getListProductCategory(params);
  }
}
