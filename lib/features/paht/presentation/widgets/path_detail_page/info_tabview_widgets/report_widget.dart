import 'package:cached_network_image/cached_network_image.dart';
import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/features/paht/data/models/image_model.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/tonkho_model.dart';
import 'package:citizen_app/features/paht/domain/entities/image_entity.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'dart:math';

import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/domain/entities/place_images_entity.dart';
import 'package:citizen_app/features/paht/presentation/pages/media_presenter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/services.dart';

class ReportWidget extends StatelessWidget {
  final ProductModel productModel;
  final TonKhoModel tonKhoModel;

  ReportWidget({this.productModel, this.tonKhoModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        ///color: Color(0xffE6EFF3).withOpacity(0.6),
        color: Color.fromARGB(153, 250, 245, 232),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Color(0xfff1e3c0),
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                SizedBox(width: 10),
                Image.asset(
                  ICONS_ASSETS + 'icon_info.png',
                  width: 32,
                  height: 32,
                ),
                SizedBox(width: 10),
                Text("Thông tin",
                    style: GoogleFonts.inter(
                      fontSize: FONT_EX_MIDDLE,
                      color: Color(0xff0F8E70),
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(children: [
            SizedBox(width: 30),
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_poi_name.svg',
            ),
            SizedBox(width: 10),
            Expanded(
                child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Text("Tên Sản phẩm",
                      style: GoogleFonts.inter(
                        fontSize: FONT_MIDDLE,
                        color: PRIMARY_TEXT_COLOR,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(height: 10),
                  Text(
                    productModel == null ? "" : productModel.productName,
                    style: GoogleFonts.inter(
                      fontSize: FONT_MIDDLE,
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]))),
          ]),
          SizedBox(height: 18),
          Row(
            children: [
              SizedBox(width: 30),
              Image.asset(
                ICONS_ASSETS + 'icon_scan_qr.png',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    Text("Mã Sản phẩm",
                        style: GoogleFonts.inter(
                          fontSize: FONT_MIDDLE,
                          color: PRIMARY_TEXT_COLOR,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(height: 10),
                    Text(
                      productModel == null ? "" : productModel.productCode,
                      style: GoogleFonts.inter(
                        fontSize: FONT_MIDDLE,
                        color: Colors.amber.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]))),
            ],
          ),
          SizedBox(height: 18),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 30),
                Image.asset(
                  ICONS_ASSETS + 'icon_ware_house.png',
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                    child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                      Text("Tồn kho",
                          style: GoogleFonts.inter(
                            fontSize: FONT_MIDDLE,
                            color: PRIMARY_TEXT_COLOR,
                            fontWeight: FontWeight.w600,
                          )),
                      SizedBox(height: 10),
                      Text(
                        tonKhoModel == null || tonKhoModel.so_luong == null
                            ? "Không có thông tin"
                            : tonKhoModel.so_luong.toString(),
                        style: GoogleFonts.inter(
                          color: Colors.amber.shade900,
                          fontSize: FONT_MIDDLE,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ])))
              ]),
          SizedBox(height: 10),
          Container(
              // color: Color(0xfff1e3c0),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                ///color: Color(0xffE6EFF3).withOpacity(0.6),
                color: Color(0xfff1e3c0),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Image.asset(
                    ICONS_ASSETS + 'icon_images.png',
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(width: 10),
                  Text("Hình ảnh",
                      style: GoogleFonts.inter(
                        fontSize: FONT_EX_MIDDLE,
                        color: Color(0xff0F8E70),
                        fontWeight: FontWeight.w600,
                      )),
                ],
              )),
          Expanded(
            child: Container(
                padding: EdgeInsets.all(5),
                //width: ,
                width: MediaQuery.of(context).size.width,
                child: productModel.images.isNotEmpty
                    ? GridView.count(
                        // shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                        padding: const EdgeInsets.all(4.0),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        children: _getTiles(productModel.images, context)
    )
                    : Text("Không có hình ảnh",
                        style: GoogleFonts.inter(
                          fontSize: FONT_EX_MIDDLE,
                          color: Color(0xff0F8E70),
                          fontWeight:
                          FontWeight.w600,
                        ))),
          ),
        ],
      ),
    );
  }

  List<Widget> _getTiles(List<ImageModel> imageModels, BuildContext context) {
    final List<Widget> tiles = <Widget>[];
    for (int i = 0; i < imageModels.length; i++) {
      ImageModel imageModel = imageModels[i];
      tiles.add(GridTile(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child:
            //FadeInImage.memoryNetwork(placeholder: AssetImage('sdsadas'), image: '$baseUrl' + url),
            InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MediaPresenterPage(
                          urls: productModel.images,
                          initialIndex: i,
                        ),
                  ),
                );
                SystemChrome.setSystemUIOverlayStyle(
                    SystemUiOverlayStyle.light);
                SystemChrome.setSystemUIOverlayStyle(
                  SystemUiOverlayStyle(
                      statusBarColor: PRIMARY_COLOR),
                );
              },
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: '$baseUrl' + imageModel.path + imageModel.name,
                placeholder: (context, url) =>
                new CircularProgressIndicator(
                    strokeWidth: 2.0),
                height: 15,
                width: 15,
                errorWidget: (context, url, error) =>
                new Icon(Icons.error),
              ),
            ),
          )));
    }
    return tiles;
  }

}
