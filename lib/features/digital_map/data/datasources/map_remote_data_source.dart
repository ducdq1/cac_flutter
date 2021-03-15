import 'dart:convert';

import 'package:citizen_app/core/error/exceptions.dart';
import 'package:citizen_app/core/network/network_request.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/digital_map/data/models/filter_category_model.dart';
import 'package:citizen_app/features/digital_map/data/models/marker_info_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class MapRemoteDataSource {
  Future<List<FilterCategoryModel>> getListFilterCategory();
  Future<List<MarkerInfoModel>> getListMarkerInfo(
      {String query, List<double> proximity});
  // Future<AlarmInfoModel> getDetailAlarmInfo({String id});
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final http.Client client;
  final NetworkRequest networkRequest;
  MapRemoteDataSourceImpl(
      {@required this.client, @required this.networkRequest});

  @override
  Future<List<FilterCategoryModel>> getListFilterCategory() async {
    try {
      final response = await networkRequest.getRequest(
          url: '$urlVTMap/gateway/place/v1/key-search/');
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        // ResponseDataSuccessModel responseDataSuccess =
        //     ResponseDataSuccessModel.fromJson(data);
        // final listCategories = responseDataSuccess.data;
        List<FilterCategoryModel> result =
            (data['data']['categories'] as List).map((category) {
          return FilterCategoryModel.fromJson(category);
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
  Future<List<MarkerInfoModel>> getListMarkerInfo({
    String query,
    List<double> proximity,
  }) async {
    try {
      String token = '6ht5fdbc-1996-4f54-87gf-5664f304f3d2';
      String url =
          '$urlVTMap/gateway/searching/v1/search/geojson/address?access_token=$token';
      final body = {
        "offset": "0",
        "limit": "10",
        "sortByDistance": "true",
        "query": query,
        "proximity": proximity,
        "mode": "search_result",
      };
      print(body);
      final response =
          await networkRequest.postRequest(url: url, body: jsonEncode(body));
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        // ResponseDataSuccessModel responseDataSuccess =
        //     ResponseDataSuccessModel.fromJson(data);
        // final listPahts = responseDataSuccess.data;
        List<MarkerInfoModel> result = (data['features'] as List)
            .map((markerInfo) => MarkerInfoModel.fromJson(markerInfo))
            .toList();
        return result;
      } else {
        throw Exception('Not Connecting');
      }
    } catch (error) {
      return handleException(error);
    }
  }
}
