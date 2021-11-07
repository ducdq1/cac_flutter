import 'dart:convert';

import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_model.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

class CreateCKBG implements UseCase<StatusEntity, CreateCKBGParams> {
  final PahtRepository repository;

  CreateCKBG(this.repository);

  @override
  Future<CKBGModel> call(CreateCKBGParams issueParams) async {
    return await repository.createCKBG(issueParams);
  }
}


class CreateCKBGParams extends Equatable {
  final bool updateNote;//cap nhat tien do
  final bool isApproveAble;
  final bool isPreViewApprove;
  final CKBGModel ckbg;
  final List<CKBGDetailModel> lstCKBGDetail;
  final String expiredDate;
  final String quotationDate;
  final bool isInvalid;
  final String userName;
  CreateCKBGParams({this.ckbg,this.lstCKBGDetail,this.isApproveAble = false,this.expiredDate,this.isPreViewApprove= false,this.quotationDate,this.updateNote = false,this.isInvalid=false,this.userName});
  @override
  List<Object> get props => throw UnimplementedError();

  toJson() {
    return {
      "isPreViewApprove" : isPreViewApprove,
      "ckBaoGia": ckbg.toJson(),
      "ckBaoGiaDetail": lstCKBGDetail == null ? null : this.lstCKBGDetail.map((e) => e.toJson()).toList(),
      "userName" : userName,
    };
  }
}
