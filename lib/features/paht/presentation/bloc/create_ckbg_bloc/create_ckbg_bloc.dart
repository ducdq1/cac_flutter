import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/domain/usecases/create_ckbg.dart';
import 'package:citizen_app/features/paht/domain/usecases/get_list_ckbg_detail.dart';
import 'package:citizen_app/features/paht/domain/usecases/get_list_quotation_detail.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
// import 'package:rxdart/rxdart.dart';

part 'create_ckbg_event.dart';
part 'create_ckbg_state.dart';

class CreateCKBGBloc extends Bloc<CreateCKBGEvent, CreateCKBGState> {
  final CreateCKBG createCKBG;
  final GetCKBGDetail getCKBGDetail;
  final UpdatePaht updatePaht;
  CreateCKBGBloc({@required this.createCKBG, @required this.updatePaht,@required this.getCKBGDetail})
      : super(CreateCKBGInitial());

  @override
  Stream<CreateCKBGState> mapEventToState(
    CreateCKBGEvent event,
  ) async* {
    if (event is CreateCKBGButtonPresseEvent) {
      yield CreateCKBGLoading();
      try {
        // if (event.type == 0) {
        String result = await createCKBG(event.createCKBGParams);

        yield CreateCKBGSuccess(fileName: result);
      } catch (error) {
        yield CreateCKBGFailure(error: error);
      }
    }

    if(event is GetListCKBGDetailEvent){
      try {
        yield GetListCKBGDetailLoading();
        List<CKBGDetailModel>  listCKBGDetailModel=   await getCKBGDetail(event.id);
        yield GetListCKBGDetailSuccess(listCKBGDetailModel :listCKBGDetailModel);
      } catch (error) {
        yield CreateCKBGFailure(error: error);
      }
    }
  }
}
