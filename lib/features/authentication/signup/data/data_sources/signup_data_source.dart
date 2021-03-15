import 'dart:convert';
import 'dart:io';

import 'package:citizen_app/core/network/network_request.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/signin/data/datasources/otp_data_source.dart';
import 'package:citizen_app/features/authentication/signin/data/models/auth_model.dart';
import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';
import 'package:citizen_app/features/authentication/signup/domain/entities/signup_entity.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

abstract class SignUpDataSource {
  Future<AuthEntity> signUp({SignUpEntity entity});
  Future activeAccount({String username, String password, String otp});
  Future<String> otp({String phone});
}

class SignUpDataSourceImpl extends SignUpDataSource {
  final http.Client client;
  final NetworkRequest networkRequest;
  final OtpDataSourceImpl otpDataSourceImpl;

  SignUpDataSourceImpl({this.client, this.networkRequest})
      : otpDataSourceImpl =
            OtpDataSourceImpl(client: client, networkRequest: networkRequest);

  @override
  Future<AuthEntity> signUp({SignUpEntity entity}) async {
    try {
      print('vao day');
      final body = jsonEncode(entity.toJson());
      print(body);
      final response = await client.post(
          '$baseUrl/uaa/v1/users/register',
          body: body,
          headers: {
            Headers.contentTypeHeader: Headers.jsonContentType,
            HttpHeaders.acceptLanguageHeader: 'vi',
          });
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        return AuthModel.fromJson(data['data']);
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Future activeAccount({String username, String password, String otp}) async {
    try {
      print('vao day');
      final response = await client.post(
        '$baseUrl/uaa/v1/users/register-confirm-otp',
        body: jsonEncode({"username": username, "otp": otp}),
        headers: {
          Headers.contentTypeHeader: Headers.jsonContentType,
          HttpHeaders.acceptLanguageHeader: 'vi',
        },
      );
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        return null;
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Future<String> otp({String phone}) async {
    return await otpDataSourceImpl.otp(phone: phone);
  }
}
