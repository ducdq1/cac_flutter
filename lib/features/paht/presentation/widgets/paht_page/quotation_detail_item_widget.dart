import 'package:cached_network_image/cached_network_image.dart';
import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/core/functions/handle_time.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const DESCRIPTION_COLOR = Color(0xff353739);

class QuotationDetailItemWidget extends StatelessWidget {
  final QuotationDetailModel quotationDetailModel;
  final Function onTap;
  final bool isPersonal;
  final Function onEdit;
  final Function onDelete;

  QuotationDetailItemWidget(
      {@required this.quotationDetailModel,
      @required this.onTap,
      @required this.isPersonal,
      this.onDelete,
      this.onEdit});

  @override
  Widget build(BuildContext context) {
    return !isPersonal
        ? Slidable.builder(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            secondaryActionDelegate: SlideActionBuilderDelegate(
                actionCount: 2,
                builder: (context, index, animation, renderingMode) {
                  if (index == 0) {
                    return IconSlideAction(
                      color: Color.fromRGBO(97, 120, 130, 0.2),
                      iconWidget: SvgPicture.asset(
                        SVG_ASSETS_PATH + 'icon_edit.svg',
                        color: Color.fromRGBO(53, 55, 57, 0.8),
                        height: 24,
                        width: 24,
                      ),
                      onTap: onEdit,
                    );
                  } else {
                    return IconSlideAction(
                      color: Color.fromRGBO(221, 48, 48, 0.9),
                      onTap: onDelete,
                      iconWidget: SvgPicture.asset(
                        SVG_ASSETS_PATH + 'icon_recycle_bin.svg',
                        height: 28,
                        width: 23,
                      ),
                    );
                  }
                }),
            child: _itemWidget(context),
          )
        : _itemWidget(context);
  }

  Widget _itemWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: quotationDetailModel.price !=null ? Colors.green.shade100 : Colors.amber.shade100,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 0,
                    offset: Offset(3, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text('S???n ph???m:',
                                style: GoogleFonts.inter(
                                    color: DESCRIPTION_COLOR,
                                    fontSize: FONT_SMALL,
                                    height: 1.5,
                                    fontWeight: FontWeight.bold),
                                softWrap: true),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                quotationDetailModel.productName == null
                                    ? ''
                                    : quotationDetailModel.productName,
                                style: GoogleFonts.inter(
                                    color: DESCRIPTION_COLOR,
                                    fontSize: FONT_SMALL,
                                    height: 1.5),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                            children: [
                              Text('M?? SP:',
                                  style: GoogleFonts.inter(
                                      color: DESCRIPTION_COLOR,
                                      fontSize: FONT_SMALL,
                                      height: 1.5,
                                      fontWeight: FontWeight.bold),
                                  softWrap: true),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Text(
                                quotationDetailModel.productCode == null
                                    ? ''
                                    : quotationDetailModel.productCode,
                                style: GoogleFonts.inter(
                                    color: DESCRIPTION_COLOR,
                                    fontSize: FONT_SMALL,
                                    height: 1.5),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ))
                            ],
                          ),
                        ),
                        quotationDetailModel.amount == null
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Text('S??? l?????ng:',
                                        style: GoogleFonts.inter(
                                            color: DESCRIPTION_COLOR,
                                            fontSize: FONT_SMALL,
                                            height: 1.5,
                                            fontWeight: FontWeight.bold),
                                        softWrap: true),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        quotationDetailModel.amount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") +
                                            ' ' +
                                            (quotationDetailModel.unit != null
                                                ? quotationDetailModel.unit
                                                    .toString()
                                                : ''),
                                        style: GoogleFonts.inter(
                                            color: DESCRIPTION_COLOR,
                                            fontSize: FONT_SMALL,
                                            height: 1.5))
                                  ],
                                ),
                              ),
                        (quotationDetailModel.value == null ||
                                quotationDetailModel.value == 0)
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Text('Th??nh ti???n:',
                                        style: GoogleFonts.inter(
                                            color: DESCRIPTION_COLOR,
                                            fontSize: FONT_SMALL,
                                            height: 1.5,
                                            fontWeight: FontWeight.bold),
                                        softWrap: true),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        NumberFormat.currency(locale: 'vi')
                                                .format(
                                                    quotationDetailModel.value)
                                            ,
                                        style: GoogleFonts.inter(
                                            color: DESCRIPTION_COLOR,
                                            fontSize: FONT_SMALL,
                                            height: 1.5))
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  quotationDetailModel.image == null
                      ? SizedBox()
                      : Container(
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: '$baseUrl' +
                                  quotationDetailModel.image.path +
                                  quotationDetailModel.image.name,
                              placeholder: (context, url) =>
                                  new CircularProgressIndicator(
                                      strokeWidth: 2.0),
                              height: 15,
                              width: 15,
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                          ),
                        )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
