part of 'create_ckbg_bloc.dart';

abstract class CreateCKBGState extends Equatable {
  const CreateCKBGState();

  @override
  List<Object> get props => [];
}

class CreateCKBGInitial extends CreateCKBGState {}

class CreateCKBGLoading extends CreateCKBGState {

}

class CreateCKBGFailure extends CreateCKBGState {
  final dynamic error;

  CreateCKBGFailure({@required this.error});
}
class GetListCKBGDetailSuccess extends CreateCKBGState {
  final List<CKBGDetailModel> listCKBGDetailModel;
  GetListCKBGDetailSuccess({this.listCKBGDetailModel});
}

class GetListCKBGDetailLoading extends CreateCKBGState {
  GetListCKBGDetailLoading();
}

class CreateCKBGSuccess extends CreateCKBGState {
  final String fileName;
  CreateCKBGSuccess({this.fileName});
}

class RefreshState extends CreateCKBGState {}
