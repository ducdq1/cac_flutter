import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/image_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/media_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/place_images_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:equatable/equatable.dart';

class QuotationDetailEntity extends Equatable {
  int quotationId;
  int quotationDetailId;
  int productId;
  String productName;
  String productCode;
  int price;
  double value;
  double amount;
  int attachId;
  ImageEntity image;
  String note;
  String unit;
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  QuotationDetailEntity({
      this.quotationId,
      this.quotationDetailId,
      this.productId,
      this.productName,
      this.productCode,
      this.price,
      this.value,
      this.amount,
      this.attachId,
      this.image,
      this.note,
      this.unit});
}
