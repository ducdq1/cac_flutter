import 'dart:async';
import 'dart:io';
import 'package:citizen_app/core/error/exceptions.dart';
import 'package:citizen_app/core/functions/handle_language.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/injection_container.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

abstract class NetworkRequest {
  Future<dynamic> getRequest({@required String url, String service});
  Future<dynamic> putRequest(
      {@required String url, @required String body, String service});
  Future<dynamic> postRequest(
      {@required String url, @required String body, String service});
  Future<dynamic> deleteRequest({@required String url, String service});
  void closeRequest();
}

typedef Future<http.Response> _RequestMethodChooser(String token);

class NetworkRequestImpl implements NetworkRequest {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  final pref = singleton<SharedPreferences>();
  String locale = ui.window.locale.languageCode;
  NetworkRequestImpl({this.client, this.sharedPreferences});

  @override
  Future<http.Response> getRequest(
      {@required String url, String service}) async {
    return await _requestUrl((token) {
      return client.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Language': handleLanguage(),
          HttpHeaders.authorizationHeader: token != null ? 'Bearer $token' : '',
          'provinceId': '1',
          'districtId': '1',
          'wardId': '1',
        },
      ).timeout(
        Duration(seconds: 20),
        onTimeout: () {
          throw SocketException(trans(LABEL_TRY_AGAIN));
        },
      );
    });
  }

  @override
  Future<http.Response> putRequest(
      {@required String url, @required String body, String service}) async {
    return await _requestUrl((token) {
      return client.put(url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept-Language': handleLanguage(),
            HttpHeaders.authorizationHeader:
                token != null ? 'Bearer $token' : '',
            'provinceId': '1',
            'districtId': '1',
            'wardId': '1',
          },
          body: body);
    }).timeout(
      Duration(seconds: 20),
      onTimeout: () {
        throw SocketException(trans(LABEL_TRY_AGAIN));
      },
    );
  }

  @override
  Future<http.Response> postRequest(
      {@required String url, @required String body, String service}) async {
    return await _requestUrl((token) {
      return client
          .post(url,
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept-Language': handleLanguage(),
                HttpHeaders.authorizationHeader:
                    token != null ? 'Bearer $token' : '',
              },
              body: body)
          .timeout(
        Duration(seconds: 20),
        onTimeout: () {
          print('Request Time out');
          throw SocketException(trans(LABEL_TRY_AGAIN));
        },
      );
    });
  }

  @override
  Future<http.Response> deleteRequest(
      {@required String url, String service}) async {
    return await _requestUrl((token) {
      return client.delete(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Language': handleLanguage(),
          HttpHeaders.authorizationHeader: token != null ? 'Bearer $token' : '',
          'provinceId': '1',
          'districtId': '1',
          'wardId': '1',
        },
      ).timeout(
        Duration(seconds: 20),
        onTimeout: () {
          throw SocketException(trans(LABEL_TRY_AGAIN));
        },
      );
    });
  }

  Future<http.Response> _requestUrl(
    _RequestMethodChooser requestMethod,
  ) async {
    try {
      final token = sharedPreferences.getString('token');
      final res = await requestMethod(token);
      return res;
    } catch (error) {
      return handleException(error);
    }
  }

  void closeRequest() {
    return client.close();
  }
}
