import 'dart:convert';
import 'dart:io';

import 'package:citizen_app/core/resources/api.dart';
import 'package:citizen_app/features/profile/data/models/update_profile_model.dart';
import 'package:citizen_app/features/profile/domain/entities/update_profile_entity.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class UpdateProfileDataSource {
  Future update(UpdateProfileEntity entity);
  Future<UpdateProfileEntity> fetchUser({int userId});
}

class UpdateProfileDataSourceImpl implements UpdateProfileDataSource {
  final http.Client client;

  UpdateProfileDataSourceImpl({this.client});

  @override
  Future update(UpdateProfileEntity entity) async {
    final prefrs = singleton<SharedPreferences>();
    final token = prefrs.get('token').toString();
    print('token: $token');
    try {
      var url = '$baseUrl/uaa/v1/users/profile';
      Map<String, String> headers = {
        HttpHeaders.acceptLanguageHeader: 'vi',
        HttpHeaders.authorizationHeader: 'bearer $token',
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      };
      final msg = jsonEncode(entity.toJson());
      print(msg);

      var response = await http.put(
        url,
        headers: headers,
        body: msg,
      );

      final json = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        throw Exception(json['message']);
      }
      // else if (response.statusCode == 401) {
      //   throw ErrorExpiredToken();
      // } else {
      //   print(response.statusCode);
      //   throw ErrorServerResponse(message: json['message']);
      // }
    } catch (e) {
      // final connectivityResult = await (Connectivity().checkConnectivity());
      // if (connectivityResult == ConnectivityResult.none) {
      //   throw ErrorConnectNetwork(message: ERROR_INTERNET_CONNECT_MESSAGE);
      // } else {
      //   throw e;
      // }
      throw e;
    }
  }

  @override
  Future<UpdateProfileEntity> fetchUser({int userId}) async {
    print('vao day r: $userId');
    final prefrs = singleton<SharedPreferences>();
    final token = prefrs.get('token').toString();
    print('token: $token');
    try {
      String url = "$baseUrl/uaa/v1/users/profile?userId=$userId";
      Map<String, String> headers = {
        HttpHeaders.acceptLanguageHeader: 'vi',
        HttpHeaders.authorizationHeader: 'bearer $token',
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      };
      print(headers);
      final response = await client.get(
        url,
        headers: headers,
      );

      print(response.body);
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        print(response.body);
        return UpdateProfileModel.fromJson(json['data']);
      }
      //  else if (response.statusCode == 401) {
      //   throw ErrorExpiredToken();
      // } else {
      //   print(response.body);
      //   throw Exception(jsonDecode(response.body)['message']);
      // }
      else {
        throw Exception(json['message']);
      }
    } catch (e) {
      // final connectivityResult = await (Connectivity().checkConnectivity());
      // if (connectivityResult == ConnectivityResult.none) {
      //   throw ErrorConnectNetwork(message: ERROR_INTERNET_CONNECT_MESSAGE);
      // }
      // print("Error: $e");
      // throw ErrorServerResponse(message: e.message);
      throw e;
    }
  }
}
