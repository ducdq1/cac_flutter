import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:chewie/chewie.dart';
import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/paht/data/models/image_model.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/tonkho_model.dart';
import 'package:citizen_app/features/paht/domain/entities/image_entity.dart';
import 'package:citizen_app/features/paht/presentation/pages/video_player_page.dart';
//import 'package:citizen_app/features/paht/presentation/pages/video_player_page.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:citizen_app/features/common/dialogs/view_feature_product_dialog.dart';
import 'package:citizen_app/features/common/dialogs/view_price_dialog.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/domain/entities/place_images_entity.dart';
import 'package:citizen_app/features/paht/presentation/pages/media_presenter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io' as io;

import '../../../../../../injection_container.dart';

class ReportWidget extends StatelessWidget {
  final ProductModel productModel;
  final TonKhoModel tonKhoModel;
  final pref = singleton<SharedPreferences>();
  final bool isViewTonKho;

  ReportWidget({this.productModel, this.tonKhoModel, this.isViewTonKho = true});

  @override
  Widget build(BuildContext context) {
    int userType = pref.getInt('userType');
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
            children: [
              SizedBox(width: 30),
              Image.asset(
                ICONS_ASSETS + 'icon_money.png',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    Text(
                      "Giá bán",
                      style: GoogleFonts.inter(
                        fontSize: FONT_MIDDLE,
                        color: PRIMARY_TEXT_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    productModel.salePrice != null &&
                            productModel.salePrice.isNotEmpty
                        ? Text(
                            productModel.salePrice ?? 'Chưa có giá bán',
                            style: GoogleFonts.inter(
                              fontSize: productModel.priceBLKM != null &&
                                      productModel.priceBLKM.isNotEmpty
                                  ? FONT_SMALL
                                  : FONT_MIDDLE,
                              color: productModel.priceBLKM != null &&
                                      productModel.priceBLKM.isNotEmpty
                                  ? Colors.grey
                                  : Colors.amber.shade900,
                              fontWeight: FontWeight.w600,
                              textStyle: productModel.priceBLKM != null &&
                                      productModel.priceBLKM.isNotEmpty
                                  ? TextStyle(
                                      decoration: TextDecoration.lineThrough)
                                  : null,
                            ),
                          )
                        : SizedBox(),
                    productModel.priceBLKM != null &&
                            productModel.priceBLKM.isNotEmpty
                        ? Text(
                            productModel.priceBLKM ?? 'Chưa có giá bán',
                            style: GoogleFonts.inter(
                              fontSize: FONT_MIDDLE,
                              color: Colors.amber.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : SizedBox(),
                  ]))),
            ],
          ),
          isViewTonKho
              ? Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Row(
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
                                  tonKhoModel == null ||
                                          tonKhoModel.so_luong == null
                                      ? "Không có thông tin"
                                      : tonKhoModel.so_luong.toString(),
                                  style: GoogleFonts.inter(
                                    color: Colors.amber.shade900,
                                    fontSize: FONT_MIDDLE,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                        ))
                      ]),
                )
              : SizedBox(),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                    width: 150,
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: RaisedButton(
                        color: PRIMARY_COLOR,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36),
                        ),
                        onPressed: () {
                          showViewFeatureProductDialog(
                              context: context, model: productModel);
                        },
                        child: AutoSizeText(
                          'Xem thông tin',
                          style: GoogleFonts.inter(
                            fontSize: FONT_EX_SMALL,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: FONT_EX_SMALL,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))),
              ),
              userType != null && (userType == 3 || userType == 4)
                  ? //cho xem gia
                  Center(
                      child: Container(
                          width: 150,
                          padding: const EdgeInsets.only(bottom: 5.0, left: 7),
                          child: RaisedButton(
                              color: PRIMARY_COLOR,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(36),
                              ),
                              onPressed: () {
                                showViewPriceDialog(
                                    context: context,
                                    giaBan: productModel.salePrice != null
                                        ? productModel.salePrice.toString()
                                        : "Chưa có giá",
                                    giaNhap: productModel.price != null
                                        ? productModel.price.toString()
                                        : "Chưa có giá",
                                    ngayCapNhat: productModel.createDate,
                                    model: productModel);
                              },
                              child: AutoSizeText(
                                'Xem giá',
                                style: GoogleFonts.inter(
                                  fontSize: FONT_EX_SMALL,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                minFontSize: FONT_EX_SMALL,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))),
                    )
                  : SizedBox(),
            ],
          ),
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
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        padding: const EdgeInsets.all(4.0),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        children: _getTiles(productModel.images, context))
                    : Text("Không có hình ảnh",
                        style: GoogleFonts.inter(
                          fontSize: FONT_EX_MIDDLE,
                          color: Color(0xff0F8E70),
                          fontWeight: FontWeight.w600,
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
          child: Container(
        decoration: BoxDecoration(
          color: Color(0xfff1e3c0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child:
                  //FadeInImage.memoryNetwork(placeholder: AssetImage('sdsadas'), image: '$baseUrl' + url),
                  InkWell(
                onTap: () async {
                  if (isVideoFile(imageModel.name)) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerPage(
                          url: Uri.encodeFull('$baseUrl' + imageModel.path + imageModel.name)
                          
                          //'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
                          //'$baseUrl' + imageModel.path + imageModel.name,
                        ),
                      ),
                    );
                  } else {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MediaPresenterPage(
                          urls: productModel.images,
                          initialIndex: i,
                        ),
                      ),
                    );
                    SystemChrome.setSystemUIOverlayStyle(
                        SystemUiOverlayStyle.light);
                    SystemChrome.setSystemUIOverlayStyle(
                      SystemUiOverlayStyle(statusBarColor: PRIMARY_COLOR),
                    );
                  }
                },
                child: isVideoFile(imageModel.name)
                    ? Stack(children: [
                            // Center(
                            //     child: Image.file(
                            //       snapshot.data,
                            //       fit: BoxFit.cover,
                            //     )),
                            Center(
                              child: Image.asset(
                                ICONS_ASSETS + 'icon_play.png',
                                width: 100,
                                height: 100,
                              ),
                            )
                          ]) 
                    : CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                  '$baseUrl' + imageModel.path + imageModel.name,
                  height: 15,
                  width: 15,
                  errorWidget: (context, url, error) =>
                  new Icon(Icons.error),
                ),
              )),
        ),
      )));
    }
    return tiles;
  }

  Future<io.File> getThumnail(ImageModel imageModel) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: '$baseUrl' + imageModel.path + imageModel.name,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      //maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 100,
    );
    final file = io.File(thumbnail);
    String filePath = file.path;

    return file;
  }
 

  bool isVideoFile(String fileName) {
    fileName = fileName.toLowerCase();
    if (fileName.endsWith(".mp4") ||
        fileName.endsWith(".3gp") ||
        fileName.endsWith(".amv") ||
        fileName.endsWith(".avi") ||
        fileName.endsWith(".mov") ||
        fileName.endsWith(".fmp4") ||
        fileName.endsWith(".wav")) {
      return true;
    }
    return false;
  }

  @override
  onClick(String id) {
    // TODO: implement onClick
    throw UnimplementedError();
  }
}
