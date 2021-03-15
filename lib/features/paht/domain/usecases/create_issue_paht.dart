import 'dart:convert';

import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

class CreateIssuePaht implements UseCase<StatusEntity, IssueParams> {
  final PahtRepository repository;

  CreateIssuePaht(this.repository);

  @override
  Future<bool> call(IssueParams issueParams) async {
    return await repository.createIssuePaht(issueParams);
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
