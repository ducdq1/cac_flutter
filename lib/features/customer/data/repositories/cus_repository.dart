import 'package:citizen_app/features/customer/data/models/product_category_model.dart';
import 'package:citizen_app/features/customer/data/models/promotion_model.dart';

abstract class CusRepository {
  Future<List<PromotionModel>> getListPromotions(String name);
  Future<List<ProductCategoryModel>> getListProductCategory(String name);
}
