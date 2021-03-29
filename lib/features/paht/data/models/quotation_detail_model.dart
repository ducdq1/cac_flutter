import 'package:citizen_app/features/paht/data/models/image_model.dart';
import 'package:citizen_app/features/paht/data/models/tonkho_model.dart';
import 'package:citizen_app/features/paht/domain/entities/image_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/product_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/quatation_detail_entity.dart';

class QuotationDetailModel extends QuotationDetailEntity {
  QuotationDetailModel(
      {int quotationId,
      int quotationDetailId,
      int productId,
      String productName,
      String productCode,
      int price,
      double value,
      double  amount,
      String unit,
      int attachId,
      ImageModel image,
      String note})
      : super(
            quotationId: quotationId,
            quotationDetailId: quotationDetailId,
            productId: productId,
            productCode: productCode,
            price: price,
            value: value,
            amount: amount,
            attachId: attachId,
            image: image,
            note: note,
            unit: unit,
            productName: productName);

  factory QuotationDetailModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);
    return QuotationDetailModel(
        productId: json['productId'],
        quotationId: json['quotationId'],
        productName: json['productName'],
        productCode : json['productCode'],
        quotationDetailId: json['quotationDetailId'],
        price: json['price'],
        value: json['value'] == null ? null : double.parse(json['value'].toString()),
        amount: json['amount'],
        attachId: json['attachId'],
        unit: json['unit'],
        note: json['note'],
        image:
            json['image'] == null ? null : ImageModel.fromJson(json['image']));
  }

  toJson() {
    return {
      "productId": productId,
      "amount": amount,
      "attachId" : attachId,
      "note" : note,
      "productName" :productName,
      "productCode" : productCode,
      "unit": unit ,
    };
  }

}
