import 'dart:async';

import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/routers.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/no_network_failure_widget.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
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

class ProductsTypePage extends StatefulWidget {
  @override
  _ProductsTypePageState createState() => _ProductsTypePageState();
}

class _ProductsTypePageState extends State<ProductsTypePage> {
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
    return BaseLayoutWidget(
        title: 'Danh mục sản phẩm',
        // isTitleHeaderWidget: true,
        body: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: 120, right: 50, left: 50, bottom: 50),
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
                                Text(
                                  'CÔNG TY CHÚNG TÔI CUNG CẤP',
                                  style: GoogleFonts.inter(
                                    fontSize: FONT_HUGE,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
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
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        getItem(
                          label: 'Thiết bị',
                          icon: '/images/tb_noi_that.jpg',
                          onPress: () {
                            Navigator.pushNamed(
                                context, ROUTER_CUS_PRODUCT_CATEGORY,
                                arguments: ProductCategoryArgument(type: 0));
                          },
                        ),
                        getItem(
                          label: 'Gạch men',
                          icon: '/images/gach_men.jpg',
                          onPress: () {
                            Navigator.pushNamed(
                                    context, ROUTER_CUS_PRODUCT_CATEGORY,
                                    arguments: ProductCategoryArgument(type: 1))
                                .then((value) => {});
                          },
                        ),
                      ]),
                ])));
  }

  Widget getItem({String label, Function onPress, String icon}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17.0),
      ),
      elevation: 20,
      child: InkWell(
        onTap: () {
          onPress();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 150,
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
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
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
                        fontSize: 20,
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
