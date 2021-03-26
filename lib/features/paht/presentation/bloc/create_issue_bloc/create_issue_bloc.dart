import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
// import 'package:rxdart/rxdart.dart';

part 'create_issue_event.dart';
part 'create_issue_state.dart';

class CreateIssueBloc extends Bloc<CreateIssueEvent, CreateIssueState> {
  final CreateIssuePaht createIssuePaht;
  final UpdatePaht updatePaht;
  CreateIssueBloc({@required this.createIssuePaht, @required this.updatePaht})
      : super(CreateIssueInitial());

  @override
  Stream<CreateIssueState> mapEventToState(
    CreateIssueEvent event,
  ) async* {
    if (event is CreateIssueButtonPresseEvent) {
      yield CreateIssueLoading();
      try {
        // if (event.type == 0) {
          await createIssuePaht(event.quotationParams);
        // } else {
        //   await updatePaht(UpdatedParams(
        //       address: event.address,
        //       description: event.description,
        //       files: event.files,
        //       location: event.location,
        //       userId: event.userId,
        //       id: event.pahtId));
        // }

        yield CreateIssueSuccess();
      } catch (error) {
        yield CreateIssueFailure(error: error);
      }
    }
  }
}
