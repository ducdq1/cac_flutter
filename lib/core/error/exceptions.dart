import 'dart:async';
import 'dart:io';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:http/http.dart';

class ServerException implements Exception {}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

handleException(error) {
  if (error.runtimeType == SocketException ||
      error.runtimeType == ClientException ||
      error.runtimeType == TimeoutException) {
    throw Exception(trans(ERROR_CONNECTION_FAILED));
  } else
    throw Exception(error);
}
