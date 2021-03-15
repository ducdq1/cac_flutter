import 'dart:convert';
import 'dart:io';

import 'package:citizen_app/core/resources/api.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

abstract class ForgotPasswordRemoteDataSource {
  Future fetchSecretCode(
      {String phone, String captchaId, String captch});
  Future resetPassword({String phone, String secretCode, String newPassword});
}

class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSource {
  final http.Client client;

  ForgotPasswordRemoteDataSourceImpl({this.client});

  @override
  Future fetchSecretCode(
      {String phone, String captchaId, String captch}) async {
    try {
      print('vao day');
      final body = jsonEncode({
        "username": phone,
        "method": "1",
        "captchaId": captchaId,
        "captcha": captch
      });
      print(body);
      final response = await client
          .post('$baseUrl/uaa/v1/users/passwords', body: body, headers: {
        Headers.contentTypeHeader: Headers.jsonContentType,
        HttpHeaders.acceptLanguageHeader: 'en',
      });
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        // return AuthModel.fromJson(data['data']);
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Future resetPassword(
      {String phone, String secretCode, String newPassword}) async {
    try {
      print('vao day');
      final body = jsonEncode({
        "username": phone,
        "secretCode": secretCode,
        "newPassword": newPassword
      });
      print(body);
      final response = await client.put (
          '$baseUrl/uaa/v1/users/passwords/recovery',
          body: body,
          headers: {
            Headers.contentTypeHeader: Headers.jsonContentType,
            HttpHeaders.acceptLanguageHeader: 'en',
          });
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        // return AuthModel.fromJson(data['data']);
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
