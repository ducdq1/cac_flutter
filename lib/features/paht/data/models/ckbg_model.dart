import 'package:citizen_app/features/paht/data/models/business_hour_model.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/domain/entities/ckbg_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/paht_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';

class CKBGModel extends CKBGEntity {
  CKBGModel({int ckbgId,
    String ckbgNumber,
    String cusName,
    String cusAddress,
    String cusPhone,
    String createUserCode,
    int type,
    int status,
    int totalPrice,
    String modifyDate,
    String createUserFullName,
    String fileName,
    String content,
    String ckbgDate,
    bool isInvalid,
    String ckbgUserName,
  })
      : super(
      ckbgId: ckbgId,
      ckbgNumber: ckbgNumber,
      cusName: cusName,
      cusAddress: cusAddress,
      cusPhone: cusPhone,
      createUserCode: createUserCode,
      type: type,
      status: status,
      totalPrice: totalPrice,
      modifyDate: modifyDate,
      createUserFullName: createUserFullName,
      fileName: fileName,
      ckbgDate : ckbgDate,
      content : content,
      isInvalid: isInvalid,
      ckbgUserName: ckbgUserName);

  factory CKBGModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);
    return CKBGModel(
        ckbgId: json['ckId'],
        ckbgNumber: json['ckNumber'],
        cusName: json['cusName'],
        cusAddress: json['cusAddress'],
        cusPhone: json['cusPhone'],
        createUserCode: json['createUserCode'],
        type: json['type'],
        status: json['status'],
        totalPrice: json['totalPrice'],
        modifyDate: json['modifyDate'],
        createUserFullName: json['createUserFullName'],
        fileName: json['fileName'],
        ckbgDate: json['ckbgDate'],
        content : json['ckContent'],
        ckbgUserName: json['ckUserName']);
  }

  Map<String, dynamic> toJson() {
    return {
      "ckId": ckbgId,
      "cusName": cusName,
      "cusAddress": cusAddress,
      "cusPhone": cusPhone,
      "createUserCode": createUserCode,
      "createUserFullName": createUserFullName,
      "type": type,
      "ckbgDate": ckbgDate,
      "ckContent": content,
      "ckUserName" : ckbgUserName
    };
  }

  @override
  String toString() => '';
}
