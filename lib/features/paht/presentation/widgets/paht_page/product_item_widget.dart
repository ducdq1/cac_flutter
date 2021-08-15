import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/core/functions/handle_time.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

const DESCRIPTION_COLOR = Color(0xff353739);

class ProductITemWidget extends StatelessWidget {
  final ProductModel pahtModel;
  final Function onTap;

  ProductITemWidget({@required this.pahtModel, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _itemWidget(context);
  }

  Widget _itemWidget(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.all(Radius.circular(6)),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.1),
                //     spreadRadius: 1,
                //     blurRadius: 1,
                //     offset: Offset(3, 3), // changes position of shadow
                //   ),
                // ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(right: 0),
                          child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      SVG_ASSETS_PATH + 'icon_info.svg',
                                      fit: BoxFit.scaleDown,
                                      width: 22,
                                      height: 22,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        pahtModel.productCode == null
                                            ? ''
                                            : pahtModel.productCode,
                                        style: GoogleFonts.inter(
                                          fontSize: FONT_MIDDLE,
                                          color: Color(0xff0F8E70),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 10),
                          child: Row(children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                pahtModel.productName == null
                                    ? ''
                                    : 'Sản phẩm: ' + pahtModel.productName,
                                style: GoogleFonts.inter(
                                  fontSize: FONT_MIDDLE,
                                  color: PRIMARY_TEXT_COLOR,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ]),
                        ),
                        pahtModel.unit == null || pahtModel.unit.isEmpty
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          text: pahtModel.unit == null
                                              ? ''
                                              : 'Đơn vị tính: ',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: FONT_MIDDLE,
                                            color: PRIMARY_TEXT_COLOR,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: pahtModel.unit == null
                                                  ? ''
                                                  : pahtModel.unit,
                                              style: GoogleFonts.inter(
                                                color: PRIMARY_TEXT_COLOR,
                                                fontSize: FONT_MIDDLE,
                                                fontWeight: FontWeight.normal,
                                                height: 1.7,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        pahtModel.size == null || pahtModel.size.isEmpty
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                        child: RichText(
                                      text: TextSpan(
                                        text: pahtModel.size == null
                                            ? ''
                                            : 'Kích thước: ',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: FONT_MIDDLE,
                                          color: PRIMARY_TEXT_COLOR,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: pahtModel.size == null
                                                ? ''
                                                : pahtModel.size,
                                            style: GoogleFonts.inter(
                                              color: PRIMARY_TEXT_COLOR,
                                              fontSize: FONT_MIDDLE,
                                              fontWeight: FontWeight.normal,
                                              height: 1.7,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                        pahtModel.feature == null || pahtModel.feature.isEmpty
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Tính năng: ',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: FONT_MIDDLE,
                                            color: PRIMARY_TEXT_COLOR,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: pahtModel.feature,
                                              style: GoogleFonts.inter(
                                                color: PRIMARY_TEXT_COLOR,
                                                fontSize: FONT_MIDDLE,
                                                fontWeight: FontWeight.normal,
                                                height: 1.7,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Xem chi tiết >>>',
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
