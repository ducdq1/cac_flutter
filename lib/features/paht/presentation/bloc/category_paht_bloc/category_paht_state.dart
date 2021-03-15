part of 'category_paht_bloc.dart';

abstract class CategoryPahtState extends Equatable {
  const CategoryPahtState();

  @override
  List<Object> get props => [];
}

class CategoryPahtInitial extends CategoryPahtState {}

class CategoryPahtFailure extends CategoryPahtState {
  final dynamic error;

  CategoryPahtFailure({@required this.error});
  @override
  String toString() => 'CategoryPahtFailure $error';
}

class CategoryPahtSuccess extends CategoryPahtState {
  final List<CategoryModel> listCategories;

  CategoryPahtSuccess({@required this.listCategories});
  @override
  String toString() => 'CategoryPahtSuccess ${listCategories.length}';
}
