import 'package:equatable/equatable.dart';

class ResponseDataSuccessModelVTMap extends Equatable {
  final int statusCode;
  final String message;
  final List data;

  ResponseDataSuccessModelVTMap({
    this.statusCode,
    this.message,
    this.data,
  });
  factory ResponseDataSuccessModelVTMap.fromJson(Map<String, dynamic> json) {
    return ResponseDataSuccessModelVTMap(
        statusCode: json['statusCode'],
        message: json['message'],
        data: json['data'] == null
            ? []
            : json['data'].map<Object>((item) {
                return item;
              }).toList());
  }
  @override
  List<Object> get props => [statusCode, message, data];
  @override
  String toString() =>
      'Response { code: ${statusCode.toString()}, message: $message}';
}
