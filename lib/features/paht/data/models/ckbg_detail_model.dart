import 'package:citizen_app/features/paht/data/models/image_model.dart';
import 'package:citizen_app/features/paht/data/models/tonkho_model.dart';
import 'package:citizen_app/features/paht/domain/entities/ckbg_detail_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/image_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/product_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/quatation_detail_entity.dart';
import 'package:intl/intl.dart';

class CKBGDetailModel extends CKBGDetailEntity {
  CKBGDetailModel({int ckbgId,
    int ckbgDetailId,
    int productId,
    String productName,
    String productCode,
    int price,
    double value,
    double amount,
    String unit,
    int attachId,
    ImageModel image,
    String note,
    DateTime pickDate,
    int percent})
      : super(
      ckbgId: ckbgId,
      ckbgDetailId: ckbgDetailId,
      productId: productId,
      productCode: productCode,
      price: price,
      value: value,
      amount: amount,
      attachId: attachId,
      image: image,
      note: note,
      unit: unit,
      productName: productName,
      pickDate: pickDate,
      percent: percent);

  factory CKBGDetailModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);
    return CKBGDetailModel(
        productId: json['productId'],
        ckbgId: json['ckbgId'],
        productName: json['productName'],
        productCode: json['productCode'],
        ckbgDetailId: json['ckDetailId'],
        price: json['price'],
        value: json['value'] == null
            ? null
            : double.parse(json['value'].toString()),
        amount: json['amount'],
        attachId: json['attachId'],
        unit: json['unit'],
        note: json['note'],
        pickDate: json['pickDate'] != null ? DateTime.parse(json['pickDate']) : null,
        percent: json['percent'],
        image:
        json['image'] == null ? null : ImageModel.fromJson(json['image']));
  }

  toJson() {
    return {
      "ckDetailId": ckbgDetailId,
      "ckbgId": ckbgId,
      "productId": productId,
      "amount": amount,
      "attachId": attachId,
      "note": note,
      "productName": productName,
      "productCode": productCode,
      "unit": unit,
      "price": price,
      "percent": percent,
      "pickDate": pickDate != null ? pickDate.toIso8601String() : null,
    };
  }
}
