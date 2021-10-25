import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/media_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/place_images_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:equatable/equatable.dart';

class CKBGEntity extends Equatable {
  int ckbgId;
  String ckbgNumber;
  String cusName;
  String cusAddress;
  String cusPhone;
  String createUserCode;
  int type;
  int status;
  int totalPrice;
  String modifyDate;
  String ckbgDate;
  String createUserFullName;
  String fileName;
  bool isInvalid;
  String ckbgUserName;
  String content;

  CKBGEntity(
      {this.ckbgId,
      this.ckbgNumber,
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
      this.ckbgDate,
      this.isInvalid,
      this.ckbgUserName,
      this.content});

  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
