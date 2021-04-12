part of 'create_issue_bloc.dart';

abstract class CreateIssueEvent extends Equatable {
  const CreateIssueEvent();

  @override
  List<Object> get props => [];
}

class GetListQuotationDetailEvent extends CreateIssueEvent {
  final int id;
  GetListQuotationDetailEvent(
      {this.id  });
  @override
  String toString() =>
      'GetListQuotationDetailEvent:  $id';
}

class CreateIssueButtonPresseEvent extends CreateIssueEvent {
  final IssueParams params;
  final int type;
  final QuotationParams quotationParams;
  CreateIssueButtonPresseEvent(
      {this.params,this.type,this.quotationParams});
  @override
  String toString() =>
      'CreateIssueButtonPresseEvent:  $params';
}

class UpdateSaleDateEvent extends CreateIssueEvent {
  final IssueParams params;
  final int type;
  final QuotationParams quotationParams;
  UpdateSaleDateEvent(
      {this.params,this.type,this.quotationParams});
  @override
  String toString() =>
      'UpdateSaleDateEvent:  $params';
}
