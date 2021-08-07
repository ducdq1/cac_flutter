import 'dart:convert';

import 'package:citizen_app/core/network/network_request.dart';
import 'package:citizen_app/core/resources/api.dart';
import 'package:citizen_app/features/authentication/signin/data/models/auth_model.dart';
import 'package:citizen_app/features/authentication/signin/data/models/user_model.dart';
import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';
import 'package:citizen_app/features/authentication/signin/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:citizen_app/injection_container.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/core/resources/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citizen_app/core/functions/trans.dart';

abstract class AccountDataSource {
  Future<AuthEntity> auth({String otpCode, String phone, String password});

  Future<AuthEntity> authNonOtp({String phone, String password,bool isCustomer,String inviter,int cusGroup});

  Future<UserEntity> getUserInfo();

  Future<String> otp({String phone, String password});
}

class AccountDataSourceImpl implements AccountDataSource {
  http.Client client;
  final NetworkRequest networkRequest;

  AccountDataSourceImpl({@required this.client, @required this.networkRequest});

  @override
  Future<AuthEntity> auth(
      {String phone, String otpCode, String password}) async {
    try {
      final body = jsonEncode(<String, String>{
        "username": phone,
        "osType": "TL",
        "factorAuth": '1',
        "password": password,
        "otp": otpCode,
      });
      print(body);
      final response = await client.post(
        '$baseUrl/uaa/v1/users/login-otp',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Language': 'vi',
        },
        body: body,
      );
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data);
      if (response.statusCode == 200) {
        final json = data['data'];
        return AuthModel.fromJson(json);
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<String> otp({String phone, String password}) async {
    try {
      print('vao otp');
      final body = jsonEncode(
        <String, String>{
          "username": phone,
          "password": password,
          "osType": "MB",
          "factorAuth": '1',
        },
      );
      print(body);
      final response = await client.post(
        '$baseUrl/uaa/v1/users/login',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Language': 'vi',
        },
        body: body,
      );
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data);
      if (response.statusCode == 200) {
        final message = data['message'];
        return message;
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<AuthEntity> authNonOtp({String phone, String password,bool isCustomer,String inviter,int cusGroup}) async {
    try {
      var body;
      if (isCustomer) {
        body  = jsonEncode(
          <String, String>{
            "phone": phone,
            "name": password,
            "inviterName" :inviter,
            "cusGroup": cusGroup.toString()
          },
        );
      } else {
        body  = jsonEncode(
          <String, String>{
            "userName": phone,
            "pw": password
          },
        );
      }

      print(body);
      final response = await client
          .post(isCustomer? '$base_cus_url_api/workers/login' : '$baseUrl_api/login',
            headers: {
              'Accept-Language': 'vi',
              'Content-Type': 'application/json'
            },
            body: body,
          )
          .timeout(Duration(seconds: 30),
              onTimeout: () => throw Exception(
                  "Hết thời gian yêu cầu. Kiểm tra lại kết nối"));

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 ) {
        if( data['user'] !=null) {
          return AuthModel.fromJson(data['user']);
        }else{
          return null;
        }
      } else if (response.statusCode == 401) {
        throw Exception(trans(TEXT_LOGIN_USER_INVALID));
      } else {
        throw Exception('Không thể kết nối đến máy chủ');
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<UserEntity> getUserInfo() async {
    final prefrs = singleton<SharedPreferences>();
    final token = prefrs.get('token').toString();
    print('Get user ');
    print(token);
    try {
      Map<String, String> headers = {
        HttpHeaders.acceptLanguageHeader: 'vi',
        HttpHeaders.authorizationHeader: 'bearer $token',
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      };

      final response = await client.get(
          '$vtmaps_baseUrl/auth/v1/user/user-info',
          headers: headers);
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        final dataJson = data['data'];
        final user = dataJson['user'];
        print(data['user']);
        return UserModel.fromJson(user);
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      throw error;
    }
  }
}
