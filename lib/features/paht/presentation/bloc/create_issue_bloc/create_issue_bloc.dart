import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/domain/usecases/get_list_quotation_detail.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
// import 'package:rxdart/rxdart.dart';

part 'create_issue_event.dart';
part 'create_issue_state.dart';

class CreateIssueBloc extends Bloc<CreateIssueEvent, CreateIssueState> {
  final CreateIssuePaht createIssuePaht;
  final GetQuotationDetail getQuotationDetailPaht;
  final UpdatePaht updatePaht;
  CreateIssueBloc({@required this.createIssuePaht, @required this.updatePaht,@required this.getQuotationDetailPaht})
      : super(CreateIssueInitial());

  @override
  Stream<CreateIssueState> mapEventToState(
    CreateIssueEvent event,
  ) async* {
    if (event is CreateIssueButtonPresseEvent) {
      yield CreateIssueLoading();
      try {
        // if (event.type == 0) {
        String result = await createIssuePaht(event.quotationParams);

        yield CreateIssueSuccess(fileName: result);
      } catch (error) {
        yield CreateIssueFailure(error: error);
      }
    }

    if(event is GetListQuotationDetailEvent){
      try {
        yield GetListQuotationDetailLoading();
        List<QuotationDetailModel>  listQuotationDetailModel=   await getQuotationDetailPaht(event.id);
        yield GetListQuotationDetailSuccess(listQuotationDetailModel :listQuotationDetailModel);
      } catch (error) {
        yield CreateIssueFailure(error: error);
      }
    }
  }
}
