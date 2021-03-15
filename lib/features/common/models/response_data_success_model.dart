import 'package:equatable/equatable.dart';

class ResponseDataSuccessModel extends Equatable {
  final int code;
  final String message;
  final List data;

  ResponseDataSuccessModel({
    this.code,
    this.message,
    this.data,
  });
  factory ResponseDataSuccessModel.fromJson(Map<String, dynamic> json) {
    return ResponseDataSuccessModel(
        code: json['code'],
        message: json['message'],
        data: json['data'] == null
            ? []
            : json['data'].map<Object>((item) {
                return item;
              }).toList());
  }
  @override
  List<Object> get props => [code, message, data];
  @override
  String toString() =>
      'Response { code: ${code.toString()}, message: $message}';
}
