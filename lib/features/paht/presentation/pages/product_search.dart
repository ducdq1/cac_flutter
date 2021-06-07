import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/routers.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/presentation/bloc/personal_paht_bloc/personal_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/product_search_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/widgets.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/dialogs/input_dialog.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';
import 'package:citizen_app/features/home/presentation/pages/home_page.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/banner_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/citizens_menu_item_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart' as paht_list_widget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';

class SearchArgument {
  final bool isSaled;
  final bool isApproveAble;

  SearchArgument({this.isSaled = false, this.isApproveAble});
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
  var items = List<PahtModel>();
  bool isSearch = false;
  bool isSaled = false;
  bool isApproveAble = false;

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
    }
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: BlocProvider<PublicPahtBloc>(
            create: (context) => singleton<PublicPahtBloc>()
              ..add(ListProductFetchingEvent(
                  offset: 0, limit: 100)),
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
                                search: searchController.text.trim() , offset: 0, limit: 100
                              ));
                      }
                      if (value.isNotEmpty) {
                        setState(() {
                          isShowClearSearch = true;
                        });

                      }
                    }, onEditingComplete: () {
                    BlocProvider.of<PublicPahtBloc>(context).add(
                        ListProductFetchingEvent(
                            search: searchController.text.trim(),offset: 0, limit: 100
                             ));
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
                          onTap: (value){
                            Navigator.pop(context,  value);
                          },
                        )
                      : state is PublicPahtFailure
                          ? NoNetworkFailureWidget(
                              message: state.error.toString() == "UNAUTHORIZED"
                                  ? trans(MESSAGE_SESSION_EXPIRED)
                                  : state.error.toString(),
                              onPressed: () {
                                BlocProvider.of<PublicPahtBloc>(context).add(
                                  ListProductFetchingEvent(
                                      search: searchController.text.trim() , offset: 0, limit: 100
                                  ),
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
