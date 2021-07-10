import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/customer/data/models/product_category_model.dart';
import 'package:citizen_app/features/customer/data/models/promotion_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const DESCRIPTION_COLOR = Color(0xff353739);

class ProductCategoryItemWidget extends StatelessWidget {
  final ProductCategoryModel model;
  final Function onTap;
  final String header;
  final bool showHeader;
  ProductCategoryItemWidget({@required this.model, @required this.onTap,this.header='Thiết bị',this.showHeader=true});

  @override
  Widget build(BuildContext context) {
    return _itemWidget(context);
  }

  Widget _itemWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 30, right: 30, bottom: 20),
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
             !showHeader? SizedBox() : Container(

                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset( ICONS_ASSETS + 'icon_da_ban.png',
                            width: 40,
                            height: 40),
                          SizedBox(width: 10,),
                          Text(
                          header,
                          style: GoogleFonts.inter(
                            fontSize: FONT_HUGE,
                            color: Color(0xff34A052),
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        )
                        ],
                      ),
                      Divider(
                        color: Colors.blue,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
              ),
              Container(
                decoration: BoxDecoration(
                  color: model.type== 0 ? Color(0xff39B65C).withOpacity(0.4): Color(0xffFFC59B).withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(2, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Image.network(
                                model.imageUrl ?? '',
                                fit: BoxFit.cover,
                                width: 25,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                  return Image.asset(
                                    IMAGE_ASSETS_PATH + 'supper_sale.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Color(0xffE6EFF3).withOpacity(0.6),
                                    width: 30,
                                    //height: 150,
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: SizedBox(
                                            width: 45,
                                            height: 45,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(PRIMARY_COLOR),
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                            ),
                                          ),
                                        )),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              model.name == null ? '' : model.name,
                              style: GoogleFonts.inter(
                                fontSize: FONT_HUGE,
                                color: DESCRIPTION_COLOR,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
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
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Xem tất cả >>>',
                            style: GoogleFonts.inter(
                                color: Colors.teal,
                                fontSize: FONT_SMALL,
                                fontStyle: FontStyle.italic,
                                height: 1.5),
                            softWrap: true,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 00,
              )
            ]),
          ),
          // Positioned(
          //     top: 15,
          //     left: 15,
          //     child: Image.asset(
          //       IMAGE_ASSETS_PATH + 'images.png',
          //       height: 30,
          //     )),
        ]),
      ),
    );
  }
}
