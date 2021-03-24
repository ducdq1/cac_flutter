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
                      caption: 'Delete',
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
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                              children: [
                              Text(
                              'Sản phẩm:',
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
                                    : quotationDetailModel.productName.length < 60
                                    ? quotationDetailModel.productName
                                    : quotationDetailModel.productName
                                    .substring(0, 60) +
                                    '...',
                                style: GoogleFonts.inter(
                                    color: DESCRIPTION_COLOR,
                                    fontSize: FONT_SMALL,
                                    height: 1.5),
                                softWrap: true),
                          )]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                            children: [
                              Text(
                                  'Mã SP:',
                                  style: GoogleFonts.inter(
                                      color: DESCRIPTION_COLOR,
                                      fontSize: FONT_SMALL,
                                      height: 1.5,
                                  fontWeight: FontWeight.bold),
                                  softWrap: true),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(child: Text(
                                  quotationDetailModel.productCode == null
                                      ? ''
                                      : quotationDetailModel.productCode.length < 60
                                          ? quotationDetailModel.productCode
                                          : quotationDetailModel.productCode
                                                  .substring(0, 60) +
                                              '...',
                                  style: GoogleFonts.inter(
                                      color: DESCRIPTION_COLOR,
                                      fontSize: FONT_SMALL,
                                      height: 1.5),
                                  softWrap: true)
                              )
                            ],
                          ),
                        ),
                        quotationDetailModel.amount == null
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Text(
                                        'Số lượng:',
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
                                        quotationDetailModel.amount == null
                                            ? ''
                                            : quotationDetailModel.amount.toString(),
                                        style: GoogleFonts.inter(
                                          color: DESCRIPTION_COLOR,
                                          fontSize: FONT_SMALL,
                                        ))
                                  ],
                                ),
                              ),

                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    SVG_ASSETS_PATH + 'icon_time.svg',
                    width: 32,
                    height: 32,
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
