import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/core/functions/handle_time.dart';
import 'package:citizen_app/features/customer/data/models/promotion_model.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

const DESCRIPTION_COLOR = Color(0xff353739);

class PromotionItemWidget extends StatelessWidget {
  final PromotionModel model;
  final Function onTap;

  PromotionItemWidget({@required this.model, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _itemWidget(context);
  }

  Widget _itemWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0, left: 5),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      //color: Color(0xff82C341), //Colors.green.withOpacity(0.8),
                      //borderRadius: BorderRadius.all(Radius.circular(6)),
                      // boxShadow: [
                      //   BoxShadow(
                      //     // /color: Colors.grey.withOpacity(0.1),
                      //     //spreadRadius: 3,
                      //     //blurRadius: 3,
                      //    // offset: Offset(3, 3), // changes position of shadow
                      //   ),
                      // ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 120,
                            //padding: EdgeInsets.all( 20),
                            //color: Colors.red,
                            child: ClipRRect(
                              //borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                model.imageUrl ?? '',
                                //width: (MediaQuery.of(context).size.width - 70) / 3,
                                //height: 130,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception,
                                    StackTrace stackTrace) {
                                  return Image.asset(IMAGE_ASSETS_PATH + 'banner_new4.png',
                                    fit: BoxFit.cover,
                                   // height: 120,
                                  );
                                },
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Color(0xffE6EFF3).withOpacity(0.6),
                                    width: (MediaQuery.of(context).size.width - 70) / 3,
                                    //height: 150,
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: SizedBox(
                                              width: 15,
                                              height: 15,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.5,
                                                valueColor: new AlwaysStoppedAnimation<Color>(
                                                    PRIMARY_COLOR),
                                                value: loadingProgress.expectedTotalBytes !=
                                                    null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes
                                                    : null,
                                              )),
                                        )),
                                  );
                                },

                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                          bottom: 8.0, top: 0),
                                      child: Row(children: [
                                        Image.asset(
                                          ICONS_ASSETS + 'hot_deal1.png',
                                          width: 29,
                                          height: 29,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            model.name == null ? '' : model.name,
                                            style: GoogleFonts.inter(
                                              fontSize: FONT_MIDDLE,
                                              color: DESCRIPTION_COLOR,
                                              //Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            softWrap: true,
                                           // maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 0.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              model.description == null
                                                  ? ''
                                                  : model.description,
                                              style: GoogleFonts.inter(
                                                  color: DESCRIPTION_COLOR,
                                                  fontSize: FONT_MIDDLE,
                                                  height: 1.5),
                                              softWrap: true,
                                              //maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 00,
                  )
                ],
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  IMAGE_ASSETS_PATH + 'supper_sale.png',
                  height: 45,
                )),
            Positioned(
                top: 25,
                left: 8,
                child: Image.asset(
                  IMAGE_ASSETS_PATH + 'icon_hot.png',
                  height: 35,
                )),
            Positioned(
              top: 25,
              right: 13,
                child: Text(model.numberSaleOff !=null ? model.numberSaleOff.toString() : '',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: FONT_SMALL,
                      fontWeight: FontWeight.bold,
                      ),
                  softWrap: true,
                  //maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),)
          ]),
        ),
      ),
    );
  }
}
