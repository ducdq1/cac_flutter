part of 'category_paht_bloc.dart';

abstract class CategoryPahtEvent extends Equatable {
  const CategoryPahtEvent();

  @override
  List<Object> get props => [];
}

class ListCategoriesFetched extends CategoryPahtEvent {}
