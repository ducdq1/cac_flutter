import 'dart:async';

import 'package:citizen_app/features/common/widgets/failure_widget/no_network_failure_widget.dart';
import 'package:citizen_app/features/customer/presentation/bloc/productCategory/product_category_bloc.dart';
import 'package:citizen_app/features/customer/presentation/widgets/product_category_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCategoryPage extends StatefulWidget {
  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  Completer<void> _refreshCompleter;
  bool isRefresh = false;
  final scrollController = ScrollController();
  final scrollThreshold = 200.0;

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    super.initState();
  }

  void handleRefresh(context) {
    setState(() {
      isRefresh = !isRefresh;
    });
    BlocProvider.of<PublicPahtBloc>(context).add(
      ListPublicPahtFetchingEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 0, right: 0, bottom: 20),
      child: Container(
        child: RefreshIndicator(
          onRefresh: () async => handleRefresh(context),
          child: BlocConsumer<ProductCategoryBloc, ProductCategoryState>(
            listener: (context, state) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            },
            builder: (context, state) {
              if (state is ProductCategoryFailure) {
                return NoNetworkFailureWidget(
                    message: state.error.message,
                    onPressed: () {
                      BlocProvider.of<ProductCategoryBloc>(context)
                          .add(ListProductCategoriesFetching());
                    });
              }
              if (state is ProductCategorySuccess) {
                return ListViewProductCategoryWidget(
                  categories: state.listCategories,
                  scrollController: scrollController,
                );
              }

              return SkeletonPahtWidget();
            },
          ),
        ),
      ),
    );
  }
}
