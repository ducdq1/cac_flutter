import 'dart:convert';

import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

class CreateIssuePaht implements UseCase<StatusEntity, QuotationParams> {
  final PahtRepository repository;

  CreateIssuePaht(this.repository);

  @override
  Future<String> call(QuotationParams issueParams) async {
    return await repository.createIssuePaht(issueParams);
  }
}


class QuotationParams extends Equatable {
  final bool updateNote;//cap nhat tien do
  final bool isApproveAble;
  final bool isPreViewApprove;
  final PahtModel quotation;
  final List<QuotationDetailModel> lstQuotationDetail;
  final String expiredDate;
  final String quotationDate;
  final bool isInvalid;
  final String userName;
  QuotationParams({this.quotation,this.lstQuotationDetail,this.isApproveAble = false,this.expiredDate,this.isPreViewApprove= false,this.quotationDate,this.updateNote = false,this.isInvalid=false,this.userName});
  @override
  List<Object> get props => throw UnimplementedError();

  toJson() {
    return {
      "isPreViewApprove" : isPreViewApprove,
      "isApproveAble" : isApproveAble,
      "expiredDate" : expiredDate,
      "quotationDate" : quotationDate,
      "quotation": quotation.toJson(),
      "lstQuotationDetail": lstQuotationDetail == null ? null : this.lstQuotationDetail.map((e) => e.toJson()).toList(),
      "isInvalid" : isInvalid,
      "userName" : userName
    };
  }
}

class IssueParams extends Equatable {
  final int id;
  final String userId;
  final String address;
  final String lat;
  final String lng;
  final String description;
  final String phone;
  final String hyperlink;
  final String name;
  final int poiId;
  final int fromPoiType;
  final List<BusinessHourEntity> businessHour;
  List<int> deletePlaceImageIds;

  final List<dynamic> files;


  IssueParams(
      {this.userId, this.address, this.lat,this.lng,this.phone,this.hyperlink,this.name,this.poiId,this.id,this.businessHour, this.description, this.fromPoiType,this.files,this.deletePlaceImageIds});

  @override
  List<Object> get props => [userId, address, lat, description, files];
  toJson() {
    return {
      "id": id,
      "name" : name,
      "address": address,
      "lat": lat,
      "lng": lng,
      "phone":phone,
      "hyperlink": hyperlink,
      "fromPoiType":fromPoiType,
      "businessHour" :businessHour
    };
  }

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }
}
