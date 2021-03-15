part of 'create_issue_bloc.dart';

abstract class CreateIssueEvent extends Equatable {
  const CreateIssueEvent();

  @override
  List<Object> get props => [];
}

class CreateIssueButtonPresseEvent extends CreateIssueEvent {
  final IssueParams params;
  final int type;
  CreateIssueButtonPresseEvent(
      {this.params,this.type});
  @override
  String toString() =>
      'CreateIssueButtonPresseEvent:  $params';
}
