import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/core/functions/handle_time.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_model.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

const DESCRIPTION_COLOR = Color(0xff353739);

class CKBGItemWidget extends StatelessWidget {
  final CKBGModel pahtModel;
  final Function onTap;
  final Function onEdit;
  final Function onDelete;

  CKBGItemWidget(
      {@required this.pahtModel,
      @required this.onTap,
      this.onDelete,
      this.onEdit, });

  @override
  Widget build(BuildContext context) {
    return   Slidable.builder(
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
          );
  }

  Widget _itemWidget(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.all(Radius.circular(6)),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
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
                                    Text(
                                      pahtModel.ckbgNumber ?? '',
                                      style: GoogleFonts.inter(
                                        fontSize: FONT_SMALL,
                                        color: Color(0xff0F8E70),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 10),
                          child: Row(children: [
                            Image.asset(
                              ICONS_ASSETS + 'icon_user2.png',
                              width: 16,
                              height: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                pahtModel.cusName == null
                                    ? ''
                                    : pahtModel.cusName,
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
                              RichText(
                                  text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: handleTime(pahtModel.modifyDate),
                                      style: GoogleFonts.inter(
                                        color: DESCRIPTION_COLOR,
                                        fontSize: FONT_MIDDLE,
                                      )),
                                  TextSpan(
                                      text: '  -  '+ pahtModel.createUserCode.toUpperCase(),
                                      style: GoogleFonts.inter(
                                        color: Colors.blue,
                                        fontSize: FONT_MIDDLE,
                                      )),

                                ],
                              )),
                            ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 5),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 0,
            )
          ],
        ),
      ),
    );
  }
}
