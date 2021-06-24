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

class PromotionLoading extends PromotionState {
  PromotionLoading();
  @override
  String toString() => 'PromotionLoading}';
}

class PromotionSuccess extends PromotionState {
  final List<PromotionModel> listPromotion;

  PromotionSuccess({@required this.listPromotion});
  @override
  String toString() => 'PromotionSuccess ${listPromotion.length}';
}
