import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/media_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/place_images_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:equatable/equatable.dart';

class PahtEntity extends Equatable {
  int quotationID;
  String quotationNumber;
  String cusName;
  String cusAddress;
  String cusPhone;
  String createUserCode;
  int type;
  int status;
  int totalPrice;
  String modifyDate;
  String quotationDate;
  String createUserFullName;
  String fileName;
  String saledDate;
  String note;
  PahtEntity(
      {this.quotationID,
      this.quotationNumber,
      this.cusName,
      this.cusAddress,
      this.cusPhone,
      this.createUserCode,
      this.status,
      this.totalPrice,
      this.type,
      this.modifyDate,
      this.createUserFullName,
      this.fileName,
        this.quotationDate,
      this.saledDate,
      this.note});

  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
