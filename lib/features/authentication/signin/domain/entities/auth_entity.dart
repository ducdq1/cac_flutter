import 'dart:convert';

abstract class AuthEntity {
  String access_token;
  String token_type;
  String refresh_token;
  String scope;
  String avartarPath;
  String fullName;
  int userId;
  String userName;

  AuthEntity.fromJson(Map json) {
    this.access_token = json['access_token'];
    this.token_type = json['token_type'];
    this.refresh_token = json['refresh_token'];
    this.avartarPath = json['avartarPath'];
    this.fullName = json['fullName'];
    this.userId = json['userId'];
    this.userName = json['userName'];
  }

  toJson() {
    return {
      'access_token': access_token,
      'token_type': token_type,
      'refresh_token': refresh_token,
      'scope': scope

    };
  }

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }
}
