part of 'create_issue_bloc.dart';

abstract class CreateIssueState extends Equatable {
  const CreateIssueState();

  @override
  List<Object> get props => [];
}

class CreateIssueInitial extends CreateIssueState {}

class CreateIssueLoading extends CreateIssueState {}

class CreateIssueFailure extends CreateIssueState {
  final dynamic error;

  CreateIssueFailure({@required this.error});
}

class CreateIssueSuccess extends CreateIssueState {}

class RefreshState extends CreateIssueState {}
