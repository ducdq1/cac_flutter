import 'package:citizen_app/features/paht/data/models/business_hour_model.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/domain/entities/paht_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';

class PahtModel extends PahtEntity {
  PahtModel({int quotationID,
    String quotationNumber,
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
    String note,
    String quotationDate,
    String saledDate,
    bool isInvalid,
    String quotationUserName
  })
      : super(
      quotationID: quotationID,
      quotationNumber: quotationNumber,
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
      quotationDate : quotationDate,
      saledDate: saledDate,
      note : note,
      isInvalid: isInvalid,
      quotationUserName: quotationUserName);

  factory PahtModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);
    return PahtModel(
        quotationID: json['quotationID'],
        quotationNumber: json['quotationNumber'],
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
        quotationDate: json['quotationDate'],
        saledDate: json['saledDate'],
        note : json['note'],
        isInvalid: json['isInvalid'] !=null && json['isInvalid'] == 1 ? true : false,
        quotationUserName: json['quotationUserName']);
  }

  Map<String, dynamic> toJson() {
    return {
      "quotationID": quotationID,
      "cusName": cusName,
      "cusAddress": cusAddress,
      "cusPhone": cusPhone,
      "createUserCode": createUserCode,
      "createUserFullName": createUserFullName,
      "type": type,
      "quotationDate": quotationDate,
      "saledDate": saledDate,
      "note": note,
      "isInvalid" : isInvalid,
      "quotationUserName" : quotationUserName
    };
  }

  @override
  String toString() => '';
}
