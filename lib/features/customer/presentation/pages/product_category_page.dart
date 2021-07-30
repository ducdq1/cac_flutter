import 'dart:async';

import 'package:citizen_app/features/common/widgets/failure_widget/no_network_failure_widget.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/features/customer/presentation/bloc/productCategory/product_category_bloc.dart';
import 'package:citizen_app/features/customer/presentation/widgets/product_category_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class ProductCategoryArgument {
  final int type;

  ProductCategoryArgument(
      {this.type});
}

class ProductCategoryPage extends StatefulWidget {
  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  Completer<void> _refreshCompleter;
  bool isRefresh = false;
  final scrollController = ScrollController();
  final scrollThreshold = 200.0;
  int type;
  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    super.initState();
    // ProductCategoryArgument args =
    // ModalRoute.of(context).settings.arguments as ProductCategoryArgument;
    // type = args.type;

  }

  void handleRefresh(context) {
    setState(() {
      isRefresh = !isRefresh;
    });
    BlocProvider.of<ProductCategoryBloc>(context).add(
      ListProductCategoriesFetching(type: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProductCategoryArgument args =
    ModalRoute.of(context).settings.arguments as ProductCategoryArgument;
    type = args.type;
    return Container(
      child: RefreshIndicator(
        onRefresh: () async => handleRefresh(context),
        child: BlocProvider<ProductCategoryBloc>(
            create: (context) => singleton<ProductCategoryBloc>()
              ..add(
                ListProductCategoriesFetching(type: type),
              ),
            child: BlocConsumer<ProductCategoryBloc, ProductCategoryState>(
              listener: (context, state) {
                _refreshCompleter?.complete();
                _refreshCompleter = Completer();
              },
              builder: (context, state) {
                return BaseLayoutWidget(
                    title: 'Danh mục sản phẩm',
                   // isTitleHeaderWidget: true,
                    body: state is ProductCategoryFailure
                        ? NoNetworkFailureWidget(
                            message: state.error.message,
                            onPressed: () {
                              BlocProvider.of<ProductCategoryBloc>(context)
                                  .add(ListProductCategoriesFetching(type: type));
                            })
                        : state is ProductCategorySuccess
                            ? ListViewProductCategoryWidget(
                                 type: type,
                                categories: state.listCategories,
                                scrollController: scrollController,
                              )
                            : SkeletonPahtWidget());
              },
            )),
      ),
    );
  }
}
