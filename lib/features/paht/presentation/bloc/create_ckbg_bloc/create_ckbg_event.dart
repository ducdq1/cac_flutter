part of 'create_ckbg_bloc.dart';

abstract class CreateCKBGEvent extends Equatable {
  const CreateCKBGEvent();

  @override
  List<Object> get props => [];
}

class GetListCKBGDetailEvent extends CreateCKBGEvent {
  final int id;
  GetListCKBGDetailEvent(
      {this.id  });
  @override
  String toString() =>
      'GetListCKBGDetailEvent:  $id';
}

class CreateCKBGButtonPresseEvent extends CreateCKBGEvent {
  final IssueParams params;
  final int type;
  final CreateCKBGParams createCKBGParams;
  CreateCKBGButtonPresseEvent(
      {this.params,this.type,this.createCKBGParams});
  @override
  String toString() =>
      'CreateCKBGButtonPresseEvent:  $params';
}
