import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/tonkho_model.dart';
import 'package:citizen_app/features/paht/presentation/bloc/detailed_paht_bloc/detailed_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/appbar_heading_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/paht_info_tabview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../injection_container.dart';

const PADDING_CONTENT_HORIZONTAL = 16.0;
const SIZE_ARROW_BACK_ICON = 24.0;

class PahtDetailPage extends StatefulWidget {
  @override
  _PahtDetailPageState createState() => _PahtDetailPageState();
}

class SearchProductParam extends Equatable {
  final int productId;
  final String productCode;
  final String productName;
  final String userName;
  final int userType;
  final int limit;
  final int offset;
  final int type;
  final bool isAgent;
  final String code;
  final int searchType;
  final bool isGetPromotionProduct;
  final bool isViewTonKho;
  SearchProductParam({this.productCode, this.productName, this.userName,this.limit, this.offset, this.type = null,this.isAgent = false,this.code,this.searchType,this.productId,this.isGetPromotionProduct,this.userType,this.isViewTonKho = false});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  Map<String, dynamic> toJson() {
    return {
      'productCode': productCode == null ? '' : productCode,
      'productName': productName,
      'userName': userName,
      'userType' : userType,
      'limit' : limit,
      'offset' : offset,
       'type' : type,
      'isAgent': isAgent,
      'code' : code,
      'searchType' : searchType,
      'productId': productId,
      'isGetPromotionProduct' : isGetPromotionProduct,
      'isViewTonKho' : (userType == 3 || userType == 4)
    };
  }
}

class _PahtDetailPageState extends State<PahtDetailPage>
    with TickerProviderStateMixin {
  TabController _controller;
  final tabs = [trans(TITLE_INFORMATION_SCREEN), trans(LABEL_MEDIA_PAHT)];
  int _index;
  PahtDetailArgument arg;
  String productCode;
  int productId;
  ProductModel productModel;
  TonKhoModel tonKhoModel;
  bool firstLoad = true;

  @override
  void initState() {
    bool firstLoad = true;
    _controller = TabController(vsync: this, length: 2);
    _index = _controller.index;
    _controller.addListener(() {
      setState(() {
        _index = _controller.index;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(firstLoad){
      firstLoad = false;
      arg = ModalRoute.of(context).settings.arguments as PahtDetailArgument;
      productCode = arg.productCode;
      productId = arg.productId;
      BlocProvider.of<DetailedPahtBloc>(context).add(
        DetailedPahtFetching(pahtId: productCode,productId: arg.productId),
      );
    }

    return BaseLayoutWidget(
        title: 'Th??ng tin s???n ph???m',
        centerTitle: true,
        body: Scaffold(
          body: BlocConsumer<DetailedPahtBloc, DetailedPahtState>(
              listener: (context, state) {
            if (state is DetailedPahtFailure &&
                state.error.toString() == "UNAUTHORIZED") {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  ROUTER_SIGNIN, (Route<dynamic> route) => false);
            }
          }, builder: (context, state) {
            child:
            if (state is DetailedPahtSuccess) {
              if (state.searchProductModel.lstProduct != null &&
                  state.searchProductModel.lstProduct.isNotEmpty) {
                productModel = state.searchProductModel.lstProduct[0];
                tonKhoModel = state.searchProductModel.tonKhoModel;

                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      SizedBox(height: 0),
                      // TabBarCustomWidget(controller: _controller),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 0),
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: Container(
                              color: Colors.white,
                              child: PahtInfoTabViewWidget(
                                  productModel: productModel,
                                  tonKhoModel: tonKhoModel,
                                  isViewTonKho:  arg.fromCategoryPage == false,),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Text(
                              'Kh??ng t??m th???y th??ng tin c???a s???n ph???m: ' +
                                  productCode,
                              style: GoogleFonts.inter(
                                color: PRIMARY_TEXT_COLOR,
                                fontSize: FONT_MIDDLE,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ));
              }
            } else if (state is DetailedPahtFailure) {
              return NoNetworkFailureWidget(
                  message: state.error.toString() == "UNAUTHORIZED"
                      ? trans(MESSAGE_SESSION_EXPIRED)
                      : state.error.toString(),
                  onPressed: () {
                    BlocProvider.of<DetailedPahtBloc>(context)
                        .add(DetailedPahtFetching(pahtId: productCode,productId: productId));
                  });
            }
            return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SkeletonPahtWidget(
                      itemCount: 1,
                    ),
                    Text('??ang l???y th??ng tin...',
                        style: GoogleFonts.inter(
                          color: PRIMARY_TEXT_COLOR,
                          fontSize: FONT_MIDDLE,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ));
          }),
        ));
  }
}
