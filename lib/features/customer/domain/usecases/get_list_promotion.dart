import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/customer/data/repositories/cus_repository.dart';
import 'package:citizen_app/features/customer/domain/entities/promotion_entity.dart';

class GetListPromotion implements UseCase<PromotionEntity, String> {
  final CusRepository repository;

  GetListPromotion(this.repository);

  @override
  Future<List<PromotionEntity>> call(String params) async {
    return await repository.getListPromotions(params);
  }
}
