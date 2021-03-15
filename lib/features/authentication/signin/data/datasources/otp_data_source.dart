import 'dart:convert';

import 'package:citizen_app/core/network/network_request.dart';
import 'package:citizen_app/core/resources/api.dart';
import 'package:citizen_app/features/authentication/signin/data/models/auth_model.dart';
import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class OtpDataSource {
  Future<AuthEntity> auth({String otpCode, String phone});
  Future<String> otp({String phone});
}

class OtpDataSourceImpl implements OtpDataSource {
  final http.Client client;
  final NetworkRequest networkRequest;
  OtpDataSourceImpl({@required this.client, @required this.networkRequest});

  @override
  Future<String> otp({String phone}) async {
    final body = jsonEncode({"osType": "MB", "phone": phone});

    try {
      final response = await client.post(
        '$baseUrl/uaa/v1/users/login-phone',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Language': 'en',
        },
        body: body,
      );
      print(body);
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        return data['data'].toString();
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Future<AuthEntity> auth(
      {@required String otpCode, @required String phone}) async {
    Map data;
    try {
      final response = await client.post(
        '$baseUrl/uaa/v1/users/login-phone-otp',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Language': 'en',
        },
        body: jsonEncode(
          <String, String>{"phone": phone, "otp": otpCode, "osType": "MB"},
        ),
      );
      print('$baseUrl/uaa/v1/users/login-phone-otp');
      print(jsonEncode(
        <String, String>{"phone": phone, "otp": otpCode, "osType": "MB"},
      ));
      data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data);
      print(data['data']['accessToken']);
      if (response.statusCode == 200) {
        final json = data['data'];
        return AuthModel.fromJson(json);
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      throw Exception(data['message']);
    }
  }
}
