import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/customer/data/models/product_category_model.dart';
import 'package:citizen_app/features/customer/presentation/bloc/productCategory/product_category_bloc.dart';
import 'package:citizen_app/features/customer/presentation/widgets/product_category_item_widget.dart';
import 'package:citizen_app/features/paht/presentation/pages/pages.dart';
import 'package:citizen_app/features/paht/presentation/pages/product_search.dart' as productSearch;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class _ListViewProductCategoryWidgetState
    extends State<ListViewProductCategoryWidget> {
  bool isLoadingVertical = false;
  bool loadmore = false;
  bool isApproveAble = false;
  bool isSaled = false;

  handleRefresh(context) {
    BlocProvider.of<ProductCategoryBloc>(context).add(
      ListProductCategoriesFetching(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: widget.categories.length != 0
            ? LazyLoadScrollView(
                onEndOfPage: () => {},
                isLoading: isLoadingVertical,
                child: RefreshIndicator(
                  onRefresh: () async => {handleRefresh(context)},
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 0),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: ProductCategoryItemWidget(
                              model: widget.categories[index],
                              onTap: () {
                                Navigator.pushNamed(
                                        context, ROUTER_SEARCH_PRODUCT,
                                        arguments: productSearch.SearchArgument(
                                    fromCategoryPage: true,
                                        type:  widget.categories[index].type ))
                                    .then((value) => {});
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    // itemCount: widget.hasReachedMax
                    //     ? widget.pahts.length
                    //     : widget.pahts.length + 1,
                    itemCount: widget.categories.length,
                    controller: widget.scrollController,
                  ),
                ),
              )
            : NoDataFailureWidget(),
      ),
    );
  }
}

class ListViewProductCategoryWidget extends StatefulWidget {
  final List<ProductCategoryModel> categories;
  final ScrollController scrollController;

  ListViewProductCategoryWidget(
      {@required this.categories, @required this.scrollController});

  @override
  _ListViewProductCategoryWidgetState createState() =>
      _ListViewProductCategoryWidgetState();
}
