import 'dart:async';

import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/routers.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/no_network_failure_widget.dart';
import 'package:citizen_app/features/customer/presentation/bloc/productCategory/product_category_bloc.dart';
import 'package:citizen_app/features/customer/presentation/pages/product_category_page.dart';
import 'package:citizen_app/features/customer/presentation/widgets/product_category_list_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/citizens_menu_item_widget.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cus_product_search.dart';
import 'package:citizen_app/features/customer/presentation/pages/cus_product_search.dart' as productSearch;
class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Completer<void> _refreshCompleter;
  bool isRefresh = false;
  final scrollController = ScrollController();
  final scrollThreshold = 200.0;

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: 30, right: 30, left: 30, bottom: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(ICONS_ASSETS + 'icon_da_ban.png',
                            //     width: 40, height: 40),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'CH??NG T??I CUNG C???P',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 3,
                                    shadows: [Shadow(color:Colors.grey)]

                                  ),
                                  softWrap: true,
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.indigo,
                          thickness: 1,
                        ),
                      ])),
              SizedBox(
                height: 10,
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getItem(
                  label: 'THI???T B???',
                  icon: '/images/tb_noi_that.jpg',
                  onPress: () {
                    Navigator.pushNamed(context, ROUTER_CUS_PRODUCT_CATEGORY,
                        arguments: ProductCategoryArgument(type:0));
                  },
                ),
                getItem(
                  label: 'G???CH MEN',
                  icon: '/images/gach_men.jpg',
                  onPress: () {
                    Navigator.pushNamed(context, ROUTER_CUS_PRODUCT_CATEGORY,
                    arguments: ProductCategoryArgument(type:1))
                        .then((value) => {});
                  },
                ),
              ]),
              SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        getItem(
                          label: 'KHUY???N M??I',
                          icon: '/images/tb_kmx.jpg',
                          onPress: () {
                            Navigator.pushNamed(
                                context, ROUTER_CUS_SEARCH_PRODUCT,
                                arguments: productSearch.SearchArgument(
                                    fromCategoryPage: true,
                                    type: 2 ));
                          },
                        ),
                        Container(height: 200, width: 150),
                      ]),
                  Positioned(
                    left: 140,
                    child: Image.asset('assets/icons/hot_deal1.png',
                        width: 35, height: 35),
                  )
                ],
              ),
      ]),
      ),
    );
  }

  Widget getItem({String label, Function onPress, String icon}) {
    return Card(
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17.0),
      ),
      shadowColor: Colors.indigoAccent.withOpacity(0.3),
      elevation: 20,
      child: InkWell(
        onTap: () {
          onPress();
        },
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 180,
              width: 140,
              decoration: BoxDecoration(
                color: Color(0xffE6EFF3).withOpacity(0.6),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                      child: Image.asset(
                        'assets${icon}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    child: Text(
                      label.replaceAll("\n", "\n").replaceAll("/n", "\n"),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
