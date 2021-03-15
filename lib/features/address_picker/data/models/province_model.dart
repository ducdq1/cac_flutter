

import 'package:citizen_app/features/address_picker/domain/entities/address_entity.dart';

class ProvinceModel extends AddressEntity {
  ProvinceModel.fromJson(Map json) : super.fromJson(json);
  ProvinceModel({int id, String value, String name})
      : super(id: id, value: value, name: name);
}
