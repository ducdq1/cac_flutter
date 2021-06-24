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
  Future<String> createIssuePaht(QuotationParams issueParams) async {
    try {
      final token = sharedPreferences.getString('token');
      final body = jsonEncode(issueParams.toJson());
      print('create or update QUOTATION ');

      String url = '$baseUrl_api/quotation';
      if (issueParams.updateNote || (issueParams.quotationDate != null &&
          issueParams.quotationDate.isNotEmpty &&
          issueParams.lstQuotationDetail == null)) {
        url = '$baseUrl_api/quotation/update-saledate';
      } else {
        url = '$baseUrl_api/quotation';
      }

      print(url);
      print(body);
      final response = await networkRequest.postRequest(
          url: url, body: body);


      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print('create or update QUOTATION result: ' + responseJson.toString());
      if (response.statusCode == 200) {
        if (data['statusCode'] == 1001 && data['message'] == "UNAUTHORIZED") {
          throw Exception(data['message'].toString());
        }

        if (data['statusCode'] != 200) {
          throw Exception(data['message'].toString());
        }

        return data['message'];
      } else {
        throw Exception("Lỗi ${response.statusCode}: ${data['message']}");
      }
    } catch (error) {
      //print(error);
      throw error;
    }
  }

  @override
  Future<List<StatusModel>> fetchListStatusPersonal() =>
      _fetchListStatusFromUrl('$baseUrl/issue-report/status/');

  @override
  Future<List<StatusModel>> fetchListStatusPublic() =>
      _fetchListStatusFromUrl('$baseUrl/issue-report/status/');

  Future<List<StatusModel>> _fetchListStatusFromUrl(String url) async {
    try {
      List<StatusModel> result = [];
      result.add(StatusModel(name: 'Chưa Bán', id: 0));
      result.add(StatusModel(name: 'Đã bán', id: 1));
      return result;
      // } else {
      //   throw Exception(data['message']);
      // }
    } catch (error) {
      return handleException(error);
    }
  }

  @override
  Future<List<CategoryModel>> fetchListCategoriesPaht() async {
    try {
      final response = await networkRequest.getRequest(
          url: '$vtmaps_baseUrl/place/v1/categories');
      //print('$vtmaps_baseUrl/place/v1/categories');

      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        final data = responseJson['data'];

        final listCategories = data['categories'];
        List<CategoryModel> result = listCategories.map<CategoryModel>((item) {
          return CategoryModel.fromJson(item);
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
  Future<List<CommentModel>> fetchComments({String pahtId}) async {
    try {
      final response = await networkRequest.getRequest(
          url: '$baseUrl/issue-report/comments/issue/$pahtId');
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        ResponseDataSuccessModel responseDataSuccess =
            ResponseDataSuccessModel.fromJson(data);
        final comments = responseDataSuccess.data;
        List<CommentModel> result = comments.map((comment) {
          return CommentModel.fromJson(comment);
        }).toList();
        return result;
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      return handleException(error);
    }
  }

  @override
  Future<List<PahtModel>> fetchListPersonalPaht(
      PahtParams parram) async {
    return _fetchListPahtFromUrl(parram
        //'$vtmaps_baseUrl/place/v1/user/contributed/edits/place-only?page=${offset.toString()}&size=${limit.toString()}&categoryIds$categogyIds&approveStatus$statusIds&search$search&action=2'
        );
  }

  @override
  Future<List<PahtModel>> fetchListPublicPaht(
      PahtParams parram) async {
    return _fetchListPahtFromUrl(parram
        // '$vtmaps_baseUrl/place/v1/user/contributed/edits/place-only?page=${offset.toString()}&size=${limit.toString()}&categoryIds$categogyIds&approveStatus=0&search$search&action=2');
    );
  }

  Future<List<PahtModel>> _fetchListPahtFromUrl(PahtParams param) async {
    try {
      final body = jsonEncode(param.toJson());

      String url = '$baseUrl_api/quotations?time='+  DateTime.now().millisecondsSinceEpoch.toString();
      print(url);
      print(body);

      final response = await networkRequest.postRequest(
          url: url, body: body);

      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      //print(responseJson);
      if (response.statusCode == 200) {
        // ResponseDataSuccessModel responseDataSuccess =
        //     ResponseDataSuccessModel.fromJson(data);
        if (responseJson['statusCode'] == 1001 &&
            responseJson['message'] == "UNAUTHORIZED") {
          throw Exception(responseJson['message']);
        } else {
          final data = responseJson['listData'];
          if (data != null) {
            List<PahtModel> result = data.map<PahtModel>((paht) {
              return PahtModel.fromJson(paht);
            }).toList();
            return result;
          }
          List<PahtModel> result = [];
          return result;
        }
      } else {
        throw Exception(responseJson['message']);
      }
    } catch (error) {
      // return handleException(error);
      throw error;
    }
  }

  @override
  Future<SearchProductModel> fetchDetailedPaht(SearchProductParam param) async {
    try {
      final body = jsonEncode(param.toJson());
      print(body);
      String url = '$baseUrl_api/search';
      final response = await networkRequest.postRequest(
          url: '$baseUrl_api/search', body: body);
      print(url);
      var data = json.decode(utf8.decode(response.bodyBytes));
      print(data);

      if (response.statusCode == 200) {
        SearchProductModel result = SearchProductModel.fromJson(data);
        return result;
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<bool> deletePaht({String id}) async {
    try {
      print('$baseUrl_api/quotation/delete/$id');
      final response = await networkRequest.postRequest(
          url:
              '$baseUrl_api/quotation/delete/$id');
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Xóa thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return true;
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  Future<bool> updatePaht(UpdatedParams updatedParams) async {
    try {
      final token = sharedPreferences.getString('token');
      var uri = Uri.parse('$iocUrl/issues/${updatedParams.id}');
      var request = http.MultipartRequest('PUT', uri)
        ..fields['description'] = updatedParams.description
        ..fields['location'] = updatedParams.location
        ..fields['address'] = updatedParams.address
        ..fields['userId'] = updatedParams.userId;
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['provinceId'] = '1';
      request.headers['districtId'] = '1';
      request.headers['wardId'] = '1';
      request.headers['Authorization'] = 'Bearer $token';
      for (var file in updatedParams.files) {
        if (file.runtimeType != MediaFromServer) {
          request.files
              .add(await http.MultipartFile.fromPath('files', file.path));
        }
        if (file.runtimeType == MediaFromServer && file.type == "video") {
          request.fields['videos'] = file.url;
        }
        if (file.runtimeType == MediaFromServer && file.type == "photo") {
          print(file.url);
          request.fields['photos'] = file.url;
        }
      }
      final response = await http.Response.fromStream(await request.send());
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      return handleException(error);
    }
  }

  @override
  Future<bool> createComment(Params commentParams) async {
    try {
      final body = jsonEncode({"content": commentParams.content});

      final response = await networkRequest.postRequest(
          url: '$baseUrl/issue-report/comments/issue/${commentParams.issueId}',
          body: body);
      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      return handleException(error);
    }
  }

  @override
  Future<bool> replyComment(Params commentParams) async {
    try {
      final body = jsonEncode({"content": commentParams.content});
      final response = await networkRequest.postRequest(
          url:
              '$baseUrl/issue-report/comments/issue/${commentParams.issueId}/reply/${commentParams.commentId}',
          body: body);

      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      return handleException(error);
    }
  }

  @override
  Future<List<QuotationDetailModel>> getListQuotationDetail(int id) async {
    try {
      String url = '$baseUrl_api/quotation/$id';
      final response = await networkRequest.postRequest(
          url: '$baseUrl_api/quotation/$id');
      print('--> success');
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      print(responseJson);
      if (response.statusCode == 200) {
        // ResponseDataSuccessModel responseDataSuccess =
        //     ResponseDataSuccessModel.fromJson(data);
        if (responseJson['statusCode'] == 1001 &&
            responseJson['message'] == "UNAUTHORIZED") {
          throw Exception(responseJson['message']);
        } else {
          final data = responseJson['listData'];
          if (data != null) {
            List<QuotationDetailModel> result = data.map<QuotationDetailModel>((paht) {
              return QuotationDetailModel.fromJson(paht);
            }).toList();
            return result;
          }
          List<QuotationDetailModel> result = [];
          return result;
        }
      } else {
        throw Exception(responseJson['message']);
      }
    } catch (error) {
      // return handleException(error);
      throw error;
    }
  }

  @override
  Future<SearchProductModel> searchProduct(SearchProductParam param)async {
    try {
      final body = jsonEncode(param.toJson());
      print(body);
      String url = '$baseUrl_api/search-product';
      final response = await networkRequest.postRequest(
          url: '$baseUrl_api/search-product', body: body);
      print(url);
      var data = json.decode(utf8.decode(response.bodyBytes));
      print(data);

      if (response.statusCode == 200) {
        SearchProductModel result = SearchProductModel.fromJson(data);
        return result;
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<List<ProductCategoryModel>> fetchListProductCategory(String name) async{
    try {
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
            description: "Chương tình khuyến mãi từ 10/6 - 12/6"));
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
