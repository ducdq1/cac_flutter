import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/resources/routers.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart'
    as paht_list_widget;
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/product_search_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/widgets.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/dialogs/delete_confirm_dialog.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
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

class SearchArgument {
  final bool isSaled;
  final bool isApproveAble;
  final bool fromCategoryPage;
  final int type;
  final String code;
  final int selectType;
  SearchArgument(
      {this.isSaled = false,
      this.isApproveAble,
      this.fromCategoryPage = false,
      this.type = -1,
      this.code,
  this.selectType = 0 });
}

class CusProductSearch extends StatefulWidget {
  CusProductSearch();

  @override
  _CusProductSearchState createState() => _CusProductSearchState();
}

class _CusProductSearchState extends State<CusProductSearch>
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
  String code;
  int selectType ;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    SearchArgument args =
        ModalRoute.of(context).settings.arguments as SearchArgument;
    if (args != null) {
      isSaled = args.isSaled;
      isApproveAble = args.isApproveAble;
      fromCategory = args.fromCategoryPage;
      type = args.type;
      code = args.code;
      selectType = args.selectType;
    }
    int userType = pref.getInt('userType');
    isAgent = userType == 4 ? true : false;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: BlocProvider<PublicPahtBloc>(
            create: (context) => singleton<PublicPahtBloc>()
              ..add(ListProductFetchingEvent(
                  offset: 0,
                  limit: 10,
                  type: type,
                  isAgent: isAgent,
                  code: code,
                  selectType: selectType  )),
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
                    onClear: (){
                      BlocProvider.of<PublicPahtBloc>(context).add(
                          ListProductFetchingEvent(
                              search: searchController.text.trim(),
                              offset: 0,
                              limit: 300,
                              type: type,
                              isAgent: false,
                              code: code,
                              selectType: selectType ));
                    },
                    onChanged: (value) {
                        // setState(() {
                        //   isShowClearSearch = false;
                        // });
                        BlocProvider.of<PublicPahtBloc>(context).add(
                            ListProductFetchingEvent(
                                search: searchController.text.trim(),
                                offset: 0,
                                limit: 300,
                                type: type,
                                isAgent: false,
                                code: code,
                                selectType: selectType ));
                      // if (value.isNotEmpty) {
                        setState(() {
                          isShowClearSearch = value.isNotEmpty;
                        });
                      // }
                    },
                    onEditingComplete: () {
                      BlocProvider.of<PublicPahtBloc>(context).add(
                          ListProductFetchingEvent(
                              search: searchController.text.trim(),
                              offset: 0,
                              limit: 300,
                              type: type,
                              isAgent: false,
                              code: code,
                              selectType: selectType ));
                    },
                    isSearch: isSearch,
                    isShowClearSearch: isShowClearSearch,
                    searchController: searchController,
                    searchFocus: searchFocus,
                  ),
                  body: state is SearchProductSuccess
                      ? state.lstProduct == null || state.lstProduct.length == 0
                          ? NoDataFailureWidget()
                          : Container(
                              color: Color(0xffF0F2F5),
                              child: AnimationLimiter(
                                child: GridView.count(
                                    // shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    childAspectRatio:
                                        (itemWidth / (itemHeight - 50)),
                                    padding: const EdgeInsets.all(10.0),
                                    mainAxisSpacing: 50.0,
                                    crossAxisSpacing: 20.0,
                                    children: _getTiles(state.lstProduct,
                                        context, itemWidth, itemHeight)),
                              ),
                            )
                      // ListViewProductsWidget(
                      //             hasReachedMax: state.hasReachedMax,
                      //             pahts: state.lstProduct,
                      //             paddingBottom: 00,
                      //             textSearch: searchController.text.trim(),
                      //             onTap: (value) {
                      //               if (fromCategory) {
                      //                 Navigator.pushNamed(context, ROUTER_DETAILED_PAHT,
                      //                     arguments:
                      //                         paht_list_widget.PahtDetailArgument(
                      //                             productCode: value,
                      //                             fromCategoryPage: true));
                      //               } else {
                      //                 Navigator.pop(context, value);
                      //               }
                      //             },
                      //           )
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
                                      limit: 10,
                                      type: type,
                                      isAgent: isAgent,
                                      code: code,
                                      selectType: selectType ),
                                );
                              })
                          : SkeletonPahtWidget());
            })));
  }

  List<Widget> _getTiles(List<ProductModel> products, BuildContext context,
      double itemWidth, double itemHeight) {
    final List<Widget> tiles = <Widget>[];
    for (int i = 0; i < products.length; i++) {
      ProductModel model = products[i];
      tiles.add(AnimationConfiguration.staggeredList(
        position: i,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: GridTile(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, ROUTER_DETAILED_PAHT,
                      arguments: paht_list_widget.PahtDetailArgument(
                          productCode: model.productCode,
                          fromCategoryPage: true));
                },
                child: Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    //Colors.grey.shade50, //Colors.green.withOpacity(0.8),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(3, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Expanded(
                      child: Container(
                        width: itemWidth,
                        //height: 200,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.only(topRight:Radius.circular(6),topLeft: Radius.circular(6)),
                          child:
                              //FadeInImage.memoryNetwork(placeholder: AssetImage('sdsadas'), image: '$baseUrl' + url),
                              model.image != null
                                  ? CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: baseUrl + model.image,
                                      placeholder: (context, url) => Center(
                                          child: Container(
                                              height: 40,
                                              width: 40,
                                              child:
                                                  new CircularProgressIndicator(
                                                      strokeWidth:
                                                          1.50))),
                                      height: 15,
                                      width: 15,
                                      errorWidget:
                                          (context, url, error) =>
                                              Padding(
                                        padding:
                                            const EdgeInsets.all(20.0),
                                        child: Image.asset(
                                          'assets/images/cac_logo.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.all(20.0),
                                      child: Image.asset(
                                        'assets/images/cac_logo.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(minHeight: 70),
                      width: itemWidth - 20,
                      decoration: BoxDecoration(
                        color: Color(0xffC2E591).withOpacity(0.9),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: 5, right: 8, left: 8, top: 8),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                model.productName?? '',
                                style: GoogleFonts.inter(
                                    // color: Color(0xff272727),
                                    color: Color(0xFF2E7D32),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                                softWrap: true,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                  mainAxisAlignment: model.productType > 1
                                      ? MainAxisAlignment.spaceBetween
                                      : MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      model.productType <= 1
                                          ? ''
                                          : model.size ?? '',
                                      style: GoogleFonts.inter(
                                          color: Colors.orange,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                      softWrap: true,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          'Đã bán: ' +
                                              new Random()
                                                  .nextInt(5000)
                                                  .toString(),
                                          style: GoogleFonts.inter(
                                              color: Colors.orange,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                          softWrap: true,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ])
                            ]),
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ),
        ),
      ));
    }
    return tiles;
  }

  @override
  onClick(String id) {
    if (id == 'primary_btn') {
      BlocProvider.of<PublicPahtBloc>(context).add(
          SearchPublicButtonPressedEvent(search: searchController.text.trim()));
    }
  }
}
