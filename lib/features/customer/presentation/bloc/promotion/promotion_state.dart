part of 'promotion_bloc.dart';

abstract class PromotionState extends Equatable {
  const PromotionState();

  @override
  List<Object> get props => [];
}

class PromotionInitial extends PromotionState {}

class PromotionFailure extends PromotionState {
  final dynamic error;

  PromotionFailure({@required this.error});
  @override
  String toString() => 'PromotionFailure $error';
}

class PromotionSuccess extends PromotionState {
  final List<PromotionModel> listCategories;

  PromotionSuccess({@required this.listCategories});
  @override
  String toString() => 'PromotionSuccess ${listCategories.length}';
}
