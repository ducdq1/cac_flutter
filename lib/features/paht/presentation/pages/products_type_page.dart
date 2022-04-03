import 'dart:async';

import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/routers.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/authentication/signin/presentation/signin_page.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/no_network_failure_widget.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/features/customer/presentation/bloc/productCategory/product_category_bloc.dart';
import 'package:citizen_app/features/customer/presentation/pages/product_category_page.dart';
import 'package:citizen_app/features/customer/presentation/widgets/product_category_list_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/citizens_menu_item_widget.dart';
import 'package:citizen_app/features/paht/data/repositories/paht_repository_impl.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:citizen_app/features/paht/presentation/pages/product_search.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../injection_container.dart';

class ProductsTypePage extends StatefulWidget {
  @override
  _ProductsTypePageState createState() => _ProductsTypePageState();
}

class _ProductsTypePageState extends State<ProductsTypePage> {
  Completer<void> _refreshCompleter;
  bool isRefresh = false;
  final scrollController = ScrollController();
  final scrollThreshold = 200.0;
  final pref = singleton<SharedPreferences>();

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    super.initState();
    checkUser();
  }

  void checkUser() async{
    String userName = pref.get('userName');
    String pw = pref.get('pw');
    PahtRepositoryImpl repo = PahtRepositoryImpl(localDataSource: singleton(),
      networkInfo: singleton(),
      remoteDataSource: singleton(),);
    print('Checking user........');

    bool isValidUser = await repo.checkUser(userName,pw);
    if (userName == null || isValidUser == false) {
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteTransition(
            animationType: AnimationType.slide_right,
            builder: (context) => SignInPage(isCustomer: false),
          ),
              (route) => false,
        );
      });
    }
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
                          top: 60, right: 30, left: 30, bottom: 40),
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
                                  'CHỌN DANH MỤC SẢN PHẨM',
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
                          label: 'THIẾT BỊ',
                          icon: '/images/tb_noi_that.jpg',
                          onPress: () {
                            Navigator.pushNamed(context, ROUTER_SEARCH_PRODUCT,
                                arguments: SearchArgument(type: 0));
                          },
                        ),
                        getItem(
                          label: 'GẠCH MEN',
                          icon: '/images/gach_men.jpg',
                          onPress: () {
                            Navigator.pushNamed(context, ROUTER_SEARCH_PRODUCT,
                                    arguments: SearchArgument(type: 1))
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
                              label: 'KHUYẾN MÃI',
                              icon: '/images/tb_kmx.jpg',
                              onPress: () {
                                Navigator.pushNamed(
                                    context, ROUTER_SEARCH_PRODUCT,
                                    arguments: SearchArgument(type: 2));
                              },
                            ),
                            Container(height: 200, width: 150),
                          ]),
                      Positioned(
                        left: 150,
                        child: Image.asset('assets/icons/hot_deal1.png',
                            width: 35, height: 35),
                      )
                    ],
                  ),
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
                        fontSize: 19,
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
