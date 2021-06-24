import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/dialogs/delete_confirm_dialog.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/customer/data/models/product_category_model.dart';
import 'package:citizen_app/features/customer/data/models/promotion_model.dart';
import 'package:citizen_app/features/customer/presentation/bloc/productCategory/product_category_bloc.dart';
import 'package:citizen_app/features/customer/presentation/bloc/promotion/promotion_bloc.dart';
import 'package:citizen_app/features/customer/presentation/widgets/product_category_item_widget.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/presentation/bloc/personal_paht_bloc/personal_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/bottom_loader_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class _ListViewProductCategoryWidgetState extends State<ListViewProductCategoryWidget> {
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
        child: widget.promotions.length != 0
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
                                model: widget.promotions[index],
                            onTap: () {},
                          ),
                          ),
                        ),
                      );
                    },
                    // itemCount: widget.hasReachedMax
                    //     ? widget.pahts.length
                    //     : widget.pahts.length + 1,
                    itemCount: widget.promotions.length,
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
  final List<ProductCategoryModel> promotions;
  final ScrollController scrollController;
  ListViewProductCategoryWidget({@required this.promotions,@required  this.scrollController});

  @override
  _ListViewProductCategoryWidgetState createState() =>
      _ListViewProductCategoryWidgetState();
}
