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
      int value,
      int amount,
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
            productName: productName);

  factory QuotationDetailModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);
    return QuotationDetailModel(
        productId: json['productId'],
        quotationId: json['quotationId'],
        productName: json['productName'],
        quotationDetailId: json['quotationDetailId'],
        price: json['price'],
        value: json['value'],
        amount: json['amount'],
        attachId: json['attachId'],
        note: json['note'],
        image:
            json['image'] == null ? null : ImageModel.fromJson(json['image']));
  }
}
