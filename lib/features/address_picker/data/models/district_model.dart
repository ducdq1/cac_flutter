


import 'package:citizen_app/features/address_picker/domain/entities/address_entity.dart';

class DistrictModel extends AddressEntity {
  int parentId;
  DistrictModel.fromJson(Map json) : super.fromJson(json) {
    this.parentId = json['parentId'];
  }

  DistrictModel({int id, String value, String name, int parentId})
      : super(id: id, value: value, name: name) {
    this.parentId = parentId;
  }
}
