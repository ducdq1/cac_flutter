import 'dart:async';

import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/routers.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/no_network_failure_widget.dart';
import 'package:citizen_app/features/customer/presentation/bloc/promotion/promotion_bloc.dart';
import 'package:citizen_app/features/customer/presentation/widgets/promotion_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cus_product_search.dart';


class PromotionPage extends StatefulWidget {

  @override
  _PromotionPageState createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  Completer<void> _refreshCompleter;
  bool isRefresh = false;
  final scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
        alignment: Alignment.center,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: 80, right: 10, left: 10, bottom: 50),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/hot_deal1.png',
                                width: 40, height: 40),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                'CHƯƠNG TRÌNH KHUYẾN MÃI',
                                style: GoogleFonts.inter(
                                  fontSize: FONT_HUGE,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.red,
                          thickness: 0.5,
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
                      label: 'THIẾT BỊ',
                      icon: '/images/tb_noi_that.jpg',
                      onPress: () {
                        Navigator.pushNamed(
                            context, ROUTER_CUS_SEARCH_PRODUCT,
                            arguments: SearchArgument(
                                fromCategoryPage: true,
                                type:  0 ,
                                isGetPromotionProduct: true) );
                      },
                    ),
                    getItem(
                      label: 'GẠCH MEN',
                      icon: '/images/gach_men.jpg',
                      onPress: () {
                        Navigator.pushNamed(
                            context, ROUTER_CUS_SEARCH_PRODUCT,
                            arguments: SearchArgument(
                                fromCategoryPage: true,
                                type:  2 ,
                                isGetPromotionProduct: true) );
                      }),
                  ])
            ]),
      ),
    );
  }

  Widget getItem({String label, Function onPress, String icon}) {
    return Card(
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17.0),
      ),
      elevation: 20,
      shadowColor: Colors.redAccent.withOpacity(0.3),
      child: InkWell(
        onTap: () {
          onPress();
        },
        child: Column(
          //mainAxisSize: MainAxisSize.min,
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
                        color: Colors.red,
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
