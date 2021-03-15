import 'dart:convert';

import 'package:citizen_app/core/network/network_request.dart';
import 'package:citizen_app/core/resources/api.dart';
import 'package:citizen_app/features/authentication/signin/data/models/auth_model.dart';
import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class SsoDataSource {
  Future<AuthEntity> auth({String phone, String password});
}

class SsoDataSourceImpl implements SsoDataSource {
  final http.Client client;
  final NetworkRequest networkRequest;
  SsoDataSourceImpl({@required this.client, @required this.networkRequest});

  @override
  Future<AuthEntity> auth({String phone, String password}) async {
    try {
      final response = await client.post(
        '$baseUrl/uaa/v1/staffs/login-sso',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Language': 'en',
        },
        body: jsonEncode(
          <String, String>{
            "username": phone,
            "password": password,
            "osType": "MB"
          },
        ),
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
}
