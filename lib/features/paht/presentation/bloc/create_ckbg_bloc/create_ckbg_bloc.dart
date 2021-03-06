import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_model.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/data/repositories/paht_repository_impl.dart';
import 'package:citizen_app/features/paht/domain/usecases/create_ckbg.dart';
import 'package:citizen_app/features/paht/domain/usecases/get_list_ckbg_detail.dart';
import 'package:citizen_app/features/paht/domain/usecases/get_list_quotation_detail.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../injection_container.dart';
// import 'package:rxdart/rxdart.dart';

part 'create_ckbg_event.dart';
part 'create_ckbg_state.dart';

class CreateCKBGBloc extends Bloc<CreateCKBGEvent, CreateCKBGState> {
  final CreateCKBG createCKBG;
  final GetCKBGDetail getCKBGDetail;
  CreateCKBGBloc({@required this.createCKBG,@required this.getCKBGDetail})
      : super(CreateCKBGInitial());

  @override
  Stream<CreateCKBGState> mapEventToState(
    CreateCKBGEvent event,
  ) async* {
    if (event is CreateCKBGButtonPresseEvent) {
      yield CreateCKBGLoading();
      try {
        PahtRepositoryImpl repo = PahtRepositoryImpl(localDataSource: singleton(),
          networkInfo: singleton(),
          remoteDataSource: singleton(),);
        CKBGModel result = await repo.createCKBG(event.createCKBGParams);
        yield CreateCKBGSuccess(fileName: result.fileName);
      } catch (error) {
        yield CreateCKBGFailure(error: error);
      }
    }

    if(event is GetListCKBGDetailEvent){
      try {
        yield GetListCKBGDetailLoading();
        PahtRepositoryImpl repo = PahtRepositoryImpl(localDataSource: singleton(),
          networkInfo: singleton(),
          remoteDataSource: singleton(),);
        List<CKBGDetailModel>  listCKBGDetailModel= await  repo.getListCKBGDetail(event.id);
        yield GetListCKBGDetailSuccess(listCKBGDetailModel :listCKBGDetailModel);
      } catch (error) {
        yield CreateCKBGFailure(error: error);
      }
    }
  }
}
