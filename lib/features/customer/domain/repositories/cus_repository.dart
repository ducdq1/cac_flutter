import 'package:citizen_app/features/customer/domain/entities/category_entity.dart';
import 'package:citizen_app/features/customer/domain/entities/promotion_entity.dart';

abstract class CusRepository {
  Future<List<PromotionEntity>> getListPromotion(String name);
  Future<List<ProductCategoryEntity>> getListProductCategory(String name);
}
