import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/customer/data/models/product_category_model.dart';
import 'package:citizen_app/features/customer/data/models/promotion_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const DESCRIPTION_COLOR = Color(0xff353739);

class ProductCategoryItemWidget extends StatelessWidget {
  final ProductCategoryModel model;
  final Function onTap;

  ProductCategoryItemWidget({@required this.model, @required this.onTap});

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
          padding:
              const EdgeInsets.only(top: 10.0, left: 30, right: 30, bottom: 20),
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Container(
              // height: 150,
              // width: 250,//MediaQuery.of(context).size.width,
              //padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:  Colors.grey.shade50, //Colors.green.withOpacity(0.8),
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
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 85,
                          //height: 90,
                          //padding: EdgeInsets.all( 20),
                          //color: Colors.red,
                          child: ClipRRect(

                            //borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              model.imageUrl,
                              fit: BoxFit.cover,
                              width: 25,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace stackTrace) {
                                return Image.asset(
                                  IMAGE_ASSETS_PATH + 'supper_sale.png',
                                  fit: BoxFit.cover,
                                  // height: 120,
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
                              fontSize: FONT_LARGE,
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
                            model.description == null ? '' : model.description,
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
                          'Xem tất cả',
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
      ),
    );
  }
}
