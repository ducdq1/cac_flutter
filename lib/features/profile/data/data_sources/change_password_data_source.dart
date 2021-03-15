import 'dart:convert';
import 'package:citizen_app/core/resources/api.dart';
import 'package:citizen_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class ChangePasswordDataSource {
  Future change(ChangePasswordEntity entity);
}

class ChangePasswordDataSourceImpl implements ChangePasswordDataSource {
  final http.Client client;

  ChangePasswordDataSourceImpl({this.client});

  @override
  Future change(ChangePasswordEntity entity) async {
    try {
      final prefrs = singleton<SharedPreferences>();
      final token = prefrs.get('token').toString();
      print('Token: $token');
      Map<String, String> headers = {
        'Accept-Language': 'vi',
        'Authorization': 'bearer $token',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode(entity.toJson());
      print(headers);
      print(body);
      final response = await client.put(
        '$baseUrl/uaa/v1/users/passwords',
        body: body,
        headers: headers,
      );

      print(response.body);

      if(response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['message']);
      }
      print(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
