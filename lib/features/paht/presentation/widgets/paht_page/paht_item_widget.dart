import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/core/functions/handle_time.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

const DESCRIPTION_COLOR = Color(0xff353739);

class PAHTITemWidget extends StatelessWidget {
  final PahtModel pahtModel;
  final Function onTap;
  final bool isPersonal;
  final Function onEdit;
  final Function onDelete;

  PAHTITemWidget(
      {@required this.pahtModel,
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(3, 3), // changes position of shadow
                  ),
                ],
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
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                            SvgPicture.asset(
                              SVG_ASSETS_PATH + 'icon_info.svg',
                              fit: BoxFit.scaleDown,
                              width: 22,
                              height: 22,
                            ),
                            SizedBox(width: 5,),
                            Text(
                              pahtModel.quotationNumber == null
                                  ? ''
                                  : pahtModel.quotationNumber,
                              style: GoogleFonts.inter(
                                fontSize: FONT_SMALL,
                                color: Color(0xff0F8E70),
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, left: 20),
                          child: Text(
                            pahtModel.cusName == null ? '' : pahtModel.cusName,
                            style: GoogleFonts.inter(
                              fontSize: FONT_SMALL,
                              color: PRIMARY_TEXT_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Image.asset(
                                ICONS_ASSETS + 'icon_marker_detail_address.png',
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  pahtModel.cusAddress == null
                                      ? ''
                                      : pahtModel.cusAddress,
                                  style: GoogleFonts.inter(
                                      color: DESCRIPTION_COLOR,
                                      fontSize: FONT_MIDDLE,
                                      height: 1.5),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        pahtModel.cusPhone == null || pahtModel.cusPhone.isEmpty
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      SVG_ASSETS_PATH + 'icon_phone_number.svg',
                                      width: 16,
                                      height: 16,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        pahtModel.cusPhone == null
                                            ? ''
                                            : pahtModel.cusPhone,
                                        style: GoogleFonts.inter(
                                          color: DESCRIPTION_COLOR,
                                          fontSize: FONT_MIDDLE,
                                        ))
                                  ],
                                ),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              SvgPicture.asset(
                                SVG_ASSETS_PATH + 'icon_time.svg',
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(handleTime(pahtModel.modifyDate),
                                  style: GoogleFonts.inter(
                                    color: DESCRIPTION_COLOR,
                                    fontSize: FONT_MIDDLE,
                                  ))
                            ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(getIcon(pahtModel.status)),
                                    SizedBox(width: 5),
                                    Text(
                                      getStatus(pahtModel.status),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                          fontSize: FONT_SMALL,
                                          color: getColor(pahtModel.status)),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
