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
  Future<List<ProductCategoryModel>> fetchListProductCategory(int type);

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
  Future<List<ProductCategoryModel>> fetchListProductCategory(type) async{
    try {
      // List<ProductCategoryModel> pros =[];
      // pros.add(ProductCategoryModel(id: 1,
      //     name: "Thi???t b??? n???i th???t",
      //     imageUrl: "http://getbehome.com/wp-content/uploads/2017/12/GACH-MEN-OP-LAT.jpg",
      //     type: 0,
      //     description: "H??n 500 m???u m?? ?????n t??? 20 nh?? cung c???p thi???t b??? h??ng ?????u th??? gi???i"));
      //
      // pros.add(ProductCategoryModel(id: 1,
      //     name: "G???ch men cao c???p ",
      //     imageUrl: "http://getbehome.com/wp-content/uploads/2017/12/GACH-MEN-OP-LAT.jpg",
      //     type: 1,
      //     description: "M???u m?? ??a d???ng, ph?? h???p v???i m???i lo???i thi???t k???"));
      //
      // return pros;
      var body = jsonEncode({
      'type' : type});

      final response = await networkRequest.postRequest(
          url: '$base_cus_url_api/productCategory/search', body: body.toString());

      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
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
      // List<PromotionModel> pros =[];
      // for(int i=0;i<=20;i++) {
      //   pros.add(PromotionModel(id: 1,
      //       name: "Khuy???n m??i ?????c bi???t",
      //       imageUrl: "",
      //       numberSaleOff: '20%',
      //       description: "Ch????ng t??nh khuy???n m??i t??? 10/6 - 12/6 \nGi???m gi?? 20% thi???t b??? v??? sinh\nGi???m 100 G???ch men"));
      // }
      // return pros;
      var body = jsonEncode({
        'name': name});
      final response = await networkRequest.postRequest(
          url: '$base_cus_url_api/promotions/search', body: body);
      //print('$vtmaps_baseUrl/place/v1/categories');

      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
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
