import 'dart:async';
import 'dart:convert';

import 'package:citizen_app/core/error/exceptions.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/network/network_request.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/signin/data/models/auth_model.dart';
import 'package:citizen_app/features/common/models/models.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_model.dart';
import 'package:citizen_app/features/paht/data/models/comment_model.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/search_product_model.dart';
import 'package:citizen_app/features/paht/domain/usecases/create_ckbg.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:citizen_app/features/paht/presentation/pages/paht_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PahtRemoteDataSource {
  Future<List<PahtModel>> fetchListPersonalPaht(PahtParams parram);

  Future<List<PahtModel>> fetchListPublicPaht(PahtParams parram);

  Future<List<CKBGModel>> fetchListCKBG(PahtParams parram);

  Future<List<StatusModel>> fetchListStatusPersonal();

  Future<List<StatusModel>> fetchListStatusPublic();

  Future<SearchProductModel> searchProduct(SearchProductParam param);

  Future<SearchProductModel> fetchDetailedPaht(SearchProductParam param);

  Future<String> createIssuePaht(QuotationParams issueParams);

  Future<CKBGModel> createCKBG(CreateCKBGParams issueParams);

  Future<List<CKBGDetailModel>> getListCKBGDetail(int id);

  Future<bool> deleteCKBG(int id);

  Future<List<QuotationDetailModel>> getListQuotationDetail(int id);

  Future<bool> updatePaht(UpdatedParams updatedParams);

  Future<bool> deletePaht({String id});

  Future<bool> updateProcessor(String workerId, String processor);

  Future<bool> updateWorkerLastLogin(String workerId);
  Future<bool> checkUser(String userName,String pw);
}

class PahtRemoteDataSourceImpl implements PahtRemoteDataSource {
  final http.Client client;
  final NetworkRequest networkRequest;
  final SharedPreferences sharedPreferences;

  PahtRemoteDataSourceImpl(
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
      if (issueParams.isInvalid ||
          issueParams.updateNote ||
          (issueParams.quotationDate != null &&
              issueParams.quotationDate.isNotEmpty &&
              issueParams.lstQuotationDetail == null)) {
        url = '$baseUrl_api/quotation/update-saledate';
      } else {
        url = '$baseUrl_api/quotation';
      }

      print(url);
      print(body);
      final response = await networkRequest.postRequest(url: url, body: body);

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
        throw Exception("L???i ${response.statusCode}: ${data['message']}");
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
      result.add(StatusModel(name: 'Ch??a B??n', id: 0));
      result.add(StatusModel(name: '???? b??n', id: 1));
      return result;
      // } else {
      //   throw Exception(data['message']);
      // }
    } catch (error) {
      return handleException(error);
    }
  }

  @override
  Future<List<PahtModel>> fetchListPersonalPaht(PahtParams parram) async {
    return _fetchListPahtFromUrl(parram
        //'$vtmaps_baseUrl/place/v1/user/contributed/edits/place-only?page=${offset.toString()}&size=${limit.toString()}&categoryIds$categogyIds&approveStatus$statusIds&search$search&action=2'
        );
  }

  @override
  Future<List<PahtModel>> fetchListPublicPaht(PahtParams parram) async {
    return _fetchListPahtFromUrl(parram
        // '$vtmaps_baseUrl/place/v1/user/contributed/edits/place-only?page=${offset.toString()}&size=${limit.toString()}&categoryIds$categogyIds&approveStatus=0&search$search&action=2');
        );
  }

  Future<List<PahtModel>> _fetchListPahtFromUrl(PahtParams param) async {
    try {
      final body = jsonEncode(param.toJson());

      String url = '$baseUrl_api/quotations?time=' +
          DateTime.now().millisecondsSinceEpoch.toString();
      print(url);
      print(body);

      final response = await networkRequest.postRequest(url: url, body: body);

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
          url: '$baseUrl_api/quotation/delete/$id');
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'X??a th??nh c??ng',
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
  Future<List<QuotationDetailModel>> getListQuotationDetail(int id) async {
    try {
      String url = '$baseUrl_api/quotation/$id';
      final response =
          await networkRequest.postRequest(url: '$baseUrl_api/quotation/$id');
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
            List<QuotationDetailModel> result =
                data.map<QuotationDetailModel>((paht) {
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
  Future<SearchProductModel> searchProduct(SearchProductParam param) async {
    try {
      final body = jsonEncode(param.toJson());
      print('----------------- ' + body);

      final response = await networkRequest.postRequest(
          url: '$baseUrl_api/search-product', body: body);
      // print(url);
      var data = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        SearchProductModel result = SearchProductModel.fromJson(data);
        print('-----------------Response with items size: ' +
            result.lstProduct.length.toString());
        return result;
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<bool> updateProcessor(String workerId, String processor) async {
    try {
      var body;
      body = jsonEncode(
        <String, dynamic>{"workerId": workerId, "processor": processor},
      );

      print(body);
      final response = await client
          .post(
            '$base_cus_url_api/workers/updateProcessor',
            headers: {
              'Accept-Language': 'vi',
              'Content-Type': 'application/json'
            },
            body: body,
          )
          .timeout(Duration(seconds: 30),
              onTimeout: () => throw Exception(
                  "H???t th???i gian y??u c???u. Ki???m tra l???i k???t n???i"));

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> updateWorkerLastLogin(String workerId) async {
    try {
      print('$base_cus_url_api/workers/updateLastLogin?workerId=' +
          (workerId ?? 'null'));
      final response = await client.get(
        '$base_cus_url_api/workers/updateLastLogin?workerId=' +
            (workerId ?? 'null'),
        headers: {'Accept-Language': 'vi', 'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30),
          onTimeout: () =>
              throw Exception("H???t th???i gian y??u c???u. Ki???m tra l???i k???t n???i"));

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['isLoginRequired'];
      }
    } catch (error) {
      return false;
    }
  }

  @override
  Future<CKBGModel> createCKBG(CreateCKBGParams issueParams) async {
    try {
      final body = jsonEncode(issueParams.toJson());
      print('create or update createCKBG ');

      String url = '$base_cus_url_api/ckbg/create';

        //url = '$baseUrl_api/quotation';

      print(url);
      print(body);
      final response = await networkRequest.postRequest(url: url, body: body);

      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print('create or update createCKBG result: ' + responseJson.toString());
      if (response.statusCode == 200) {
        if (data['statusCode'] == 1001 && data['message'] == "UNAUTHORIZED") {
          throw Exception(data['message'].toString());
        }

        if (data['statusCode'] != 200) {
          throw Exception(data['message'].toString());
        }

        return CKBGModel(fileName: data['filePath']);
      } else {
        throw Exception("L???i ${response.statusCode}: ${data['message']}");
      }
    } catch (error) {
      //print(error);
     throw  error;
    }
  }

  @override
  Future<bool> deleteCKBG(int id) async{
    try {
      print('$base_cus_url_api/ckbg/delete/$id');
      final response = await networkRequest.postRequest(
          url: '$base_cus_url_api/ckbg/delete/$id');
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'X??a th??nh c??ng',
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
  Future<List<CKBGDetailModel>> getListCKBGDetail(int id) async{
    try {
      String url = '$base_cus_url_api/ckbg/$id';
      print(url);
      final response =
          await networkRequest.postRequest(url: url);
      print('--> success');
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      print(responseJson);
      if (response.statusCode == 200) {
        if (responseJson['statusCode'] == 1001 &&
            responseJson['message'] == "UNAUTHORIZED") {
          throw Exception(responseJson['message']);
        } else {
          final data = responseJson['listData'];
          if (data != null) {
            List<CKBGDetailModel> result =
            data.map<CKBGDetailModel>((paht) {
              return CKBGDetailModel.fromJson(paht);
            }).toList();
            return result;
          }
          return [];
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
  Future<List<CKBGModel>> fetchListCKBG(PahtParams param) async {
    try {
      final body = jsonEncode(param.toJson());

      String url = '$base_cus_url_api/ckbg/list?time=' +
          DateTime.now().millisecondsSinceEpoch.toString();
      print(url);
      print(body);

      final response = await networkRequest.postRequest(url: url, body: body);

      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        if (responseJson['statusCode'] == 1001 &&
            responseJson['message'] == "UNAUTHORIZED") {
          throw Exception(responseJson['message']);
        } else {
          final data = responseJson['listData'];
          if (data != null) {
            List<CKBGModel> result = data.map<CKBGModel>((paht) {
              return CKBGModel.fromJson(paht);
            }).toList();
            return result;
          }
          return [];
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
  Future<bool> checkUser(String userName, String pw)async {
    try {
      var body = jsonEncode(
          <String, String>{
            "userName": userName,
            "pw": pw
          },
        );

      print(body);
      final response = await client
          .post('$baseUrl_api/login',
        headers: {
          'Accept-Language': 'vi',
          'Content-Type': 'application/json'
        },
        body: body,
      )
          .timeout(Duration(seconds: 30),
          onTimeout: () => throw Exception(
              "H???t th???i gian y??u c???u. Ki???m tra l???i k???t n???i"));

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 ) {
        if( data['user'] !=null) {
          return true;
        }else{
          return false;
        }
      } else if (response.statusCode == 401) {
        return false;
      } else {
        throw Exception('Kh??ng th??? k???t n???i ?????n m??y ch???');
      }
    } catch (error) {
      throw error;
    }
  }
}
