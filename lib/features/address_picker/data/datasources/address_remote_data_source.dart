import 'dart:convert';

import 'package:citizen_app/core/resources/api.dart';
import 'package:citizen_app/features/address_picker/data/models/district_model.dart';
import 'package:citizen_app/features/address_picker/data/models/province_model.dart';
import 'package:citizen_app/features/address_picker/data/models/ward_model.dart';
import 'package:citizen_app/features/address_picker/domain/entities/address_entity.dart';
import 'package:citizen_app/features/address_picker/domain/usecases/address_command_exp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressRemoteDataSource {
  final http.Client client;
  AddressRemoteDataSource(
      {@required this.client});

  Future<List<AddressEntity>> fetchAddress(
      AddressType addressType, int parentId) async {
    await Future.delayed(Duration(seconds: 0));
    String url = '$baseUrl/categories/v1/list';
    switch (addressType) {
      case AddressType.ward:
        url = url + '/wards/$parentId';
        break;
      case AddressType.district:
        url = url + '/districts/$parentId';
        break;
      case AddressType.province:
        url = url + '/provinces';
        break;
      default:
        throw Exception('Address type did not match...');
    }

    print(url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body)['data'] as List;
        switch (addressType) {
          case AddressType.ward:
            return jsonBody.map((item) {
              final ward = WardModel.fromJson(item);
              return ward;
            }).toList();
            break;
          case AddressType.district:
            return jsonBody.map((item) {
              final district = DistrictModel.fromJson(item);
              
              return district;
            }).toList();
            break;
          case AddressType.province:
            return jsonBody.map((item) {
              final province = ProvinceModel.fromJson(item);
              return province;
            }).toList();
            break;
          default:
            throw Exception('Address type did not match...');
        }
      } else {
        throw Exception(
            'Error fetch address with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<List<WardModel>> fetchWards(int parentId) async {
    return await this.fetchAddress(AddressType.ward, parentId);
  }

  Future<List<DistrictModel>> fetchDistricts(int parentId) async {
    return await this.fetchAddress(AddressType.district, parentId);
  }

  Future<List<ProvinceModel>> fetchProvices(int parentId) async {
    return await this.fetchAddress(AddressType.province, parentId);
  }
}
