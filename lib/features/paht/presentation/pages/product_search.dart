import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/resources/routers.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart'
    as paht_list_widget;
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/product_search_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/widgets.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchArgument {
  final bool isSaled;
  final bool isApproveAble;
  final bool fromCategoryPage;
  final int type;
  SearchArgument(
      {this.isSaled = false,
      this.isApproveAble,
      this.fromCategoryPage = false,
      this.type = -1 });
}

class ProductSearch extends StatefulWidget {
  ProductSearch();

  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch>
    implements OnButtonClickListener {
  bool isShowClearSearch = false;
  final searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  bool isSearch = false;
  bool isSaled = false;
  bool isApproveAble = false;
  bool fromCategory = false;
  int type = null;
  bool isAgent = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SearchArgument args =
        ModalRoute.of(context).settings.arguments as SearchArgument;
    if (args != null) {
      isSaled = args.isSaled;
      isApproveAble = args.isApproveAble;
      fromCategory = args.fromCategoryPage;
      type = args.type;
    }
    int userType = pref.getInt('userType');
    isAgent = userType == 4 ? true : false ;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: BlocProvider<PublicPahtBloc>(
            create: (context) => singleton<PublicPahtBloc>()
              ..add(ListProductFetchingEvent(offset: 0, limit: 100,type: type,isAgent: isAgent)),
            child: BlocConsumer<PublicPahtBloc, PublicPahtState>(
                listener: (context, state) {
              if (state is PublicPahtFailure) {
                // Fluttertoast.showToast(
                //     msg: state.error.toString()  );
              }
            }, builder: (context, state) {
              return BaseLayoutWidget(
                  title: '',
                  isTitleHeaderWidget: true,
                  titleHeaderWidget: SearchFormFieldWidget(
                    onChanged: (value) {
                      if (value.trim().isEmpty) {
                        setState(() {
                          isShowClearSearch = false;
                        });
                        BlocProvider.of<PublicPahtBloc>(context).add(
                            ListProductFetchingEvent(
                                search: searchController.text.trim(),
                                offset: 0,
                                limit: 100,
                            type: type, isAgent: isAgent));
                      }
                      if (value.isNotEmpty) {
                        setState(() {
                          isShowClearSearch = true;
                        });
                      }
                    },
                    onEditingComplete: () {
                      BlocProvider.of<PublicPahtBloc>(context).add(
                          ListProductFetchingEvent(
                              search: searchController.text.trim(),
                              offset: 0,
                              limit: 100,
                              type: type, isAgent: isAgent));
                    },
                    isSearch: isSearch,
                    isShowClearSearch: isShowClearSearch,
                    searchController: searchController,
                    searchFocus: searchFocus,
                  ),
                  body: state is SearchProductSuccess
                      ? ListViewProductsWidget(
                          hasReachedMax: state.hasReachedMax,
                          pahts: state.lstProduct,
                          paddingBottom: 00,
                          textSearch: searchController.text.trim(),
                          onTap: (value) {
                            if (fromCategory) {
                              Navigator.pushNamed(context, ROUTER_DETAILED_PAHT,
                                  arguments:
                                      paht_list_widget.PahtDetailArgument(
                                          productId: value,
                                          fromCategoryPage: true));
                            } else {
                              Navigator.pop(context, value);
                            }
                          },
                        )
                      : state is SearchProducttFailure
                          ? NoNetworkFailureWidget(
                              message: state.error.toString() == "UNAUTHORIZED"
                                  ? trans(MESSAGE_SESSION_EXPIRED)
                                  : state.error.toString(),
                              onPressed: () {
                                BlocProvider.of<PublicPahtBloc>(context).add(
                                  ListProductFetchingEvent(
                                      search: searchController.text.trim(),
                                      offset: 0,
                                      limit: 100,
                                      type: type, isAgent: isAgent),
                                );
                              })
                          : SkeletonPahtWidget());
            })));
  }

  @override
  onClick(String id) {
    if (id == 'primary_btn') {
      BlocProvider.of<PublicPahtBloc>(context).add(
          SearchPublicButtonPressedEvent(search: searchController.text.trim()));
    }
  }
}
