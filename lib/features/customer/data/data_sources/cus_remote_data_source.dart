import 'dart:async';
import 'dart:convert';

import 'package:citizen_app/core/error/exceptions.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/network/network_request.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/models/models.dart';
import 'package:citizen_app/features/customer/data/models/product_category_model.dart';
import 'package:citizen_app/features/paht/data/data_sources/paht_remote_data_source.dart';
import 'package:citizen_app/features/paht/data/models/comment_model.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/search_product_model.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:citizen_app/features/paht/presentation/pages/paht_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citizen_app/features/customer/data/models/promotion_model.dart';
abstract class CusRemoteDataSource {
  Future<List<PromotionModel>> fetchListPromotions(String name);
  Future<List<ProductCategoryModel>> fetchListProductCategory(String name);

}

class CusRemoteDataSourceImpl implements CusRemoteDataSource {
  final http.Client client;
  final NetworkRequest networkRequest;
  final SharedPreferences sharedPreferences;

  CusRemoteDataSourceImpl(
      {@required this.client,
      @required this.networkRequest,
      @required this.sharedPreferences});

  @override
  Future<List<ProductCategoryModel>> fetchListProductCategory(String name) async{
    try {
      List<ProductCategoryModel> pros =[];
      pros.add(ProductCategoryModel(id: 1,
          name: "Thiết bị nội thất",
          imageUrl: "http://getbehome.com/wp-content/uploads/2017/12/GACH-MEN-OP-LAT.jpg",
          type: 0,
          description: "Hơn 500 mẫu mã đến từ 20 nhà cung cấp thiết bị hàng đầu thế giới"));

      pros.add(ProductCategoryModel(id: 1,
          name: "Gạch men cao cấp ",
          imageUrl: "http://getbehome.com/wp-content/uploads/2017/12/GACH-MEN-OP-LAT.jpg",
          type: 1,
          description: "Mẫu mã đa dạng, phù hợp với mọi loại thiết kế"));

      return pros;

      final response = await networkRequest.getRequest(
          url: '$vtmaps_baseUrl/place/v1/categories');
      //print('$vtmaps_baseUrl/place/v1/categories');

      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        //final data = responseJson['data'];

        final listCategories = responseJson['datas'];
        List<ProductCategoryModel> result = listCategories.map<ProductCategoryModel>((item) {
          return ProductCategoryModel.fromJson(item);
        }).toList();

        return result;
      } else {
        throw Exception(responseJson['message']);
      }
    } catch (error) {
      print(error);
      return handleException(error);
    }
  }

  @override
  Future<List<PromotionModel>> fetchListPromotions(String name) async {
    try {
      List<PromotionModel> pros =[];
      for(int i=0;i<=20;i++) {
        pros.add(PromotionModel(id: 1,
            name: "Khuyến mãi đặc biệt",
            imageUrl: "",
            numberSaleOff: '20%',
            description: "Chương tình khuyến mãi từ 10/6 - 12/6 \nGiảm giá 20% thiết bị vệ sinh\nGiảm 100 Gạch men"));
      }
      return pros;

      final response = await networkRequest.getRequest(
          url: '$vtmaps_baseUrl/place/v1/categories');
      //print('$vtmaps_baseUrl/place/v1/categories');

      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        //final data = responseJson['datas'];

        final listCategories = responseJson['datas'];
        List<PromotionModel> result = listCategories.map<PromotionModel>((item) {
          return PromotionModel.fromJson(item);
        }).toList();

        return result;
      } else {
        throw Exception(responseJson['message']);
      }
    } catch (error) {
      print(error);
      return handleException(error);
    }
  }
}
