import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/customer/data/repositories/cus_repository.dart';
import 'package:citizen_app/features/customer/domain/entities/category_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';

class GetListProductCategory implements UseCase<ProductCategoryEntity, int> {
  final CusRepository repository;

  GetListProductCategory(this.repository);

  @override
  Future<List<ProductCategoryEntity>> call(int type) async {
    return await repository.getListProductCategory(type);
  }

}
