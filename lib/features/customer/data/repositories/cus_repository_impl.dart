import 'package:citizen_app/features/customer/data/data_sources/cus_remote_data_source.dart';
import 'package:citizen_app/features/customer/data/models/product_category_model.dart';
import 'package:citizen_app/features/customer/data/models/promotion_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'cus_repository.dart';


class PahtRepositoryImpl implements CusRepository {
  final CusRemoteDataSource remoteDataSource;

  PahtRepositoryImpl({
    @required this.remoteDataSource
  });


  @override
  Future<List<ProductCategoryModel>> getListProductCategory(String name) async{
    try {
      final remoteCreateIssuePaht =
          await remoteDataSource.fetchListProductCategory(name);
      return remoteCreateIssuePaht;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<List<PromotionModel>> getListPromotions(String name) async{
    try {
      final remoteCreateIssuePaht =
          await remoteDataSource.fetchListPromotions(name);
      return remoteCreateIssuePaht;
    } catch (error) {
      throw error;
    }
  }
}
