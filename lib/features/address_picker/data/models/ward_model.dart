

import 'package:citizen_app/features/address_picker/domain/entities/address_entity.dart';

class WardModel extends AddressEntity {
  int parentId;
  WardModel.fromJson(Map json) : super.fromJson(json) {
    this.parentId = json['parentId'];
  }

  WardModel({int id, String value, String name, int parentId})
      : super(id: id, value: value, name: name) {
    this.parentId = parentId;
  }
}
